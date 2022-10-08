import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:week10/DbHelper.dart';

import 'note.dart';

class Home extends StatefulWidget {
  TextEditingController teSeach = TextEditingController();

  @override
  _homeState createState() => _homeState();
}

late String Task;
var date;
late DbHelper helper;

class _homeState extends State<Home> {
  late DbHelper helper;
  var allTasks = [];
  var items = [];

  DateTime Tdate = DateTime.now();
  TextEditingController Sdate = TextEditingController();

  DateTime newDate = DateTime.now();
  @override
  void initState() {
    super.initState();
    helper = DbHelper();
    helper.allTasks().then((tasks) {
      setState(() {
        allTasks = tasks;
        items = allTasks;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Column(children: [
          Container(
            padding: EdgeInsets.all(15.0),
            color: Colors.blueAccent,
            child: Column(children: [
              SizedBox(
                height: 20,
              ),
              Row(
                children: [
                  Icon(
                    Icons.menu,
                    color: Colors.white,
                  ),
                  SizedBox(
                    width: 20,
                  ),
                  Text(
                    'Tasker',
                    style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 20),
                  )
                ],
              ),
              SizedBox(
                height: 25,
              ),
              Row(
                children: [
                  Text(
                    '${Tdate.day}',
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 35,
                        fontWeight: FontWeight.bold),
                  ),
                  Column(
                    children: [
                      Text(
                        '${Tdate.month}',
                        style: TextStyle(color: Colors.white, fontSize: 15),
                      ),
                      Text(
                        '${Tdate.year}',
                        style: TextStyle(color: Colors.white, fontSize: 15),
                      ),
                    ],
                  ),
                  SizedBox(
                    width: 220,
                  ),
                  Text(
                    '${DateFormat.EEEE().format(DateTime.now())}',
                    style: TextStyle(color: Colors.white, fontSize: 15),
                  ),
                ],
              ),
              SizedBox(
                height: 20,
              ),
            ]),
          ),
          FutureBuilder(
            builder: (context, AsyncSnapshot snapshot) {
              if (!snapshot.hasData) {
                return CircularProgressIndicator();
              } else {
                return Expanded(
                    child: ListView.builder(
                        itemCount: snapshot.data.length,
                        itemBuilder: (context, i) {
                          Note note = Note.fromMap(snapshot.data[i]);
                          return Card(
                            child: ListTile(
                              leading: Checkbox(
                                  activeColor: Colors.cyan,
                                  value: note.isChecked,
                                  onChanged: (newValue) {
                                    setState(() {
                                      note.isChecked = newValue!;
                                      helper.createUpdate(note);
                                    });
                                  }),
                              title: Text(note.task),
                              subtitle: Text(newDate.toString()),
                              trailing: Column(
                                children: [
                                  IconButton(
                                    icon: Icon(
                                      Icons.delete,
                                      color: Colors.blueAccent,
                                    ),
                                    onPressed: () {
                                      setState(() {
                                        helper.delete(note.id);
                                      });
                                    },
                                  ),
                                ],
                              ),
                            ),
                          );
                        }));
              }
            },
            future: helper.allTasks(),
          ),
        ]),
        floatingActionButton: FloatingActionButton(
            backgroundColor: Colors.blueAccent,
            child: Icon(Icons.add),
            onPressed: () => showMaterialModalBottomSheet(
                  expand: false,
                  context: context,
                  barrierColor: Colors.white70,
                  backgroundColor: Colors.white,
                  builder: (context) => Container(
                    decoration:
                        BoxDecoration(borderRadius: BorderRadius.circular(30)),
                    height: 220,
                    child: Padding(
                      padding: const EdgeInsets.all(15.0),
                      child: Form(
                        child: Column(children: <Widget>[
                          TextFormField(
                            decoration: InputDecoration(hintText: 'Task'),
                            onChanged: (value) {
                              setState(() {
                                Task = value;
                              });
                            },
                          ),
                          SizedBox(
                            height: 15,
                          ),
                          TextFormField(
                            decoration:
                                InputDecoration(hintText: 'No due date'),
                            controller: Sdate,
                          ),
                          SizedBox(
                            width: 100,
                          ),
                          Row(children: [
                            IconButton(
                                icon: Icon(
                                  Icons.calendar_month,
                                  color: Colors.blueAccent,
                                ),
                                onPressed: () async {
                                  DateTime? newDate = await showDatePicker(
                                    context: context,
                                    initialDate: Tdate,
                                    firstDate: DateTime(2000),
                                    lastDate: DateTime(2100),
                                  );
                                  if (newDate == null) return;
                                  setState(() {
                                    Sdate.text = newDate.toString();
                                  });
                                }),
                            SizedBox(
                              width: 100,
                            ),
                            RaisedButton(
                              color: Colors.white,
                              child: Text(
                                'Cancel',
                                style: TextStyle(color: Colors.black),
                              ),
                              onPressed: () {
                                Navigator.of(context).push(
                                  MaterialPageRoute(
                                      builder: (context) => Home()),
                                );
                              },
                            ),
                            SizedBox(
                              width: 10,
                            ),
                            RaisedButton(
                              color: Colors.white,
                              child: Text(
                                'Save',
                                style: TextStyle(color: Colors.blueAccent),
                              ),
                              onPressed: () async {
                                Note note = Note({'task': Task, 'date': date});
                                int id = await helper.createTask(note);
                                Navigator.of(context).push(
                                  MaterialPageRoute(
                                      builder: (context) => Home()),
                                );
                              },
                            ),
                          ]),
                        ]),
                      ),
                    ),
                  ),
                )));
  }
}
