import 'package:flutter/material.dart';
import '../models/note_model.dart';
import '../services/storage_service.dart';

class EditorScreen extends StatefulWidget {
  final Note? note;
  const EditorScreen({super.key, this.note});

  @override
  State<EditorScreen> createState() => _EditorScreenState();
}

class _EditorScreenState extends State<EditorScreen> {
  late TextEditingController _titleController;
  late TextEditingController _contentController;

  @override
  void initState() {
    super.initState();
    _titleController = TextEditingController(text: widget.note?.title ?? "");
    _contentController = TextEditingController(
      text: widget.note?.content ?? "",
    );
  }

  Future<void> _handleAutoSave() async {
    String title = _titleController.text.trim();
    String content = _contentController.text.trim();

    if (title.isEmpty && content.isEmpty) return;

    List<Note> notes = await StorageService.loadNotes();

    if (widget.note == null) {
      // Tạo mới
      notes.add(
        Note(
          id: DateTime.now().millisecondsSinceEpoch.toString(),
          title: title,
          content: content,
          dateTime: DateTime.now(),
        ),
      );
    } else {
      // Cập nhật
      int idx = notes.indexWhere((n) => n.id == widget.note!.id);
      if (idx != -1) {
        notes[idx] = Note(
          id: widget.note!.id,
          title: title,
          content: content,
          dateTime: DateTime.now(),
        );
      }
    }
    await StorageService.saveNotes(notes);
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      onPopInvoked: (didPop) async {
        if (didPop) await _handleAutoSave();
      },
      child: Scaffold(
        appBar: AppBar(title: const Text("Soạn thảo")),
        body: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              TextField(
                controller: _titleController,
                style: const TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                ),
                decoration: const InputDecoration(
                  hintText: "Tiêu đề",
                  border: InputBorder.none,
                ),
              ),
              const Divider(),
              Expanded(
                child: TextField(
                  controller: _contentController,
                  maxLines: null,
                  decoration: const InputDecoration(
                    hintText: "Bắt đầu viết...",
                    border: InputBorder.none,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
