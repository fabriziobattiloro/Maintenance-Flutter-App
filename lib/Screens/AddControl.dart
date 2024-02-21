import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:datetime_picker_formfield/datetime_picker_formfield.dart';
import 'package:ethos_app/DataTypes/tipo.dart';
import 'package:ethos_app/Screens/QRCode.dart';
import 'package:ethos_app/Services/database_command.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../DataTypes/Controllo.dart';

class Add extends StatefulWidget {
  String c;

  Add({Key? key, required this.c}) : super(key: key);

  @override
  _Add createState() => _Add();
}

class _Add extends State<Add> {
  String tipo = "Armadi per stoccaggio";
  String periodo = "Mensile";
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _codice = TextEditingController();
  late TextEditingController _descrizione = TextEditingController();
  late TextEditingController _filename = TextEditingController();
  late TextEditingController _dataProssimoControllo = TextEditingController();
  late TextEditingController _dataUltimoControllo = TextEditingController();

  File? file;

  @override
  void initState() {
    // TODO: implement initState

    _codice = TextEditingController(text: widget.c);
    _descrizione = TextEditingController();
    _filename = TextEditingController();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    @override
    void dispose() {
      _codice.dispose();
      _descrizione.dispose();
      _filename.dispose();
      super.dispose();
    }

    return WillPopScope(
      onWillPop: () async {
        return await showDialog(
            context: context,
            builder: (context) {
              return AlertDialog(
                content: const Text('Vuoi annullare le modifiche apportate?'),
                actions: <Widget>[
                  TextButton(
                    child: const Text('Annulla'),
                    onPressed: () {
                      Navigator.of(context).pop(false);
                    },
                    style: TextButton.styleFrom(
                      primary: Colors.grey.shade600,
                    ),
                  ),
                  TextButton(
                    child: const Text('Esci'),
                    onPressed: () {
                      Navigator.of(context).pop(true);
                    },
                    style: TextButton.styleFrom(
                      primary: Colors.red.shade900,
                    ),
                  )
                ],
              );
            });
      },
      child: Scaffold(
          appBar: AppBar(
            title: const Text("Aggiungi macchina"),
            backgroundColor: Colors.red.shade900,
            leading: BackButton(
              onPressed: () => showDialog(
                  context: context,
                  builder: (context) {
                    return AlertDialog(
                      content:
                          const Text('Vuoi annullare le modifiche apportate?'),
                      actions: <Widget>[
                        TextButton(
                          child: const Text('Annulla'),
                          onPressed: () {
                            Navigator.of(context).pop();
                          },
                          style: TextButton.styleFrom(
                            primary: Colors.grey.shade600,
                          ),
                        ),
                        TextButton(
                          child: const Text('Esci'),
                          onPressed: () {
                            Navigator.of(context).pop(true);
                            Navigator.of(context).pop();
                          },
                          style: TextButton.styleFrom(
                            primary: Colors.red.shade900,
                          ),
                        )
                      ],
                    );
                  }),
            ),
          ),
          backgroundColor: Colors.white,
          body: Form(
            key: _formKey,
            child: Padding(
              padding:
                  const EdgeInsets.symmetric(vertical: 20.0, horizontal: 20),
              child: Column(
                children: [
                  Expanded(
                    child: SingleChildScrollView(
                      scrollDirection: Axis.vertical,
                      child: Column(
                        children: <Widget>[
                          TextFormField(
                            autovalidateMode:
                                AutovalidateMode.onUserInteraction,
                            decoration: InputDecoration(
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                              errorMaxLines: 3,
                              fillColor: Colors.white,
                              filled: true,
                              prefixIcon: Icon(
                                Icons.qr_code,
                                color: Colors.grey.shade600,
                              ),
                              suffixIcon: IconButton(
                                icon: const Icon(Icons.add_a_photo_sharp),
                                onPressed: () {
                                  Navigator.of(context).pushReplacement(
                                    MaterialPageRoute(
                                        builder: (context) => QRCode()),
                                  );
                                },
                              ),
                              hintText: '',
                              labelText: 'Codice',
                              labelStyle: const TextStyle(color: Colors.black),
                            ),
                            controller: _codice,
                            validator: (value) =>
                                value!.isNotEmpty ? null : "Il campo è vuoto",
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(vertical: 20),
                            child: DropdownButtonFormField(
                              value: tipo,
                              items: tip.map((String s) {
                                return DropdownMenuItem<String>(
                                    child: Text(s), value: s);
                              }).toList(),
                              onChanged: (String? value) {
                                setState(() {
                                  tipo = value!;
                                });
                              },
                              isExpanded: true,
                              dropdownColor: Colors.white,
                              decoration: InputDecoration(
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                errorMaxLines: 3,
                                fillColor: Colors.white,
                                filled: true,
                                prefixIcon: Icon(
                                  Icons.sort_by_alpha_rounded,
                                  color: Colors.grey.shade600,
                                ),
                                hintText: 'Armadi ...',
                                labelText: 'Tipologia',
                                labelStyle:
                                    const TextStyle(color: Colors.black),
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(vertical: 20),
                            child: DropdownButtonFormField(
                              value: periodo,
                              items: per.map((String s) {
                                return DropdownMenuItem<String>(
                                    child: Text(s), value: s);
                              }).toList(),
                              onChanged: (String? value) {
                                setState(() {
                                  periodo = value!;
                                });
                              },
                              isExpanded: true,
                              dropdownColor: Colors.white,
                              decoration: InputDecoration(
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                errorMaxLines: 3,
                                fillColor: Colors.white,
                                filled: true,
                                prefixIcon: Icon(
                                  Icons.timeline,
                                  color: Colors.grey.shade600,
                                ),
                                hintText: 'Mensile ...',
                                labelText: 'Periodicità',
                                labelStyle:
                                const TextStyle(color: Colors.black),
                              ),
                            ),
                          ),
                          TextFormField(
                            maxLines: null,
                            autovalidateMode:
                                AutovalidateMode.onUserInteraction,
                            minLines: 3,
                            decoration: InputDecoration(
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                              errorMaxLines: 3,
                              fillColor: Colors.white,
                              filled: true,
                              prefixIcon: Icon(
                                Icons.info_outline,
                                color: Colors.grey.shade600,
                              ),
                              hintText: '',
                              labelText: 'Descrizione intervento',
                              labelStyle: const TextStyle(color: Colors.black),
                            ),
                            controller: _descrizione,
                            validator: (value) =>
                                value!.isNotEmpty ? null : "Il campo è vuoto",
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(vertical: 24.0),
                            child: Theme(
                              data: Theme.of(context).copyWith(
                                colorScheme: ColorScheme.light(
                                  primary: Colors.red.shade900, // <-- SEE HERE
                                ),
                              ),
                              child: DateTimeField(
                                autovalidateMode:
                                    AutovalidateMode.onUserInteraction,
                                controller: _dataUltimoControllo,
                                format: DateFormat("dd/MM/yyyy"),
                                validator: (value) =>
                                    value != null ? null : "Il campo è vuoto",
                                decoration: InputDecoration(
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  errorMaxLines: 3,
                                  fillColor: Colors.white,
                                  filled: true,
                                  prefixIcon: Icon(
                                    Icons.calendar_today,
                                    color: Colors.grey.shade600,
                                  ),
                                  hintText: 'Oggi',
                                  labelText: 'Data ultimo controllo',
                                  labelStyle:
                                      const TextStyle(color: Colors.black),
                                ),
                                onShowPicker: (context, currentValue) {
                                  return showDatePicker(
                                      context: context,
                                      firstDate: DateTime(1900),
                                      initialDate:
                                          currentValue ?? DateTime.now(),
                                      lastDate: DateTime(2100));
                                },
                              ),
                            ),
                          ),
                          Theme(
                            data: Theme.of(context).copyWith(
                              colorScheme: ColorScheme.light(
                                primary: Colors.red.shade900, // <-- SEE HERE
                              ),
                            ),
                            child: DateTimeField(
                              controller: _dataProssimoControllo,
                              autovalidateMode:
                                  AutovalidateMode.onUserInteraction,
                              format: DateFormat("dd/MM/yyyy"),
                              validator: (value) =>
                                  value != null ? null : "Il campo è vuoto",
                              onShowPicker: (context, currentValue) {
                                return showDatePicker(
                                  context: context,
                                  firstDate: DateTime.parse(
                                      _dataUltimoControllo.text.isEmpty
                                          ? "1900-01-01"
                                          : _dataUltimoControllo.text
                                              .split("/")
                                              .reversed
                                              .join("-")),
                                  initialDate: currentValue ??
                                      (_dataUltimoControllo.text.isEmpty
                                          ? DateTime.now()
                                          : DateTime.parse(_dataUltimoControllo
                                              .text
                                              .split("/")
                                              .reversed
                                              .join("-")).add(Duration(days: setPeriod(periodo)))),
                                  lastDate: DateTime(2100),
                                );
                              },
                              decoration: InputDecoration(
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                errorMaxLines: 3,
                                fillColor: Colors.white,
                                filled: true,
                                prefixIcon: Icon(
                                  Icons.calendar_today,
                                  color: Colors.grey.shade600,
                                ),
                                hintText: 'Oggi',
                                labelText: 'Data prossimo controllo',
                                labelStyle:
                                    const TextStyle(color: Colors.black),
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(top: 24.0),
                            child: TextFormField(
                              autovalidateMode:
                                  AutovalidateMode.onUserInteraction,
                              decoration: InputDecoration(
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                errorMaxLines: 3,
                                fillColor: Colors.white,
                                filled: true,
                                prefixIcon: Icon(
                                  Icons.insert_drive_file,
                                  color: Colors.grey.shade600,
                                ),
                                suffixIcon: IconButton(
                                  icon: const Icon(Icons.attach_file),
                                  onPressed: () async {
                                    final result = await FilePicker.platform
                                        .pickFiles(allowMultiple: false);
                                    if (result == null) return;
                                    final path = result.files.single.path!;
                                    setState(() {
                                      _filename.text = path.split('/').last;
                                      file = File(path);
                                    });
                                  },
                                ),
                                hintText: 'Nessun documento caricato',
                                labelText: 'Scheda controllo',
                                labelStyle:
                                    const TextStyle(color: Colors.black),
                              ),
                              readOnly: true,
                              controller: _filename,
                              validator: (value) =>
                                  value!.isNotEmpty ? null : "Il campo è vuoto",
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  Container(
                    alignment: Alignment.center,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            primary: const Color.fromRGBO(163, 0, 6, 1),
                            onPrimary: Colors.white,
                            shadowColor: const Color.fromRGBO(163, 0, 6, 1),
                            elevation: 0,
                            padding: const EdgeInsets.symmetric(
                                horizontal: 28, vertical: 16),
                          ),
                          onPressed: () async {
                            if (!_formKey.currentState!.validate() ||
                                file == null) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text("Campi inseriti non validi"),
                                ),
                              );
                            } else {
                              showDialog(
                                  context: context,
                                  builder: (context) {
                                    return FutureBuilder<
                                        DocumentSnapshot<Map<String, dynamic>>>(
                                      future: FirebaseFirestore.instance
                                          .collection('controlli')
                                          .doc(_codice.text)
                                          .get(),
                                      builder: (BuildContext context,
                                          AsyncSnapshot snapshot) {
                                        if (snapshot.hasData) {
                                          if (snapshot.data.exists) {
                                            return const AlertDialog(
                                              content: Text(
                                                  'Il controllo è già presente'),
                                            );
                                          } else {
                                            return AlertDialog(
                                              title: const Text(
                                                'Confermi di voler aggiungere il controllo:',
                                                style: TextStyle(fontSize: 15),
                                                textAlign: TextAlign.center,
                                              ),
                                              contentPadding:
                                                  const EdgeInsets.all(10),
                                              content: Text(
                                                _codice.text,
                                                textAlign: TextAlign.center,
                                                style: const TextStyle(
                                                    color: Colors.black),
                                              ),
                                              actions: <Widget>[
                                                TextButton(
                                                  child: Text(
                                                    'Annulla',
                                                    style: TextStyle(
                                                        color: Colors
                                                            .grey.shade600),
                                                  ),
                                                  onPressed: () {
                                                    Navigator.of(context)
                                                        .pop(false);
                                                  },
                                                ),
                                                TextButton(
                                                  child: Text(
                                                    'Conferma',
                                                    style: TextStyle(
                                                        color: Colors
                                                            .red.shade900),
                                                  ),
                                                  onPressed: () async {
                                                    Controllo c = Controllo(
                                                      cod: _codice.text,
                                                      tipo: tipo,
                                                      periodo: periodo,
                                                      descrizione:
                                                          _descrizione.text,
                                                      dataUltimoControllo:
                                                          DateTime.parse(
                                                              _dataUltimoControllo
                                                                  .text
                                                                  .split("/")
                                                                  .reversed
                                                                  .join("-")),
                                                      dataProssimoControllo:
                                                          DateTime.parse(
                                                              _dataProssimoControllo
                                                                  .text
                                                                  .split("/")
                                                                  .reversed
                                                                  .join("-")),
                                                      scheda: "schede/" +
                                                          _codice.text,
                                                    );
                                                    print(c);
                                                    await addControlloDB(c);
                                                    await FirebaseStorage
                                                        .instance
                                                        .ref()
                                                        .child("schede/" +
                                                            _codice.text)
                                                        .putFile(file!);
                                                    Navigator.of(context)
                                                        .pushNamed('home');
                                                  },
                                                ),
                                              ],
                                            );
                                          }
                                        }
                                        return const SizedBox(
                                          child: CircularProgressIndicator(),
                                          height: 1.0,
                                          width: 1.0,
                                        );
                                      },
                                    );
                                  });
                            }
                          },
                          child: Text("Salva"),
                        ),
                      ],
                    ),
                  )
                ],
              ),
            ),
          )),
    );
  }
}
