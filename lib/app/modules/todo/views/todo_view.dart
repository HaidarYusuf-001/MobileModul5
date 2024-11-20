import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

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
          onPressed: () => Navigator.pop(context),
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
            _buildWidgetListTodo(context),
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

  Widget _buildWidgetListTodo(BuildContext context) {
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

              return ListView.builder(
                padding: EdgeInsets.symmetric(horizontal: 16.0),
                itemCount: snapshot.data!.docs.length,
                itemBuilder: (context, index) {
                  DocumentSnapshot document = snapshot.data!.docs[index];
                  Map<String, dynamic> task =
                  document.data() as Map<String, dynamic>;
                  String strDate = task['date'];

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
                        task['name'],
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
                            task['description'],
                            style: TextStyle(
                              color: appColor.backgroundColor.withOpacity(0.7),
                            ),
                            maxLines: 3,
                            overflow: TextOverflow.ellipsis,
                          ),
                          // SizedBox(height: 3),
                          // Garis pemisah antara deskripsi dan tanggal
                          Divider(
                            color: appColor.backgroundColor
                                .withOpacity(0.5), // Warna garis
                            thickness: 1, // Ketebalan garis
                          ),
                          // SizedBox(height: 3),
                          Row(
                            children: [
                              Icon(
                                Icons.calendar_today,
                                size: 14,
                                color: appColor.backgroundColor,
                              ),
                              SizedBox(width: 4),
                              Text(
                                strDate,
                                style: TextStyle(
                                  color: appColor.backgroundColor,
                                  fontSize: 12,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                      trailing: PopupMenuButton(
                        icon: Icon(
                          Icons.more_vert,
                          color: appColor.backgroundColor.withOpacity(0.5),
                        ),
                        itemBuilder: (context) => [
                          PopupMenuItem(
                            value: 'edit',
                            child: Row(
                              children: [
                                Icon(Icons.edit, size: 20),
                                SizedBox(width: 8),
                                Text('Edit'),
                              ],
                            ),
                          ),
                          PopupMenuItem(
                            value: 'delete',
                            child: Row(
                              children: [
                                Icon(Icons.delete,
                                    size: 20, color: appColor.textColor),
                                SizedBox(width: 8),
                                Text('Delete',
                                    style:
                                    TextStyle(color: appColor.textColor)),
                              ],
                            ),
                          ),
                        ],
                        onSelected: (value) => _handleMenuSelection(
                            value, document, task, context),
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