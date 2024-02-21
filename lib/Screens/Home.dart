import 'package:ethos_app/Components/ControlCard.dart';
import 'package:ethos_app/Screens/AllControls.dart';
import 'package:ethos_app/Screens/QRCode.dart';
import 'package:ethos_app/Services/database_command.dart';
import 'package:ethos_app/Services/searchControl.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';
import 'package:table_calendar/table_calendar.dart';

import '../DataTypes/Controllo.dart';
import '../Services/database_command.dart';
import '../Services/mostraPdf.dart';
import 'AddControl.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late CalendarController _controller;
  DateTime giorno = DateTime.now();
  DateTime _focusedDay = DateTime.now();
  final controller = CalendarController();
  CalendarFormat _calendarFormat = CalendarFormat.week;

  DateTimeRange? _selectedDateRange;
  DateTime? start;
  DateTime? end;

  void initState() {
    super.initState();
    _controller = CalendarController();
  }

  Widget build(BuildContext context) {
    void dispose() {
      _controller.dispose();
      super.dispose();
    }

    ValueNotifier<bool> isDialOpen = ValueNotifier(false);

    return WillPopScope(
      onWillPop: () async {
        if (isDialOpen.value) {
          isDialOpen.value = false;
          return false;
        } else {
          return true;
        }
      },
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        appBar: AppBar(
          title: Image.asset(
            'assets/images/logo-transparent.png',
            width: MediaQuery.of(context).size.width * 0.4,
          ),
          backgroundColor: Colors.red.shade900,
          automaticallyImplyLeading: false,
          actions: [
            IconButton(
              icon: const Icon(Icons.logout),
              onPressed: () async {
                bool success = await showDialog(
                  context: context,
                  builder: (context) {
                    return AlertDialog(
                      content: const Text('Sei sicuro di voler uscire?'),
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
                        ),
                      ],
                    );
                  },
                );
                if (success == true) {
                  await FirebaseAuth.instance.signOut();
                  Navigator.of(context).pushReplacementNamed('login');
                }
              },
            ),
          ],
        ),
        body: Container(
          color: Colors.white,
          child: Column(
            children: [
              Container(
                color: Colors.grey.shade200,
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(10, 0, 10, 15),
                  child: TableCalendar(
                    locale: 'it',
                    startingDayOfWeek: StartingDayOfWeek.monday,
                    calendarFormat: _calendarFormat,
                    availableCalendarFormats: const {
                      CalendarFormat.month: 'Mese',
                      CalendarFormat.twoWeeks: '2 settimane',
                      CalendarFormat.week: 'Settimana',
                    },
                    onFormatChanged: ((format) {
                      if (_calendarFormat != format) {
                        setState(() {
                          _calendarFormat = format;
                        });
                      }
                    }),
                    calendarStyle: CalendarStyle(
                      canMarkersOverflow: true,
                      selectedDecoration: BoxDecoration(
                          color: Colors.red.shade900,
                          borderRadius: BorderRadius.circular(10)),
                      selectedTextStyle: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 18.0,
                          color: Colors.white),
                    ),
                    headerStyle: HeaderStyle(
                      titleCentered: true,
                      formatButtonDecoration: BoxDecoration(
                        color: Colors.red.shade900,
                        borderRadius: BorderRadius.circular(20.0),
                      ),
                      formatButtonTextStyle:
                          const TextStyle(color: Colors.white),
                      formatButtonShowsNext: false,
                    ),
                    calendarBuilders: CalendarBuilders(
                      selectedBuilder: (context, date, events) => Container(
                          margin: const EdgeInsets.all(4.0),
                          alignment: Alignment.center,
                          decoration: BoxDecoration(
                              color: Colors.red.shade900,
                              borderRadius: BorderRadius.circular(10.0)),
                          child: Text(
                            date.day.toString(),
                            style: const TextStyle(color: Colors.white),
                          )),
                      todayBuilder: (context, date, events) => Container(
                        margin: const EdgeInsets.all(4.0),
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10.0)),
                        child: Text(
                          date.day.toString(),
                          style: TextStyle(color: Colors.red.shade900),
                        ),
                      ),
                    ),
                    shouldFillViewport: false,
                    firstDay: DateTime(2022),
                    focusedDay: giorno,
                    lastDay:
                        DateTime.utc(giorno.year + 1, giorno.month, giorno.day),
                    selectedDayPredicate: (day) {
                      return isSameDay(giorno, day);
                    },
                    onDaySelected: (selectedDay, focusedDay) {
                      setState(() {
                        giorno = selectedDay;
                        _focusedDay =
                            focusedDay; // update `_focusedDay` here as well
                      });
                    },
                  ),
                ),
              ),
              Expanded(
                child: Container(
                  color: Colors.white,
                  child: FutureBuilder<List<Controllo>>(
                      future: getControlliPerData(giorno, hour: "10:00:00"),
                      builder: (BuildContext context,
                          AsyncSnapshot<List<Controllo>> snapshot) {
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return const Center(
                            child: CircularProgressIndicator(),
                          );
                        } else if (snapshot.hasError || !snapshot.hasData) {
                          print(snapshot.error);
                          print(snapshot.hasData);
                          return const Text("Si è verificato un errore");
                        } else if (snapshot.hasData) {
                          if (snapshot.data!.isEmpty) {
                            return const SizedBox(
                              height: 200,
                              child:
                                  Center(child: Text('Non ci sono controlli')),
                            );
                          } else {
                            return ListView.builder(
                              scrollDirection: Axis.vertical,
                              padding: const EdgeInsets.all(8),
                              itemCount: snapshot.data!.length,
                              itemBuilder: (BuildContext context, int index) =>
                                  Padding(
                                padding: const EdgeInsets.all(10),
                                child: ControlCard(
                                  controllo: snapshot.data![index],
                                ),
                              ),
                            );
                          }
                        } else {
                          return const SizedBox(
                            height: 200,
                            child: Center(
                              child: Text(
                                  'Non sembrano essere disponibili controlli'),
                            ),
                          );
                        }
                      }),
                ),
              ),
            ],
          ),
        ),
        floatingActionButton: SpeedDial(
          animatedIcon: AnimatedIcons.menu_close,
          openCloseDial: isDialOpen,
          backgroundColor: Colors.red.shade900,
          overlayColor: Colors.grey,
          overlayOpacity: 0.5,
          spacing: 15,
          spaceBetweenChildren: 15,
          //animationDuration: const Duration(milliseconds: 700),
          closeManually: false,
          children: [
            SpeedDialChild(
              child: const Icon(Icons.add),
              label: 'Aggiungi macchina',
              onTap: () {
                Navigator.of(context).push(
                  MaterialPageRoute(builder: (context) => Add(c: '')),
                );
              },
            ),
            SpeedDialChild(
              child: const Icon(Icons.search),
              label: 'Cerca con codice',
              onTap: () {
                SearchControl(context);
              },
            ),
            SpeedDialChild(
              child: const Icon(Icons.photo_camera),
              label: 'Scanner',
              onTap: () async {
                Navigator.of(context).push(
                  MaterialPageRoute(builder: (context) => const QRCode()),
                );
              },
            ),
            SpeedDialChild(
              child: const Icon(Icons.download),
              label: 'Esito controlli',
              onTap: () async {
                _rangePicker();
              },
            ),
            SpeedDialChild(
              child: const Icon(Icons.align_horizontal_left_sharp),
              label: 'Macchine registrate',
              onTap: () async {
                Navigator.of(context).push(
                  MaterialPageRoute(builder: (context) => AllControls()),
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  void _rangePicker() async {
    final DateTimeRange? result = await showDateRangePicker(
      locale: const Locale('it', 'IT'),
      context: context,
      firstDate: DateTime(2015, 1, 1),
      lastDate: DateTime(2050, 12, 31),
      currentDate: DateTime.now(),
      saveText: 'Conferma',
      builder: (BuildContext context, Widget? child) {
        return Theme(
          data: ThemeData.light().copyWith(
            primaryColor: Colors.red.shade900,
            colorScheme: ColorScheme.light(primary: Colors.red.shade900),
            buttonTheme:
                const ButtonThemeData(textTheme: ButtonTextTheme.primary),
          ),
          child: child!,
        );
      },
    );

    if (result != null) {
      // Rebuild the UI
      print(result.start.toString());
      print(result.end.toString());
      setState(() {
        start = result.start;
        end = result.end;
      });
      await createPdf(context, result.start, result.end);
    }
  }
}
