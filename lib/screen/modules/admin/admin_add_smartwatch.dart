import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:watchapp/utils/constants.dart';

import '../../../view_model/home_vew_model.dart';
import '../../../widgets/textfiled_widget.dart'; // Ensure you have your TextfieldWidget

class AdminAddSmartWatch extends StatefulWidget {
  const AdminAddSmartWatch({super.key});

  @override
  State<AdminAddSmartWatch> createState() => _AdminAddSmartWatchState();
}

class _AdminAddSmartWatchState extends State<AdminAddSmartWatch> {
  final _nameController = TextEditingController();
  final _typeController = TextEditingController();
  final _brandController = TextEditingController();
  final _priceController = TextEditingController();
  final _descriptionController = TextEditingController();
  File? _imageFile;
  final _picker = ImagePicker();

  Future<void> _pickImage() async {
    try {
      final pickedFile = await _picker.pickImage(source: ImageSource.gallery);
      if (pickedFile != null) {
        setState(() {
          _imageFile = File(pickedFile.path);
        });
      }
    } catch (e) {
      print('Error picking image: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to pick image: ${e.toString()}')),
      );
    }
  }

  Future<void> _addProduct() async {
    if (_imageFile == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Please select an image.')),
      );
      return;
    }

    final name = _nameController.text;
    final type = _typeController.text;
    final brand = _brandController.text;
    final price = double.tryParse(_priceController.text) ?? 0;
    final description = _descriptionController.text;

    final homeViewModel = Provider.of<HomeViewModel>(context, listen: false);

    try {
      await homeViewModel.addProduct(
        name: name,
        brand: brand,
        price: price,
        description: description,
        image: _imageFile!,
        type: type,
      );
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Product added successfully.')),
      );
      // Clear the form fields and image
      _nameController.clear();
      _typeController.clear();
      _brandController.clear();
      _priceController.clear();
      _descriptionController.clear();
      setState(() {
        _imageFile = null;
      });
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to add product: ${e.toString()}')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Add Smart Watch"),
      ),
      backgroundColor: bgcolor,
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            SizedBox(height: 20),
            TextfieldWidget(
              ctrl: _nameController,
              txt: 'Name',
            ),
            TextfieldWidget(
              txt: 'Type',
              ctrl: _typeController,
            ),
            TextfieldWidget(
              ctrl: _brandController,
              txt: 'Brand',
            ),
            TextfieldWidget(
              ctrl: _priceController,
              txt: 'Price',
              keybrd: TextInputType.number,
            ),
            TextfieldWidget(
              ctrl: _descriptionController,
              txt: 'Description',
            ),
            SizedBox(height: 20),
            _imageFile == null
                ? Text('No image selected.')
                : Image.file(_imageFile!, height: 150, fit: BoxFit.cover),
            ElevatedButton(
              onPressed: _pickImage,
              child: Text('Select Image'),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: _addProduct,
              child: Text('Add Product'),
            ),
          ],
        ),
      ),
    );
  }
}
