import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:mongo_dart/mongo_dart.dart' as M;
import '../../API/api_service.dart';
import '../../API/config.dart';

class TontineModel{
  late String id;
  late String typeTontine;
  late double montantTontine;
  late double montantParMise;
  late double montantPrelever;

  TontineModel();

  TontineModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    typeTontine = json['typeTontine'];
    montantTontine = json['montantTontine'];
    montantParMise = json['montantMise'];
    montantPrelever = json['montant_prelever'];
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['id'] = id;
    _data['nom'] = typeTontine;
    _data['montantTontine'] = montantTontine;
    _data['montantMise'] = montantParMise;
    _data['montant_prelever'] = montantPrelever;

    return _data;
  }

  static Future<void> insertTontine(
      TontineModel miseModel, BuildContext context) async {
    final _id = M.ObjectId().$oid;
    miseModel.id = _id;
    var result = await MongoDatabase.insert(
        miseModel.toJson(), Config.tontine_collection);
    ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(content: Text("Mise Enregistré ")));
  }
}