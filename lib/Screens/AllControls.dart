import 'package:ethos_app/Components/ControlCard.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../DataTypes/Controllo.dart';
import '../Services/database_command.dart';

class AllControls extends StatefulWidget {
  AllControls({Key? key}) : super(key: key);

  @override
  _AllControls createState() => _AllControls();
}

class _AllControls extends State<AllControls> {
  String descrizione1 = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text("Macchine registrate"),
          backgroundColor: Colors.red.shade900,
          leading: BackButton(
            onPressed: (){
              Navigator.pushNamed(context, 'home');
            },
          ),
        ),
        body: Column(
          children: [
            Expanded(
              child: FutureBuilder<List<Controllo>>(
                  future: getAllControls(),
                  builder: (BuildContext context,
                      AsyncSnapshot<List<Controllo>> snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Center(
                        child: CircularProgressIndicator(),
                      );
                    } else if (snapshot.hasError || !snapshot.hasData) {
                      print(snapshot.error);
                      print(snapshot.hasData);
                      return const Center(child: Text("Si è verificato un errore"));
                    } else if (snapshot.hasData) {
                      if (snapshot.data!.isEmpty) {
                        return const Center(child: Text('Non ci sono controlli'));
                      } else {
                        return ListView.builder(
                            scrollDirection: Axis.vertical,
                            padding: const EdgeInsets.all(8),
                            itemCount: snapshot.data!.length,
                            itemBuilder: (BuildContext context, int index) {
                              return Padding(
                                padding: const EdgeInsets.all(5),
                                child: ControlCard(
                                  controllo: snapshot.data![index],
                                ),
                              );
                            });
                      }
                    }
                    return const SizedBox(
                      height: 200,
                      child: Center(
                          child: Text(
                              'Non è stato possibile recuperare i controlli')),
                    );
                  }),
            ),
          ],
        ));
  }
}
