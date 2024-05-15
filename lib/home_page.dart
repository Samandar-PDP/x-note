import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:note_app/note.dart';
import 'package:note_app/note_database.dart';
import 'package:note_app/note_item.dart';
import 'package:note_app/second_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {

  final _controller = TextEditingController();
  final List<Note> _cachedList = []; // 2 chi idish
  final List<Note> _noteList = []; // 1 chi idish
  bool _isFirstTime = true;

  _search(String value) {
    if(value.isEmpty) {
      _noteList.clear();
      _noteList.addAll(_cachedList);
    } else {
      final filteredList = _cachedList.where((element) => element.title.toLowerCase().contains(value.toLowerCase()) ||
      element.desc.toLowerCase().contains(value.toLowerCase()));
      _noteList.clear();
      _noteList.addAll(filteredList);
    }
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("X Note"),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(55),
          child: Padding(
            padding: const EdgeInsets.all(12.0),
            child: SearchBar(
              controller: _controller,
              onChanged: (value) => _search(value),
              backgroundColor: MaterialStateProperty.all(const Color(0xFFefe6dd)),
              hintText: "Search",
              hintStyle: MaterialStateProperty.all(
                  const TextStyle(
                      color: Colors.black
                  )
              ),
              textStyle: MaterialStateProperty.all(const TextStyle(
                  color: Colors.black,
                fontWeight: FontWeight.bold
              )),
              elevation: MaterialStateProperty.all(2),
            ),
          ),
        ),
        actions: [
          IconButton(
              onPressed: () {}, // delete all notes
              icon: const Icon(CupertinoIcons.delete, color: Colors.red))
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 15),
        child: FutureBuilder(
          future: NoteDatabase.getAllNotes(), //
          builder: (context, snapshot) {
            if(snapshot.data != null && snapshot.data?.isNotEmpty == true) {
              if(_isFirstTime) {
                _cachedList.clear();
                _cachedList.addAll(snapshot.data ?? []);
                _noteList.clear();
                _noteList.addAll(snapshot.data ?? []);
                _isFirstTime = false;
              }
              return GridView.builder(
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    mainAxisSpacing: 12, crossAxisSpacing: 12, crossAxisCount: 2),
                itemCount: _noteList.length,
                itemBuilder: (context, index) {
                  return NoteItem(note: _noteList[index], onClick: () => _showDeleteDialog(_noteList[index].id));
                },
              );
            }  else if(snapshot.data?.isEmpty == true) {
              return const Center(child: Text("No data."));
            }
            else {
              return const Center(child: CircularProgressIndicator());
            }
          },
        ),
      ),
      floatingActionButton: FloatingActionButton(onPressed: () {
        Navigator.of(context).push(
          CupertinoPageRoute(builder: (context) => const SecondPage())
        );
      },
      backgroundColor: const Color(0xFFefe6dd),
        child: const Icon(CupertinoIcons.add,color: Colors.black,),
      ),
    );
  }
  void _showDeleteDialog(int? id) async {
    showAdaptiveDialog(context: context, builder: (context) => CupertinoAlertDialog(
      title: const Text("Delete?"),
      actions: [
        CupertinoDialogAction(child: const Text("No"),onPressed: () {
          Navigator.of(context).pop();
        },),
        CupertinoDialogAction(isDestructiveAction: true,onPressed: () {
          Navigator.of(context).pop();
          NoteDatabase.deleteNote(id).then((value) {
            setState(() {});
          });
        } ,child: const Text("Yes")),
      ],
    ));
  }
}
