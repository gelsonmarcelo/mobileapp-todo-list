import 'package:flutter/material.dart';

showAlertDialog1(BuildContext context) {
  //Configura o AlertDialog
  AlertDialog alerta = AlertDialog(
    title: Text("Tarefa em branco"),
    content: Text("Não é possível criar uma tarefa vazia."),
  );
  //Exibe o dialog
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return alerta;
    },
  );
}
