import 'package:flutter/material.dart';

class EditProfileScreen extends StatelessWidget {
  const EditProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        centerTitle: false,
        elevation: 0,
        backgroundColor: const Color(0xFF00BF6D),
        foregroundColor: Colors.white,
        title: const Text("Edit Profile"),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: Column(
            children: [
              ProfilePic(
                image: 'https://i.postimg.cc/cCsYDjvj/user-2.png',
                imageUploadBtnPress: () {},
              ),
              const Divider(),
              Form(
                child: Column(
                  children: [
                    UserInfoEditField(
                      text: "Name",
                      child: TextFormField(
                        initialValue: "Annette Black",
                        decoration: InputDecoration(
                          filled: true,
                          fillColor: const Color(0xFF00BF6D).withOpacity(0.05),
                          contentPadding: const EdgeInsets.symmetric(
                            horizontal: 16.0 * 1.5,
                            vertical: 16.0,
                          ),
                          border: const OutlineInputBorder(
                            borderSide: BorderSide.none,
                            borderRadius: BorderRadius.all(Radius.circular(50)),
                          ),
                        ),
                      ),
                    ),
                    UserInfoEditField(
                      text: "Email",
                      child: TextFormField(
                        initialValue: "annette@gmail.com",
                        decoration: InputDecoration(
                          filled: true,
                          fillColor: const Color(0xFF00BF6D).withOpacity(0.05),
                          contentPadding: const EdgeInsets.symmetric(
                            horizontal: 16.0 * 1.5,
                            vertical: 16.0,
                          ),
                          border: const OutlineInputBorder(
                            borderSide: BorderSide.none,
                            borderRadius: BorderRadius.all(Radius.circular(50)),
                          ),
                        ),
                      ),
                    ),
                    UserInfoEditField(
                      text: "Phone",
                      child: TextFormField(
                        initialValue: "(316) 555-0116",
                        decoration: InputDecoration(
                          filled: true,
                          fillColor: const Color(0xFF00BF6D).withOpacity(0.05),
                          contentPadding: const EdgeInsets.symmetric(
                            horizontal: 16.0 * 1.5,
                            vertical: 16.0,
                          ),
                          border: const OutlineInputBorder(
                            borderSide: BorderSide.none,
                            borderRadius: BorderRadius.all(Radius.circular(50)),
                          ),
                        ),
                      ),
                    ),
                    UserInfoEditField(
                      text: "Address",
                      child: TextFormField(
                        initialValue: "New York, NVC",
                        decoration: InputDecoration(
                          filled: true,
                          fillColor: const Color(0xFF00BF6D).withOpacity(0.05),
                          contentPadding: const EdgeInsets.symmetric(
                            horizontal: 16.0 * 1.5,
                            vertical: 16.0,
                          ),
                          border: const OutlineInputBorder(
                            borderSide: BorderSide.none,
                            borderRadius: BorderRadius.all(Radius.circular(50)),
                          ),
                        ),
                      ),
                    ),
                    UserInfoEditField(
                      text: "Ancien mot de passe",
                      child: TextFormField(
                        obscureText: true,
                        initialValue: "demopass",
                        decoration: InputDecoration(
                          suffixIcon: const Icon(
                            Icons.visibility_off,
                            size: 20,
                          ),
                          filled: true,
                          fillColor: const Color(0xFF00BF6D).withOpacity(0.05),
                          contentPadding: const EdgeInsets.symmetric(
                            horizontal: 16.0 * 1.5,
                            vertical: 16.0,
                          ),
                          border: const OutlineInputBorder(
                            borderSide: BorderSide.none,
                            borderRadius: BorderRadius.all(Radius.circular(50)),
                          ),
                        ),
                      ),
                    ),
                    UserInfoEditField(
                      text: "Nouveau mot de passe",
                      child: TextFormField(
                        decoration: InputDecoration(
                          hintText: "New Password",
                          filled: true,
                          fillColor: const Color(0xFF00BF6D).withOpacity(0.05),
                          contentPadding: const EdgeInsets.symmetric(
                            horizontal: 16.0 * 1.5,
                            vertical: 16.0,
                          ),
                          border: const OutlineInputBorder(
                            borderSide: BorderSide.none,
                            borderRadius: BorderRadius.all(Radius.circular(50)),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16.0),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF00BF6D),
                    foregroundColor: Colors.white,
                    minimumSize: const Size(double.infinity, 48),
                    shape: const StadiumBorder(),
                  ),
                  onPressed: () {},
                  child: const Text(
                    "Sauvegarder les modifications",
                    style: TextStyle(fontSize: 15, fontFamily: 'Poppins'),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class ProfilePic extends StatelessWidget {
  const ProfilePic({
    super.key,
    required this.image,
    this.isShowPhotoUpload = false,
    this.imageUploadBtnPress,
  });

  final String image;
  final bool isShowPhotoUpload;
  final VoidCallback? imageUploadBtnPress;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16.0),
      margin: const EdgeInsets.symmetric(vertical: 16.0),
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border: Border.all(
          color: Theme.of(
            context,
          ).textTheme.bodyLarge!.color!.withOpacity(0.08),
        ),
      ),
      child: Stack(
        alignment: Alignment.bottomRight,
        children: [
          CircleAvatar(radius: 50, backgroundImage: NetworkImage(image)),
          InkWell(
            onTap: imageUploadBtnPress,
            child: CircleAvatar(
              radius: 13,
              backgroundColor: Theme.of(context).primaryColor,
              child: const Icon(Icons.add, color: Colors.white, size: 20),
            ),
          ),
        ],
      ),
    );
  }
}

class UserInfoEditField extends StatelessWidget {
  const UserInfoEditField({super.key, required this.text, required this.child});

  final String text;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 16.0 / 2),
      child: Row(
        children: [
          Expanded(flex: 2, child: Text(text)),
          Expanded(flex: 3, child: child),
        ],
      ),
    );
  }
}
