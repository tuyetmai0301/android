import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:intl/intl.dart';
import '../models/note_model.dart';
import '../services/storage_service.dart';
import 'editor_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<Note> allNotes = [];
  List<Note> filteredNotes = [];
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _refreshData();
  }

  Future<void> _refreshData() async {
    final notes = await StorageService.loadNotes();
    setState(() {
      allNotes = notes..sort((a, b) => b.dateTime.compareTo(a.dateTime));
      filteredNotes = allNotes;
    });
  }

  void _filterNotes(String query) {
    setState(() {
      filteredNotes = allNotes
          .where((n) => n.title.toLowerCase().contains(query.toLowerCase()))
          .toList();
    });
  }

  Future<void> _deleteNote(Note note) async {
    bool? confirm = await showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text("Xóa ghi chú"),
        content: const Text("Bạn có chắc chắn muốn xóa ghi chú này không?"),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: const Text("Hủy"),
          ),
          TextButton(
            onPressed: () => Navigator.pop(ctx, true),
            child: const Text("Xóa", style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );

    if (confirm == true) {
      allNotes.removeWhere((n) => n.id == note.id);
      await StorageService.saveNotes(allNotes);
      _refreshData();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Smart Note - Triệu Thị Tuyết Mai - 2351160535",
        ), // THAY ĐỔI TẠI ĐÂY
        backgroundColor: Colors.blueAccent,
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(10),
            child: TextField(
              controller: _searchController,
              onChanged: _filterNotes,
              decoration: InputDecoration(
                hintText: "Tìm kiếm...",
                prefixIcon: const Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
              ),
            ),
          ),
          Expanded(
            child: filteredNotes.isEmpty
                ? const Center(
                    child: Text("Bạn chưa có ghi chú nào, hãy tạo mới nhé!"),
                  )
                : MasonryGridView.count(
                    padding: const EdgeInsets.all(8),
                    crossAxisCount: 2,
                    mainAxisSpacing: 8,
                    crossAxisSpacing: 8,
                    itemCount: filteredNotes.length,
                    itemBuilder: (context, index) {
                      final note = filteredNotes[index];
                      return Dismissible(
                        key: Key(note.id),
                        direction: DismissDirection.endToStart,
                        background: Container(
                          color: Colors.red,
                          alignment: Alignment.centerRight,
                          padding: const EdgeInsets.symmetric(horizontal: 20),
                          child: const Icon(Icons.delete, color: Colors.white),
                        ),
                        confirmDismiss: (_) async {
                          await _deleteNote(note);
                          return false; // Trả về false vì việc xóa đã được xử lý trong hàm _deleteNote
                        },
                        child: GestureDetector(
                          onTap: () async {
                            await Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) => EditorScreen(note: note),
                              ),
                            );
                            _refreshData();
                          },
                          child: Card(
                            child: Padding(
                              padding: const EdgeInsets.all(12),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    note.title,
                                    style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                    ),
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                  const SizedBox(height: 5),
                                  Text(
                                    note.content,
                                    maxLines: 3,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                  const SizedBox(height: 10),
                                  Text(
                                    DateFormat(
                                      'dd/MM/yyyy HH:mm',
                                    ).format(note.dateTime),
                                    style: const TextStyle(
                                      fontSize: 10,
                                      color: Colors.grey,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      );
                    },
                  ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          await Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => const EditorScreen()),
          );
          _refreshData();
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
