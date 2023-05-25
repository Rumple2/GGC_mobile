import 'package:flutter/material.dart';
import 'package:ggc/models/tontine_model.dart';
import '../API/api_service.dart';
import 'package:mongo_dart/mongo_dart.dart';

import '../API/config.dart';
import 'achatTrans_model.dart';
import 'agent_model.dart';

class CotisationModel {
  late String id;
  late String id_client;
  late String id_mise;
  late String id_agent;
  double solde = 0.0;
  List pages = [];
  List dates_cot = [];
  int posPage = 0;

  CotisationModel();

  CotisationModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    id_client = json['id_client'];
    id_mise = json['id_mise'];
    solde = json['solde'];
    pages = json['pages'];
    dates_cot = json['date_cot'];
    posPage = json['posPage'];
    id_agent = json['id_agent'];
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['id'] = id;
    _data['id_client'] = id_client;
    _data['id_mise'] = id_mise;
    _data['solde'] = solde;
    _data['date_cot'] = dates_cot;
    _data['pages'] = pages;
    _data['posPage'] = posPage;
    _data['id_agent'] = id_agent ;
    return _data;
  }

  static Future<void> insertCotisation(String clientId, String miseId, BuildContext context) async {
    var _id = ObjectId().$oid;
    CotisationModel cotisationModel = CotisationModel();
    cotisationModel.id = _id;
    cotisationModel.id_client  = clientId;
    cotisationModel.id_mise = miseId;
    cotisationModel.pages.add([]);
    cotisationModel.dates_cot.add([]);
    cotisationModel.id_agent = AgentModel.agentSession.id;
    var result_res = await MongoDatabase.insert(
        cotisationModel.toJson(), Config.cotisation_collection);
    ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(content: Text("Cotisation Enregistré ")));
  }


  static Future<void> cloturerCotisation(CotisationModel cotisationModel,TontineModel tontineModel,int nombre,BuildContext context) async{
    var resultC = await MongoDatabase.cloturerCotisation(cotisationModel.id_client,tontineModel.id);
    var resultA = AchatTransModel.transactionFinCloture(cotisationModel, tontineModel, context);
    Navigator.pop(context);
    ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(content: Text("Cotisation cloturé "),backgroundColor: Colors.green,));
  }
  static Future<void> deleteCotisationById(String cotId,BuildContext context) async{
    var resultC = await MongoDatabase.deleteById(cotId,Config.cotisation_collection);
    ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(content: Text("Cotisation Supprimé "),backgroundColor: Colors.green,));
  }
}
