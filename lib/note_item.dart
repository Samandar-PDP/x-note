import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:note_app/constants.dart';
import 'package:note_app/note.dart';

class NoteItem extends StatelessWidget {
  const NoteItem({super.key, required this.note, required this.onClick});
  final Note note;
  final VoidCallback onClick;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onLongPress: onClick,
      borderRadius: BorderRadius.circular(12),
      child: Ink(
        decoration: BoxDecoration(
          color: Constants.colorList[note.colorId].withOpacity(.8),
          borderRadius: BorderRadius.circular(12)
        ),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(note.title, style: const TextStyle(
                fontSize: 20,
                color: Colors.white,
                fontWeight: FontWeight.bold
              )),
              Text(note.desc),
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const Icon(CupertinoIcons.calendar,size: 18,),
                  const SizedBox(width: 7),
                  Text(note.time,style: TextStyle(
                    fontSize: 13
                  ),)
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
