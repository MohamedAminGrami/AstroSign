// ignore_for_file: unused_element, prefer_const_constructors, unnecessary_import, sized_box_for_whitespace, use_build_context_synchronously, avoid_print

import 'package:exam/database.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
      debugShowCheckedModeBanner: false,
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});
  final String title;
  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  TextEditingController dayController = TextEditingController();
  TextEditingController monthController = TextEditingController();
  TextEditingController yearController = TextEditingController();
  TextEditingController nomController = TextEditingController();
  TextEditingController prenomController = TextEditingController();

  int age = 0;
  String zodiac = "poisson";
  String zodiacSig = "poisson";
  String nom = "Jhon";
  String prenom = "Doe";
  DateTime nowDate = DateTime.now();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Signe Astrologique'),
      ),
      body: SizedBox(
        width: double.infinity,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            TextFormField(
              controller: nomController,
              keyboardType: TextInputType.text,
              decoration: InputDecoration(labelText: 'Nom : '),
            ),
            TextFormField(
              controller: prenomController,
              keyboardType: TextInputType.text,
              decoration: InputDecoration(labelText: 'Prenom : '),
            ),
            TextFormField(
              controller: dayController,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(labelText: 'Jour'),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Champ obligatoire';
                }
                int day = int.parse(value);
                if (day < 1 || day > 31) {
                  return 'Le numéro de jour doit être entre 1 et 31';
                }
                return null;
              },
            ),
            TextFormField(
              controller: monthController,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(labelText: 'Mois'),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Champ obligatoire';
                }
                int month = int.parse(value);
                if (month < 1 || month > 12) {
                  return 'Le numéro de mois doit être entre 1 et 12';
                }
                return null;
              },
            ),
            TextFormField(
              controller: yearController,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(labelText: 'Année'),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Champ obligatoire';
                }
                int year = int.parse(value);
                DateTime now = DateTime.now();
                if (year >= now.year || year < now.year - 10) {
                  return 'Lannée doit être inférieure d au moins 10 ans par rapport à lannée actuelle';
                }
                return null;
              },
            ),
            Container(
              margin: EdgeInsets.all(15),
              child: ElevatedButton(
                onPressed: () async {
                  DateTime birthDate = DateTime(
                    int.parse(yearController.text),
                    int.parse(monthController.text),
                    int.parse(dayController.text),
                  );
                  age = ageCalculator(birthDate);
                  zodiac = zodiacSign(birthDate);

                  nom = int.parse(nomController.text) as String;
                  prenom = int.parse(prenomController.text) as String;

                  setState(() {
                    age = age;
                    zodiac = zodiac;
                    nom = nom;
                    prenom = prenom;
                  });

                  User newUser = User(
                    name: nom,
                    lastName: prenom,
                    zodiacSig: zodiac,
                    birthDate: birthDate,
                    age: age,
                  );

                  await DatabaseHelper().insertUser(newUser);

                  print(zodiac);
                  print(age);
                },
                style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.all(Colors.purple),
                  padding: MaterialStateProperty.all(
                    EdgeInsets.all(22),
                  ),
                  shape: MaterialStateProperty.all(
                    RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(66),
                    ),
                  ),
                ),
                child: Text(
                  "Calculer",
                  style: TextStyle(fontSize: 27, color: Colors.white),
                ),
              ),
            ),
            Container(
              margin: EdgeInsets.all(15),
              child: ElevatedButton(
                onPressed: () async {
                  List<User> allUsers = await DatabaseHelper().getAllUsers();

                  showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return AlertDialog(
                        title: const Text('Liste des Utilisateurs'),
                        content: Container(
                          width: double.maxFinite,
                          child: ListView.builder(
                            itemCount: allUsers.length,
                            itemBuilder: (context, index) {
                              return ListTile(
                                title: Text('Nom: ${allUsers[index].name}'),
                                subtitle: Text(
                                    'Prénom: ${allUsers[index].lastName}\n'
                                    'Zodiac: ${allUsers[index].zodiacSig}\n'
                                    'Age: ${allUsers[index].age} ans\n'
                                    'Date de naissance: ${allUsers[index].birthDate?.toLocal()}'),
                              );
                            },
                          ),
                        ),
                        actions: [
                          TextButton(
                            onPressed: () {
                              Navigator.of(context).pop(); // Close the dialog
                            },
                            child: const Text('Fermer'),
                          ),
                        ],
                      );
                    },
                  );
                },
                style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.all(Colors.purple),
                  padding: MaterialStateProperty.all(
                    EdgeInsets.all(22),
                  ),
                  shape: MaterialStateProperty.all(
                    RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(66),
                    ),
                  ),
                ),
                child: Text(
                  "Afficher",
                  style: TextStyle(fontSize: 27, color: Colors.white),
                ),
              ),
            ),
            Container(
              margin: EdgeInsets.all(15),
              child: Image.asset("icone_astrologique/$zodiac.png"),
            ),
          ],
        ),
      ),
    );
  }

  int ageCalculator(DateTime birthDate) {
    int age = nowDate.year - birthDate.year;
    return age;
  }

  String zodiacSign(DateTime birthDate) {
    int month = birthDate.month;
    int day = birthDate.day;
    if ((month == 3 && day >= 21) || (month == 4 && day <= 19)) {
      return 'belier';
    } else if ((month == 4 && day >= 15) || (month == 5 && day <= 15)) {
      return 'taureau';
    } else if ((month == 5 && day >= 21) || (month == 6 && day <= 21)) {
      return 'gumaux';
    } else if ((month == 6 && day >= 22) || (month == 7 && day <= 22)) {
      return 'cancer';
    } else if ((month == 7 && day >= 23) || (month == 8 && day <= 22)) {
      return 'lion';
    } else if ((month == 8 && day >= 23) || (month == 9 && day <= 22)) {
      return 'vierge';
    } else if ((month == 9 && day >= 23) || (month == 10 && day <= 23)) {
      return 'ballence';
    } else if ((month == 10 && day >= 24) || (month == 11 && day <= 22)) {
      return 'scorpion';
    } else if ((month == 11 && day >= 23) || (month == 12 && day <= 21)) {
      return 'sagitaire';
    } else if ((month == 12 && day >= 22) || (month == 1 && day <= 15)) {
      return 'capricorne';
    } else if ((month == 1 && day >= 21) || (month == 2 && day <= 19)) {
      return 'verseau';
    } else {
      return 'poisson';
    }
  }
}
