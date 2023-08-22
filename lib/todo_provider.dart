import 'package:flutter/material.dart';

class TodoProvider extends ChangeNotifier{
  //List of todos
  List<String> items = ['work', 'read'];

  //Getter
  List<String> get todos => items;

  //Add todo
  void addTodo(String todo){
    items.add(todo);
    notifyListeners();
  }

  //Update todo
  void editTodo(int index, String text){
    items[index] = text;
    notifyListeners();
  }

  //Delete todo
  void delete(int index){
    items.removeAt(index);
    notifyListeners();
  }
}