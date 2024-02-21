import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

import '../Screens/AddControl.dart';

class UnregisteredMachineAlert extends StatelessWidget {
  final String codice;

  const UnregisteredMachineAlert({Key? key, required this.codice})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Macchina non registrata'),
      content: const Text('Vuoi aggiungerla?'),
      actions: [
        TextButton(
          onPressed: () {
            Navigator.pop(context, false);
          },
          child: Text(
            'No',
            style: TextStyle(color: Colors.grey.shade600),
          ),
        ),
        TextButton(
          child:
              Text('Si', style: TextStyle(color: Colors.red.shade900)),
          onPressed: () {
            Navigator.pushReplacement(context,
                MaterialPageRoute(builder: (context) => Add(c: codice)));
          },
        )
      ],
    );
  }
}
