import 'package:flutter/material.dart';
import 'package:ggc/models/tontine_model.dart';
import 'package:mongo_dart/mongo_dart.dart' as M;

import '../API/Config.dart';
import '../API/api_service.dart';
import 'cotisation_model.dart';

class AchatTransModel {
  late String id;
  late String id_client;
  late String id_tontine;
  late DateTime date;
  late String designation;
  late double retrait;
  late double montant;
  late double solde;

  AchatTransModel(
      {this.id = "",
      this.solde = 0.0,
      this.montant = 0.0,
      this.designation = "",
      this.retrait = 0.0});

  AchatTransModel.fromsJson(Map<String, dynamic> json) {
    id = json['id'];
    id_client = json['id_client'];
    id_tontine = json['id_tontine'];
    date = json['date'];
    designation = json['designation'];
    retrait = json['retrait'];
    montant = json['montant'];
    solde = json['solde'];
  }

  Map<String, dynamic> toJson() {
    final _data = Map<String, dynamic>();
    _data['id'] = id;
    _data['id_client'] = id_client;
    _data['id_tontine'] = id_tontine;
    _data['date'] = date;
    _data['montant'] = montant;
    _data['designation'] = designation;
    _data['retrait'] = retrait;
    _data['solde'] = solde;
    return _data;
  }

  //Cette fonction permet de d'enregistrement l'état de l'operatino dans les transactions.
  static transactionFinCloture(CotisationModel cotisationModel,
      TontineModel tontineModel, context) async {
    AchatTransModel achatTransModel = AchatTransModel();
    achatTransModel.id = M.ObjectId().$oid;
    achatTransModel.id_client = cotisationModel.id_client;
    achatTransModel.id_tontine = tontineModel.id;
    achatTransModel.date = DateTime.now();
    achatTransModel.designation = tontineModel.typeTontine;
    achatTransModel.retrait = 0.0;
    achatTransModel.solde = cotisationModel.solde;
    await MongoDatabase.insert(achatTransModel.toJson(), Config.transaction)
        .then((value) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text("Agent Modifié"),
        backgroundColor: Colors.green,
      ));
    });
  }
}
