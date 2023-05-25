import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:mongo_dart/mongo_dart.dart' as M;
import '../API/api_service.dart';
import '../API/config.dart';

class UserModel{
  late String id;
  late String nom;
  late String prenom;
  late String telephone;
  late String mdp;


  UserModel({
    required nom,
    required prenom,
    required telephone,
    required mdp
  });

  UserModel.fromJson(Map<String, dynamic> json){
    id = json['id'];
    nom = json['nom'];
    prenom =json['prenom'];
    telephone = json['telephone'];
    mdp = json['mdp'];

  }
  Map<String,dynamic> toJson(){
    final _data = <String,dynamic> {};
    _data['id'] = id;
    _data['nom'] = nom;
    _data['prenom'] = prenom;
    _data['telephone'] = telephone;
    _data['mdp'] = mdp;

    return _data;
  }

  static Future<void> insertClient(
      UserModel userModel, BuildContext context) async {
    final _id = M.ObjectId().$oid;
    userModel.id = _id;
    var result = await MongoDatabase.insert(
        userModel.toJson(), Config.client_collection);
    ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(content: Text("User Enregistré ")));
  }
}