import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:learnhub/app/modules/utils/internet_connection_utils.dart';
import 'package:learnhub/app/modules/utils/popups/snackbars.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'dart:async';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart'; // Local storage for offline data
import 'app_color.dart';
import 'widget_background.dart';

class CreateTaskScreen extends StatefulWidget {
  final bool isEdit;
  final String documentId, name, description, date;
  CreateTaskScreen(
      {required this.isEdit,
        this.documentId = '',
        this.name = '',
        this.description = '',
        this.date = ''});

  @override
  _CreateTaskScreenState createState() => _CreateTaskScreenState();
}

class _CreateTaskScreenState extends State<CreateTaskScreen> {
  final scaffoldState = GlobalKey<ScaffoldState>();
  final firestore = FirebaseFirestore.instance;
  final appColor = AppColor();
  final controllerName = TextEditingController();
  final controllerDescription = TextEditingController();
  final controllerDate = TextEditingController();

  DateTime date = DateTime.now().add(Duration(days: 1));
  bool isLoading = false;

  late Connectivity _connectivity;
  late StreamSubscription<ConnectivityResult> _connectivitySubscription;

  @override
  void initState() {
    super.initState();
    if (widget.isEdit) {
      date = DateFormat('dd MMMM yyyy').parse(widget.date);
      controllerName.text = widget.name;
      controllerDescription.text = widget.description;
      controllerDate.text = widget.date;
    } else {
      controllerDate.text = DateFormat('dd MMMM yyyy').format(date);
    }

    _connectivity = Connectivity();
    _connectivity.onConnectivityChanged.listen((List<ConnectivityResult> result) {
      _handleConnectivityChange(result);
    });
  }

  Future<void> _handleConnectivityChange(List<ConnectivityResult> result) async  {
    if (_isUploading) return;
    if (result != ConnectivityResult.none) {
      await _uploadLocalDataToFirestore();
    }
  }

  bool _isUploading = false; // Tambahkan flag global

  Future<void> _uploadLocalDataToFirestore() async {
    if (_isUploading) return; // Cegah pengiriman data jika sudah berjalan
    _isUploading = true;

    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? name = prefs.getString('task_name');
    String? description = prefs.getString('task_description');
    String? dueDate = prefs.getString('task_dueDate');

    if (name != null && description != null && dueDate != null) {
      try {
        await firestore.collection('todo').add({
          'name': name,
          'description': description,
          'date': dueDate,
        });

        // Hapus data lokal setelah berhasil diunggah
        await prefs.remove('task_name');
        await prefs.remove('task_description');
        await prefs.remove('task_dueDate');

        TSnackbar.successSnackBar(
          title: 'Data Synced',
          message: 'Offline data has been synced successfully.',
        );
      } catch (e) {
        TSnackbar.errorSnackBar(
          title: 'Sync Error',
          message: 'Failed to sync offline data. Please try again.',
        );
      }
    }

    _isUploading = false; // Reset flag setelah proses selesai
  }


  @override
  void dispose() {
    _connectivitySubscription.cancel();
    controllerName.dispose();
    controllerDescription.dispose();
    controllerDate.dispose();
    super.dispose();
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: scaffoldState,
      backgroundColor: appColor.backgroundColor,
      body: SafeArea(
        child: Stack(
          children: [
            WidgetBackground(),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildHeader(),
                Expanded(child: _buildForm()),
                if (isLoading)
                  _buildLoadingIndicator()
                else
                  _buildSubmitButton(),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Padding(
      padding: EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          GestureDetector(
            onTap: () => Get.offNamed('/todoview'),
            child: _iconContainer(Icons.arrow_back),
          ),
          SizedBox(height: 24),
          Text(widget.isEdit ? 'Edit Task' : 'Create Task',
              style: TextStyle(
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                  color: appColor.backgroundColor.withOpacity(0.8))),
        ],
      ),
    );
  }

  Widget _buildForm() {
    return Expanded(
      child: SingleChildScrollView(
        child: Container(
          decoration: _containerDecoration(),
          padding: EdgeInsets.all(24),
          child: Column(
            children: [
              _buildTextField(controllerName, 'Task Name', Icons.assignment),
              SizedBox(height: 24),
              _buildTextField(
                  controllerDescription, 'Description', Icons.description,
                  maxLines: 2),
              SizedBox(height: 24),
              _buildDateField(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTextField(
      TextEditingController controller, String label, IconData icon,
      {int maxLines = 1}) {
    return TextFormField(
      controller: controller,
      maxLines: maxLines,
      decoration: _inputDecoration(label, icon),
      style: TextStyle(fontSize: 16, color: appColor.textColor),
    );
  }

  Widget _buildDateField() {
    return TextFormField(
      controller: controllerDate,
      readOnly: true,
      decoration: _inputDecoration('Due Date', Icons.calendar_today),
      style: TextStyle(fontSize: 16, color: appColor.textColor),
      onTap: _pickDate,
    );
  }

  Widget _buildSubmitButton() {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(24),
      color: Colors.white,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: appColor.colorTertiary,
          padding: EdgeInsets.symmetric(vertical: 16),
          shape:
          RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          elevation: 0,
        ),
        child: Text(widget.isEdit ? 'Update Task' : 'Create Task',
            style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Colors.white)),
        onPressed: _handleSubmit,
      ),
    );
  }

  Widget _buildLoadingIndicator() {
    return Container(
      color: Colors.white,
      padding: EdgeInsets.all(16),
      child: Center(
        child: CircularProgressIndicator(
            valueColor: AlwaysStoppedAnimation(appColor.colorTertiary)),
      ),
    );
  }

  InputDecoration _inputDecoration(String label, IconData icon) {
    return InputDecoration(
      labelText: label,
      labelStyle: TextStyle(color: appColor.textColor.withOpacity(0.7)),
      prefixIcon: Icon(icon, color: appColor.colorTertiary),
      border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide:
          BorderSide(color: appColor.colorTertiary.withOpacity(0.2))),
      enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide:
          BorderSide(color: appColor.colorTertiary.withOpacity(0.2))),
      focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: appColor.colorTertiary)),
      filled: true,
      fillColor: Colors.white,
    );
  }

