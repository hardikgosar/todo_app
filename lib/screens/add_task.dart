import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:fluttertoast/fluttertoast.dart';

class AddTask extends StatefulWidget {
  const AddTask({Key? key}) : super(key: key);

  @override
  State<AddTask> createState() => _AddTaskState();
}

class _AddTaskState extends State<AddTask> {
  TextEditingController titleController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();

  addtasktofirebase() async {
   
    FirebaseAuth auth = FirebaseAuth.instance;
    final user = auth.currentUser;

    var time = DateTime.now();
    FocusScope.of(context).unfocus();

    await FirebaseFirestore.instance
        .collection('tasks')
        .doc(user?.uid)
        .collection('mytasks')
        .doc(time.toString())
        .set({
          'title': titleController.text,
          'description': descriptionController.text,
          'time': time.toString(),
          'timestamp': time
        })
        .then((value) => print("User Added"))
        .catchError((error) => print("Failed to add user: $error"));
    
    Fluttertoast.showToast(msg: 'Data Added');
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('New Task'),
        backgroundColor: Theme.of(context).primaryColor,
      ),
      body: Container(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            Container(
              child: TextField(
                controller: titleController,
                decoration: const InputDecoration(
                    labelText: 'Enter Title', border: OutlineInputBorder()),
              ),
            ),
            const SizedBox(
              height: 10,
            ),
            Container(
              child: TextField(
                controller: descriptionController,
                decoration: const InputDecoration(
                    labelText: 'Enter Description',
                    border: OutlineInputBorder()),
              ),
            ),
            const SizedBox(
              height: 10,
            ),
            Container(
                width: double.infinity,
                height: 50,
                child: ElevatedButton(
                  style: ButtonStyle(backgroundColor:
                      MaterialStateProperty.resolveWith<Color>(
                          (Set<MaterialState> states) {
                    if (states.contains(MaterialState.pressed)) {
                      return Colors.purple.shade100;
                    }
                    return Theme.of(context).primaryColor;
                  })),
                  child: Text(
                    'Add Task',
                    style: GoogleFonts.roboto(fontSize: 18),
                  ),
                  onPressed: addtasktofirebase,
                ))
          ],
        ),
      ),
    );
  }
}
