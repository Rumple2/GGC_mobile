import 'package:flutter/material.dart';
import 'package:ggc/API/api_service.dart';

import '../models/client_model.dart';
import '../models/cotisation_model.dart';
import '../models/tontine_model.dart';
import '../Static.dart';

class CotisationCalendrier extends StatefulWidget {
  CotisationCalendrier(
      {required this.clientModel, required this.miseModel, Key? key})
      : super(key: key);
  late ClientModel clientModel = ClientModel();
  late TontineModel miseModel = TontineModel();

  @override
  State<CotisationCalendrier> createState() => _CotisationCalendrierState();
}

class _CotisationCalendrierState extends State<CotisationCalendrier> {
  late final cotisationData;
  bool mListColor = false;
  bool eListColor = false;
  String currMiseId = "";
  String currMiseName = "";
  List onePage = [];
  int sizePage = 0;
  CotisationModel cotisationModel = CotisationModel();
  int numPage = 0;
  List<TontineModel> miseList = [];

  @override
  void initState() {
    cotisationData = MongoDatabase.getCotisationByClientIdAndMiseId(
        widget.clientModel.id, widget.miseModel.id);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(),
        body: SafeArea(
          child: SingleChildScrollView(
            child: Container(
                child: FutureBuilder(
              future: cotisationData,
              builder: (context, AsyncSnapshot snapshot) {
                if (snapshot.connectionState == ConnectionState.done &&
                    snapshot.hasData) {
                  cotisationModel = snapshot.data;
                  return ClientCalendar(cotisationModel);
                }
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(
                    child: CircularProgressIndicator(),
                  );
                } else
                  return Text("Pas de Calendrier");
              },
            )),
          ),
        ));
  }

  ClientCalendar(CotisationModel cotisationModel) {
    List pages = cotisationModel.pages;

    sizePage = pages.length - 1;
    return Container(
      width: MediaQuery.of(context).size.width,
      color: Colors.white,
      child: Container(
        width: MediaQuery.of(context).size.width,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
                " ${widget.clientModel.id}: ${widget.clientModel.nom} ${widget.clientModel.prenom}",
                style: TextStyle(fontSize: 24, fontFamily: globalTextFont)),
            ElevatedButton(onPressed: (){
              setState(() {
                onePage = pages.elementAt(0);

              });
            }, child: Text("Voir pages")),
            Container(
              width: 300,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  IconButton(
                    color: Colors.red,
                      onPressed: () {
                        onePage = [];
                        if (numPage > 0) {
                          setState(() {
                            numPage--;
                            onePage = pages.elementAt(numPage);
                          });
                        }
                      },
                      icon: Icon(Icons.arrow_back_ios_new_sharp)),
                  SizedBox(
                    width: 50,
                  ),
                  Text("Page ${numPage+1}"),
                  SizedBox(
                    width: 50,
                  ),
                  IconButton(
                    color: Colors.red,
                      onPressed: () {
                        if (numPage < sizePage) {
                          setState(() {
                            numPage++;
                            onePage = pages.elementAt(numPage);
                          });
                        }
                      },

                      icon: Icon(Icons.arrow_forward_ios_sharp))
                ],
              ),
            ),
            Container(
                padding: EdgeInsets.all(10),
                margin: EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(8.0),
                  boxShadow: [
                    BoxShadow(
                      offset: Offset(0.1,0.1),
                      blurRadius: 10
                    ),
                  ]
                ),
                height: MediaQuery.of(context).size.height * 0.4,
                child: GridView.builder(
                    itemCount: 31,
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 7),
                    itemBuilder: (context, index) {
                      int caseC = index + 1;
                      bool color = false;
                      if (onePage.isNotEmpty && index < onePage.length) {
                        if (onePage.elementAt(index) == 1) color = true;
                      }
                      return Container(
                        margin: EdgeInsets.all(2.0),
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(8.0),
                            color: color ? Colors.green : Colors.white),
                        child: Center(
                          child: Text(caseC.toString()),
                        ),
                      );
                    })),
            SizedBox(height: 10,),
            Text("SOLDE DU CLIENT : ${cotisationModel.solde} Fcfa",
                style: TextStyle(fontSize: 24, fontFamily: globalTextFont)),
            SizedBox(
              child: Container(
                margin: EdgeInsets.all(8.0),
                width: MediaQuery.of(context).size.height * 0.7,
                height: 0.5,
                color: Colors.blueGrey,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
