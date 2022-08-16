import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:tuesday_todo_app/home/home_bloc.dart';

Future showAddEditItem(
    {required BuildContext context,
    required HomeBloc bloc,
    String action = "create",
    String? documentID,
    QueryDocumentSnapshot? snapshot}) async {
  if (action != "create") {
    bloc.titleController.text = snapshot!["title"].toString();
    bloc.descController.text = snapshot["desc"].toString();
  }

  await showModalBottomSheet(
      isScrollControlled: true,
      context: context,
      builder: (BuildContext ctx) {
        return Padding(
          padding: EdgeInsets.only(
              top: 20,
              left: 20,
              right: 20,
              // prevent the soft keyboard from covering text fields
              bottom: MediaQuery.of(ctx).viewInsets.bottom + 20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TextField(
                controller: bloc.titleController,
                decoration: const InputDecoration(labelText: 'Title'),
              ),
              TextField(
                keyboardType: const TextInputType.numberWithOptions(decimal: true),
                controller: bloc.descController,
                decoration: const InputDecoration(
                  labelText: 'Desc',
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              ElevatedButton(
                child: Text(action == 'create' ? 'Create' : 'Update'),
                onPressed: () async {
                  final String title = bloc.titleController.text;
                  final String desc = bloc.descController.text;
                  if (title != "" && desc != "") {
                    if (action == 'create') {
                      bloc.addItemToFireStore(title: title, desc: desc);
                    }

                    if (action == 'update') {
                      bloc.updateItemOnFireStore(documentID: documentID!, title: title, desc: desc);
                    }

                    // // Clear the text fields
                    bloc.titleController.text = '';
                    bloc.descController.text = '';

                    // Hide the bottom sheet
                    Navigator.of(context).pop();
                  }
                },
              )
            ],
          ),
        );
      });
}
