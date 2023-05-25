import 'package:flutter/material.dart';
import 'package:ggc/API/api_service.dart';
import 'package:ggc/connexion_page.dart';
import 'package:ggc/historique/historique.dart';
import 'package:ggc/models/agent_model.dart';
import 'Static.dart';
import 'client/client_form.dart';
import 'client/client_list.dart';
import 'cotisation/cotisation_find_client.dart';

class HomePage extends StatelessWidget {
  const HomePage({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SafeArea(
            child: Container(
              decoration: BoxDecoration(
                  image: DecorationImage(
                      image: AssetImage("assets/images/bg_6.jpg"), fit: BoxFit.fill)),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      IconButton(onPressed: (){
                        Navigator.pop(context);
                        AgentModel.agentSession = AgentModel();
                        MongoDatabase.db!.close();
                        Navigator.push(context, MaterialPageRoute(builder: (_)=>ConnexionPage()));
                      },iconSize: 30, icon: Icon(Icons.logout,color: Colors.black,))
                    ],
                  ),
                  Container(
                    height: 50,
                    width: 200,
                    child: Center(child: Image.asset("assets/images/ggc_logo.png")),
                  ),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          GestureDetector(
                            onTap: () {
                              Navigator.push(context,
                                  MaterialPageRoute(builder: (_) => CotFindClient()));
                            },
                            child: Container(
                              height: 130,
                              width: 130,
                              padding: const EdgeInsets.all(8.0),
                              decoration: const BoxDecoration(
                                  borderRadius: BorderRadius.only(
                                    topLeft: Radius.circular(10),
                                    bottomLeft: Radius.circular(10),
                                  ),
                                  color: Colors.white,
                                  boxShadow: [
                                    BoxShadow(blurRadius: 2, offset: Offset(0, 1)),
                                  ]),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Image.asset("assets/images/create_document_60px.png"),
                                  Text(
                                    "Enregistrer cotisation",
                                    style: TextStyle(
                                      fontFamily: globalTextFont,
                                    ),
                                    textAlign: TextAlign.center,
                                  ),
                                ],
                              ),
                            ),
                          ),
                          GestureDetector(
                            onTap: () {
                              Navigator.push(context,
                                  MaterialPageRoute(builder: (_) => ClientForm()));
                            },
                            child: Container(
                                height: 130,
                                width: 130,
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.only(
                                      topRight: Radius.circular(10),
                                      bottomRight: Radius.circular(10),
                                    ),
                                    color: Colors.white,
                                    boxShadow: [
                                      BoxShadow(blurRadius: 2, offset: Offset(0, 1))
                                    ]),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Image.asset("assets/images/add_user_60px.png"),
                                    Text(
                                      "Enregistrer Client",
                                      style: TextStyle(fontFamily: globalTextFont),
                                    )
                                  ],
                                )),
                          )
                        ],
                      ),
                      SizedBox(
                        height: 30,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          GestureDetector(
                            onTap: () {
                              Navigator.push(context,
                                  MaterialPageRoute(builder: (_) => ClientList()));
                            },
                            child: Container(
                              height: 130,
                              width: 130,
                              decoration: const BoxDecoration(
                                  borderRadius: BorderRadius.only(
                                    topLeft: Radius.circular(10),
                                    bottomLeft: Radius.circular(10),
                                  ),
                                  color: Colors.white,
                                  boxShadow: [
                                    BoxShadow(blurRadius: 2, offset: Offset(0, 1))
                                  ]),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Image.asset(
                                    "assets/images/list_60px.png",
                                  ),
                                  Text(
                                    "Listes des clients",
                                    style: TextStyle(fontFamily: globalTextFont),
                                  )
                                ],
                              ),
                            ),
                          ),
                          GestureDetector(
                            onTap: (){
                              Navigator.push(context, MaterialPageRoute(builder: (_)=>Historique()));
                            },
                            child: Container(
                              height: 130,
                              width: 130,
                              decoration: const BoxDecoration(
                                  borderRadius: BorderRadius.only(
                                    topRight: Radius.circular(10),
                                    bottomRight: Radius.circular(10),
                                  ),
                                  color: Colors.white,
                                  boxShadow: [
                                    BoxShadow(blurRadius: 2, offset: Offset(0, 1))
                                  ]),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: const [
                                  Icon(Icons.history_edu, color: Colors.indigo, size: 50,),
                                  Text(
                                    "Historiques",
                                    style: TextStyle(fontFamily: globalTextFont),
                                  )
                                ],
                              ),
                            ),
                          )
                        ],
                      ),

                      Container(
                          padding: EdgeInsets.all(10),
                          margin: EdgeInsets.all(30),
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              color: secondaryColor),
                          child: Text(
                            "Groupe Général de Commerce et Parténaire",
                            style: TextStyle(
                              fontFamily: "UnifrakturCook",
                              color: primaryColor,
                              fontSize: 24,
                            ),
                            textAlign: TextAlign.center,
                          )),
                    ],
                  )
                ],
              ),
            )));
  }
}
