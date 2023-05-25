import 'package:flutter/material.dart';
import 'package:ggc/models/cotisation_model.dart';
import '../cotisation/cotisation_form.dart';
import 'package:mongo_dart/mongo_dart.dart' as M;
import '../API/api_service.dart';
import '../cotisation/otherTontines.dart';
import '../models/client_model.dart';
import '../models/tontine_model.dart';
import '../Static.dart';

class TontinesClient extends StatefulWidget {
  const TontinesClient({required this.clientModel, Key? key}) : super(key: key);
  final ClientModel clientModel;

  @override
  State<TontinesClient> createState() => _TontinesClientState();
}

class _TontinesClientState extends State<TontinesClient> {
  List<String> clientCotisationsName = [];
  List<CotisationModel> clientCotisationsList = [];
  bool isColor = false;
  bool loading = false;
  var _dataCotisationByClient;

  getClientCotId(CotisationModel cotisation, TontineModel tontine) {
    for (int i = 0; i < clientCotisationsList.length; i++) {
      print("$tontine => ${clientCotisationsList[i].id_mise}");
      if (clientCotisationsList[i].id_mise == tontine.id) {
        if (clientCotisationsList[i].dates_cot.first.isEmpty &&
            clientCotisationsList[i].dates_cot.first.isEmpty) {
          print("true");
          deleteClientCot(cotisation, tontine);
        } else {
          showDialog(
              context: context,
              builder: (context) {
                return AlertDialog(
                    title: Text(
                      "Attention",
                      style: TextStyle(color: Colors.red),
                    ),
                    content: Container(
                      height: MediaQuery.of(context).size.height * 0.2,
                      child: Column(children: const [
                        Text(
                          "Impossible de supprimer la cotisations en cours",
                          style: TextStyle(
                              fontSize: 18, fontWeight: FontWeight.w800),
                        ),
                        Text(
                            "Veillez cloturer d'abord les cotisations en cours!",
                            style: TextStyle(
                                fontSize: 18, fontWeight: FontWeight.w800))
                      ]),
                    ));
              });
        }

        return clientCotisationsList[i].id;
      }
    }
    print(" ");
  }

