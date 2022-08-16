import 'package:flutter/material.dart';
import 'package:tuesday_todo_app/home/home_bloc.dart';
import 'package:tuesday_todo_app/home/widgets/list_of_data.dart';
import 'package:tuesday_todo_app/home/widgets/showAddEditItem.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final bloc = HomeBloc();

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: const Text("TODO"),
          actions: [
            IconButton(
              onPressed: () async {
                await showAddEditItem(context: context, bloc: bloc);
              },
              icon: const Icon(Icons.add),
            )
          ],
          bottom: const TabBar(tabs: [
            Tab(
              icon: Icon(Icons.home_filled),
              text: "In Progress",
            ),
            Tab(
              icon: Icon(Icons.account_box_outlined),
              text: "Done",
            ),
          ]),
        ),
        body: TabBarView(
          children: [
            ListOfData(bloc: bloc, noteType: NoteType.inProgress),
            ListOfData(bloc: bloc, noteType: NoteType.done),
          ],
        ),
      ),
    );
  }
}
