import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:provider_demo/my_routine.dart';
import 'package:provider_demo/todo_provider.dart';
import 'dart:async';
import 'about_page.dart';
import 'package:firebase_core/firebase_core.dart';

void scheduleDataRemoval(callback) {
  DateTime now = DateTime.now();
  DateTime midnight =
      DateTime(now.year, now.month, now.day + 1); // 12 AM of the next day
  Duration durationUntilMidnight = midnight.difference(now);

  Timer(durationUntilMidnight, callback);
}

class HomePage extends StatefulWidget {
  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final habitTitleController = new TextEditingController();

  @override
  void dispose() {
    habitTitleController.dispose(); // Dispose the controller
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final todoProvider = Provider.of<TodoProvider>(context);
    final today = DateTime.now();
    final startDate = DateTime(today.year, today.month, today.day);
    final endDate = DateTime(today.year, today.month, today.day + 1);

    return Scaffold(
        appBar: AppBar(
          title: Text('Habit Tracker'),
          backgroundColor: Color.fromARGB(247, 249, 17, 0),
        ),
        drawer: Drawer(
          backgroundColor: Colors.white,
          child: Column(
            children: [
              Image.asset('assets/images/logo.png', height: 230, width: 270),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Divider(
                  thickness: 2, // Set the thickness of the line
                  color: const Color.fromARGB(
                      255, 253, 17, 0), // Set the color of the line
                ),
              ),
              ListTile(
                title: Text('Home', style: TextStyle(fontSize: 16)),
                leading: Icon(
                  Icons.home,
                  color: const Color.fromARGB(255, 255, 17, 0),
                ),
                onTap: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) => HomePage(),
                    ),
                  );
                },
              ),
              ListTile(
                title: Text(
                  'My Routine',
                  style: TextStyle(fontSize: 16),
                ),
                leading: Icon(Icons.calendar_today,
                    color: const Color.fromARGB(255, 255, 17, 0)),
                onTap: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) => MyRoutine(),
                    ),
                  );
                },
              ),
              ListTile(
                title: Text('About us', style: TextStyle(fontSize: 16)),
                leading: Icon(Icons.info_rounded,
                    color: const Color.fromARGB(255, 255, 17, 0)),
                onTap: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) => About_page(),
                    ),
                  );
                },
              ),
              ListTile(
                  title: Text('Privacy Policy', style: TextStyle(fontSize: 16)),
                  leading: Icon(Icons.privacy_tip_rounded,
                      color: const Color.fromARGB(255, 255, 17, 0))),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Divider(
                    thickness: 2, // Set the thickness of the line
                    color: Colors.black // Set the color of the line
                    ),
              ),
            ],
          ),
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
        floatingActionButton: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            children: [
              SizedBox(
                width: 100,
              ),
              FloatingActionButton(
                  backgroundColor: const Color.fromARGB(255, 255, 17, 0),
                  child: const Icon(Icons.calendar_today),
                  onPressed: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) => MyRoutine(),
                      ),
                    );
                  }),
              SizedBox(
                width: 120,
              ),
              FloatingActionButton(
                  backgroundColor: const Color.fromARGB(255, 255, 17, 0),
                  child: const Icon(Icons.add),
                  onPressed: () {
                    addButtonevent();
                  }),
            ],
          ),
        ),
        body: StreamBuilder<QuerySnapshot>(
            stream: FirebaseFirestore.instance
                .collection('habits')
                .where('time', isGreaterThanOrEqualTo: startDate)
                .where('time', isLessThan: endDate)
                .snapshots(),
            builder: (context, AsyncSnapshot snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return Center(child: Text("Loading...."));
              }

              if (snapshot.hasError) {
                return Text('Error: ${snapshot.error}');
              }
              if (snapshot.data.docs.length < 1) {
                return Center(child: Text('Please add some habits'));
              }
              if (snapshot.hasData) {
                return ListView.builder(
                  itemCount: snapshot.data.docs.length,
                  itemBuilder: (_, index) {
                    final documentId = snapshot.data!.docs[index].id;
                    final title = snapshot.data.docs[index]['title'];
                    /*   var document = snapshot.data.docs[index];
              var documentId = document.id; */
                    return Card(
                      child: Container(
                        height: 50,
                        padding: EdgeInsets.only(left: 10, right: 10),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(snapshot.data.docs[index]['title']),
                            Row(
                              children: [
                                IconButton(
                                    onPressed: () {
                                      editHabitDialog(documentId, title);
                                    },
                                    icon: Icon(Icons.edit)),
                                IconButton(
                                    onPressed: () {
                                      deleteHabitevent(documentId);
                                    },
                                    icon: Icon(Icons.delete))
                              ],
                            )
                          ],
                        ),
                        /*  trailing: Row(
                         
                        ) ,*/
                      ),
                    );
                  },
                );
              }
              return CircularProgressIndicator();
            }));
  }

  void _addEvent() async {
    final habitTitle = habitTitleController.text.trim();

    if (habitTitle.isEmpty) {
      //print('title cannot be empty');
      return;
    }
    await FirebaseFirestore.instance
        .collection('habits')
        .add({"title": habitTitle, "time": DateTime.now()});
    habitTitleController.clear();
    if (mounted) {
      Navigator.pop<bool>(context, true);
    }
  }

  void deleteHabitevent(String documentId) async {
    final delete = await showDialog<bool>(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text("Delete Habit?"),
        content: const Text("Are you sure you want to delete?"),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            style: TextButton.styleFrom(
              foregroundColor: Colors.black,
            ),
            child: const Text("No"),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            style: TextButton.styleFrom(
              foregroundColor: Colors.green,
            ),
            child: const Text("Yes"),
          ),
        ],
      ),
    );
    if (delete ?? false) {
      await FirebaseFirestore.instance
          .collection('habits')
          .doc(documentId)
          .delete();
    }
  }

  void editHabitDialog(String documentId, String currentTitle) async {
    habitTitleController.text = currentTitle;
    return showDialog(
      context: context,
      builder: (BuildContext context) {
        return Container(
          // padding: const EdgeInsets.only(top: 30, bottom: 10),
          child: StatefulBuilder(builder: (context, setState) {
            return AlertDialog(
              actionsAlignment: MainAxisAlignment.spaceEvenly,
              elevation: 20,
              title: const Text("Edit Habit"),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 10),
                  TextField(
                    controller: habitTitleController,
                    decoration: const InputDecoration(hintText: "Enter Habit"),
                  ),
                  const SizedBox(height: 10),
                ],
              ),
              actions: [
                ElevatedButton(
                  onPressed: () async {
                    Navigator.pop(context);
                  },
                  child: const Text("Cancel"),
                ),
                ElevatedButton(
                  onPressed: () async {
                    await updateHabitEvent(documentId);
                    Navigator.pop(context);
                  },
                  child: const Text("Save"),
                ),
              ],
            );
          }),
        );
      },
    );
  }

  Future<void> updateHabitEvent(String documentId) async {
    String updatedTitle = habitTitleController.text.trim();

    if (updatedTitle.isNotEmpty) {
      try {
        await FirebaseFirestore.instance
            .collection('habits')
            .doc(documentId)
            .update({
          'title': updatedTitle, // Update the 'title' field with the new data
        });
        print('Habit updated successfully');
      } catch (error) {
        print('Error updating habit: $error');
      }
    }
  }

  void addButtonevent() async {
    return showDialog(
      context: context,
      builder: (BuildContext context) {
        habitTitleController.clear();
        return Container(
          // padding: const EdgeInsets.only(top: 30, bottom: 10),
          child: StatefulBuilder(builder: (context, setState) {
            return AlertDialog(
              actionsAlignment: MainAxisAlignment.spaceEvenly,
              elevation: 20,
              title: const Text("Add New Habit"),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 10),
                  TextField(
                    controller: habitTitleController,
                    decoration: const InputDecoration(hintText: "Enter Habit"),
                  ),
                  const SizedBox(height: 10),
                ],
              ),
              actions: [
                ElevatedButton(
                  onPressed: () async {
                    Navigator.pop(context);
                  },
                  child: const Text("Cancel"),
                ),
                ElevatedButton(
                  onPressed: () async {
                    _addEvent();
                  },
                  child: const Text("Add"),
                ),
              ],
            );
          }),
        );
      },
    );
  }

  /* Future<void> AddorUpdateTodo(BuildContext context, TodoProvider todoProvider,
      bool isAdded, String text, int index) {
    ctodoText.text = text;
    return showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: isAdded ? Text('Add habit') : Text("Update habit"),
          content: TextField(
            controller: ctodoText,
            decoration: InputDecoration(
              hintText: "Enter habit",
              labelText: "Enter habit",
            ),
          ),
          actions: <Widget>[
            TextButton(
              style: TextButton.styleFrom(
                  textStyle: Theme.of(context).textTheme.labelLarge,
                  backgroundColor: Colors.blue),
              child: const Text(
                'Save',
                style: TextStyle(color: Colors.white),
              ),
              onPressed: () {
                if (isAdded) {
                  todoProvider.addTodo(ctodoText.text);
                  ctodoText.clear();
                } else {
                  todoProvider.editTodo(index, ctodoText.text);
                }
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              style: TextButton.styleFrom(
                  textStyle: Theme.of(context).textTheme.labelLarge,
                  backgroundColor: Colors.red),
              child: Text('Cancel', style: TextStyle(color: Colors.white)),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  } */
}
