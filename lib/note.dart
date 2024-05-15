class Note {
  int? id; // primary key, const identification
  String title;
  String desc;
  String time;
  int colorId;

  Note({
    required this.id,
    required this.title,
    required this.desc,
    required this.time,
    required this.colorId
});
  Note.fromJson(Map<String, dynamic> json) :
      id = json['id'],
      title = json['title'],
      desc = json['desc'],
      time = json['time'],
      colorId = json['color_id'];

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'desc': desc,
      'time': time,
      'color_id': colorId
    };
  }
}
