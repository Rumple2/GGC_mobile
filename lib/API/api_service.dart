import 'package:ggc/models/agent_model.dart';
import 'package:ggc/models/cotisation_model.dart';
import 'package:ggc/models/tontine_model.dart';
import 'package:mongo_dart/mongo_dart.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'config.dart';
import 'encryption.dart';

class MongoDatabase {
  static var dbcollection;
  static late Db db;

  static getConnection() async {
    print("Actual State ${db.state}");
    if (!db.isConnected || db.state == State.opening) {
      await db.close();
      print('closing the opening connexion');
    }

    if (db.state == State.closed) {
      print('opening connexion');
      connect();
    }

    print("Db State ${db.state}");
  }

  static connect() async {
    db = await Db.create(Config.MONGO_CONN_URL);
    try {
      await db.open();
    } catch (e) {
      print('Failed to open DB: $e');
      rethrow;
    }
  }

  static Future<List<Map<String, dynamic>>> getCollectionData(
      String collection) async {
    getConnection();
    final dataCollection = db.collection(collection);
    final arrData = await dataCollection.find().toList();
    return arrData;
  }

 /* static saveAgentSession(AgentModel agent) async {
    SharedPreferences.setMockInitialValues({});
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString("ggc_agent_id", agent.id);
    await prefs.setString("ggc_agent_telephone", agent.telephone);
    await prefs.setString("ggc_agent_mdp", agent.mdp);
  }

  static Future<bool> getAgentSession() async {
    final prefs = await SharedPreferences.getInstance();
    var a_id = prefs.getString("ggc_agent_id");
    var a_telephone = prefs.getString("ggc_agent_telephone");
    var a_mdp = prefs.getString("ggc_agent_mdp");
    if (a_id != null && a_mdp != null && a_telephone != null) {
      AgentModel.agentSession.id = a_id;
      AgentModel.agentSession.telephone = a_telephone;
      AgentModel.agentSession.mdp = a_mdp;
      return true;
    }
    print(false);
    return false;
  }

  static removeAgentSession(AgentModel agent) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove("ggc_agent_id");
    await prefs.remove("ggc_agent_telephone");
    await prefs.remove("ggc_agent_mdp");
  }*/

  // Recuperation de la taille d'une collection
  // C'est à dire le nombre d'informations à l'intérieur.
  static getLength() async {
    getConnection();
    var idCollection = db.collection(Config.client_collection);
    final getIdLength = await idCollection.find().length;
    // await db.close();
    return getIdLength;
  }

  //Enregistrement d'une donnees
  static Future<String> insert(var data, String collection) async {
    getConnection();
    try {
      var insertCollection = db.collection(collection);
      final result = await insertCollection.insertOne(data);
      if (result.isSuccess || result.operationSucceeded) {
        return "Data Inserted";
      } else
        return "Operation Failled";
    } catch (e) {
      print(e.toString());
      return e.toString();
    } finally {
      connect();
    }
  }

  // Mise à jour de la cotisation d'un client
  // C'est la fonction qui permet l'ajout des cotisations journalière dans la collection de cotisation du client
  static Future<void> updateClientCotPageAndDate(
      CotisationModel cotisationModel,
      int nombre,
      double montant,
      context) async {
    getConnection();
    var cotCollection = db.collection(Config.cotisation_collection);
    final date = DateTime.now();
    var findC = await cotCollection.findOne({
      "id_client": cotisationModel.id_client,
      "id_mise": cotisationModel.id_mise
    });
    CotisationModel cotisation = CotisationModel.fromJson(findC!);
    print("Init Cot length : ${cotisation.dates_cot[cotisation.posPage].length}");

    var filter = where
        .eq('id_client', cotisationModel.id_client)
        .and(where.eq('id_mise', cotisationModel.id_mise));
    if (nombre > 0) {
      for (int i = 0; i < nombre; i++) {
          if(cotisation.dates_cot[cotisation.posPage].length == 31){
            cotisation.dates_cot.add([]);
            cotisation.pages.add([]);
            cotisation.posPage = cotisation.posPage + 1;
          }
          cotisation.dates_cot.elementAt(cotisation.posPage).add(date);
          cotisation.pages.elementAt(cotisation.posPage).add(1);
          cotisation.solde = cotisation.solde + montant;
      }
    } else {
      cotisation.dates_cot.elementAt(cotisation.posPage).add(date);
      cotisation.pages.elementAt(cotisation.posPage).add(1);
      cotisation.solde = cotisation.solde + montant;
    }

    var update = {r'$set': cotisation.toJson()};
    var result = await cotCollection.update(filter, update);
  }

// Mise à jour d'une collection
  static Future<void> updateCollection(var data,String collection) async{
    getConnection();
    var cotCollection = db.collection(collection);
    var filter = where.eq('id', data.id);
    var update = {r'$set': data.toJson()};
    var result = await cotCollection.update(filter, update);
  }

