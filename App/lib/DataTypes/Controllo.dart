class Controllo {
  String cod;
  String tipo;
  String periodo;
  String descrizione;
  DateTime dataUltimoControllo;
  DateTime dataProssimoControllo;
  String scheda;

  Controllo({
    required this.cod,
    required this.tipo,
    required this.descrizione,
    required this.periodo,
    required this.dataUltimoControllo,
    required this.dataProssimoControllo,
    required this.scheda,
  });

  Controllo.fromSnapshot({
    required Map<String, Object?> data,
    String hour = "00:00:00",
  }) : this(
          cod: data["codice"]! as String,
          tipo: data["tipo"]! as String,
          periodo: data['periodo']! as String,
          descrizione: data["descrizione"]! as String,
          dataUltimoControllo:
              DateTime.parse((data["dataUltimo"]! as String) + " " + hour),
          dataProssimoControllo:
              DateTime.parse((data["dataProssimo"]! as String) + " " + hour),
          scheda: (data["schedaControllo"] as String?) ??
              "schede/" + (data["codice"]! as String),
        );

  Map<String, Object?> toJson() => {
        "codice": cod,
        "descrizione": descrizione,
        "periodo": periodo,
        "scheda": scheda,
        "tipo": tipo,
        "dataUltimo": dataUltimoControllo.toIso8601String().substring(0, 10),
        "dataProssimo":
            dataProssimoControllo.toIso8601String().substring(0, 10),
      };
}
