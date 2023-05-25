import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../API/Config.dart';
import '../API/api_service.dart';
import '../Static.dart';
import '../client/tontines_client.dart';
import '../models/client_model.dart';
import '../models/cotisation_model.dart';
import '../models/tontine_model.dart';

class OtherMise extends StatefulWidget {
  OtherMise({required this.clientModel, required this.clientMMembre, Key? key})
      : super(key: key);
  ClientModel clientModel;
  List<String> clientMMembre;

  @override
  State<OtherMise> createState() => _OtherMiseState();
}

class _OtherMiseState extends State<OtherMise> {
  bool loading = false;
  List<TontineModel> tontines = [];
  List<TontineModel> filteredTontines = [];
  var _getTontines;

  void initState() {
    _getTontines = MongoDatabase.getCollectionData(Config.tontine_collection);
    super.initState();
  }

  // Fonction de recherche de tontine par type de tontine
  void searchFilter(String search) {
    List<TontineModel> results = [];
    if (search.isEmpty) {
      results = tontines;
    } else {
      results = tontines
          .where((tontine) =>
              tontine.typeTontine.toLowerCase().contains(search.toLowerCase()))
          .toList();
    }
    setState(() {
      filteredTontines.clear();
      filteredTontines = results;
    });
  }

  Widget ViewMise(ClientModel client, TontineModel tontineModel, context) {
    return GestureDetector(
      onTap: () {},
      child: Container(
        margin: EdgeInsets.all(15),
        decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(8.0),
            boxShadow: [
              BoxShadow(
                  blurRadius: 5,
                  offset: Offset(3, 0.5),
                  color: Color.fromRGBO(46, 10, 102, 1))
            ]),
        padding: EdgeInsets.all(8.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: 200,
                  child: Text(
                    "Type : ${tontineModel.typeTontine}",
                    style: TextStyle(fontFamily: globalTextFont, fontSize: 18),
                  ),
                ),
                Text(
                  "Montant: ${tontineModel.montantTontine} FCFA",
                  style:
                      TextStyle(fontFamily: globalTextFont, color: Colors.grey),
                )
              ],
            ),
            ElevatedButton(
              onPressed: () {
                if (loading == false) {
                  setState(() {
                    loading = true;
                  });
                  var result = CotisationModel.insertCotisation(
                      widget.clientModel.id, tontineModel.id, context);
                  result.then((value) {
                    Navigator.pop(context);
                    Navigator.pop(context);
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (_) => TontinesClient(
                                clientModel: widget.clientModel)));
                    setState(() {
                      loading = false;
                    });
                  });
                }
              },
              style: ElevatedButton.styleFrom(backgroundColor: neutralColor),
              child: loading
                  ? const CircularProgressIndicator(
                      color: Colors.white,
                    )
                  : const Text("Ajouter"),
            )
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("AUTRES TYPE DE TONTINES"),
        centerTitle: true,
      ),
      body: Column(
        children: [
          Container(
            height: 50,
            margin: EdgeInsets.all(16),
            decoration: BoxDecoration(
                color: Colors.black12, borderRadius: BorderRadius.circular(10)),
            child: TextField(
              style: TextStyle(color: secondaryColor),
              onChanged: (value) {
                searchFilter(value);
              },
              decoration: const InputDecoration(
                hintStyle: TextStyle(
                  fontFamily: globalTextFont,
                  color: primaryColor,
                ),
                prefixIcon: Icon(
                  Icons.search,
                  color: secondaryColor,
                ),
                border: InputBorder.none,
              ),
            ),
          ),
              Container(
                height: MediaQuery.of(context).size.height * 0.81,
                width: MediaQuery.of(context).size.width,
                child:   FutureBuilder(
                    future: _getTontines,
                    builder: (context, AsyncSnapshot snap) {
                      if (snap.connectionState == ConnectionState.waiting) {
                        return const Center(child: CircularProgressIndicator());
                      } else {
                        if (snap.hasData &&
                            snap.connectionState == ConnectionState.done) {
                          tontines.clear();
                          for (int i = 0; i < snap.data.length; i++) {
                            tontines.add(TontineModel.fromJson(snap.data[i]));
                          }
                          if (filteredTontines.isEmpty) {
                            filteredTontines = tontines;
                          }

                          int verif = 0;
                          return ListView.builder(
                              itemCount: filteredTontines.length,
                              itemBuilder: (context, index) {
                                if (!widget.clientMMembre
                                    .contains(snap.data[index]["id"])) {
                                  return ViewMise(widget.clientModel,
                                      filteredTontines[index], context);
                                } else {
                                  verif++;
                                  if (verif == snap.data.length) {
                                    return Center(
                                        child: Text("Pas d'autre tontines "));
                                  }
                                }
                                return SizedBox(
                                  height: 0,
                                );
                              });
                        } else
                          return Center(child: Text('No data Found'));
                      }
                    }),
              ),
            ],
          ),

    );
  }
}
