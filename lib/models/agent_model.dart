import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../API/encryption.dart';
import 'package:mongo_dart/mongo_dart.dart' as M;
import '../API/api_service.dart';
import '../API/config.dart';

class AgentModel{
  late String id;
  late String nom;
  late String prenom;
  late String telephone;
  late String adresse;
  late String zoneAffectation;
  late String mdp;

static late AgentModel agentSession = AgentModel();

  AgentModel();

  AgentModel.fromJson(Map<String, dynamic> json){
    id = json['id'];
    nom = json['nom'];
    prenom =json['prenom'];
    telephone = json['telephone'];
    adresse = json['adresse'];
    zoneAffectation = json ['zoneA'];
    mdp = json['mdp'];
  }

  Map<String,dynamic> toJson(){
    final _data = <String,dynamic> {};
    _data['id'] = id;
    _data['nom'] = nom;
    _data['prenom'] = prenom;
    _data['telephone'] = telephone;
    _data['adresse'] = adresse;
    _data['mdp'] = mdp;
    _data['zoneA'] = zoneAffectation;

    return _data;
  }

  static Future<void> insertAgent(
      AgentModel userModel, BuildContext context) async {
      userModel.mdp = Encryption.EncryptPassword(userModel.mdp);
      final _id = M.ObjectId().$oid;
      userModel.id = _id;
    var result = await MongoDatabase.insert(
        userModel.toJson(), Config.agent_collection);
    ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(content: Text("Agent Enregistré "),
    backgroundColor: Colors.green,
    )
    );
  }
}
