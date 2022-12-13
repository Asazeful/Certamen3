import 'package:certamen3/services/firestore_service.dart';
import 'package:flutter/material.dart';

class AgregarEventoScreen extends StatefulWidget {
  const AgregarEventoScreen({Key? key}) : super(key: key);

  @override
  State<AgregarEventoScreen> createState() => _AgregarEventoScreenState();
}

class _AgregarEventoScreenState extends State<AgregarEventoScreen> {
  final formKey = GlobalKey<FormState>();
  @override

  TextEditingController nombreCtrl = TextEditingController();
  TextEditingController fechaCtrl = TextEditingController();
  TextEditingController entradasCtrl = TextEditingController();
  String error = "";


  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Añadir evento"),
      ),
      body: Padding(padding: const EdgeInsets.all(8),
      child: Form(
        key: formKey,
        child: Column(
          children: [
            TextFormField(
              controller: nombreCtrl,
              decoration: InputDecoration(
                label: Text("Nombre del evento")
              ),
            ),
            TextFormField(
              controller: fechaCtrl,
              decoration: InputDecoration(label: Text("Fecha del evento")),
              keyboardType: TextInputType.datetime,
            ),
            TextFormField(
              controller: entradasCtrl,
              decoration: InputDecoration(label: Text("Cantidad de entradas")),
              keyboardType: TextInputType.number,
            ),
            Container(
              width: double.infinity,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(backgroundColor: Colors.lightGreenAccent),
                child: Text("Añadir evento"),
                onPressed: () {
                  int entradas = int.tryParse(entradasCtrl.text.trim()) ?? 0;
                  if(entradas == 0){
                    error = "El numero de entradas no es valido";
                  }else if(nombreCtrl.text.isEmpty){
                    error = ("${error}El nombre no es valido");
                  }else{
                    FirestoreService().agregar(nombreCtrl.text.trim(), fechaCtrl.text.trim(), entradas);
                    Navigator.pop(context);
                  }
                },
              ),
            ),
            Container(
              child: Text(error),
            )
          ],
        ),
      ),),
    );
  }
}