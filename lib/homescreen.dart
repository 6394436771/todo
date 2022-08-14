import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:grouped_list/grouped_list.dart';
import 'package:intl/intl.dart';
import 'package:roundcheckbox/roundcheckbox.dart';
import 'package:sticky_grouped_list/sticky_grouped_list.dart';
import 'package:to_do_list/login.dart';
import 'package:to_do_list/sign.dart';

import 'model.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  bool isChecked = false;
  List<Date> data = [];

  String formattedDate = DateFormat.yMMMd().format(DateTime.now());
  var hour = DateFormat("hh:mm: a").format(DateTime.now());
  // Stream<DocumentSnapshot> stream =  FirebaseFirestore.instance.collection('Task').doc("User1").snapshots();

  @override
  Widget build(BuildContext context) {
    TextEditingController titleController = TextEditingController();
    // String user = '';
    TextEditingController titlController = TextEditingController();

    FirebaseAuth auth = FirebaseAuth.instance;
    final String? user = auth.currentUser?.uid;


    addTask() async {
      var time = DateTime.now();
      var hour = DateFormat("hh:mm: a").format(DateTime.now());

      String formattedDate = DateFormat.yMMMd().format(DateTime.now());
      var numberList = [for (var i = 1; i <= 20; i++) i];

      await FirebaseFirestore.instance
          .collection("Task")
          .doc(user)
          .collection("Todo")
          .doc(titleController.text)
          .set({
        'title': titleController.text,
        'time': time.toString(),
        'year': formattedDate.toString(),
        'hour': hour.toString(),
      });
    }

    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text('TODO LIST'),
        actions: [
          IconButton(
              onPressed: () async {
                await FirebaseAuth.instance.currentUser;
                await FirebaseAuth.instance.signOut();
                Navigator.push(
                    context, MaterialPageRoute(builder: (context) => LogIn()));
              },
              icon: Icon(Icons.logout))
        ],
      ),
      body: StreamBuilder(
          stream: FirebaseFirestore.instance
              .collection('Task/$user/Todo')
              .snapshots(),
          builder:
              (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
            if (!snapshot.hasData) {
              //connectionState == ConnectionState.waiting){
              return CircularProgressIndicator();
            }

            return GroupedListView<dynamic, String>(
              elements: snapshot.data!.docs,
              groupBy: (element) => element['year'],
              groupComparator: (value1, value2) => value2.compareTo(value1),
              itemComparator: (item1, item2) =>
                  item1['year'].compareTo(item2['title']),
              order: GroupedListOrder.DESC,
              useStickyGroupSeparators: true,
              groupSeparatorBuilder: (String value) => Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  value,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                      fontSize: 20, fontWeight: FontWeight.bold),
                ),
              ),
              itemBuilder: (c, element) {
                var time = DateTime.now();
                return InkWell(
                  onTap: () {
                    showModalBottomSheet(
                        context: context,
                        builder: (BuildContext context) {
                          return Container(
                            child: Column(
                              children: [
                                Padding(
                                  padding: const EdgeInsets.only(top: 20),
                                  child: Container(
                                    height: 50,
                                    width: 380,
                                    child: TextField(
                                      controller: titlController,
                                      decoration: InputDecoration(
                                          hintText: 'Title',
                                          label: Text(
                                            'Title',
                                            style:
                                                TextStyle(color: Colors.black),
                                          ),
                                          focusedBorder: OutlineInputBorder(
                                            borderSide:
                                                BorderSide(color: Colors.black),
                                            borderRadius:
                                                BorderRadius.circular(10),
                                          )),
                                    ),
                                  ),
                                ),
                                ElevatedButton(
                                    onPressed: () async {
                                      await FirebaseFirestore.instance
                                          .collection("Task")
                                          .doc(user)
                                          .collection("Todo")
                                          .doc(element['title'])
                                          .update({
                                        'title': titlController.text,
                                        'time': time.toString(),
                                        'year': formattedDate.toString(),
                                        'hour': hour.toString(),
                                      });
                                    },
                                    child: Text('Add')),
                              ],
                            ),
                          );
                        });
                  },
                  child: Card(
                    elevation: 8.0,
                    margin: const EdgeInsets.symmetric(
                        horizontal: 10.0, vertical: 6.0),
                    child: SizedBox(
                        child: ListTile(
                      contentPadding: const EdgeInsets.symmetric(
                          horizontal: 20.0, vertical: 10.0),
                      title: Text(
                        element['title'],
                        overflow: TextOverflow.ellipsis,
                        maxLines: 5,
                      ),
                      subtitle: Text(element['hour']),
                      trailing: IconButton(
                          onPressed: () async {
                            await FirebaseFirestore.instance
                                .collection('Task/$user/Todo')
                                .doc(element['title'])
                                .delete();
                          },
                          icon: Icon(Icons.delete)),
                    )),
                  ),
                );
              },
            );
          }),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          showModalBottomSheet(
              context: context,
              builder: (BuildContext context) {
                return Container(
                  child: Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(top: 20),
                        child: Container(
                          height: 50,
                          width: 380,
                          child: TextField(
                            controller: titleController,
                            decoration: InputDecoration(
                                hintText: 'Title',
                                label: Text(
                                  'Title',
                                  style: TextStyle(color: Colors.black),
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderSide: BorderSide(color: Colors.black),
                                  borderRadius: BorderRadius.circular(10),
                                )),
                          ),
                        ),
                      ),
                      ElevatedButton(
                          onPressed: () {
                            addTask();
                          },
                          child: Text('Add')),
                    ],
                  ),
                );
              });
        },
        child: Icon(Icons.add),
      ),
    );
  }
}
