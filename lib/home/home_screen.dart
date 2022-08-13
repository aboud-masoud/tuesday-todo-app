import 'package:flutter/material.dart';
import 'package:tuesday_todo_app/home/home_bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class HomeScreen extends StatelessWidget {
  HomeScreen({super.key});

  final bloc = HomeBloc();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("TODO"),
        actions: [
          IconButton(
            onPressed: () async {
              await showAddEditItem(context: context);
            },
            icon: const Icon(Icons.add),
          )
        ],
      ),
      body: StreamBuilder(
          stream: bloc.todo.snapshots(),
          builder: (context, AsyncSnapshot<QuerySnapshot> streamSnapshot) {
            if (streamSnapshot.hasData) {
              return ListView.builder(
                  itemCount: streamSnapshot.data!.docs.length,
                  itemBuilder: (ctx, index) {
                    final DocumentSnapshot documentSnapshot =
                        streamSnapshot.data!.docs[index];
                    return ListTile(
                      title: Text(
                          streamSnapshot.data!.docs[index]["title"].toString()),
                      subtitle: Text(
                          streamSnapshot.data!.docs[index]["desc"].toString()),
                      trailing: SizedBox(
                        width: 100,
                        child: Row(
                          children: [
                            IconButton(
                                icon: const Icon(Icons.edit),
                                onPressed: () async {
                                  await showAddEditItem(
                                      context: context,
                                      action: "update",
                                      documentID: documentSnapshot.id);
                                }),
                            IconButton(
                                icon: const Icon(Icons.delete),
                                onPressed: () {
                                  bloc.deleteItemFromFireStore(
                                      documentSnapshot.id);
                                }),
                          ],
                        ),
                      ),
                    );
                  });
            } else {
              return const Center(
                child: CircularProgressIndicator(),
              );
            }
          }),
    );
  }

  Future showAddEditItem(
      {required BuildContext context,
      String action = "create",
      String? documentID}) async {
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
                  keyboardType:
                      const TextInputType.numberWithOptions(decimal: true),
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
                        bloc.updateItemOnFireStore(
                            documentID: documentID!, title: title, desc: desc);
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
}