  //Cloture de la page en actuelle vers une nouvelle page
  static Future<void> cloturerCotisation(String clientId, String miseId) async {
    getConnection();
    var dataColl = db.collection(Config.cotisation_collection);
    var findC =
        await dataColl.findOne({"id_client": clientId, "id_mise": miseId});

    CotisationModel cotisation = CotisationModel.fromJson(findC!);
    cotisation.pages.add([]);
    cotisation.dates_cot.add([]);
    cotisation.posPage += 1;
    var filter =
        where.eq('id_client', clientId).and(where.eq('id_mise', miseId));
    var update = {r'$set': cotisation.toJson()};
    var result = await dataColl.update(filter, update);
  }


  //Recuperation des cotisations par client grace a leur id
  static Future<List<Map<String, dynamic>>> getCotisationByClientId(
      String? clientId) async {
    getConnection();
    final dataCollection = db.collection(Config.cotisation_collection);
    final arrData =
        await dataCollection.find(where.eq("id_client", clientId)).toList();
    return arrData;
  }

  //Recuperation des cotisations par agent grace a leur id
  static Future<List<Map<String, dynamic>>> getCotisationByAgentId(
      String AgentId) async {
    getConnection();
    final dataCollection = db.collection(Config.cotisation_collection);
    final arrData =
    await dataCollection.find(where.eq("id_agent", AgentId)).toList();
    return arrData;
  }

  //Recuperation des cotisations par id des clients et l'id des Tontines
  static Future<CotisationModel> getCotisationByClientIdAndMiseId(
      String idClient, String idMise) async {
    getConnection();
    final dataCollection = db.collection(Config.cotisation_collection);
    final findC = await dataCollection
        .findOne({"id_client": idClient, "id_mise": idMise});
    return CotisationModel.fromJson(findC!);
  }

  //Recuperation des clients par agent
  static Future<List<Map<String, dynamic>>> getClientByAgent(
      String idAgent) async {
    getConnection();
    final dataCollection = db.collection(Config.client_collection);
    final findC =
        await dataCollection.find(where.eq("id_agent", idAgent)).toList();
    return findC;
  }

  //Recuperation des tontines par id
  static Future<TontineModel> getTontineById(String? miseId) async {
    getConnection();
    var dataCollection = db.collection(Config.tontine_collection);
    var arrData = await dataCollection.findOne({"id": miseId});

    return TontineModel.fromJson(arrData!);
  }

  static Future<String> deleteById(String id, String collection) async {
    final db = await Db.create(Config.MONGO_CONN_URL);
    await db.open();
    var dataCollection = db.collection(collection);
    var result = await dataCollection.remove(where.eq('id', id));
    await db.close();
    return result.toString();
  }

  static Future<String> deleteClientCotById(
      String idCotisation, String collection) async {
    final db = await Db.create(Config.MONGO_CONN_URL);
    await db.open();
    var dataCollection = db.collection(collection);
    var result = await dataCollection.remove(where.eq('id', idCotisation));
    await db.close();
    return result.toString();
  }

  static Future<bool> agentLogin(String numTel, String mdp) async {
    getConnection();
    bool reponse = false;
    String mdpCrypted = Encryption.EncryptPassword(mdp);
    print(numTel);
    final dataCollection = db.collection(Config.agent_collection);
    var arrData =
        await dataCollection.findOne({"telephone": numTel, "mdp": mdpCrypted});
    if (arrData != null) {
      reponse = true;
      AgentModel.agentSession = AgentModel.fromJson(arrData);
      MongoDatabase.saveAgentSession(AgentModel.agentSession);
      print(arrData);
    } else
      reponse = false;
    return reponse;
  }
}
