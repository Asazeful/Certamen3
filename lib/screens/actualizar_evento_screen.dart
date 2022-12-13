import 'package:flutter/material.dart';

import '../services/firestore_service.dart';

class ActualizarEventoScreen extends StatefulWidget {
  String id;
  ActualizarEventoScreen(this.id);

  @override
  State<ActualizarEventoScreen> createState() => _ActualizarEventoScreenState();
}

class _ActualizarEventoScreenState extends State<ActualizarEventoScreen> {
  final formKey = GlobalKey<FormState>();
  @override
  TextEditingController nombreCtrl = TextEditingController();
  TextEditingController fechaCtrl = TextEditingController();
  TextEditingController entradasCtrl = TextEditingController();
  TextEditingController entradasvCtrl = TextEditingController();
  bool ocurrio = false;
  String error ="";
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
            TextFormField(
              controller: entradasCtrl,
              decoration: InputDecoration(label: Text("Cantidad de entradas")),
              keyboardType: TextInputType.number,
            ),
            Switch(value: ocurrio, onChanged:(bool value){
              setState(() {
                ocurrio = value;
              });
            }),
            Container(
              width: double.infinity,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(backgroundColor: Colors.lightGreenAccent),
                child: Text("Añadir evento"),
                onPressed: () {
                  int entradas = int.tryParse(entradasCtrl.text.trim()) ?? 0;
                  int entradasv = int.tryParse(entradasvCtrl.text.trim()) ?? 0;
                  if(entradas == 0){
                    error = "El numero de entradas no es valido";
                  }else if(nombreCtrl.text.isEmpty){
                    error = ("${error}El nombre no es valido");
                  }else{
                    FirestoreService().editar(widget.id,nombreCtrl.text.trim(), fechaCtrl.text.trim(), entradas, entradasv,ocurrio);
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