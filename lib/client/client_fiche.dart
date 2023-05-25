import 'package:flutter/material.dart';
import '../models/client_model.dart';
import '../Static.dart';

class ClientFiche extends StatefulWidget {
  ClientFiche({required this.clientModel,Key? key}) : super(key: key);
  ClientModel clientModel;

  @override
  State<ClientFiche> createState() => _ClientFicheState();
}

class _ClientFicheState extends State<ClientFiche> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Container(
            height: MediaQuery.of(context).size.height,
            color: primaryColor,
            child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                  CircleAvatar(
                    minRadius: MediaQuery.of(context).size.width/5,
                    child: Icon(Icons.person,size: 100,),
                  ),
                SizedBox(height: 30,),
                Text("${widget.clientModel.nom} ${widget.clientModel.prenom}",style: staticInfoTextStyle,),
                Text("Contact: ${widget.clientModel.contact}",style: staticInfoTextStyle,),
                SizedBox(height: 30,),

                ListTile(
                  leading: Icon(Icons.key,color: secondaryColor,),
                  title: Text('Identifiant'),
                  subtitle: Text("${widget.clientModel.id}"),
                ),
                ListTile(
                  leading: Icon(Icons.work,color: secondaryColor,),
                  title: Text('Profession'),
                  subtitle: Text("${widget.clientModel.profession}"),
                ),
                ListTile(
                  leading: Icon(Icons.location_city,color: secondaryColor,),
                  title: Text('Quartier'),
                  subtitle: Text("${widget.clientModel.quartier}"),
                ),
                ListTile(
                  leading: Icon(Icons.flag_circle_rounded,color: secondaryColor,),
                  title: Text('Nationalité'),
                  subtitle: Text("${widget.clientModel.nationalite}"),
                ),
                ListTile(
                  leading: Icon(Icons.workspace_premium,color: secondaryColor,),
                  title: Text("Lieu d'activité"),
                  subtitle: Text("${widget.clientModel.lieu_activite}"),
                ),


              ],
            ),
          ),
        ),
      ),
    );
  }
}
