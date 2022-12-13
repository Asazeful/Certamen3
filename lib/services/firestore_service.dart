import 'package:cloud_firestore/cloud_firestore.dart';

class FirestoreService{

  Stream<QuerySnapshot> eventos(){
    return FirebaseFirestore.instance.collection("Eventos").snapshots();
  }

  Future agregar(String NombreEvento, String FechaEvento, int EntradasTotal){
    return FirebaseFirestore.instance.collection("Eventos").doc().set({
      'NombreEvento': NombreEvento,
      'FechaEvento': FechaEvento,
      'EntradasTotal':EntradasTotal,
      'EntradasVendidas': 0,
      'Ocurrio':false,
    });
  }

  Future borrar(eventosId){
    return FirebaseFirestore.instance.collection("Eventos").doc(eventosId).delete();
  }

  Future editar(String id,String NombreEvento, String FechaEvento, int EntradasTotal, int EntradasVendidas, bool ocurrio){
    return FirebaseFirestore.instance.collection("Eventos").doc(id).set({
      'NombreEvento': NombreEvento,
      'FechaEvento': FechaEvento,
      'EntradasTotal':EntradasTotal,
      'EntradasVendidas': EntradasVendidas,
      'Ocurrio':ocurrio,
    });
  }

  Future ocurrio(String id){
    return FirebaseFirestore.instance.collection("Eventos").doc(id).set({
      'Ocurrio':true
    });
  }

  Future venderEntrada(String idEvento, String idCliente){
    return FirebaseFirestore.instance.collection("Eventos").doc(idEvento).snapshots().forEach((element) {
      var entradasVendidas = element.get('EntradasVendida');
      entradasVendidas = entradasVendidas + 1;
      FirebaseFirestore.instance.collection("Eventos").doc(idEvento).set({'EntradasVendidas':entradasVendidas});
      FirebaseFirestore.instance.collection("EntradasVendidas").doc().set({
        'IdCliente':idCliente,
        'IdEvento':idEvento
      });
     });
     
    
  }

  String mostrarVentas(String idEvento){
    String entradas="";
    FirebaseFirestore.instance.collection("Eventos").doc(idEvento).snapshots().forEach((element) {
      int entradasVendidas = element.get("EntradasVendidas");
      int entradasTotal = element.get("EntradasTotal");
      entradas ="Entradas vendidas:${entradasVendidas} | Total de entradas:${entradasTotal}";
      
     });
     return entradas;
  }
  
  Stream<QuerySnapshot> eventosDisponibles(){
    return FirebaseFirestore.instance.collection("Eventos").where("Ocurrio", isEqualTo: false).snapshots();
  }

  QueryDocumentSnapshot<Object?>getIdCliente(Future<String> correo){
    var objeto;
    FirebaseFirestore.instance.collection("Clientes").where("Corre", isEqualTo: correo).snapshots().single.then((value) => objeto);
    return objeto;
 
  }

  Stream<QuerySnapshot> mostrarEntradas(String idCliente){
    return FirebaseFirestore.instance.collection("EntradasVendidas").where("IdCliente", isEqualTo: idCliente).snapshots();
  }
}
