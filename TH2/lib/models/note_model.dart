class Note {
  String id;
  String title;
  String content;
  DateTime dateTime;

  Note({
    required this.id,
    required this.title,
    required this.content,
    required this.dateTime,
  });

  // Chuyển sang Map để lưu JSON
  Map<String, dynamic> toMap() => {
    'id': id,
    'title': title,
    'content': content,
    'dateTime': dateTime.toIso8601String(),
  };

  // Chuyển từ Map sang Object
  factory Note.fromMap(Map<String, dynamic> map) => Note(
    id: map['id'],
    title: map['title'],
    content: map['content'],
    dateTime: DateTime.parse(map['dateTime']),
  );
}