  BoxDecoration _containerDecoration() {
    return BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(32),
    );
  }

  Container _iconContainer(IconData icon) {
    return Container(
      padding: EdgeInsets.all(8),
      decoration: BoxDecoration(
          color: appColor.colorTertiary.withOpacity(0.1),
          borderRadius: BorderRadius.circular(8)),
      child: Icon(
        icon,
        color: Colors.black,
      ),
    );
  }

  Future<void> _pickDate() async {
    DateTime today = DateTime.now();
    DateTime? datePicker = await showDatePicker(
      context: context,
      initialDate: date,
      firstDate: today,
      lastDate: DateTime(2026),
      builder: (context, child) => Theme(
        data: Theme.of(context).copyWith(
          colorScheme: ColorScheme.light(
              primary: appColor.colorTertiary,
              onPrimary: Colors.white,
              surface: Colors.white,
              onSurface: appColor.textColor),
        ),
        child: child!,
      ),
    );
    if (datePicker != null) {
      date = datePicker;
      controllerDate.text = DateFormat('dd MMMM yyyy').format(date);
    }
  }

  void _handleSubmit() async {
    String name = controllerName.text,
        description = controllerDescription.text,
        dueDate = controllerDate.text;

    if (name.isEmpty || description.isEmpty) {
      _showSnackBarMessage(
        name.isEmpty ? 'Please enter task name' : 'Please enter task description',
      );
      return;
    }

    // Check internet connectivity using TInternetConnectionUtils
    bool isConnected = await TInternetConnectionUtils.checkConnection();

    if (!isConnected) {
      // Offline: Save data locally and show custom Snackbar
      _saveDataLocally(name, description, dueDate);
      TSnackbar.warningSnackBar(
        title: 'No Internet Connection',
        message: 'Your task will be saved locally and synced when online.',
      );

      // Navigate to TodoView after showing the snackbar
      Future.delayed(Duration(milliseconds: 1500), () {
        Navigator.of(context).pushNamedAndRemoveUntil('/todoview', (route) => false);
      });
      return;
    }

    // If connected: Save task to Firestore
    setState(() {
      isLoading = true;
    });

    try {
      if (widget.isEdit) {
        DocumentReference taskRef = firestore.doc('todo/${widget.documentId}');
        await firestore.runTransaction((transaction) async {
          if ((await transaction.get(taskRef)).exists) {
            await transaction.update(taskRef, {
              'name': name,
              'description': description,
              'date': dueDate,
            });
          }
        });
        Navigator.pop(context, true);
      } else {
        DocumentReference result = await firestore.collection('todo').add({
          'name': name,
          'description': description,
          'date': dueDate,
        });
        if (result.id.isNotEmpty) Navigator.pop(context, true);
      }
    } catch (e) {
      _showSnackBarMessage('Error: Unable to save task');
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }


  void _showSnackBarMessage(String message) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text(message),
      behavior: SnackBarBehavior.floating,
      backgroundColor: appColor.colorTertiary,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
    ));
  }

  Future<void> _saveDataLocally(String name, String description, String dueDate) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString('task_name', name);
    prefs.setString('task_description', description);
    prefs.setString('task_dueDate', dueDate);
  }
}
