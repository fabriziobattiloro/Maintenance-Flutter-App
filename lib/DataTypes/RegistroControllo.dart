class RegistroControllo {
  String codice;
  String tipo;
  String segnalazioni;
  DateTime dataControllo;
  bool esito;

  RegistroControllo({
    required this.codice,
    required this.tipo,
    required this.dataControllo,
    required this.segnalazioni,
    required this.esito,
  });

  factory RegistroControllo.fromJson(Map<String, dynamic> json) =>
      RegistroControllo(
        codice: json["codice"] ?? "",
        tipo: json["tipo"] ?? "",
        segnalazioni: json["segnalazioni"] ?? "",
        dataControllo: DateTime.parse(json["dataControllo"] ?? ""),
        esito: json["esito"] ?? "",
      );

  factory RegistroControllo.fromSnapshot({
    required Map<String, dynamic> data,
    String hour = "00:00:00",
  }) {
    return RegistroControllo(
      codice: data["codice"]! as String,
      tipo: data["tipo"]! as String,
      segnalazioni: data["segnalazioni"]! as String,
      dataControllo: DateTime.parse((data["dataControllo"]! as String)),
      esito: data["esito"]! as bool,
    );
  }

  Map<String, dynamic> toJson() => {
        "codice": codice,
        "segnalazioni": segnalazioni,
        "esito": esito,
        "tipo": tipo,
        "dataControllo": dataControllo.toIso8601String().substring(0, 10),
      };
}
