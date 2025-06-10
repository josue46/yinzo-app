import 'dart:async';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:yinzo/Utils/animation_popup_alert.dart';

class TemporaryAccountCountdownListener extends StatefulWidget {
  final Widget child;
  final VoidCallback onExpired;
  final Duration duration;
  final bool showTimer;
  final bool? launchFromSignupScreen;

  const TemporaryAccountCountdownListener({
    super.key,
    required this.child,
    required this.onExpired,
    this.duration = const Duration(minutes: 15),
    this.showTimer = true,
    this.launchFromSignupScreen,
  });

  @override
  State<TemporaryAccountCountdownListener> createState() =>
      TemporaryAccountCountdownListenerState();
}

class TemporaryAccountCountdownListenerState
    extends State<TemporaryAccountCountdownListener> {
  Timer? _timer;
  late Duration _remaining;
  bool _isStoppedTimer = false;

  @override
  void initState() {
    super.initState();
    _remaining = widget.duration;
    _loadCreationDateAndStartTimer();
  }

  Future<void> _loadCreationDateAndStartTimer() async {
    if (widget.launchFromSignupScreen != null &&
        widget.launchFromSignupScreen!) {
      return;
    }

    final prefs = await SharedPreferences.getInstance();
    final dateStr = prefs.getString('temporaryAccountExpirationDate');

    if (dateStr == null) {
      setState(() {
        _remaining = Duration.zero;
      });
      return;
    }

    final expireDate = DateTime.tryParse(dateStr);
    if (expireDate == null) {
      setState(() {
        _remaining = Duration.zero;
      });
      return;
    }

    final today = DateTime.now();
    final initialRemaining = expireDate.difference(today);

    if (initialRemaining.isNegative) {
      // Les 15 minutes sont écoulés, désactivation du compte temporaire.
      // ignore: use_build_context_synchronously
      animationPopupAlert(context);
    } else {
      setState(() {
        _remaining = initialRemaining;
      });
      startTimer();
    }
  }

  void reload() {
    setState(() {});
  }

  void startTimer() {
    _timer?.cancel();
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_remaining.inSeconds < 1) {
        timer.cancel();
        setState(() {
          _isStoppedTimer = true;
        });
        widget.onExpired();
      } else {
        setState(() {
          _remaining -= const Duration(seconds: 1);
        });
      }
    });
  }

  void stopTimer() {
    _timer?.cancel();
  }

  @override
  void dispose() {
    stopTimer();
    super.dispose();
  }

  String _format(Duration duration) {
    final minutes = duration.inMinutes.remainder(60).toString().padLeft(2, '0');
    final seconds = duration.inSeconds.remainder(60).toString().padLeft(2, '0');
    return '$minutes:$seconds';
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        widget.child,
        if (widget.showTimer && !_isStoppedTimer)
          Positioned(
            top: 40,
            right: 12,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
              decoration: BoxDecoration(
                color: Colors.red.shade100,
                borderRadius: BorderRadius.circular(10),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(Icons.timer, size: 16, color: Colors.redAccent),
                  const SizedBox(width: 4),
                  Text(
                    _format(_remaining),
                    style: const TextStyle(
                      color: Colors.redAccent,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
          ),
      ],
    );
  }
}
