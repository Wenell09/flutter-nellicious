import 'package:flutter/material.dart';
import 'package:flutter_nellicious/data/models/user_model.dart';

class InformationAccountPage extends StatelessWidget {
  final List<UserModel> user;
  const InformationAccountPage({
    super.key,
    required this.user,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
            onPressed: () => Navigator.of(context).pop(),
            icon: Icon(
              Icons.arrow_back,
              color: Colors.white,
            )),
        centerTitle: true,
        backgroundColor: Colors.green,
        title: Text(
          "Informasi Akun",
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: ListView(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 30),
            child: Container(
              padding: EdgeInsets.all(20),
              width: double.infinity,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                color: Colors.grey[350],
              ),
              child: Column(
                children: [
                  CircleAvatar(
                    radius: 50,
                    backgroundColor: Colors.greenAccent,
                    backgroundImage: NetworkImage(
                        "http://idoxaxo.sufydely.com/profile_pic.png"),
                  ),
                  Divider(),
                  ListTile(
                    leading: Icon(
                      Icons.person,
                      size: 30,
                    ),
                    title: Text(
                      (user.isEmpty) ? "loading" : user[0].username,
                      style: TextStyle(
                        fontSize: 17,
                        color: Colors.black,
                      ),
                    ),
                  ),
                  ListTile(
                    leading: Icon(
                      Icons.mail,
                      size: 30,
                    ),
                    title: Text(
                      (user.isEmpty) ? "loading" : user[0].email,
                      style: TextStyle(
                        fontSize: 17,
                        color: Colors.black,
                      ),
                    ),
                  ),
                  ListTile(
                    leading: Icon(
                      Icons.key,
                      size: 30,
                    ),
                    title: Text(
                      (user.isEmpty) ? "loading" : user[0].password,
                      style: TextStyle(
                        fontSize: 17,
                        color: Colors.black,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          const Icon(
            Icons.warning_rounded,
            color: Colors.red,
            size: 120,
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 30),
            child: const Center(
              child: Text(
                textAlign: TextAlign.center,
                "Pastikan informasi pribadi tidak diperlihatkan dan disebarluaskan!",
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}