  @override
  void initState() {
    _dataCotisationByClient =
        MongoDatabase.getCotisationByClientId(widget.clientModel.id);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          backgroundColor: neutralColor,
        ),
        body: SafeArea(
          child: SingleChildScrollView(
            child: Container(
              height: MediaQuery.of(context).size.height,
              color: neutralColor,
              child: Column(
                children: [
                  Container(
                    height: 50,
                    width: 200,
                    child: Center(
                        child: Image.asset("assets/images/ggc_logo.png")),
                  ),
                  Container(
                    margin: EdgeInsets.all(15),
                    width: MediaQuery.of(context).size.width,
                    decoration: BoxDecoration(
                        color: secondaryColor,
                        borderRadius: BorderRadius.circular(10)),
                    child: TextField(
                      style: TextStyle(color: Colors.white),
                      onChanged: (value) {
                        //searchFilter(value);
                      },
                      decoration: const InputDecoration(
                        hintText: "Type Tontine",
                        hintStyle: TextStyle(
                            fontFamily: globalTextFont, color: primaryColor),
                        prefixIcon: Icon(
                          Icons.search,
                          color: primaryColor,
                        ),
                        border: InputBorder.none,
                      ),
                    ),
                  ),
                  Container(
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
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Center(
                                  child: Text(
                                    "Tontines du client : ${widget.clientModel.id}",
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontFamily: "UnfrakturCook",
                                        color: primaryColor,
                                        fontSize: 18),
                                    textAlign: TextAlign.center,
                                  ),
                                ),
                                IconButton(
                                    onPressed: () {
                                      setState(() {
                                        _dataCotisationByClient = MongoDatabase
                                            .getCotisationByClientId(
                                                widget.clientModel.id);
                                      });
                                    },
                                    icon: Icon(
                                      Icons.refresh,
                                      color: Colors.white,
                                    ))
                              ],
                            )),
                        Container(
                          height: MediaQuery.of(context).size.height * 0.6,
                          child: FutureBuilder(
                              future:  _dataCotisationByClient,
                              builder: (context, AsyncSnapshot snapshot) {
                                if (snapshot.connectionState ==
                                    ConnectionState.waiting) {
                                  return Center(
                                      child: CircularProgressIndicator());
                                } else {
                                  if (snapshot.data == null) {
                                    if(MongoDatabase.db.state == M.State.closed){
                                      MongoDatabase.getConnection();
                                    }
                                    print("Test Etat : "+MongoDatabase.db.state.toString());
                                    return Center(
                                      child: Text("Pas de tontine en cours"),
                                    );
                                  }
                                  if (snapshot.hasData &&
                                      snapshot.connectionState ==
                                          ConnectionState.done) {
                                    clientCotisationsName.clear();
                                    clientCotisationsList.clear();
                                    return ListView.builder(
                                        itemCount: snapshot.data.length,
                                        itemBuilder: (context, index) {
                                          clientCotisationsList.add(
                                              CotisationModel.fromJson(
                                                  snapshot.data[index]));
                                          clientCotisationsName.add(
                                              snapshot.data[index]['id_mise']);
                                          CotisationModel cotModel =
                                              CotisationModel.fromJson(
                                                  snapshot.data[index]);
                                          return FutureBuilder(
                                              future: MongoDatabase.getTontineById(
                                                  cotModel.id_mise),
                                              builder: (context,
                                                  AsyncSnapshot snapshot) {
                                                if (snapshot.connectionState ==
                                                    ConnectionState.waiting) {
                                                  return Text("Chargement ...");
                                                }
                                                if (snapshot.hasData &&
                                                    snapshot.connectionState ==
                                                        ConnectionState.done) {
                                                  TontineModel miseMode =
                                                      snapshot.data;
                                                  return ViewCurrClientCotisation(
                                                      widget.clientModel,
                                                      cotModel,
                                                      miseMode);
                                                } else
                                                  return Text("Pas de mise");
                                              });
                                        });
                                  } else
                                    return Center(child: Text('No data Found'));
                                }
                              }),
                        ),
                      ],
                    ),
                  )
                ],
              ),
            ),
          ),
        ),
        floatingActionButton: FloatingActionButton.extended(
          backgroundColor: secondaryColor,
          label: Text(
            "Tontine",
            style: TextStyle(color: primaryColor),
          ),
          icon: const Icon(
            Icons.add,
            color: primaryColor,
          ),
          shape:
              BeveledRectangleBorder(borderRadius: BorderRadius.circular(8.0)),
          onPressed: () {
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (_) => OtherMise(
                        clientModel: widget.clientModel,
                        clientMMembre: clientCotisationsName)));
          },
        ));
  }

  Widget ViewCurrClientCotisation(ClientModel clientModel,
      CotisationModel cotisationModel, TontineModel tontineModel) {
    return GestureDetector(
        onTap: () {
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (_) => CotisationForm(
                        clientModel: clientModel,
                        cotisationModel: cotisationModel,
                        tontineModel: tontineModel,
                      )));
        },
        child: Card(
          elevation: 2,
          color: Colors.white,
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(
                      width: 250,
                      child: Text(
                        "Type: ${tontineModel.typeTontine}",
                        maxLines: 2,
                        style: TextStyle(
                          fontFamily: globalTextFont,
                          fontSize: 18,
                        ),
                      ),
                    ),
                    Text(
                      "Montant: ${tontineModel.montantTontine} FCFA",
                      style: TextStyle(
                          fontFamily: globalTextFont, color: Colors.grey),
                    )
                  ],
                ),
                IconButton(
                    onPressed: () {
                      String value =
                          getClientCotId(cotisationModel, tontineModel)
                              .toString();
                    },
                    icon: const Icon(Icons.delete))
              ],
            ),
          ),
        ));
  }

  deleteClientCot(CotisationModel cotisation, TontineModel tontine) async {
    showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              title: Text(
                "Attention",
                style: TextStyle(color: Colors.red),
              ),
              content: Container(
                  height: 100,
                  width: 500,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      Text("Supprimer la cotisation de ",
                          style: TextStyle(
                              fontSize: 18, fontFamily: globalTextFont)),
                      Text(
                        "${widget.clientModel.id} : ${tontine.typeTontine}",
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ],
                  )),
              actions: [
                Container(
                  margin: EdgeInsets.all(20.0),
                  child: ElevatedButton(
                    onPressed: () async {
                      if (loading == false) {
                        setState(() {
                          loading = true;
                          _dataCotisationByClient = MongoDatabase.getCotisationByClientId(widget.clientModel.id);
                        });
                       // Navigator.pop(context);
                        await CotisationModel.deleteCotisationById(
                            cotisation.id, context).whenComplete((){
                          setState(() {
                            loading = false;
                            _dataCotisationByClient =
                                MongoDatabase.getCotisationByClientId(
                                    widget.clientModel.id);
                          });
                        });
                        Navigator.of(context, rootNavigator: true).pop();
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      minimumSize: Size(150, 50),
                    ),
                    child: loading
                        ? const CircularProgressIndicator(
                            color: Colors.white,
                          )
                        : Text("Oui S'upprimer"),
                  ),
                ),
                Container(
                  margin: EdgeInsets.all(10.0),
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.of(context, rootNavigator: true).pop();
                    },
                    child: Text("Non! Annuler"),
                    style: ElevatedButton.styleFrom(
                      minimumSize: Size(150, 50),
                    ),
                  ),
                ),
              ],
            );
          },
        );
      },
    );
  }
}
