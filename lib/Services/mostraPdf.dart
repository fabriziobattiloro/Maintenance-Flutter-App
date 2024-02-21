import 'dart:io';
import 'dart:ui';

import 'package:ethos_app/DataTypes/RegistroControllo.dart';
import 'package:ethos_app/Services/database_command.dart';
import 'package:flutter/material.dart';
import 'package:open_file/open_file.dart';
import 'package:path_provider/path_provider.dart';
import 'package:syncfusion_flutter_pdf/pdf.dart';

Future<void> createPdf(
  BuildContext context,
  DateTime start,
  DateTime end,
) async {
  final List<RegistroControllo> lista = await getRevisioniPerData(start, end);
  if (lista.isEmpty) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text("Non vi è alcun controllo da mostrare"),
      ),
    );
  } else {
    PdfDocument document = PdfDocument();

    PdfGrid grid = PdfGrid();
    grid.style = PdfGridStyle(
        font: PdfStandardFont(PdfFontFamily.helvetica, 15),
        cellPadding: PdfPaddings(top: 5, left: 5, right: 5, bottom: 5));
    grid.columns.add(count: 3);
    grid.headers.add(1);

    grid.headers[0]
      ..cells[0].value = 'Codice'
      ..cells[1].value = 'Data'
      ..cells[2].value = 'Segnalazioni'
      ..style = PdfGridRowStyle(
        font: PdfStandardFont(PdfFontFamily.helvetica, 18,
            style: PdfFontStyle.bold),
      );

    lista.forEach((element) {
      grid.rows.add()
        ..cells[0].value = element.codice
        ..cells[1].value = element.dataControllo.toIso8601String().substring(0,10).split("-").reversed.join("/")
        ..cells[2].value = element.segnalazioni;
    });

    grid.draw(
      page: document.pages.add(),
      bounds: const Rect.fromLTWH(0, 0, 0, 0),
    );

    List<int> bytes = document.save() as List<int>;
    document.dispose();
    String fileName = 'Registro ' +
        start.toIso8601String().substring(0, 10) +
        '-' +
        end.toIso8601String().substring(0, 10);
    final path = (await getApplicationDocumentsDirectory()).path;
    final file = File('$path/$fileName.pdf');
    await file.writeAsBytes(bytes, flush: true).then((value) async {
      await OpenFile.open('$path/$fileName.pdf');
    }).catchError(
      (err) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text("Si è verificato un errore, riprovare"),
          ),
        );
      },
    );
  }
}
