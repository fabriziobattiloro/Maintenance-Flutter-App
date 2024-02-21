import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  late TextEditingController _emailController = TextEditingController();
  late TextEditingController _passwordController = TextEditingController();
  bool obscureText = true;
  final _formKey = GlobalKey<FormState>();
  late bool loadingForm;

  @override
  void initState() {
    // TODO: implement initState
    loadingForm = false;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: null,
      body: Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        color: const Color.fromRGBO(163, 0, 6, 1),
        child: Padding(
          padding: const EdgeInsets.all(30.0),
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image.asset(
                  'assets/images/logo-transparent.png',
                  width: MediaQuery.of(context).size.width * 0.6,
                ),
                Form(
                  key: _formKey,
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      color: Colors.white,
                    ),
                    margin: const EdgeInsets.only(top: 35),
                    padding: const EdgeInsets.symmetric(
                        vertical: 30, horizontal: 16.0),
                    child: Column(
                      children: [
                        Text(
                          "Accedi",
                          style: Theme.of(context).textTheme.headline6,
                        ),
                        const Padding(
                          padding: EdgeInsets.symmetric(
                            vertical: 8.0,
                            horizontal: 30,
                          ),
                          child: Divider(),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(top: 10, bottom: 16.0),
                          child: TextFormField(
                            controller: _emailController,
                            autovalidateMode:
                                AutovalidateMode.onUserInteraction,
                            keyboardType: TextInputType.visiblePassword,
                            textInputAction: TextInputAction.next,
                            validator: (value) => value != null &&
                                    value.contains("@") &&
                                    value.contains(".")
                                ? null
                                : "Inserire una password valida",
                            decoration: InputDecoration(
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                              errorMaxLines: 3,
                              fillColor: Colors.white,
                              filled: true,
                              prefixIcon: Icon(
                                Icons.person,
                                color: Colors.grey.shade600,
                              ),
                              hintText: 'Indirizzo email',
                              labelText: 'Email',
                              labelStyle: const TextStyle(color: Colors.black),
                            ),
                          ),
                        ),
                        TextFormField(
                          controller: _passwordController,
                          autovalidateMode: AutovalidateMode.onUserInteraction,
                          keyboardType: TextInputType.visiblePassword,
                          textInputAction: TextInputAction.done,
                          obscureText: obscureText,
                          validator: (value) =>
                              value != null && value.length >= 8
                                  ? null
                                  : "Inserire una password valida",
                          decoration: InputDecoration(
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                            errorMaxLines: 3,
                            fillColor: Colors.white,
                            filled: true,
                            prefixIcon: Icon(
                              Icons.lock,
                              color: Colors.grey.shade600,
                            ),
                            suffixIcon: IconButton(
                                icon: Icon(
                                  obscureText
                                      ? Icons.visibility
                                      : Icons.visibility_off,
                                  color: Colors.grey.shade600,
                                ),
                                onPressed: () {
                                  FocusScope.of(context).unfocus();
                                  setState(() {
                                    obscureText = !obscureText;
                                  });
                                }),
                            hintText: '*****',
                            labelText: 'Password',
                            labelStyle: const TextStyle(color: Colors.black),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(top: 16.0),
                          child: ElevatedButton(
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Visibility(
                                  visible: loadingForm,
                                  child: const Padding(
                                    padding: EdgeInsets.only(right: 16.0),
                                    child: SizedBox(
                                      width: 20,
                                      height: 20,
                                      child: CircularProgressIndicator(
                                        color: Colors.white,
                                        strokeWidth: 3,
                                      ),
                                    ),
                                  ),
                                ),
                                const Text("Entra"),
                              ],
                            ),
                            onPressed: () async {
                              if (!_formKey.currentState!.validate()) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    content: Text("Campi inseriti non validi"),
                                  ),
                                );
                              } else {
                                setState(() {
                                  loadingForm = true;
                                });
                                try {
                                  UserCredential userCredential =
                                      await FirebaseAuth
                                          .instance
                                          .signInWithEmailAndPassword(
                                              email: _emailController.text,
                                              password:
                                                  _passwordController.text);
                                  setState(() {
                                    loadingForm = false;
                                  });
                                  Navigator.of(context)
                                      .pushReplacementNamed('home');
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(
                                      content: Text("Entrato con successo"),
                                    ),
                                  );
                                } on FirebaseAuthException catch (e) {
                                  setState(() {
                                    loadingForm = false;
                                  });
                                  if (e.code == 'user-not-found') {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      const SnackBar(
                                        content: Text(
                                            "Nessun utente trovato con questa email"),
                                      ),
                                    );
                                  } else if (e.code == 'wrong-password') {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      const SnackBar(
                                        content: Text("Password non corretta"),
                                      ),
                                    );
                                  } else {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      const SnackBar(
                                        content: Text(
                                            "Si è verificato un errore, riprovare"),
                                      ),
                                    );
                                  }
                                }
                              }
                            },
                            style: ElevatedButton.styleFrom(
                              primary: const Color.fromRGBO(163, 0, 6, 1),
                              onPrimary: Colors.white,
                              shadowColor: const Color.fromRGBO(163, 0, 6, 1),
                              elevation: 0,
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 28, vertical: 16),
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
