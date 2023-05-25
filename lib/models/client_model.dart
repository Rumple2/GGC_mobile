import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:ggc/models/agent_model.dart';
import 'package:image_picker/image_picker.dart';
import 'package:mongo_dart/mongo_dart.dart' as M;
import '../API/api_service.dart';
import '../API/config.dart';
import 'cotisation_model.dart';

class ClientModel{
  late String id;
  late String nom;
  late String prenom;
  late String nationalite;
  late String quartier;
  late String profession;
  late String contact;
  late String lieu_activite;
  late List cotisationsId;
  late String id_agent;

  ClientModel({
    this.id = "",
    this.nom = "",
    this.prenom = "",
    this.nationalite = "",
    this.quartier = "",
    this.profession = "",
    this.contact = "",
    this.lieu_activite = "",
    this.id_agent = "",
  });

  ClientModel.fromJson(Map<String, dynamic> json){
    id = json['id'];
    nom = json['nom'];
    prenom =json['prenom'];
    nationalite = json['nationalite'];
    quartier = json['quartier'];
    profession = json['profession'];
    contact = json['contact'];
    lieu_activite = json['lieu_activite'];
    cotisationsId = json['cotisationsId'];
    id_agent =json['id_agent'];
  }
  Map<String,dynamic> toJson(){
    final _data = <String,dynamic> {};
    _data['id'] = id;
    _data['nom'] = nom;
    _data['prenom'] = prenom;
    _data['nationalite'] = nationalite;
    _data['quartier'] = quartier;
    _data['profession'] = profession;
    _data['contact'] = contact;
    _data['lieu_activite'] = lieu_activite;
    _data['cotisationsId'] = cotisationsId;
    _data['id_agent'] = id_agent;
    return _data;
  }

  static String convertIntoBase64(XFile xfile) {
    final imageBytes =  File(xfile.path).readAsBytesSync();
    String base64File = base64Encode(imageBytes);
    return base64File;
  }

  // creation d''un client avec un id personnalisé
  static Future<void> insertClient(
      ClientModel clientModel,BuildContext context) async {
    final idL = await MongoDatabase.getLength() +1;
    if(clientModel.nom.length >= 3){
      clientModel.id = "GGC_${clientModel.nom.substring(0,3).toUpperCase()}_${idL}";
    }
    if(clientModel.nom.length < 3){
        if(clientModel.prenom.length >= 3){
          clientModel.id = "GGC_${clientModel.prenom.substring(0,3).toUpperCase()}_${idL}";
        }else clientModel.id = "GGC_${clientModel.nom.substring(0,clientModel.nom.length).toUpperCase()}_${idL}";

    }

    clientModel.id_agent = AgentModel.agentSession.id;
    clientModel.cotisationsId = [];
    var result= await MongoDatabase.insert(
        clientModel.toJson(), Config.client_collection).then((value){
          Navigator.pop(context);
    });
    ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(content: Text("Client Enregistré "),
      backgroundColor: Colors.green,
    ));
  }

  static Future<void> updateClientCot(CotisationModel cotisation,int nombre,double montant,context) async {
    var result = await MongoDatabase.updateClientCotPageAndDate(cotisation, nombre, montant, context);
      Navigator.pop(context);
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text("Operation terminé "),backgroundColor: Colors.green,));
    }

}
