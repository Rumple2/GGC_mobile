import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import '../Static.dart';
import '../models/client_model.dart';
class ClientForm extends StatefulWidget {
  const ClientForm({Key? key}) : super(key: key);

  @override
  State<ClientForm> createState() => _ClientFormState();
}

class _ClientFormState extends State<ClientForm> {
  bool loading = false;
  final formkey = GlobalKey<FormState>();
  List dd = [
    ['mise1', 2000],
    ['mise2', 2400],
    ['mise3', 4554]
  ];
  ClientModel clientModel = ClientModel(
      id: "A4",
      nom: "",
      prenom: "",
      nationalite: "",
      quartier: "",
      profession: "",
      contact: "",
      lieu_activite: "",
      id_agent: '');
  final _picker = ImagePicker();
  late XFile image = XFile("");

  void filePicker() async {
    XFile? selectedImage = await _picker.pickImage(source: ImageSource.gallery);
    if (selectedImage != null) {
      setState(() {
        image = selectedImage;
      });
    }
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
        backgroundColor: neutralColor,
        appBar: AppBar(
          elevation: 2,
          backgroundColor: Colors.white,
        ),
        body: SafeArea(
            child: ListView(
          children: [
            Form(
              key: formkey,
              child: Column(
                children: [
                  const SizedBox(
                    height: 25,
                  ),
                  const Text(
                    "Enregistrer un client",
                    style: TextStyle(
                        color: secondaryColor,
                        fontSize: 34,
                        fontFamily: globalTextFont),
                  ),
                  const Text(
                    "Saisir informations",
                    style: TextStyle(
                        fontSize: 18,
                        fontFamily: globalTextFont,
                        color: primaryColor),
                  ),
                  Padding(
                    padding: EdgeInsets.all(20),
                    child: ElevatedButton(
                      onPressed: () {
                        // filePicker();
                      },
                      child: const Icon(
                        Icons.camera_alt_sharp,
                        color: secondaryColor,
                      ),
                    ),
                  ),
                  Container(
                      margin: const EdgeInsets.all(15.0),
                      padding: const EdgeInsets.symmetric(horizontal: 8),
                      decoration: BoxDecoration(color: primaryColor),
                      child: TextFormField(
                          validator: (value) {
                            if (value!.isEmpty) return "Champ obligatoire *";
                          },
                          onChanged: (nom) {
                            clientModel.nom = nom.trim();
                          },
                          decoration: formDecoration("nom"))),
                  Container(
                    margin: EdgeInsets.all(15.0),
                    padding: EdgeInsets.symmetric(horizontal: 8),
                    decoration: BoxDecoration(
                      color: primaryColor,
                    ),
                    child: TextFormField(
                        onChanged: (prenom) {
                          clientModel.prenom = prenom.trim();
                        },
                        validator: (value) {
                          if (value!.isEmpty) return "Champ obligatoire *";
                        },
                        decoration: formDecoration("prenom")),
                  ),
                  Container(
                    margin: EdgeInsets.all(15.0),
                    padding: EdgeInsets.symmetric(horizontal: 8),
                    decoration: BoxDecoration(
                      color: primaryColor,
                    ),
                    child: TextFormField(
                        onChanged: (nat) {
                          clientModel.nationalite = nat.trim();
                        },
                        validator: (value) {
                          if (value!.isEmpty) {
                            return "Champs obligatoire *";
                          }
                        },
                        decoration: formDecoration("Nationalité")),
                  ),
                  Container(
                    margin: EdgeInsets.all(15.0),
                    padding: EdgeInsets.symmetric(horizontal: 8),
                    decoration: BoxDecoration(
                      color: primaryColor,
                    ),
                    child: TextFormField(
                        onChanged: (quartier) {
                          clientModel.quartier = quartier.trim();
                        },
                        validator: (value) {
                          if (value!.isEmpty) {
                            return "Champs obligatoire *";
                          }
                        },
                        decoration: formDecoration("Quartier")),
                  ),
                  Container(
                    margin: EdgeInsets.all(15.0),
                    padding: EdgeInsets.symmetric(horizontal: 8),
                    decoration: BoxDecoration(
                      color: primaryColor,
                    ),
                    child: TextFormField(
                        onChanged: (proff) {
                          clientModel.profession = proff.trim();
                        },
                        validator: (value) {
                          if (value!.isEmpty) {
                            return "Champs obligatoire *";
                          }
                        },
                        decoration: formDecoration("Profession")),
                  ),
                  Container(
                    margin: EdgeInsets.all(15.0),
                    padding: EdgeInsets.symmetric(horizontal: 8),
                    decoration: BoxDecoration(
                      color: primaryColor,
                    ),
                    child: TextFormField(
                        onChanged: (contact) {
                          clientModel.contact = contact.trim();
                        },
                        validator: (value) {
                          if (value!.isEmpty) {
                            return "Champs obligatoire *";
                          }
                        },
                        decoration: formDecoration("Contact")),
                  ),
                  Container(
                    margin: EdgeInsets.all(15.0),
                    padding: EdgeInsets.symmetric(horizontal: 8),
                    decoration: BoxDecoration(
                      color: primaryColor,
                    ),
                    child: TextFormField(
                        onChanged: (lieu) {
                          clientModel.lieu_activite = lieu.trim();
                        },
                        validator: (value) {
                          if (value!.isEmpty) {
                            return "Champs obligatoire *";
                          }
                        },
                        decoration: formDecoration("Lieu d'activités")),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: ElevatedButton(
                      onPressed: () {
                        if (loading == false) {
                          if (formkey.currentState!.validate()) {
                            setState(() {
                              loading = true;
                            });
                            ClientModel.insertClient(clientModel, context)
                                .whenComplete(() {
                              setState(() {
                                setState(() {
                                  loading = false;
                                });
                              });
                            });
                          }
                        }
                      },
                      child: loading
                          ? CircularProgressIndicator()
                          : Text(
                              "Enregistrer",
                              style: TextStyle(color: primaryColor),
                            ),
                      style: ElevatedButton.styleFrom(
                          backgroundColor: secondaryColor,
                          minimumSize: Size(300, 50)),
                    ),
                  ),
                ],
              ),
            ),
          ],
        )));
  }
}
