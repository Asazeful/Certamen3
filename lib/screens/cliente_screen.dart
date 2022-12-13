// ignore_for_file: unnecessary_this

import 'package:certamen3/services/firestore_service.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'login_screen.dart';

class ClienteScreen extends StatefulWidget {
  const ClienteScreen({Key? key}) : super(key: key);
  
  @override
  State<ClienteScreen> createState() => _ClienteScreenState();
}

class _ClienteScreenState extends State<ClienteScreen> {
  final Future<String> correo = () async {
    SharedPreferences sp = await SharedPreferences.getInstance();
    return sp.getString('userEmail')?? '';
  }();
  late var cliente = FirestoreService().getIdCliente(correo);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black,
        leading: const Icon(MdiIcons.human, color: Colors.lightGreenAccent,),
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text("Eventos"),
            FutureBuilder(
              future: this.getUserEmail(),
              builder: (context, AsyncSnapshot snapshot){
                if(!snapshot.hasData || snapshot.connectionState == ConnectionState.waiting)
              {
                return const Text("Cargando. . .");
              }
              return Text(
                snapshot.data,
                style: const TextStyle(fontSize: 12),
              );
              })
          ],),
          actions: [
            PopupMenuButton(itemBuilder: (context) => [
            const PopupMenuItem(value: 'logout', child: Text("Cerrar sesion"),),
          ],
          onSelected:(opcionSeleccionada){
            if(opcionSeleccionada == 'logout'){logout(context);}
          }),
          ],
      ),

      body: StreamBuilder(
        stream: FirestoreService().eventosDisponibles(),
        builder: (context, AsyncSnapshot<QuerySnapshot> snapshot)
        {
          if(!snapshot.hasData || snapshot.connectionState == ConnectionState.waiting){
          return const Center(
            child: CircularProgressIndicator(),
          );
        }
        return ListView.separated(
          separatorBuilder: (context, index) => const Divider() ,
          itemCount: snapshot.data!.docs.length,
          itemBuilder: (context, index) {
            var evento = snapshot.data!.docs[index];
            return ListTile(
              leading: const Icon(MdiIcons.ticket, color: Colors.grey,),
              title: Text(evento['NombreEvento']),
              subtitle: Text(evento['FechaEvento']),
              trailing: FloatingActionButton(
                child: Icon(Icons.add),
                onPressed: (() {
                  FirestoreService().venderEntrada(evento.id, cliente.id);
                }),
              ),);
        });
        }
      ),
      
    );
  }
  
  Future <String> getUserEmail() async {
    SharedPreferences sp = await SharedPreferences.getInstance();
    return sp.getString('userEmail')?? '';
  }

  void logout(BuildContext context) async 
  {
    await FirebaseAuth.instance.signOut();

    SharedPreferences sp = await SharedPreferences.getInstance();

    MaterialPageRoute route = MaterialPageRoute(builder: ((context) => const LoginScreen()));
    Navigator.pushReplacement(context, route);
  }
}