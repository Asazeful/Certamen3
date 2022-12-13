import 'package:certamen3/screens/cliente_screen.dart';
import 'package:certamen3/screens/eventos_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  Future<FirebaseApp> _initializeFirebase() async {
    FirebaseApp firebaseApp = await Firebase.initializeApp();
    return firebaseApp;
  }

  @override
  final formKey = GlobalKey<FormState>();
  TextEditingController emailCtrl = TextEditingController();
  TextEditingController passCtrl = TextEditingController();
  String error = '';
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Login", style: TextStyle(color: Colors.lightGreenAccent),),
        backgroundColor: Colors.black,
      ),
      backgroundColor: Colors.lightGreen.shade50,
      body: 
              Center(
          child: Container(
            margin: EdgeInsets.symmetric(horizontal:30),
            width: double.infinity,
            height: 300,
            decoration: BoxDecoration(
              color: Colors.white,
              border:  Border.all(
                color: Colors.lightGreen
              ),
              borderRadius: BorderRadius.all(Radius.circular(10))
            ),
            child: 
              Padding(padding: EdgeInsets.all(5),
              child:
              Form(
                key: formKey,
                child:Column(
                  children: [
                    Text("Iniciar Sesion"),
                    Spacer(),
                    TextFormField(
                      controller: emailCtrl,
                      decoration: InputDecoration(
                        label: Text("Email"),
                      ),
                      keyboardType: TextInputType.emailAddress,
                    ),
                    TextFormField(
                      controller: passCtrl,
                      decoration: InputDecoration(label: Text("Contraseña")),
                      obscureText: true,
                    ),
                    Container(
                      width:  double.infinity,
                      child: 
                      ElevatedButton(
                        
                        child: Text("Iniciar Sesion"),
                        onPressed: ()=>login(),
                      ),
                    ),
      
                    Container(
                      margin: EdgeInsets.only(top: 10),
                      alignment: Alignment.center,
                      width: double.infinity,
                      child: Text(error, style: TextStyle(color: Colors.red),),
                    )
                  ],
                ) ,) ,),
              
            ),
        )
            

      );
  }

  void login() async {
    try{
      UserCredential userCredential = await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: emailCtrl.text.trim(), password: passCtrl.text.trim());
      
      SharedPreferences sp = await SharedPreferences.getInstance();
      sp.setString('userEmail', userCredential.user!.email.toString());

      if (emailCtrl.text == "admin@gmail.com")
      {
        MaterialPageRoute route = MaterialPageRoute(
          builder: ((context) => EventosScreen()));
          Navigator.pushReplacement(context, route);
      }else
      {
        MaterialPageRoute route = MaterialPageRoute(
          builder: ((context) => ClienteScreen()));
          Navigator.pushReplacement(context, route);
      }
    } on FirebaseAuthException catch (ex)
    {
      switch (ex.code) {
        case 'user-not-found':
          error = 'Usuario no existe';
          break;
        case 'wrong-password':
          error = 'Contraseña incorrecta';
          break;
        case 'user-disabled':
          error = 'Cuenta desactivada';
          break;
        default:
          error = ex.message.toString();
          break;
      }
      setState(() {});
    }
  }
}