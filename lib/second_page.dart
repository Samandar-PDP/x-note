import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:intl/intl.dart';
import 'package:note_app/constants.dart';
import 'package:note_app/home_page.dart';
import 'package:note_app/note.dart';
import 'package:note_app/note_database.dart';

class SecondPage extends StatefulWidget {
  const SecondPage({super.key});

  @override
  State<SecondPage> createState() => _SecondPageState();
}

class _SecondPageState extends State<SecondPage> {
  int _selectedIndex = 0;
  final _title = TextEditingController();
  final _desc = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        //  extendBodyBehindAppBar: true,
        backgroundColor: Constants.colorList[_selectedIndex],
        appBar: AppBar(
          elevation: 0,
          backgroundColor: Colors.transparent,
          title: const Text("New Note"),
          actions: [
            AnimatedOpacity(
              opacity: _desc.text.isNotEmpty ? 1 : 0,
              duration: const Duration(milliseconds: 500),
              child: IconButton(
                  onPressed: _desc.text.isNotEmpty ? _save : null,
                  icon: const Icon(
                    CupertinoIcons.check_mark,
                    color: Colors.white,
                  )),
            )
          ],
        ),
        body: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Column(
            children: [
              TextField(
                controller: _title,
                maxLines: null,
                style: const TextStyle(
                    fontSize: 18,
                    color: Colors.white,
                    fontWeight: FontWeight.bold),
                decoration: const InputDecoration(
                  border: InputBorder.none,
                  hintText: "Title",
                  hintStyle:
                      TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
              ),
              Expanded(
                child: TextField(
                  onChanged: (v) => setState(() {}),
                  controller: _desc,
                  maxLines: null,
                  style: const TextStyle(color: Colors.white),
                  decoration: const InputDecoration(
                      border: InputBorder.none, hintText: "Description"),
                ),
              )
            ],
          ),
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: _showColorPicker,
          backgroundColor: const Color(0xFFefe6dd),
          child: const Icon(
            Icons.palette_outlined,
            color: Colors.black,
          ),
        ));
  }

  void _save() {
    String title = _title.text; // ""
    if(_title.text.isEmpty) {
      final indexOfSpace = _desc.text.indexOf(" "); // 2
      final word = _desc.text.substring(0, indexOfSpace); // My name is Teshavoy // 0, 2
      title = word;
    }
    final formatter = DateFormat("dd/MM/yyyy");
    NoteDatabase.saveNote(Note(
        id: null,
        title: title,
        desc: _desc.text,
        time: formatter.format(DateTime.now()),
        colorId: _selectedIndex)).then((value) {
          Navigator.of(context)
              .pushAndRemoveUntil(CupertinoPageRoute(builder: (context) => const HomePage()), (route) => false);
    });
  }

  _showColorPicker() {
    showModalBottomSheet(
        context: context,
        builder: (context) => SizedBox(
              height: 150,
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Center(
                  child: SizedBox(
                    height: 40,
                    child: ListView.separated(
                      separatorBuilder: (context, index) => const SizedBox(
                        width: 12,
                      ),
                      scrollDirection: Axis.horizontal,
                      itemCount: Constants.colorList.length,
                      itemBuilder: (context, index) {
                        return _dot(() {
                          Navigator.of(context).pop();
                          setState(() {
                            _selectedIndex = index;
                          });
                        }, Constants.colorList[index], index);
                      },
                    ),
                  ),
                ),
              ),
            ));
  }

  _dot(VoidCallback onClick, Color color, int index) {
    return SizedBox(
      height: 40,
      width: 40,
      child: InkWell(
        onTap: onClick,
        borderRadius: BorderRadius.circular(50),
        child: Ink(
          width: 40,
          height: 40,
          decoration: BoxDecoration(
              color: color,
              borderRadius: BorderRadius.circular(50),
              border: Border.all(
                  width: 2,
                  color: _selectedIndex == index
                      ? Colors.white
                      : Colors.transparent)),
        ),
      ),
    );
  }
}
