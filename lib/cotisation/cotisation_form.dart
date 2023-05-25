import 'package:flutter/material.dart';
import 'package:ggc/client/cotisationCalendrier.dart';
import 'package:ggc/models/cotisation_model.dart';
import '../models/client_model.dart';
import '../models/tontine_model.dart';
import '../Static.dart';

class CotisationForm extends StatefulWidget {
  CotisationForm(
      {required this.clientModel,
      required this.cotisationModel,
      required this.tontineModel,
      Key? key})
      : super(key: key);
  ClientModel clientModel;
  TontineModel tontineModel;
  CotisationModel cotisationModel;

  @override
  State<CotisationForm> createState() => _CotisationFormState();
}

class _CotisationFormState extends State<CotisationForm> {
  bool loading = false;
  bool cotisationChecked = false;
  bool clotureChecked = false;
  final formKey = GlobalKey<FormState>();
  int nombre = 1;
  Text alert = Text("");

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          actions: [
            IconButton(
                onPressed: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (_) => CotisationCalendrier(
                                clientModel: widget.clientModel,
                                miseModel: widget.tontineModel,
                              )));
                },
                icon: Icon(Icons.stacked_bar_chart))
          ],
        ),
        body: SafeArea(
            child: SingleChildScrollView(
          child: Column(
            children: [
              Container(
                height: 50,
                width: 200,
                child: Center(child: Image.asset("assets/images/ggc_logo.png")),
              ),
              Text(
                "Cotisation",
                style: TextStyle(
                    color: secondaryColor,
                    fontSize: 34,
                    fontFamily: globalTextFont),
              ),
              Container(
                  height: MediaQuery.of(context).size.height * 0.85,
                  width: MediaQuery.of(context).size.width,
                  decoration: const BoxDecoration(
                      color: neutralColor,
                      borderRadius: BorderRadius.only(
                          topRight: Radius.circular(30),
                          topLeft: Radius.circular(30))),
                  child: Form(
                    child: ListView(
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const SizedBox(
                                height: 50,
                              ),
                              RichText(
                                  text: TextSpan(
                                      text: "Numéro client : ",
                                      style: staticInfoTextStyle,
                                      children: [
                                    TextSpan(
                                        text: "${widget.clientModel.id}",
                                        style: infoClientTextStyle)
                                  ])),
                              SizedBox(
                                child: Container(
                                  margin: EdgeInsets.all(8.0),
                                  height: 2,
                                  width:
                                      MediaQuery.of(context).size.width * 0.8,
                                  color: Colors.black12,
                                ),
                              ),
                              RichText(
                                  text: TextSpan(
                                      text: "Numéro Cotisation : ",
                                      style: staticInfoTextStyle,
                                      children: [
                                    TextSpan(
                                        text: "${widget.tontineModel.id}",
                                        style: infoClientTextStyle)
                                  ])),
                              SizedBox(
                                child: Container(
                                  margin: EdgeInsets.all(8.0),
                                  height: 2,
                                  width:
                                      MediaQuery.of(context).size.width * 0.8,
                                  color: Colors.black12,
                                ),
                              ),
                              RichText(
                                  text: TextSpan(
                                      text: "Nom : ",
                                      style: staticInfoTextStyle,
                                      children: [
                                    TextSpan(
                                        text: "${widget.clientModel.nom}",
                                        style: infoClientTextStyle)
                                  ])),
                              SizedBox(
                                child: Container(
                                  margin: EdgeInsets.all(8.0),
                                  height: 2,
                                  width:
                                      MediaQuery.of(context).size.width * 0.8,
                                  color: Colors.black12,
                                ),
                              ),
                              RichText(
                                  text: TextSpan(
                                      text: "Prénom : ",
                                      style: staticInfoTextStyle,
                                      children: [
                                    TextSpan(
                                        text: "${widget.clientModel.prenom}",
                                        style: infoClientTextStyle)
                                  ])),
                              SizedBox(
                                child: Container(
                                  margin: EdgeInsets.all(8.0),
                                  height: 2,
                                  width:
                                      MediaQuery.of(context).size.width * 0.8,
                                  color: Colors.black12,
                                ),
                              ),
                              RichText(
                                  text: TextSpan(
                                      text: "Type de tontine : ",
                                      style: staticInfoTextStyle,
                                      children: [
                                    TextSpan(
                                        text:
                                            "${widget.tontineModel.typeTontine}",
                                        style: infoClientTextStyle)
                                  ])),
                              SizedBox(
                                child: Container(
                                  margin: EdgeInsets.all(8.0),
                                  height: 2,
                                  width:
                                      MediaQuery.of(context).size.width * 0.8,
                                  color: Colors.black12,
                                ),
                              ),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceAround,
                                children: [
                                  RichText(
                                      text: TextSpan(
                                          text: "Pages: ",
                                          style: staticInfoTextStyle,
                                          children: [
                                        TextSpan(
                                            text:
                                                "${widget.cotisationModel.posPage + 1}",
                                            style: infoClientTextStyle)
                                      ])),
                                  RichText(
                                      text: TextSpan(
                                          text: "Cases: ",
                                          style: staticInfoTextStyle,
                                          children: [
                                        TextSpan(
                                            text:
                                                "${widget.cotisationModel.dates_cot[widget.cotisationModel.posPage].length} / 31",
                                            style: infoClientTextStyle)
                                      ])),
                                ],
                              ),
                              SizedBox(
                                child: Container(
                                  margin: EdgeInsets.all(8.0),
                                  height: 2,
                                  width:
                                      MediaQuery.of(context).size.width * 0.8,
                                  color: Colors.black12,
                                ),
                              ),
                              Row(
                                children: [
                                  SizedBox(
                                    width: 20,
                                  ),
                                  /*Expanded(
                                      child: Row(
                                    children: [
                                      Transform.scale(
                                        scale: 3,
                                        child: Checkbox(
                                          value: cotisationChecked,
                                          onChanged: (value) {
                                            setState(() {
                                              cotisationChecked = value!;
                                              if (cotisationChecked == true) {
                                                alert = Text("");
                                                clotureChecked = false;
                                              }
                                            });
                                          },
                                        ),
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.all(20.0),
                                        child: Text(
                                          "Nouvelle Mise",
                                          style: TextStyle(
                                            fontWeight: FontWeight.w700,
                                          ),
                                        ),
                                      )
                                    ],
                                  )),*/
                                  Expanded(
                                    child: Row(
                                      children: [
                                        Padding(
                                          padding: const EdgeInsets.all(20.0),
                                          child: Text("Cloturé la page",
                                              style: TextStyle(
                                                fontWeight: FontWeight.w700,letterSpacing: 2
                                              )),
                                        ),
                                        Transform.scale(
                                          scale: 2,
                                          child: Checkbox(
                                              value: clotureChecked,
                                              onChanged: (value) {
                                                setState(() {
                                                  clotureChecked =
                                                      !clotureChecked;
                                                  if (cotisationChecked ==
                                                      true) {
                                                    cotisationChecked = false;
                                                  }
                                                });
                                              }),
                                        ),

                                      ],
                                    ),
                                  ),
                                ],
                              ),
                              Container(
                                  margin: EdgeInsets.all(15.0),
                                  padding: EdgeInsets.symmetric(horizontal: 8),
                                  decoration: const BoxDecoration(
                                    color: textFieldColor,
                                  ),
                                  child: TextFormField(
                                      onChanged: (value) {
                                        if (!value.isEmpty)
                                          nombre = int.parse(value.trim());
                                        else
                                          nombre = 0;
                                      },
                                      decoration: const InputDecoration(
                                          enabledBorder: OutlineInputBorder(
                                              borderSide: BorderSide(
                                                  color: secondaryColor)),
                                          label: Text(
                                            'Nombre',
                                            style: TextStyle(
                                                color: secondaryColor),
                                          ),
                                          border: const OutlineInputBorder()))),
                              ElevatedButton(
                                onPressed: () {
                                 if (clotureChecked == true) {
                                   if (loading == false) {
                                     setState(() {
                                       loading = true;
                                       CotisationModel.cloturerCotisation(
                                           widget.cotisationModel,
                                           widget.tontineModel,
                                           nombre,
                                           context)
                                           .whenComplete(() {
                                         setState(() {
                                           loading = false;
                                         });
                                       });
                                     });
                                   }
                                  } else {
                                   if (loading == false) {
                                     setState(() {
                                       loading = true;
                                     });
                                     ClientModel.updateClientCot(
                                         widget.cotisationModel,
                                         nombre,
                                         widget
                                             .tontineModel.montantParMise,
                                         context)
                                         .whenComplete(() {
                                       setState(() {
                                         loading = false;
                                       });
                                     });
                                   }
                                  }
                                },
                                style: ElevatedButton.styleFrom(
                                    backgroundColor: secondaryColor,
                                    minimumSize: Size(300, 50)),
                                child: loading
                                    ? CircularProgressIndicator()
                                    : const Text(
                                        "Enregistrer",
                                        style: TextStyle(color: neutralColor),
                                      ),
                              ),
                              const SizedBox(
                                height: 100,
                              )
                            ],
                          ),
                        ),
                      ],
                    ),
                  ))
            ],
          ),
        )));
  }
}
