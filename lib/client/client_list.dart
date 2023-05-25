import 'package:flutter/material.dart';
import 'package:ggc/API/config.dart';
import 'package:ggc/models/agent_model.dart';
import '../API/api_service.dart';
import '../client/client_fiche.dart';
import '../Static.dart';

import '../models/client_model.dart';

class ClientList extends StatefulWidget {
  const ClientList({Key? key}) : super(key: key);

  @override
  State<ClientList> createState() => _ClientListState();
}

class _ClientListState extends State<ClientList> {
  List<ClientModel> allClient = [];
  List<ClientModel> _foundClient = [];
  bool isColor = false;
  late final _data;

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
  void initState(){
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
            child: Column(
              children: [
                Container(
                  height: MediaQuery.of(context).size.height * 0.8,
                  width: MediaQuery.of(context).size.width,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        padding: EdgeInsets.all(8),
                        height: 50,
                        color: neutralColor,
                        width: MediaQuery.of(context).size.width,
                      child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text(
                                    "Liste des clients",
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontFamily: "UnfrakturCook",
                                        color: secondaryColor,
                                        fontSize: 18),
                                    textAlign: TextAlign.center,
                                  ),

                            Container(
                              height: 50,
                              width: 150,
                              decoration: BoxDecoration(
                                  color: primaryColor,
                                  borderRadius: BorderRadius.circular(10)),
                              child: TextField(
                                  style: TextStyle(color: secondaryColor),
                                  onChanged: (value) {
                                    searchFilter(value);
                                  },
                                  decoration: const InputDecoration(
                                    hintStyle: TextStyle(
                                        fontFamily: globalTextFont, color: primaryColor,),
                                    prefixIcon: Icon(
                                      Icons.search,
                                      color: secondaryColor,
                                    ),
                                    border: InputBorder.none,
                                  ),
                                ),

                            ),
                          ],
                        ),
                      ),
                      RefreshIndicator(
                        onRefresh: () async {
                          setState(() {
                            _data = MongoDatabase.getClientByAgent(AgentModel.agentSession.id);
                          });
                        },
                        child: Container(
                          height: MediaQuery.of(context).size.height * 0.6,
                          child: FutureBuilder(
                              future: _data,
                              builder: (context, AsyncSnapshot snapshot) {
                                if (snapshot.connectionState == ConnectionState.waiting) {
                                  return const Center(
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
        decoration: const BoxDecoration(
            //color: isColor ? primaryColor : neutralColor.withOpacity(0.5),
            border:
            Border(bottom: BorderSide(color: secondaryColor, width: 0.2))),
        child: ListTile(
          onTap: () {
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (_) => ClientFiche(clientModel: clientModel)));
          },
          leading: const CircleAvatar(
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
