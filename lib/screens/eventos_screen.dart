// ignore_for_file: prefer_const_constructors

import 'package:certamen3/screens/agregar_evento_screen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../services/firestore_service.dart';
import 'actualizar_evento_screen.dart';
import 'login_screen.dart';

class EventosScreen extends StatefulWidget {
  const EventosScreen({Key? key}) : super(key: key);

  @override
  State<EventosScreen> createState() => _EventosScreenState();
}

class _EventosScreenState extends State<EventosScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        
        leading: Icon(MdiIcons.microphone, color: Colors.lightGreenAccent,),
        backgroundColor: Colors.black,

      title: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text("Eventos"),
          FutureBuilder(
            future: this.getUserEmail(),
            builder: (context, AsyncSnapshot snapshot)
            {
              if(!snapshot.hasData || snapshot.connectionState == ConnectionState.waiting)
              {
                return Text("Cargando. . .");
              }
              return Text(
                snapshot.data,
                style: TextStyle(fontSize: 12),
              );
            },
          )
        ],),
        actions: 
        [
          PopupMenuButton(itemBuilder: (context) => [
            PopupMenuItem(value: 'logout', child: Text("Cerrar sesion"),),
          ],
          onSelected:(opcionSeleccionada){
            if(opcionSeleccionada == 'logout'){logout(context);}
          }),
        ],
        
    ),
    body: StreamBuilder(
      stream: FirestoreService().eventos(),
      builder: (context, AsyncSnapshot<QuerySnapshot> snapshot)
      {
        if(!snapshot.hasData || snapshot.connectionState == ConnectionState.waiting){
          return Center(
            child: CircularProgressIndicator(),
          );
        }
        return ListView.separated(
          separatorBuilder: (context, index) => Divider() ,
          itemCount: snapshot.data!.docs.length,
          itemBuilder: (context, index) {
            var evento = snapshot.data!.docs[index];
            return ListTile(
              leading: Icon(MdiIcons.ticket, color: Colors.grey,),
              title: Text(evento['NombreEvento']),
              subtitle: Text(evento['FechaEvento']),
              trailing: PopupMenuButton(itemBuilder: (context) => [
                PopupMenuItem(child: Text("Borrar"),value: 1, ),
                PopupMenuItem(child: Text("Editar"), value: 2,),
                PopupMenuItem(child: Text("ocurrio"),value: 3,),
                PopupMenuItem(child: Text("Ventas"),value: 4,)
              ],
              onSelected: (opcion){
                if(opcion == 1){
                  FirestoreService().borrar(evento.id);
                }else if(opcion ==2){
                  MaterialPageRoute route = MaterialPageRoute(builder: (context) => ActualizarEventoScreen(evento.id));
                  Navigator.push(context,route);
                }else if(opcion ==3){
                  FirestoreService().ocurrio(evento.id);
                }else if(opcion == 4){
                  showDialog(
                    context: context, 
                    builder: (BuildContext context) => AlertDialog(
                      title: Text("Ventas"),
                      content: Text(FirestoreService().mostrarVentas(evento.id)),
                      actions: [TextButton(
                        onPressed: () => Navigator.pop(context, 'OK'),
                        child: const Text('OK'),)],
                    )
                    );
                }
              },
              ),
              
            );
          },
        );
      },
    ),
    floatingActionButton: FloatingActionButton(
      child: Icon(Icons.add),
      onPressed: () {
        MaterialPageRoute route = MaterialPageRoute(builder: ((context) => AgregarEventoScreen()));
        Navigator.push(context,route);
      },
    ),);
  }
  
  Future <String> getUserEmail() async {
    SharedPreferences sp = await SharedPreferences.getInstance();
    return sp.getString('userEmail')?? '';
  }

  void logout(BuildContext context) async 
  {
    await FirebaseAuth.instance.signOut();

    SharedPreferences sp = await SharedPreferences.getInstance();

    MaterialPageRoute route = MaterialPageRoute(builder: ((context) => LoginScreen()));
    Navigator.pushReplacement(context, route);
  }
}