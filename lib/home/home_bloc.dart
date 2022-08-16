import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/widgets.dart';
// import 'package:tuesday_todo_app/models/item.dart';

class HomeBloc {
  // List<Item> itemsList = [
  //   Item(title: "ahmad", desc: "Success"),
  //   Item(title: "ali", desc: "Success"),
  //   Item(title: "layla", desc: "Failed"),
  //   Item(title: "anas", desc: "Success"),
  //   Item(title: "mahmoud", desc: "Failed")
  // ];

  final CollectionReference todo = FirebaseFirestore.instance.collection('todo');

  TextEditingController titleController = TextEditingController();
  TextEditingController descController = TextEditingController();

  deleteItemFromFireStore(String documentID) async {
    await todo.doc(documentID).delete();
  }

  addItemToFireStore({required String title, required String desc}) async {
    await todo.add({"title": title, "desc": desc, "note status": "inprogress", "date": DateTime.now().toString()});
  }

  updateItemOnFireStore({required String documentID, required String title, required String desc}) async {
    await todo
        .doc(documentID)
        .update({"title": title, "desc": desc, "note status": "inprogress", "date": DateTime.now().toString()});
  }

  changeNoteStatusToDone({required String documentID, required String title, required String desc}) async {
    await todo.doc(documentID).update({"title": title, "desc": desc, "note status": "done", "date": DateTime.now().toString()});
  }

  changeNoteStatusToInProgress({required String documentID, required String title, required String desc}) async {
    await todo
        .doc(documentID)
        .update({"title": title, "desc": desc, "note status": "inprogress", "date": DateTime.now().toString()});
  }
}
