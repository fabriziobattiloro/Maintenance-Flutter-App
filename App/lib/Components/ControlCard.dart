import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

import '../DataTypes/Controllo.dart';
import '../Screens/ShowControl.dart';

class ControlCard extends StatelessWidget {
  final Controllo controllo;

  const ControlCard({Key? key, required this.controllo}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Colors.deepOrange.shade100,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      elevation: 0,
      child: Padding(
        padding: const EdgeInsets.all(4.0),
        child: Theme(
          data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
          child: ExpansionTile(
            title: Text(
              controllo.tipo + ' ' + controllo.cod,
            ),
            children: [
              Container(
                width: MediaQuery.of(context).size.width * 0.80,
                padding:
                    const EdgeInsets.symmetric(vertical: 16, horizontal: 0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Descrizione",
                      overflow: TextOverflow.ellipsis,
                      style: Theme.of(context).textTheme.caption,
                    ),
                    Text(
                      controllo.descrizione.toString(),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: Theme.of(context).textTheme.bodyText2,
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 24.0),
                      child: ElevatedButton(
                        onPressed: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) =>
                                      ControlView(controllo: controllo)));
                        },
                        child: const Text("Mostra riepilogo"),
                        style: ElevatedButton.styleFrom(
                          primary: const Color.fromRGBO(163, 0, 6, 1),
                          onPrimary: Colors.white,
                          shadowColor: const Color.fromRGBO(163, 0, 6, 1),
                          elevation: 0,
                          padding: const EdgeInsets.symmetric(
                              horizontal: 28, vertical: 16),
                        ),
                      ),
                    ),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
