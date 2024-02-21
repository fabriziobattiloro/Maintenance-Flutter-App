import 'package:ethos_app/Components/UnregisteredMachineAlert.dart';
import 'package:flutter/material.dart';

import '../DataTypes/Controllo.dart';
import '../Screens/ShowControl.dart';
import 'database_command.dart';

Future SearchControl(context) {
  String codice = "";
  late TextEditingController _codice = TextEditingController();
  GlobalKey<FormState> _formkey = GlobalKey<FormState>();
  return showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          backgroundColor: Colors.grey.shade200,
          title: const Text('Inserisci il codice'),
          content: Form(
            key: _formkey,
            child: TextFormField(
              controller: _codice,
              autovalidateMode: AutovalidateMode.onUserInteraction,
              validator: (value) =>
                  value != null && value.isNotEmpty ? null : "Campo vuoto",
              decoration: InputDecoration(
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                errorMaxLines: 3,
                fillColor: Colors.white,
                filled: true,
                hintText: 'Codice',
              ),
              onChanged: (String value) {
                codice = value;
              },
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context, false);
              },
              child: Text(
                'Annulla',
                style: TextStyle(color: Colors.grey.shade600),
              ),
            ),
            TextButton(
              child: Text(
                'Cerca',
                style: TextStyle(color: Colors.red.shade900),
              ),
              onPressed: () async {
                if (_formkey.currentState!.validate()) {
                  //Navigator.of(context).pop();
                  bool presente = await isControlloPresente(codice);
                  if (presente == true) {
                    Controllo c = await getControllo(codice);
                    print("Controllo caricato correttamente");
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) =>
                                ControlView(controllo: c)));
                  } else {
                    showDialog(
                      context: context,
                      builder: (context) {
                        return UnregisteredMachineAlert(codice: codice);
                      },
                    );
                  }
                }
              },
            )
          ],
        );
      });
}
