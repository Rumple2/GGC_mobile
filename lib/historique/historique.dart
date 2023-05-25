import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:syncfusion_flutter_datepicker/datepicker.dart';
import '../API/Config.dart';
import '../API/api_service.dart';
import '../Static.dart';
import '../models/agent_model.dart';
import '../models/cotisation_model.dart';
import '../models/tontine_model.dart';

// Afficher l'historique des cotisations journalière d'un agent
class Historique extends StatefulWidget {
  const Historique({Key? key}) : super(key: key);

  @override
  State<Historique> createState() => _HistoriqueState();
}

class _HistoriqueState extends State<Historique> {
  ScrollController _scrollController = ScrollController();
  var _dataAgents;
  var _dataCotisationsByAgent;
  var _dataTontines;
  double textFieldWidth = 200;
  late List<AgentModel> agentList = [];
  late List<AgentModel> _filterAgentList = [];
  late List<CotisationModel> cotisations = [];
  late List<CotisationModel> filteredCotisationsByDate = [];
  late List<TontineModel> typeTontines = [];
  List<DataRow> _tableRow = [];
  DateTime selectedDate = DateTime.now();

  //Montant total effectuer par un agent de la journée
  double montantTotalDay = 0;

  //Recupération des cotisations éffectuer dans la journée
  void cotisationToday(DateTime date) {
    DateTime todayDate = DateTime.now();
    List<CotisationModel> findCotisationsByDate = [];
    filteredCotisationsByDate = cotisations;
    montantTotalDay = 0;
    for (int i = 0; i < filteredCotisationsByDate.length; i++) {
      for (int j = 0; j < filteredCotisationsByDate[i].dates_cot.length; j++) {
        for (int z = 0;
            z < filteredCotisationsByDate[i].dates_cot[j].length;
            z++) {
          //print(DateFormat.yMd().format(filteredCotisationsByDate[i].dates_cot[j][z]));
          if (DateFormat.yMd()
                  .format(filteredCotisationsByDate[i].dates_cot[j][z]) ==
              DateFormat.yMd().format(date)) {
            findCotisationsByDate.add(filteredCotisationsByDate[i]);
            totalDay(getTypeTontine(filteredCotisationsByDate[i].id_mise)
                .montantParMise);
          }
        }
      }
    }
    setState(() {
      filteredCotisationsByDate = findCotisationsByDate;
      selectedDate = date;
    });
  }

  TontineModel getTypeTontine(String id) {
    return typeTontines.where((tontine) => tontine.id == id).first;
  }

  void totalDay(double montant) {
    montantTotalDay = montantTotalDay + montant;
  }

