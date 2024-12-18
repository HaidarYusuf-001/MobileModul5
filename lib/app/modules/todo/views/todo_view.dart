import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'app_color.dart';
import 'create_task_screen.dart';
import 'widget_background.dart';

class TodoView extends StatefulWidget {
  @override
  _TodoScreenState createState() => _TodoScreenState();
}

class _TodoScreenState extends State<TodoView> {
  final GlobalKey<ScaffoldState> scaffoldState = GlobalKey<ScaffoldState>();
  final FirebaseFirestore firestore = FirebaseFirestore.instance;
  final AppColor appColor = AppColor();
  List<Map<String, String>> offlineTasks = [];

  @override
  void initState() {
    super.initState();
    _loadSavedTasks();
  }

  // Memuat tugas yang disimpan secara offline
  Future<void> _loadSavedTasks() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? name = prefs.getString('task_name');
    String? description = prefs.getString('task_description');
    String? dueDate = prefs.getString('task_dueDate');

    if (name != null && description != null && dueDate != null) {
      setState(() {
        offlineTasks.add({
          'name': name,
          'description': description,
          'date': dueDate,
        });
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: scaffoldState,
      backgroundColor: appColor.backgroundColor,
      appBar: AppBar(
        backgroundColor: appColor.textColor,
        toolbarHeight: 70,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: appColor.backgroundColor),
          onPressed: () => Get.offNamed('/home'),
        ),
        title: Text(
          'Todo app',
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: appColor.backgroundColor,
          ),
        ),
      ),
      body: SafeArea(
        child: Stack(
          children: [
            WidgetBackground(),
            _buildWidgetListTodo(),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        icon: Icon(Icons.add_task, color: Colors.white),
        label: Text('Add Task', style: TextStyle(color: Colors.white)),
        onPressed: () => _navigateToCreateTask(context),
        backgroundColor: appColor.colorTertiary,
        elevation: 2,
      ),
    );
  }

  // Membangun widget untuk menampilkan daftar tugas
  Widget _buildWidgetListTodo() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Manage your daily tasks\nJangan malas!',
                style: TextStyle(
                  fontSize: 20,
                  color: appColor.backgroundColor,
                ),
              ),
            ],
          ),
        ),
        Expanded(
          child: StreamBuilder<QuerySnapshot>(
            stream: firestore.collection('todo').orderBy('date').snapshots(),
            builder: (context, snapshot) {
              if (!snapshot.hasData) {
                return Center(
                  child: CircularProgressIndicator(
                    valueColor:
                    AlwaysStoppedAnimation<Color>(appColor.colorTertiary),
                  ),
                );
              }

              List<Map<String, String>> tasks = [];
              snapshot.data!.docs.forEach((document) {
                Map<String, dynamic> task = document.data() as Map<String, dynamic>;
                tasks.add({
                  'name': task['name'],
                  'description': task['description'],
                  'date': task['date'],
                });
              });

              // Gabungkan tugas online dan offline
              tasks.addAll(offlineTasks);

              return ListView.builder(
                padding: EdgeInsets.symmetric(horizontal: 16.0),
                itemCount: tasks.length,
                itemBuilder: (context, index) {
                  Map<String, String> task = tasks[index];
                  return Card(
                    color: appColor.textColor.withOpacity(0.8),
                    elevation: 0,
                    margin:
                    EdgeInsets.symmetric(vertical: 1.0, horizontal: 4.0),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                      side: BorderSide(
                        color: appColor.colorTertiary.withOpacity(0.2),
                        width: 1,
                      ),
                    ),
                    child: ListTile(
                      contentPadding: EdgeInsets.only(
                          left: 16, right: 16, top: 8, bottom: 8),
                      title: Text(
                        task['name']!,
                        style: TextStyle(
                          fontWeight: FontWeight.w600,
                          fontSize: 18,
                          color: appColor.backgroundColor,
                        ),
                      ),
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SizedBox(height: 8),
                          Text(
                            task['description']!,
                            style: TextStyle(
                              color: appColor.backgroundColor.withOpacity(0.7),
                            ),
                            maxLines: 3,
                            overflow: TextOverflow.ellipsis,
                          ),
                          Divider(
                            color: appColor.backgroundColor
                                .withOpacity(0.5),
                            thickness: 1,
                          ),
                          Row(
                            children: [
                              Icon(
                                Icons.calendar_today,
                                size: 14,
                                color: appColor.backgroundColor,
                              ),
                              SizedBox(width: 4),
                              Text(
                                task['date']!,
                                style: TextStyle(
                                  color: appColor.backgroundColor,
                                  fontSize: 12,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                      trailing: PopupMenuButton<String>(
                        icon: Icon(Icons.more_vert, color: appColor.backgroundColor),
                        onSelected: (String value) {
                          _handleMenuSelection(value, snapshot.data!.docs[index], task, context);
                        },
                        itemBuilder: (BuildContext context) {
                          return [
                            PopupMenuItem<String>(
                              value: 'edit',
                              child: Text('Edit'),
                            ),
                            PopupMenuItem<String>(
                              value: 'delete',
                              child: Text('Delete'),
                            ),
                          ];
                        },
                      ),
                    ),
                  );
                },
              );
            },
          ),
        ),
      ],
    );
  }

  // Menavigasi ke halaman pembuatan tugas
  Future<void> _navigateToCreateTask(BuildContext context) async {
    bool? result = await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => CreateTaskScreen(isEdit: false)),
    );
    if (result == true && mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Task has been created'),
          behavior: SnackBarBehavior.floating,
          backgroundColor: appColor.colorTertiary,
        ),
      );
      setState(() {});
    }
  }

  // Menangani pemilihan menu (edit atau delete)
  void _handleMenuSelection(String value, DocumentSnapshot document,
      Map<String, dynamic> task, BuildContext context) async {
    if (value == 'edit') {
      bool? result = await Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => CreateTaskScreen(
            isEdit: true,
            documentId: document.id,
            name: task['name'],
            description: task['description'],
            date: task['date'],
          ),
        ),
      );
      if (result == true && mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Task has been updated'),
            behavior: SnackBarBehavior.floating,
            backgroundColor: appColor.colorTertiary,
          ),
        );
        setState(() {});
      }
    } else if (value == 'delete') {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Delete Task'),
            content: Text('Are you sure you want to delete "${task['name']}"?'),
            actions: [
              TextButton(
                child: Text('Cancel'),
                onPressed: () => Navigator.pop(context),
              ),
              TextButton(
                child: Text('Delete', style: TextStyle(color: Colors.red)),
                onPressed: () {
                  document.reference.delete();
                  Navigator.pop(context);
                  if (mounted) setState(() {});
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('Task has been deleted'),
                      behavior: SnackBarBehavior.floating,
                      backgroundColor: Colors.red,
                    ),
                  );
                },
              ),
            ],
          );
        },
      );
    }
  }
}
