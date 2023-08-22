import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class MyRoutine extends StatefulWidget {
  const MyRoutine({super.key});

  @override
  State<MyRoutine> createState() => _MyRoutineState();
}

class _MyRoutineState extends State<MyRoutine>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 4, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("My Routine"),
        backgroundColor: Color.fromARGB(247, 249, 17, 0),
        bottom: TabBar(
          controller: _tabController,
          tabs: [
            Tab(text: 'Daily'),
            Tab(text: 'Weekly'),
            Tab(text: 'Monthly'),
            Tab(text: 'Last Year'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          TabContent(tabText: 'Daily'),
          TabContent(tabText: 'Weekly'),
          TabContent(tabText: 'Monthly'),
          TabContent(tabText: 'Last Year'),
        ],
      ),
    );
  }
}

class TabContent extends StatefulWidget {
  final String tabText;

  TabContent({required this.tabText});

  @override
  State<TabContent> createState() => _TabContentState();
}

class _TabContentState extends State<TabContent> {
  Widget _buildContent() {
    QuerySnapshot? searchSnapshot;

    String currentTimeRange = 'Today';

    Future<void> habitDateSearch(String tabText) async {
      DateTime startDate = DateTime.now();
      DateTime endDate = DateTime.now();

      setState(() {});

      if (tabText == 'Daily') {
        startDate = DateTime(startDate.year, startDate.month, startDate.day);
        endDate = DateTime(endDate.year, endDate.month, endDate.day + 1);
      } else if (tabText == 'Weekly') {
        startDate = startDate.subtract(Duration(days: 7));
      } else if (tabText == 'Monthly') {
        startDate = startDate.subtract(Duration(days: 30));
      } else if (tabText == 'Last Year') {
        startDate = startDate.subtract(Duration(days: 365));
      }
    }

    switch (widget.tabText) {
      case 'Daily':
        return buildDailyContent();
      case 'Weekly':
        return buildWeeklyContent();
      case 'Monthly':
        return buildMonthlyContent();
      case 'Last Year':
        return buildAllTimeContent();
      default:
        return Center(child: Text('Unknown Tab'));
    }
  }

  Widget buildDailyContent() {
    final today = DateTime.now();
    final startDate = DateTime(today.year, today.month, today.day);
    final endDate = DateTime(today.year, today.month, today.day + 1);

    print(endDate);
    return StreamBuilder<QuerySnapshot>(
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
                //  final documentId = snapshot.data!.docs[index].id;
                // final title = snapshot.data.docs[index]['title'];
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
                                  // editHabitDialog(documentId, title);
                                },
                                icon: Icon(Icons.edit)),
                            IconButton(
                                onPressed: () {
                                  //  deleteHabitevent(documentId);
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
        });
  }

  Widget buildMonthlyContent() {
    final today = DateTime.now();
    final thirtyDaysAgo = today.subtract(Duration(days: 30));
    return StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection('habits')
            .where('time', isGreaterThanOrEqualTo: thirtyDaysAgo)
            .where('time', isLessThan: today)
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
                //  final documentId = snapshot.data!.docs[index].id;
                // final title = snapshot.data.docs[index]['title'];
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
                                  // editHabitDialog(documentId, title);
                                },
                                icon: Icon(Icons.edit)),
                            IconButton(
                                onPressed: () {
                                  //  deleteHabitevent(documentId);
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
        });
  }

  Widget buildWeeklyContent() {
    final today = DateTime.now();
    final sevenDaysAgo = today.subtract(Duration(days: 7));

    return StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection('habits')
            .where('time', isGreaterThanOrEqualTo: sevenDaysAgo)
            .where('time', isLessThan: today)
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
                //  final documentId = snapshot.data!.docs[index].id;
                // final title = snapshot.data.docs[index]['title'];
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
                                  // editHabitDialog(documentId, title);
                                },
                                icon: Icon(Icons.edit)),
                            IconButton(
                                onPressed: () {
                                  //  deleteHabitevent(documentId);
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
        });
  }

  Widget buildAllTimeContent() {
    final today = DateTime.now();
    final lastYear = today.subtract(Duration(days: 365));
    return StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection('habits')
            .where('time', isGreaterThanOrEqualTo: lastYear)
            .where('time', isLessThan: today)
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
                //  final documentId = snapshot.data!.docs[index].id;
                // final title = snapshot.data.docs[index]['title'];
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
                                  // editHabitDialog(documentId, title);
                                },
                                icon: Icon(Icons.edit)),
                            IconButton(
                                onPressed: () {
                                  //  deleteHabitevent(documentId);
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
        });
  }

  @override
  Widget build(BuildContext context) {
    return _buildContent();
  }
}
/* QuerySnapshot? searchSnapshot;



  String currentTimeRange = 'Today';

  Future<void> habitDateSearch(String tabText) async {
    DateTime startDate = DateTime.now();
    DateTime endDate = DateTime.now();

    setState(() {});

    if (tabText == 'Daily') {
      startDate = DateTime(startDate.year, startDate.month, startDate.day);
      endDate = DateTime(endDate.year, endDate.month, endDate.day + 1);
    } else if (tabText == 'Weekly') {
      startDate = startDate.subtract(Duration(days: 7));
    } else if (tabText == 'Monthly') {
      startDate = startDate.subtract(Duration(days: 30));
    } else if (tabText == 'Last Year') {
      startDate = startDate.subtract(Duration(days: 365));
    }} */