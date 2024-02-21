import 'dart:io';

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

class EditControl extends StatefulWidget {
  final Controllo controllo;

  const EditControl({Key? key, required this.controllo}) : super(key: key);

  @override
  _EditControl createState() => _EditControl();
}

class _EditControl extends State<EditControl> {
  String tipo = 'Armadi per stoccaggio';
  String periodo = 'Mensile';
  final _formKey = GlobalKey<FormState>();
  TextEditingController _codice = TextEditingController();
  TextEditingController _descrizione = TextEditingController();
  TextEditingController _periodo = TextEditingController();
  TextEditingController _filename = TextEditingController();
  TextEditingController _dataProssimoControllo = TextEditingController();
  TextEditingController _dataUltimoControllo = TextEditingController();

  File? file;

  @override
  void initState() {
    print(DateFormat("dd/MM/yyyy")
        .format(widget.controllo.dataProssimoControllo));
    print(
        DateFormat("dd/MM/yyyy").format(widget.controllo.dataUltimoControllo));
    tipo = widget.controllo.tipo;
    periodo = widget.controllo.periodo;
    _codice = TextEditingController(text: widget.controllo.cod);
    _descrizione = TextEditingController(text: widget.controllo.descrizione);
    _periodo = TextEditingController(text: widget.controllo.periodo);
    _filename = TextEditingController(text: widget.controllo.scheda);
    _dataProssimoControllo = TextEditingController(
        text: DateFormat("dd/MM/yyyy")
            .format(widget.controllo.dataProssimoControllo));
    _dataUltimoControllo = TextEditingController(
        text: DateFormat("dd/MM/yyyy")
            .format(widget.controllo.dataUltimoControllo));
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    @override
    void dispose() {
      _codice.dispose();
      _periodo.dispose();
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
            title: const Text("Modifica macchina"),
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
          body: Container(
            alignment: Alignment.topLeft,
            color: Colors.white,
            child: Form(
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
                              readOnly: true,
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
                                labelStyle:
                                    const TextStyle(color: Colors.black),
                              ),
                              controller: _codice,
                              validator: (value) =>
                                  value!.isNotEmpty ? null : "Il campo è vuoto",
                            ),
                            Padding(
                              padding: const EdgeInsets.symmetric(vertical: 20),
                              child: DropdownButtonFormField(
                                value: widget.controllo.tipo,
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
                              padding: const EdgeInsets.only(bottom: 20),
                              child: DropdownButtonFormField(
                                value: widget.controllo.periodo,
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
                                    Icons.sort_by_alpha_rounded,
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
                                labelStyle:
                                    const TextStyle(color: Colors.black),
                              ),
                              controller: _descrizione,
                              validator: (value) =>
                                  value!.isNotEmpty ? null : "Il campo è vuoto",
                            ),
                            Padding(
                              padding:
                                  const EdgeInsets.symmetric(vertical: 24.0),
                              child: Theme(
                                data: Theme.of(context).copyWith(
                                  colorScheme: ColorScheme.light(
                                    primary:
                                        Colors.red.shade900, // <-- SEE HERE
                                  ),
                                ),
                                child: DateTimeField(
                                  autovalidateMode:
                                      AutovalidateMode.onUserInteraction,
                                  controller: _dataUltimoControllo,
                                  format: DateFormat("dd/MM/yyyy"),
                                  initialValue: DateTime.parse(
                                      _dataUltimoControllo.text
                                          .split("/")
                                          .reversed
                                          .join("-")),
                                  validator: (value) {
                                    print(value);
                                    return value != null
                                        ? null
                                        : "Il campo è vuoto";
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
                                    labelText: 'Data ultimo controllo',
                                    labelStyle:
                                        const TextStyle(color: Colors.black),
                                  ),
                                  onShowPicker: (context, currentValue) {
                                    return showDatePicker(
                                      context: context,
                                      firstDate: DateTime(1900),
                                      initialDate:
                                          widget.controllo.dataUltimoControllo,
                                      lastDate: DateTime(2100),
                                    );
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
                                validator: (value) {
                                  print(value);
                                  return value != null
                                      ? null
                                      : "Il campo è vuoto";
                                },
                                initialValue: DateTime.parse(
                                    _dataProssimoControllo.text
                                        .split("/")
                                        .reversed
                                        .join("-")),
                                onShowPicker: (context, currentValue) {
                                  print(_dataUltimoControllo.text
                                      .split("/")
                                      .reversed
                                      .join("-"));
                                  return showDatePicker(
                                    context: context,
                                    firstDate: DateTime.parse(
                                        _dataUltimoControllo.text.isEmpty
                                            ? "1900-01-01"
                                            : _dataUltimoControllo.text
                                                .split("/")
                                                .reversed
                                                .join("-")),
                                    initialDate:
                                        widget.controllo.dataProssimoControllo,
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
                                  helperText: file == null
                                      ? "Il file non risulta modificato"
                                      : "Il file modificato",
                                ),
                                readOnly: true,
                                controller: _filename,
                                validator: (value) => value!.isNotEmpty
                                    ? null
                                    : "Il campo è vuoto",
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
                              if (!_formKey.currentState!.validate()) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    content: Text("Campi inseriti non validi"),
                                  ),
                                );
                              } else {
                                showDialog(
                                    context: context,
                                    builder: (context) {
                                      return AlertDialog(
                                        title: const Text(
                                          'Confermi di voler modificare il controllo:',
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
                                                  color: Colors.grey.shade600),
                                            ),
                                            onPressed: () {
                                              Navigator.of(context).pop(false);
                                            },
                                          ),
                                          TextButton(
                                            child: Text(
                                              'Conferma',
                                              style: TextStyle(
                                                  color: Colors.red.shade900),
                                            ),
                                            onPressed: () async {
                                              Controllo c = Controllo(
                                                cod: _codice.text,
                                                tipo: tipo,
                                                periodo: periodo,
                                                descrizione: _descrizione.text,
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
                                                scheda:
                                                    "schede/" + _codice.text,
                                              );
                                              await editControlDB(c);
                                              if (file != null) {
                                                await FirebaseStorage.instance
                                                    .ref()
                                                    .child("schede/" +
                                                        _codice.text)
                                                    .putFile(file!);
                                              }
                                              Navigator.of(context)
                                                  .pushNamed('home');
                                            },
                                          ),
                                        ],
                                      );
                                    });
                              }
                            },
                            child: const Text("Salva"),
                          ),
                        ],
                      ),
                    )
                  ],
                ),
              ),
            ),
          )),
    );
  }
}
