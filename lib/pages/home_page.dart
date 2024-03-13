import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:task_manager/data/database.dart';
import 'package:task_manager/util/dialog_box.dart';
import 'package:task_manager/util/todo_tile.dart';


class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {

  final _myBox=Hive.box("mybox");
  ToDoDataBase db=ToDoDataBase();

  @override
  void initState() {
    if(_myBox.get("TODOLIST")==null){
      db.createInitialData();
    }else{
      db.loadData();
    }
    super.initState();
  }

  final _controller=TextEditingController();

  void checkBoxChanged(bool? value,int index){
    setState(() {
      db.toDoList[index][1]=!db.toDoList[index][1];
    });
    db.updateDatabase();
  }
  void createNewTask(){
    showDialog(context: context, builder: (context){
      return DialogBox(
        controller: _controller,
        onSave: saveNewTask,
        onCancel: ()=>Navigator.of(context).pop(),
      );
    });

  }
  void saveNewTask(){
    setState(() {
      db.toDoList.add([_controller.text,false]);
      _controller.clear();
    });
    Navigator.of(context).pop();
    db.updateDatabase();
  }
  void deleteTask(int index){

    setState(() {
      db.toDoList.removeAt(index);
    });
    db.updateDatabase();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.yellow[200],
      appBar: AppBar(
        title: Center(child: Text("TASK MANAGER ",style: TextStyle(fontWeight: FontWeight.bold),)),
        backgroundColor: Colors.yellow,
      ),
      body: ListView.builder(
        itemCount:db.toDoList.length,
        itemBuilder:(context,index){
          return ToDoTile(taskName:db.toDoList[index][0] ,
            taskCompleted:db.toDoList[index][1]
            ,onChanged:(value)=>checkBoxChanged(value,index),
          deleteFunction: (context)=>deleteTask(index),);
      },
      ),
      floatingActionButton: FloatingActionButton(
        shape: CircleBorder(),
        backgroundColor: Colors.yellow,
        onPressed: createNewTask,
        child: Icon(Icons.add),),
    );
  }
}
