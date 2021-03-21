import 'package:flutter/cupertino.dart';

class Item {
  String title;
  bool done;
  double opacity;
  TextStyle style;

  Item({this.title, this.done, this.opacity, this.style});

  //https://javiercbk.github.io/json_to_dart/ --gerar código de conversão
  Item.fromJson(Map<String, dynamic> json) {
    title = json['title'];
    done = json['done'];
    opacity = json['opacity'];
    style = json['style'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['title'] = this.title;
    data['done'] = this.done;
    data['opacity'] = this.opacity;
    data['style'] = this.style;
    return data;
  }
}
