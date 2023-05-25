import 'package:flutter/material.dart';
import 'package:ggc/API/config.dart';
import '../API/api_service.dart';
import '../Static.dart';

import '../client/tontines_client.dart';
import '../models/agent_model.dart';
import '../models/client_model.dart';

class CotFindClient extends StatefulWidget {
  const CotFindClient({Key? key}) : super(key: key);

  @override
  State<CotFindClient> createState() => _CotFindClientState();
}

class _CotFindClientState extends State<CotFindClient> {
  Future? _data;
  List<ClientModel> allClient = [];
  List<ClientModel> _foundClient = [];
  bool isColor = false;

  // Fonction de recherche de client par id
  void searchFilter(String search) {
    List<ClientModel> results = [];
    if (search.isEmpty) {
      results = allClient;
    } else {
      results = allClient
          .where((client) =>
          client.id.toLowerCase().contains(search.toLowerCase()))
          .toList();
    }
    setState(() {
      _foundClient.clear();
      _foundClient = results;
    });
  }

  void initState() {
    _data = MongoDatabase.getClientByAgent(AgentModel.agentSession.id);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: neutralColor,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Container(
            height: MediaQuery.of(context).size.height,
            decoration: BoxDecoration(
              color: neutralColor,
            ),
            child: Column(
              children: [
                Container(
                  height: 50,
                  width: 200,
                  child: Center(child: Image.asset("assets/images/ggc_logo.png")),
                ),
                Container(
                  margin: EdgeInsets.all(15),
                  width: MediaQuery.of(context).size.width,
                  decoration: BoxDecoration(
                      color: secondaryColor,
                      borderRadius: BorderRadius.circular(10),
                      boxShadow: [
                        BoxShadow(
                            offset: Offset(0.5,0.5),
                            color: Colors.white,
                            blurRadius: 5
                        )
                      ]
                  ),

                  child: TextField(
                    onChanged: (value) {
                      searchFilter(value);
                    },
                    style: TextStyle(color: primaryColor),
                    decoration: const InputDecoration(
                      hintText: "Recherche ... ",
                      hintStyle: TextStyle(
                          fontFamily: globalTextFont, color: primaryColor),
                      prefixIcon: Icon(
                        Icons.search,
                        color: primaryColor,
                      ),
                      border: InputBorder.none,
                    ),
                  ),
                ), Container(
                  height: MediaQuery.of(context).size.height * 0.8,
                  width: MediaQuery.of(context).size.width,
                  decoration: const BoxDecoration(
                    color: primaryColor,
                    borderRadius: BorderRadius.only(
                        topRight: Radius.circular(30),
                        topLeft: Radius.circular(30)),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                          height: 50,
                          width: double.infinity,
                          color: secondaryColor,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,

                            children: [
                              Center(
                                child: Text(
                                  "Liste des clients",
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontFamily: "UnfrakturCook",
                                      color: primaryColor,
                                      fontSize: 18),
                                  textAlign: TextAlign.center,
                                ),
                              ),
                              IconButton(onPressed: (){
                                setState(() {
                                  _data = MongoDatabase.getClientByAgent(AgentModel.agentSession.id);

                                });
                              }, icon: Icon(Icons.refresh))

                            ],
                          )),
                      RefreshIndicator(
                        onRefresh: () async{
                          setState(() {
                            _data = MongoDatabase.getClientByAgent(AgentModel.agentSession.id);
                          });
                        },
                        child: Container(
                          height: MediaQuery.of(context).size.height * 0.6,
                          child: FutureBuilder(
                              future: _data,
                              builder: (context, AsyncSnapshot snapshot) {
                                if (snapshot.connectionState ==
                                    ConnectionState.waiting) {
                                  return Center(
                                      child: CircularProgressIndicator());
                                }
                                if (snapshot.connectionState ==
                                    ConnectionState.done &&
                                    snapshot.hasData) {
                                  allClient.clear();
                                  for (int i = 0;
                                  i < snapshot.data.length;
                                  i++) {
                                    allClient.add(ClientModel.fromJson(
                                        snapshot.data[i]));
                                  }
                                  if (_foundClient.isEmpty)
                                    _foundClient = allClient;
                                  return ListView.builder(
                                      itemCount: _foundClient.length,
                                      itemBuilder: (context, index) {
                                        isColor = !isColor;
                                        return ViewClient(
                                            _foundClient.elementAt(index));
                                      });
                                } else
                                  return Center(child: Text('No data Found'));
                              }),
                        ),
                      ),
                    ],
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget ViewClient(ClientModel clientModel) {
    return Container(
        decoration: BoxDecoration(
            color: isColor ? primaryColor : Colors.grey.shade100,
            border:
            Border(bottom: BorderSide(color: secondaryColor, width: 0.2))),
        child: ListTile(
          onTap: () {
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (_) => TontinesClient(clientModel: clientModel)));
          },
          leading: CircleAvatar(
            backgroundImage: AssetImage(
              "assets/images/obama.jpg",
            ),
          ),
          title: Text(
            "${clientModel.nom} ${clientModel.prenom}",
          ),
          subtitle: Text(
            "${clientModel.id}",
            style: TextStyle(
                fontFamily: globalTextFont,
                color: neutralColor),
          ),
        ));
  }
}
