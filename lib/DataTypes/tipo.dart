
class Tipologia {
  String _tipo;
  String _descrizione;

  Tipologia(this._tipo,this._descrizione);

  String get tipo => _tipo;

  set tipo(String value) {
    _tipo = value;
  }

  String get descrizione => _descrizione;

  set descrizione(String value) {
    _descrizione = value;
  }
}

  late List<Tipologia> tipologie =  <Tipologia>[
    Tipologia('Armadi per stoccaggio', 'CCPI-P&T-SPEC-2015-01'),
    Tipologia('Aspiratori e Cappe FISSI', 'CCPI-P&T-SPEC-2015-01'),
    Tipologia('Aspiratori e Cappe FISSI CA', 'CCPI-P&T-SPEC-2015-01'),
    Tipologia('Aspiratori e Cappe mobili CA', 'CCPI-P&T-SPEC-2015-01'),
    Tipologia('Attrezzi-Utensili', 'CCPI-P&T-SPEC-2015-01'),
    Tipologia('Autoclavi', 'CCPI-P&T-SPEC-2015-01'),
    Tipologia('Bagni e Trattamenti Chimici', 'CCPI-P&T-SPEC-2015-01'),
    Tipologia('Cabine aspirate', 'CCPI-P&T-SPEC-2015-01'),
    Tipologia('Cabine aspirate CA', 'CCPI-P&T-SPEC-2015-01'),
    Tipologia('Camere pulite', 'CCPI-P&T-SPEC-2015-01'),
    Tipologia('Celle Frigorifere', 'CCPI-P&T-SPEC-2015-01'),
    Tipologia('Centralina Oleodinamica', 'CCPI-P&T-SPEC-2015-01'),
    Tipologia('Docce e Lavaocchi', 'CCPI-P&T-SPEC-2015-01'),
    Tipologia('Forni', 'CCPI-P&T-SPEC-2015-01'),
    Tipologia('Impianti generici', 'CCPI-P&T-SPEC-2015-01'),
    Tipologia('Macchine per cucire', 'CCPI-P&T-SPEC-2015-01'),
    Tipologia('Movim. e Sollevam.', 'CCPI-P&T-SPEC-2015-01'),
    Tipologia('Vuoto Pompe', 'CCPI-P&T-SPEC-2015-01'),
    Tipologia('Vuoto Serbatoi', 'CCPI-P&T-SPEC-2015-01'),
  ];

late List<String> tip =  <String>[
  ('Armadi per stoccaggio' ),
  ('Armadi stoccaggio prodotti chimici'),
  ('Aspiratori e Cappe FISSI'),
  ('Aspiratori e Cappe FISSI CA'),
  ('Aspiratori e Cappe mobili CA'),
  ('Attrezzi-Utensili'),
  ('Autoclavi'),
  ('Bagni e Trattamenti Chimici'),
  ('Cabine aspirate'),
  ('Cabine aspirate CA'),
  ('Camere pulite'),
  ('Celle Frigorifere'),
  ('Centralina Oleodinamica'),
  ('Compressore Aria'),
  ('Compressore Aria'),
  ('Condizionamento Autonomo'),
  ('Forni'),
  ('Impianti generici'),
  ('Macchine per cucire'),
  ('Movim. e Sollevam.'),
  ('Pompe H2O'),
  ('Vuoto Pompe'),
  ('Vuoto Serbatoi'),
];

late List<String> per = <String> [
  ('Mensile'),
  ('Trimestrale'),
  ('Semestrale'),
  ('Annuale'),
];

int setPeriod(String periodo) {
  int p = 0;
  if (periodo == "Mensile") {
    p = 30;
  }
  else if (periodo == "Trimestrale"){
    p = 90;
  }
  else if (periodo == "Semestrale") {
    p = 180;
  }
  else if (periodo == "Annuale") {
    p = 365;
  }
  return p;
}
