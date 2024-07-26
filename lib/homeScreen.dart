import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:hive_practice/boxes/boxes.dart';
import 'package:hive_practice/models/notes_model.dart';

class HomeScreen extends StatelessWidget {
  HomeScreen({super.key});

  TextEditingController titleController = TextEditingController();
  TextEditingController discriptionController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.orange,
        onPressed: () async {
          _showMyDialog(context);
        },
        child: const Icon(
          Icons.add,
          color: Colors.black,
        ),
      ),
      appBar: AppBar(
        backgroundColor: Colors.black,
        centerTitle: true,
        title: const Text(
          "Local Storage(Hive)",
          style: TextStyle(
              color: Colors.orange, fontSize: 28, fontWeight: FontWeight.bold),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 20),
        child: ValueListenableBuilder<Box<NotesModel>>(
          valueListenable: Boxes.getData().listenable(),
          builder: (context, value, child) {
            var data = value.values.toList().cast<NotesModel>();
            return ListView.builder(
              itemCount: value.length,
              itemBuilder: (context, index) {
                return Card(
                  color: Colors.orange,
                  child: ListTile(
                    trailing: SizedBox(
                      width: 68,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 10),
                            child: InkWell(
                                onTap: () {
                                  delete(data[index]);
                                },
                                child: const Icon(
                                  Icons.delete,
                                  color: Colors.black,
                                )),
                          ),
                          InkWell(
                              onTap: () {
                                _update(
                                    context,
                                    data[index],
                                    data[index].title.toString(),
                                    data[index].discreption.toString());
                              },
                              child: const InkWell(
                                  child: Icon(
                                Icons.edit,
                                color: Colors.white,
                              )))
                        ],
                      ),
                    ),
                    title: Text(
                      data[index].title.toString(),
                      style: const TextStyle(
                          fontWeight: FontWeight.w500, color: Colors.black),
                    ),
                    subtitle: Padding(
                      padding:
                          EdgeInsets.symmetric(vertical: 5, horizontal: 10),
                      child: Text(
                        data[index].discreption.toString(),
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                  ),
                );
              },
            );
          },
        ),
      ),
    );
  }

  void delete(NotesModel model) {
    model.delete();
  }

  Future<void> _update(BuildContext context, NotesModel model, String title,
      String description) async {
    titleController.text = title;
    discriptionController.text = description;
    return showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text("Edit Task"),
          content: SingleChildScrollView(
            child: Column(
              children: [
                TextFormField(
                  controller: titleController,
                  decoration: InputDecoration(
                      hintText: "Enter Title",
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10))),
                ),
                const SizedBox(
                  height: 20,
                ),
                TextFormField(
                  controller: discriptionController,
                  decoration: InputDecoration(
                      hintText: "Enter Discription",
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10))),
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: const Text("Cancel")),
            TextButton(
                onPressed: () async {
                  model.title = titleController.text.toString();
                  model.discreption = discriptionController.text.toString();
                  await model.save();
                  titleController.clear();
                  discriptionController.clear();
                  Navigator.pop(context);
                },
                child: const Text("Add")),
          ],
        );
      },
    );
  }

  Future<void> _showMyDialog(BuildContext context) async {
    return showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text("Add Task"),
          content: SingleChildScrollView(
            child: Column(
              children: [
                TextFormField(
                  controller: titleController,
                  decoration: InputDecoration(
                      hintText: "Enter Title",
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10))),
                ),
                const SizedBox(
                  height: 20,
                ),
                TextFormField(
                  controller: discriptionController,
                  decoration: InputDecoration(
                      hintText: "Enter Discription",
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10))),
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: const Text("Cancel")),
            TextButton(
                onPressed: () {
                  final data = NotesModel(
                      title: titleController.text,
                      discreption: discriptionController.text);
                  final box = Boxes.getData();
                  box.add(data);
                  data.save();
                  titleController.clear();
                  discriptionController.clear();
                  Navigator.pop(context);
                },
                child: const Text("Add")),
          ],
        );
      },
    );
  }
}
