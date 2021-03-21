import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'AlertDialogs/alert.dart';
import 'models/item.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Todo App', //Título da aplicação
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.indigo,
      ),
      home: HomePage(),
    );
  }
}

class HomePage extends StatefulWidget {
  var items = new List<Item>();

  HomePage() {
    items = []; //Inicialização da lista

    items.add(
      Item(
        title: "Item 1",
        done: false,
        opacity: 1.0,
        style: TextStyle(
          color: Colors.white,
          decoration: TextDecoration.none,
        ),
      ),
    );
    // items.add(Item(title: "Item 2", done: true));
    // items.add(Item(title: "Item 3", done: false));
  }

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  var newTaskCtrl = TextEditingController();

  ///Esse método verifica se o nome não está vazio e gera um novo item com ele
  void add() {
    if (newTaskCtrl.text.isEmpty) {
      showAlertDialog1(context);
      return;
    } else {
      setState(() {
        widget.items.add(
          Item(
            title: newTaskCtrl.text,
            done: false,
            opacity: 1.0,
            style: TextStyle(
              color: Colors.white,
              decoration: TextDecoration.none,
            ),
          ),
        );
        newTaskCtrl.text = "";
        save();
      });
    }
  }

  void remove(int index) {
    setState(() {
      widget.items.removeAt(index); //Remove o item da lista
      save();
    });
  }

  ///Future/async - Não será realizado na hora, virá depois
  Future load() async {
    var prefs = await SharedPreferences.getInstance();
    var data = prefs.getString('data');

    if (data != null) {
      Iterable decoded =
          jsonDecode(data); //Significa que é uma coluna onde há uma iteração
      List<Item> result = decoded.map((x) => Item.fromJson(x)).toList();
      setState(() {
        widget.items = result;
      });
    }
  }

  ///Todo método que trabalhar com shared_preferences será async
  save() async {
    var prefs = await SharedPreferences.getInstance();
    await prefs.setString('data', jsonEncode(widget.items));
  }

  ///Método construtor que chamará o 'load' quando executar
  _HomePageState() {
    load();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        //leading: Text("oi"),
        title: TextFormField(
          controller:
              newTaskCtrl, //Controlador para conseguir pegar o texto descrito
          keyboardType: TextInputType
              .text, //Mostra teclado personalizado de acordo com dado de entrada que o usuário precisará inserir
          style: TextStyle(color: Colors.white, fontSize: 18),

          decoration: InputDecoration(
            labelText: "Nova Tarefa",
            labelStyle: TextStyle(color: Colors.white),
          ),
        ),
        /*actions: <Widget>[
          Icon(Icons.plus_one),
        ],*/
      ),
      body: ListView.builder(
        //Controla para que itens da lista que não aparecem na tela desapareçam e apareçam sob demanda
        itemCount: widget.items.length, //acessa informações da classe pai
        itemBuilder: (BuildContext ctxt, int index) {
          final item = widget.items[index];

          ///Conseguir arrastar o item para o lado
          return Dismissible(
            child: CheckboxListTile(
              title: AnimatedOpacity(
                child: Text(
                  item.title,
                  style: item.style,
                ),
                duration: const Duration(milliseconds: 50),
                opacity: item.opacity,
              ),
              value: item.done,
              activeColor: Colors.cyan[700],
              checkColor: Colors.white,
              controlAffinity: ListTileControlAffinity.leading,
              onChanged: (value) {
                setState(() {
                  //Atualiza o item que mudou para alterar na tela
                  item.done = value;
                  if (value) {
                    item.opacity = 0.5;
                    item.style = TextStyle(
                      color: Colors.white,
                      decoration: TextDecoration.lineThrough,
                    );
                  } else {
                    item.opacity = 1.0;
                    item.style = TextStyle(
                      color: Colors.white,
                      decoration: TextDecoration.none,
                    );
                  }
                  save();
                });
              },
            ),
            key: Key(item.title),
            background: Container(
              color: Colors.red.withOpacity(0.5),
              child: Center(
                child: Text(
                  'Eliminar',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                  ),
                ),
              ),
            ),
            onDismissed: (direction) {
              //if(direction == DismissDirection.endToStart /*startToEnd*/)
              //print(direction);
              remove(index);
            },
          );
        },
      ),
      backgroundColor: Colors.black,
      floatingActionButton: FloatingActionButton(
        onPressed: add, //Chamando função para criar item
        child: Icon(Icons.add_box),
        backgroundColor: Colors.indigo,
      ),
    );
  }
}