  @override
  void initState() {
    _dataAgents = MongoDatabase.getCollectionData(Config.agent_collection);
    _dataCotisationsByAgent =
        MongoDatabase.getCotisationByAgentId(AgentModel.agentSession.id);

    _dataTontines = MongoDatabase.getCollectionData(Config.tontine_collection)
        .then((value) {
      typeTontines.clear();
      for (int i = 0; i < value.length; i++) {
        typeTontines.add(TontineModel.fromJson(value[i]));
      }
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          iconTheme: const IconThemeData(color: Colors.black),
          backgroundColor: Colors.white,
          title: const Text("Historique / J"),
          centerTitle: true,
          elevation: 0,
        ),
        bottomNavigationBar: Card(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              "Total : ${montantTotalDay} F",
              style: TextStyle(
                  fontSize: 18, fontWeight: FontWeight.bold, color: Colors.red),
            ),
          ),
        ),
        body: Column(children: [
          Expanded(
              flex: 1,
              child: Card(
                child: Row(
                  children: [
                    Card(
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(
                          "Date : ${DateFormat.yMMMd().format(selectedDate)}",
                          style: TextStyle(color: Colors.red),
                        ),
                      ),
                    ),
                    Card(
                      child: IconButton(
                          onPressed: () {
                            cotisationToday(DateTime.now());
                          },
                          icon: Icon(Icons.today)),
                    ),

                    Card(
                      child: IconButton(
                          onPressed: () {
                            // Choix date de cotisation
                            showDialog(
                                context: context,
                                builder: (context) {
                                  return StatefulBuilder(
                                    builder: (BuildContext context,
                                        void Function(void Function()) setState) {
                                      return AlertDialog(
                                        content: Container(
                                          height:
                                              MediaQuery.of(context).size.height *
                                                  0.5,
                                          width:
                                              MediaQuery.of(context).size.width *
                                                  0.5,
                                          padding: EdgeInsets.all(8),
                                          child: SfDateRangePicker(
                                            showActionButtons: true,
                                            onSubmit: (value) {
                                              Navigator.of(context).pop();
                                              setState(() {
                                                cotisationToday(
                                                    value as DateTime);
                                              });
                                            },
                                            onCancel: () {
                                              Navigator.of(context).pop();
                                            },
                                            initialDisplayDate: DateTime.now(),
                                            showNavigationArrow: true,
                                            cancelText: "Quitrer",
                                            confirmText: "Ok",
                                          ),
                                        ),
                                      );
                                    },
                                  );
                                });
                          },
                          icon: Icon(Icons.calendar_month)),
                    )
                  ],
                ),
              )),
          Expanded(
              flex: 15,
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: FutureBuilder(
                    future: _dataCotisationsByAgent,
                    builder: (context, AsyncSnapshot snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return const Center(
                          child: CircularProgressIndicator(),
                        );
                      }
                      if (snapshot.connectionState == ConnectionState.done &&
                          snapshot.hasData) {
                        cotisations.clear();
                        _tableRow.clear();
                        for (int i = 0; i < snapshot.data.length; i++) {
                          cotisations
                              .add(CotisationModel.fromJson(snapshot.data[i]));
                        }
                        // filteredCotisationsByDate = cotisations;

                        for (int i = 0;
                            i < filteredCotisationsByDate.length;
                            i++) {
                          DataRow aRow = DataRow(
                            onSelectChanged: (value) {},
                            color: MaterialStateColor.resolveWith((states) {
                              //total = data[i]['nb_nuit'] * data[i]['cout']*1.0;
                              return const Color.fromRGBO(
                                  213, 214, 2, 223); //make tha magic!
                            }),
                            cells: [
                              DataCell(Text("${i + 1}")),
                              DataCell(Text(
                                  "${filteredCotisationsByDate[i].id_client}")),
                              DataCell(Text(
                                  "${getTypeTontine(filteredCotisationsByDate[i].id_mise).typeTontine}")),
                            ],
                          );
                          _tableRow.add(aRow);
                        }
                        return Container(
                          height: MediaQuery.of(context).size.height,
                          width: MediaQuery.of(context).size.width,
                          child: ListView(
                            children: [
                              DataTable(
                                  headingRowColor:
                                      MaterialStateColor.resolveWith(
                                          (states) => globalColor),
                                  showCheckboxColumn: false,
                                  dividerThickness: 2,
                                  dataRowHeight: 35,
                                  headingRowHeight: 70,
                                  columns: [
                                    DataColumn(
                                      label: Text(
                                        "",
                                        style: columnTextStyle,
                                      ),
                                    ),
                                    DataColumn(
                                      label: Text(
                                        "Client",
                                        style: columnTextStyle,
                                        overflow: TextOverflow.visible,
                                        softWrap: true,
                                      ),
                                    ),
                                    DataColumn(
                                      label: Text(
                                        "type",
                                        style: columnTextStyle,
                                        overflow: TextOverflow.visible,
                                        softWrap: true,
                                      ),
                                    ),
                                  ],
                                  rows: _tableRow),
                            ],
                          ),
                        );
                      }
                      return Center(
                        child: Text("No data"),
                      );
                    }),
              ))
        ]));
  }

  viewHistorique() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text("GGC_GRE_1"),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text("Type_T"),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text("Nb cot"),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text("Montant"),
            ),
          ],
        ),
        SizedBox(
          width: MediaQuery.of(context).size.width,
          height: 1,
          child: Container(
            color: Colors.black,
          ),
        )
      ],
    );
  }
}
