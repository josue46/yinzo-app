import 'package:flutter/material.dart';
import 'package:icons_plus/icons_plus.dart' show OctIcons;

Future<dynamic> showModalDialog(
  BuildContext context, {
  void Function()? onTakePhoto,
  void Function()? onImportPhoto,
}) {
  return showDialog(
    barrierDismissible: false,
    context: context,
    builder: (context) {
      return AlertDialog(
        backgroundColor: Colors.white,
        content: SizedBox(
          width: 260,
          height: 140,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Align(
                alignment: Alignment.topRight,
                child: InkWell(
                  onTap: () => Navigator.pop(context),
                  child: const Icon(OctIcons.x, color: Colors.red),
                ),
              ),
              SizedBox(height: 15),
              ElevatedButton(
                onPressed: onImportPhoto,
                style: ElevatedButton.styleFrom(
                  fixedSize: const Size(250, 40),
                  foregroundColor: Colors.white,
                  backgroundColor: Theme.of(context).primaryColor,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(6),
                  ),
                ),
                child: const Text(
                  "Importer une photo",
                  style: TextStyle(fontSize: 16),
                ),
              ),
              const SizedBox(height: 12),
              ElevatedButton(
                onPressed: onTakePhoto,
                style: ElevatedButton.styleFrom(
                  fixedSize: const Size(250, 40),
                  foregroundColor: Colors.white,
                  backgroundColor: Theme.of(context).primaryColor,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(6),
                  ),
                ),
                child: const Text(
                  "Prendre une photo",
                  style: TextStyle(fontSize: 16),
                ),
              ),
            ],
          ),
        ),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      );
    },
  );
}
