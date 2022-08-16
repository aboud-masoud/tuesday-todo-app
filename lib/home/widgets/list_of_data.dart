import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:tuesday_todo_app/home/home_bloc.dart';
import 'package:tuesday_todo_app/home/widgets/showAddEditItem.dart';

enum NoteType { inProgress, done }

class ListOfData extends StatelessWidget {
  final HomeBloc bloc;
  final NoteType noteType;
  const ListOfData({required this.bloc, required this.noteType, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
        stream: bloc.todo.snapshots(),
        builder: (context, AsyncSnapshot<QuerySnapshot> streamSnapshot) {
          if (streamSnapshot.hasData) {
            List dataList = [];

            for (var item in streamSnapshot.data!.docs) {
              if (item["note status"] == "inprogress" && noteType == NoteType.inProgress) {
                dataList.add(item);
              } else if (item["note status"] != "inprogress" && noteType == NoteType.done) {
                dataList.add(item);
              }
            }

            return ListView.builder(
                itemCount: dataList.length,
                itemBuilder: (ctx, index) {
                  final DocumentSnapshot documentSnapshot = dataList[index];
                  return ListTile(
                    title: Text(dataList[index]["title"].toString()),
                    subtitle: Text(dataList[index]["desc"].toString()),
                    trailing: noteType == NoteType.inProgress
                        ? SizedBox(
                            width: 150,
                            child: Row(
                              children: [
                                IconButton(
                                    icon: const Icon(Icons.edit),
                                    onPressed: () async {
                                      await showAddEditItem(
                                          context: context,
                                          bloc: bloc,
                                          action: "update",
                                          documentID: documentSnapshot.id,
                                          snapshot: dataList[index]);
                                    }),
                                IconButton(
                                    icon: const Icon(Icons.delete),
                                    onPressed: () {
                                      bloc.deleteItemFromFireStore(documentSnapshot.id);
                                    }),
                                IconButton(
                                    icon: const Icon(Icons.arrow_circle_right),
                                    onPressed: () async {
                                      bloc.changeNoteStatusToDone(
                                        documentID: documentSnapshot.id,
                                        title: dataList[index]["title"].toString(),
                                        desc: dataList[index]["desc"].toString(),
                                      );
                                    }),
                              ],
                            ),
                          )
                        : SizedBox(
                            width: 100,
                            child: Row(
                              children: [
                                IconButton(
                                    icon: const Icon(Icons.reset_tv_rounded),
                                    onPressed: () async {
                                      //TODO

                                      bloc.changeNoteStatusToInProgress(
                                        documentID: documentSnapshot.id,
                                        title: dataList[index]["title"].toString(),
                                        desc: dataList[index]["desc"].toString(),
                                      );
                                    }),
                                IconButton(
                                    icon: const Icon(Icons.delete),
                                    onPressed: () {
                                      bloc.deleteItemFromFireStore(documentSnapshot.id);
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
        });
  }
}
