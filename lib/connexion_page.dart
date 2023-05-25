import 'package:flutter/material.dart';
import 'package:ggc/API/api_service.dart';
import 'package:google_fonts/google_fonts.dart';
import '../delay_animation.dart';
import 'HomePage.dart';

class ConnexionPage extends StatefulWidget {
  @override
  State<ConnexionPage> createState() => _ConnexionPageState();
}

class _ConnexionPageState extends State<ConnexionPage> {
  bool loading = false;
  bool _obscureText = true;

  final formkey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    final mdp = TextEditingController();
    final numTel = TextEditingController();
    return Scaffold(
      body: SingleChildScrollView(
        child: Form(
          key: formkey,
          child: Column(
            children: [
              DelayedAnimation(
                delay: 1500,
                child: Container(
                  height: 300,
                  decoration: const BoxDecoration(
                      borderRadius: BorderRadius.only(
                        bottomLeft: Radius.circular(200),
                      ),
                      color: Color.fromRGBO(1, 193, 204, 1),
                      gradient: LinearGradient(
                        colors: [
                          Colors.black87,
                          Colors.black87,
                        ],
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                      )),
                  child: Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Container(
                          margin: const EdgeInsets.only(top: 30),
                          child: Text(
                            "GGC&P",
                            style: GoogleFonts.poppins(
                              color: const Color.fromRGBO(1, 193, 204, 1),
                              fontSize: 70,
                              letterSpacing: .5,
                              fontWeight: FontWeight.w800,
                            ),
                          ),
                        ),
                        Container(
                          margin: EdgeInsets.only(right: 20, top: 20),
                          alignment: Alignment.bottomRight,
                          child: Text(
                            "CONNEXION",
                            style: GoogleFonts.poppins(
                              color: Colors.white,
                              fontSize: 20,
                              fontWeight: FontWeight.w900,
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                ),
              ),
              DelayedAnimation(
                delay: 2000,
                child: Container(
                  margin: EdgeInsets.only(left: 20, right: 20, top: 60),
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8),
                      color: Colors.grey[200],
                      boxShadow: [
                        BoxShadow(
                          offset: Offset(0, 10),
                          blurRadius: 50,
                          color: Colors.white,
                        )
                      ]),
                  alignment: Alignment.center,
                  child: TextFormField(
                    controller: numTel,
                    /*onChanged: (value) {
                      numTel.text = value;
                    },*/
                    validator: (value) {
                      if (value!.isEmpty) return "Champ vide";
                    },
                    cursorColor: Color.fromRGBO(1, 193, 204, 1),
                    decoration: const InputDecoration(
                      icon: Icon(
                        Icons.call,
                        color: Color.fromRGBO(1, 193, 204, 1),
                      ),
                      hintText: "Telephone agent",
                      enabledBorder: InputBorder.none,
                      focusedBorder: InputBorder.none,
                    ),
                  ),
                ),
              ),
              DelayedAnimation(
                delay: 2500,
                child: Container(
                  margin: EdgeInsets.only(left: 20, right: 20, top: 60),
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8),
                      color: Colors.grey[200],
                      boxShadow: const [
                        BoxShadow(
                          offset: Offset(0, 10),
                          blurRadius: 50,
                          color: Colors.white,
                        )
                      ]),
                  alignment: Alignment.center,
                  child: TextFormField(
                    obscureText: _obscureText,
                    controller: mdp,
                   /* onChanged: (value) {
                      mdp.text = value;
                    }*/
                    validator: (value) {
                      if (value!.isEmpty) return "Champ vide";
                    },
                    cursorColor: const Color.fromRGBO(1, 193, 204, 1),
                    decoration: const InputDecoration(
                      icon: Icon(
                        Icons.lock,
                        color: Color.fromRGBO(1, 193, 204, 1),
                      ),
                      hintText: "Entrer le mot de passe",
                      enabledBorder: InputBorder.none,
                      focusedBorder: InputBorder.none,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 50),
              DelayedAnimation(
                delay: 3000,
                child: ElevatedButton(
                  onPressed: () async {
                    if (loading == false) {
                      if (formkey.currentState!.validate()) {
                        setState(() {
                          loading = true;
                        });
                        if (await MongoDatabase.agentLogin(
                                numTel.text.trim(), mdp.text.trim()) ==
                            true) {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => HomePage()));
                        } else {
                          setState(() {
                            loading = false;
                            numTel.clear();
                            mdp.clear();
                          });
                          ScaffoldMessenger.of(context)
                              .showSnackBar((const SnackBar(
                            content: Text("Mot de passe ou numéro incorrect"),
                            backgroundColor: Colors.red,
                          )));
                        }
                      }
                    }
                  },
                  child: loading
                      ? CircularProgressIndicator(
                          color: Colors.white,
                        )
                      : Text("Se connecter"),
                  style: ElevatedButton.styleFrom(
                      backgroundColor: Color.fromRGBO(1, 193, 204, 1),
                      minimumSize: Size(200, 50)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
