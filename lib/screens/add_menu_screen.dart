import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:tailorapp/firebase/firebase_services.dart';
import 'package:tailorapp/screens/tailor_dashboard.dart';
import 'package:tailorapp/widgets/background_widget.dart';
import 'package:tailorapp/widgets/custom_button.dart';
import 'package:tailorapp/widgets/custom_textfield.dart';

class MenuInputScreen extends StatefulWidget {
  const MenuInputScreen({super.key});

  @override
  MenuInputScreenState createState() => MenuInputScreenState();
}

class MenuInputScreenState extends State<MenuInputScreen> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _priceController = TextEditingController();
  File? _imageFile; // To store the picked image
  final ImagePicker _picker = ImagePicker(); // Image picker instance

  String? _selectedCategory; // To store the selected category
  final List<String> _categories = [
    'Fast Food',
    'Tea',
    'Biryani',
    'Chinese',
    'Juices'
  ];

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
        foregroundColor: Colors.white,
      ),
      body: BackgroundWidget(
        backgroundImage: SingleChildScrollView(
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
                DropdownButtonFormField<String>(
                  value: _selectedCategory,
                  hint: const Text('Select Category'),
                  items: _categories.map((String category) {
                    return DropdownMenuItem<String>(
                      value: category,
                      child: Text(category),
                    );
                  }).toList(),
                  onChanged: (String? newValue) {
                    setState(() {
                      _selectedCategory = newValue;
                    });
                  },
                  decoration: InputDecoration(
                    filled: true,
                    fillColor: Colors.orange[50],
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8.0),
                      borderSide: const BorderSide(color: Colors.orangeAccent),
                    ),
                  ),
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
                CustomButton(
                  onPress: () async {
                    final String name = _nameController.text;
                    final String description = _descriptionController.text;
                    final String price = _priceController.text;

                    if (name.isEmpty ||
                        description.isEmpty ||
                        price.isEmpty ||
                        _imageFile == null ||
                        _selectedCategory == null) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                            content: Text(
                                'Please fill in all fields, pick an image, and select a category')),
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
                        category:
                            _selectedCategory!, // Save the selected category
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
                        _selectedCategory = null;
                      });
                    } catch (e) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('Error: $e')),
                      );
                    }
                    Navigator.of(context)
                        .push(MaterialPageRoute(builder: (context) {
                      return const TailorDashboard();
                    }));
                  },
                  buttonTxt: const Text(
                    'Add Menu Item',
                    style: TextStyle(fontSize: 18, color: Colors.white),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
