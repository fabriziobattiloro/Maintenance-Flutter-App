
import 'package:ethos_app/Screens/EditControl.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:url_launcher/url_launcher_string.dart';

import '../DataTypes/Controllo.dart';
import 'CheckControl.dart';

class ControlView extends StatefulWidget {
  final Controllo controllo;

  const ControlView({Key? key, required this.controllo}) : super(key: key);

  @override
  _ControlView createState() => _ControlView();
}

class _ControlView extends State<ControlView> {
  late TextEditingController _codice = TextEditingController();
  late TextEditingController _tipo = TextEditingController();
  late TextEditingController _periodo = TextEditingController();
  late TextEditingController _descrizione = TextEditingController();
  late TextEditingController _dataUltimoControllo = TextEditingController();
  late TextEditingController _dataProssimoControllo = TextEditingController();
  late TextEditingController _schedaControllo = TextEditingController();

  @override
  void initState() {
    // TODO: implement initState
    _codice = TextEditingController(text: widget.controllo.cod);
    _descrizione = TextEditingController(text: widget.controllo.descrizione);
    _tipo = TextEditingController(text: widget.controllo.tipo);
    _periodo = TextEditingController(text: widget.controllo.periodo);
    _schedaControllo = TextEditingController(text: widget.controllo.scheda);
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
    print(widget.controllo.cod);
    print(widget.controllo.tipo);
    @override
    void dispose() {
      _codice.dispose();
      _descrizione.dispose();
      _tipo.dispose();
      _periodo.dispose();
      super.dispose();
    }

    return Scaffold(
      appBar: AppBar(
        title: Text("Macchina " + widget.controllo.cod),
        backgroundColor: Colors.red.shade900,
        leading: BackButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
        actions: [
          IconButton(
              onPressed: () {
                showDialog(
                    context: context,
                    builder: (context) {
                      return AlertDialog(
                        title: const Text(
                          'Vuoi modificare il controllo:',
                          style: TextStyle(fontSize: 15),
                        ),
                        content: Text(
                          _codice.text,
                        ),
                        actions: <Widget>[
                          TextButton(
                            child: Text(
                              'Annulla',
                              style: TextStyle(color: Colors.grey.shade600),
                            ),
                            onPressed: () {
                              Navigator.of(context).pop();
                            },
                          ),
                          TextButton(
                            child: Text(
                              'Conferma',
                              style: TextStyle(color: Colors.red.shade900),
                            ),
                            onPressed: () {
                              print(widget.controllo.toJson());
                              Navigator.of(context).pushReplacement(
                                MaterialPageRoute(
                                  builder: (context) =>
                                      EditControl(controllo: widget.controllo),
                                ),
                              );
                            },
                          ),
                        ],
                      );
                    });
              },
              icon: const Icon(Icons.edit))
        ],
      ),
      body: Container(
        alignment: Alignment.topLeft,
        color: Colors.white,
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            children: [
              Expanded(
                child: SingleChildScrollView(
                  scrollDirection: Axis.vertical,
                  child: Column(
                    children: <Widget>[
                      TextFormField(
                        readOnly: true,
                        enabled: false,
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
                        child: TextFormField(
                          enabled: false,
                          readOnly: true,
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
                            hintText: '',
                            labelText: 'Tipo',
                            labelStyle: const TextStyle(color: Colors.black),
                          ),
                          controller: _tipo,
                          validator: (value) =>
                              value!.isNotEmpty ? null : "Il campo è vuoto",
                        ),
                      ),
                      TextFormField(
                        enabled: false,
                        readOnly: true,
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
                          hintText: '',
                          labelText: 'Periodicità',
                          labelStyle: const TextStyle(color: Colors.black),
                        ),
                        controller: _periodo,
                        validator: (value) =>
                        value!.isNotEmpty ? null : "Il campo è vuoto",
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 20.0),
                        child: TextFormField(
                          maxLines: null,
                          readOnly: true,
                          enabled: false,
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
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 24.0),
                        child: TextFormField(
                          readOnly: true,
                          enabled: false,
                          controller: _dataUltimoControllo,
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
                            labelStyle: const TextStyle(color: Colors.black),
                          ),
                        ),
                      ),
                      TextFormField(
                        controller: _dataProssimoControllo,
                        readOnly: true,
                        enabled: false,
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
                          labelStyle: const TextStyle(color: Colors.black),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 24.0),
                        child: GestureDetector(
                          onTap: () async {
                            await FirebaseStorage.instance
                                .ref(_schedaControllo.text)
                                .getDownloadURL()
                                .then(
                                  (value) => launchUrl(
                                    Uri.parse(value),
                                    mode: LaunchMode.externalApplication,
                                  ),
                                )
                                .catchError((err) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                    content: Text(
                                        'Il file non sembra essere raggiungibile'),),
                              );
                            });
                          },
                          child: TextFormField(
                            readOnly: true,
                            enabled: false,
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
                              hintText: 'Nessun documento caricato',
                              labelText: 'Scheda controllo',
                              labelStyle: const TextStyle(color: Colors.black),
                            ),
                            controller: _schedaControllo,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Row(
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
                    onPressed: () {
                      showDialog(
                          context: context,
                          builder: (context) {
                            return AlertDialog(
                              title: const Text(
                                'Vuoi effettuare il controllo:',
                                style: TextStyle(fontSize: 15),
                              ),
                              content: Text(
                                _codice.text,
                              ),
                              actions: <Widget>[
                                TextButton(
                                  child: Text(
                                    'Annulla',
                                    style:
                                        TextStyle(color: Colors.grey.shade600),
                                  ),
                                  onPressed: () {
                                    Navigator.of(context).pop();
                                  },
                                ),
                                TextButton(
                                  child: Text(
                                    'Conferma',
                                    style:
                                        TextStyle(color: Colors.red.shade900),
                                  ),
                                  onPressed: () {
                                    Navigator.of(context).pushReplacement(
                                      MaterialPageRoute(
                                        builder: (context) => ControlCheck(
                                            controllo: widget.controllo),
                                      ),
                                    );
                                  },
                                ),
                              ],
                            );
                          });
                    },
                    child: const Text(
                      "Effettua controllo",
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
