import 'package:datetime_picker_formfield/datetime_picker_formfield.dart';
import 'package:ethos_app/DataTypes/RegistroControllo.dart';
import 'package:ethos_app/Services/database_command.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../DataTypes/Controllo.dart';
import '../DataTypes/tipo.dart';

class ControlCheck extends StatefulWidget {
  final Controllo controllo;

  const ControlCheck({Key? key, required this.controllo}) : super(key: key);

  @override
  _ControlCheck createState() => _ControlCheck();
}

class _ControlCheck extends State<ControlCheck> {
  bool positivo = false;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  late TextEditingController _segnalazione = TextEditingController();
  late TextEditingController _dataProssimo = TextEditingController();
  late TextEditingController _dataControllo = TextEditingController();

  @override
  Widget build(BuildContext context) {
    void initState() {
      // TODO: implement initState
      _segnalazione = TextEditingController();
      super.initState();
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
                  child: Text(
                    'Annulla',
                    style: TextStyle(color: Colors.grey.shade600),
                  ),
                  onPressed: () {
                    Navigator.of(context).pop(false);
                  },
                ),
                TextButton(
                  child: Text(
                    'Esci',
                    style: TextStyle(color: Colors.red.shade900),
                  ),
                  onPressed: () {
                    Navigator.of(context).pop(true);
                  },
                )
              ],
            );
          },
        );
      },
      child: Scaffold(
          appBar: AppBar(
            title: Text("Controllo " + widget.controllo.cod),
            backgroundColor: Colors.red.shade900,
            leading: BackButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ),
          backgroundColor: Colors.white,
          body: Column(
            children: [
              Expanded(
                child: Form(
                  key: _formKey,
                  child: SingleChildScrollView(
                    scrollDirection: Axis.vertical,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                          vertical: 20.0, horizontal: 20),
                      child: Column(
                        children: <Widget>[
                          Padding(
                            padding: const EdgeInsets.symmetric(vertical: 20),
                            child: TextFormField(
                              initialValue: widget.controllo.cod,
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
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(bottom: 20),
                            child: TextFormField(
                              initialValue: widget.controllo.tipo,
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
                            child: TextFormField(
                              initialValue: widget.controllo.periodo,
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
                          Padding(
                            padding: const EdgeInsets.only(bottom: 20),
                            child: TextFormField(
                              initialValue: widget.controllo.descrizione,
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
                                labelText: 'Descrizione intervento',
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(bottom: 20),
                            child: TextFormField(
                              maxLines: null,
                              minLines: 3,
                              decoration: InputDecoration(
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                errorMaxLines: 3,
                                fillColor: Colors.white,
                                filled: true,
                                labelText: "Eventuali segnalazioni",
                                hintText: "",
                                prefixIcon: Icon(
                                  Icons.lightbulb_outline,
                                  color: Colors.grey.shade600,
                                ),
                                labelStyle:
                                    const TextStyle(color: Colors.black),
                              ),
                              controller: _segnalazione,
                            ),
                          ),
                          Theme(
                            data: Theme.of(context).copyWith(
                              colorScheme: ColorScheme.light(
                                primary: Colors.red.shade900, // <-- SEE HERE
                              ),
                            ),
                            child: DateTimeField(
                              controller: _dataControllo,
                              autovalidateMode:
                                  AutovalidateMode.onUserInteraction,
                              format: DateFormat("dd/MM/yyyy"),
                              validator: (value) =>
                                  value != null ? null : "Il campo è vuoto",
                              onShowPicker: (context, currentValue) {
                                print(_dataControllo.text
                                    .split("/")
                                    .reversed
                                    .join("-"));
                                return showDatePicker(
                                  context: context,
                                  firstDate: DateTime.parse(
                                      _dataControllo.text.isEmpty
                                          ? "1900-01-01"
                                          : _dataControllo.text
                                              .split("/")
                                              .reversed
                                              .join("-")),
                                  initialDate: currentValue ??
                                      (_dataControllo.text.isEmpty
                                          ? DateTime.now()
                                          : DateTime.parse(_dataControllo.text
                                              .split("/")
                                              .reversed
                                              .join("-"))),
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
                                labelText: 'Data controllo',
                                labelStyle:
                                    const TextStyle(color: Colors.black),
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(vertical: 20.0),
                            child: Theme(
                              data: Theme.of(context).copyWith(
                                colorScheme: ColorScheme.light(
                                  primary: Colors.red.shade900, // <-- SEE HERE
                                ),
                              ),
                              child: DateTimeField(
                                controller: _dataProssimo,
                                autovalidateMode:
                                    AutovalidateMode.onUserInteraction,
                                format: DateFormat("dd/MM/yyyy"),
                                validator: (value) =>
                                    value != null ? null : "Il campo è vuoto",
                                onShowPicker: (context, currentValue) {
                                  print(_dataProssimo.text
                                      .split("/")
                                      .reversed
                                      .join("-"));
                                  return showDatePicker(
                                    context: context,
                                    firstDate: DateTime.parse(
                                        _dataControllo.text.isEmpty
                                            ? "1900-01-01"
                                            : _dataControllo.text
                                            .split("/")
                                            .reversed
                                            .join("-")),
                                    initialDate: currentValue ??
                                        (_dataControllo.text.isEmpty
                                            ? DateTime.now()
                                            : DateTime.parse(_dataControllo
                                            .text
                                            .split("/")
                                            .reversed
                                            .join("-")).add(Duration(days: setPeriod(widget.controllo.periodo)))),
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
                                  labelText: 'Data prossimo',
                                  labelStyle:
                                      const TextStyle(color: Colors.black),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
              Container(
                alignment: Alignment.center,
                margin: const EdgeInsets.only(bottom: 10),
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
                      onPressed: () {
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
                                    'Cliccando su conferma il seguente controllo verrà registrato a sistema',
                                    style: TextStyle(fontSize: 15),
                                    textAlign: TextAlign.center,
                                  ),
                                  contentPadding: const EdgeInsets.all(10),
                                  content: Text(
                                    widget.controllo.cod,
                                    textAlign: TextAlign.center,
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
                                      onPressed: () async{
                                        registroControllo(
                                          RegistroControllo(
                                              codice: widget.controllo.cod,
                                              tipo: widget.controllo.tipo,
                                              segnalazioni: _segnalazione.text,
                                              dataControllo: DateTime.parse(
                                                  _dataControllo.text
                                                      .split("/")
                                                      .reversed
                                                      .join("-")),
                                              esito: positivo),
                                        );
                                        Controllo c = Controllo(
                                          cod: widget.controllo.cod,
                                          tipo: widget.controllo.tipo,
                                          periodo: widget.controllo.periodo,
                                          descrizione: widget.controllo.descrizione,
                                          dataUltimoControllo:
                                          DateTime.parse(
                                              _dataControllo
                                                  .text
                                                  .split("/")
                                                  .reversed
                                                  .join("-")),
                                          dataProssimoControllo:
                                          DateTime.parse(
                                              _dataProssimo
                                                  .text
                                                  .split("/")
                                                  .reversed
                                                  .join("-")),
                                          scheda:
                                          widget.controllo.scheda,
                                        );
                                        await editControlDB(c);
                                        Navigator.of(context).pushNamed('home');
                                      },
                                    ),
                                  ],
                                );
                              });
                        }
                      },
                      child: Text(
                        "Registra",
                      ),
                    ),
                  ],
                ),
              )
            ],
          )),
    );
  }
}
