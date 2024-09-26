import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:tailorapp/firebase/firebase_services.dart';

class MenuInputScreen extends StatefulWidget {
  const MenuInputScreen({super.key});

  @override
  _MenuInputScreenState createState() => _MenuInputScreenState();
}

class _MenuInputScreenState extends State<MenuInputScreen> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _priceController = TextEditingController();
  File? _imageFile; // To store the picked image
  final ImagePicker _picker = ImagePicker(); // Image picker instance

  Future<void> _pickImage() async {
    final pickedFile = await _picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _imageFile = File(pickedFile.path);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add Menu Item'),
        backgroundColor: Colors.orangeAccent,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              CustomTextField(
                controller: _nameController,
                label: 'Item Name',
                maxLines: 1,
              ),
              const SizedBox(height: 20),
              CustomTextField(
                controller: _descriptionController,
                label: 'Description',
                maxLines: 3,
              ),
              const SizedBox(height: 20),
              CustomTextField(
                controller: _priceController,
                label: 'Price',
                keyboardType: TextInputType.number,
              ),
              const SizedBox(height: 20),
              GestureDetector(
                onTap: _pickImage,
                child: Container(
                  height: 150,
                  decoration: BoxDecoration(
                    color: Colors.orange[50],
                    border: Border.all(color: Colors.orangeAccent),
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                  child: _imageFile != null
                      ? Image.file(_imageFile!, fit: BoxFit.cover)
                      : const Center(
                          child: Text(
                            'Tap to pick an image',
                            style: TextStyle(color: Colors.orangeAccent),
                          ),
                        ),
                ),
              ),
              const SizedBox(height: 40),
              ElevatedButton(
                onPressed: () async {
                  final String name = _nameController.text;
                  final String description = _descriptionController.text;
                  final String price = _priceController.text;

                  if (name.isEmpty ||
                      description.isEmpty ||
                      price.isEmpty ||
                      _imageFile == null) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                          content: Text(
                              'Please fill in all fields and pick an image')),
                    );
                    return;
                  }

                  try {
                    FirebaseService firebaseService = FirebaseService();
                    await firebaseService.saveMenuItem(
                      name: name,
                      description: description,
                      price: price,
                      imageFile: _imageFile!,
                    );

                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                          content: Text('Menu item added successfully!')),
                    );

                    // Clear the fields after successful submission
                    _nameController.clear();
                    _descriptionController.clear();
                    _priceController.clear();
                    setState(() {
                      _imageFile = null;
                    });
                  } catch (e) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('Error: $e')),
                    );
                  }
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.orangeAccent,
                  padding: const EdgeInsets.symmetric(vertical: 16.0),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                ),
                child: const Text(
                  'Add Menu Item',
                  style: TextStyle(fontSize: 18, color: Colors.white),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class CustomTextField extends StatelessWidget {
  final TextEditingController controller;
  final String label;
  final int maxLines;
  final TextInputType? keyboardType;

  const CustomTextField({
    Key? key,
    required this.controller,
    required this.label,
    this.maxLines = 1,
    this.keyboardType,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      maxLines: maxLines,
      keyboardType: keyboardType,
      decoration: InputDecoration(
        labelText: label,
        labelStyle: const TextStyle(color: Colors.orangeAccent),
        enabledBorder: OutlineInputBorder(
          borderSide: const BorderSide(color: Colors.orangeAccent),
          borderRadius: BorderRadius.circular(8.0),
        ),
        focusedBorder: OutlineInputBorder(
          borderSide: const BorderSide(color: Colors.deepOrange),
          borderRadius: BorderRadius.circular(8.0),
        ),
      ),
    );
  }
}
