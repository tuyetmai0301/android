import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/note_model.dart';

class StorageService {
  static const String _key = 'smart_notes';

  // Lưu toàn bộ danh sách
  static Future<void> saveNotes(List<Note> notes) async {
    final prefs = await SharedPreferences.getInstance();
    List<String> jsonList = notes.map((n) => jsonEncode(n.toMap())).toList();
    await prefs.setStringList(_key, jsonList);
  }

  // Tải danh sách từ bộ nhớ
  static Future<List<Note>> loadNotes() async {
    final prefs = await SharedPreferences.getInstance();
    List<String>? jsonList = prefs.getStringList(_key);
    if (jsonList == null) return [];
    return jsonList.map((item) => Note.fromMap(jsonDecode(item))).toList();
  }
}
