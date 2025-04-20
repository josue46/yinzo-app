import 'package:flutter/material.dart';
import 'package:yinzo/widgets/custom_app_bar.dart';
import 'package:intl/intl.dart' show DateFormat;

class DiscussionsScreen extends StatelessWidget {
  const DiscussionsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    List<String> nameList = [
      "Josué Panzu",
      "Luis Martin's",
      "Winner",
      "Osée",
      "Parfait Mousson",
      "Master Fredo",
      "Dobolo king",
      "Exaucé",
      "Adam",
      "Élie",
      "Mukendi",
      "Aganze",
      "Arsène",
      "Joyce",
      "Blaster oméga",
      "Trix",
      "Gaby",
      "Sem",
    ];
    return Scaffold(
      appBar: AppBar(
        flexibleSpace: CustomAppBar(title: "Discussions", centerTitle: true),
      ),
      body: ListView.builder(
        itemCount: nameList.length,
        itemBuilder: (context, index) {
          var date = DateFormat('dd/MM/yyyy').format(DateTime.now().toLocal());
          return ListTile(
            visualDensity: VisualDensity.defaultDensityForPlatform(
              TargetPlatform.android,
            ),
            onTap: () {},
            leading: CircleAvatar(
              backgroundImage: AssetImage("assets/images/profil.jpg"),
            ),
            title: Text(nameList[index]),
            subtitle: Text(date),
            trailing: IconButton(
              icon: Icon(Icons.more_vert_sharp),
              onPressed: () {},
            ),
          );
        },
      ),
    );
  }
}
