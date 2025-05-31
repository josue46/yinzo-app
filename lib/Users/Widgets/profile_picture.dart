import 'package:flutter/material.dart';
import 'package:yinzo/Users/Provider/auth_provider.dart';

class ProfilePicture extends StatelessWidget {
  const ProfilePicture({super.key});

  @override
  Widget build(BuildContext context) {
    final auth = AuthProvider.of(context, listen: false);
    return SizedBox(
      height: 115,
      width: 115,
      child:
          auth.isConnected
              ? auth.userData!.photoUrl.isNotEmpty
                  ? CircleAvatar(
                    backgroundImage: NetworkImage(auth.userData!.photoUrl),
                  )
                  : const CircleAvatar(
                    backgroundImage: AssetImage('assets/images/profil.jpg'),
                  )
              : const CircleAvatar(
                backgroundImage: AssetImage('assets/images/profil.jpg'),
              ),
    );
  }
}
