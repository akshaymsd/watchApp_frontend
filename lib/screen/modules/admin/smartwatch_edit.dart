import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:watchapp/screen/modules/admin/admin_screen.dart';
import 'package:watchapp/screen/modules/admin/view_smartWatch.dart';

import '../../../view_model/home_vew_model.dart';
import '../../../widgets/textfiled_widget.dart';

class SmartWatchEdit extends StatefulWidget {
  final String productId;
  final String name;
  final String type;

  final String brand;
  final double price;
  final String description;
  final String img; // Assuming image is a URL

  SmartWatchEdit({
    super.key,
    required this.productId,
    required this.name,
    required this.brand,
    required this.price,
    required this.description,
    required this.img,
    required this.type,
  });

  @override
  State<SmartWatchEdit> createState() => _SmartWatchEditState();
}

class _SmartWatchEditState extends State<SmartWatchEdit> {
  final _nameController = TextEditingController();
  final _typeController = TextEditingController();
  final _brandController = TextEditingController();
  final _priceController = TextEditingController();
  final _descriptionController = TextEditingController();
  File? _imageFile;
  final ImagePicker _picker = ImagePicker();

  @override
  void initState() {
    super.initState();
    _initializeFields();
  }

  void _initializeFields() {
    _nameController.text = widget.name;
    _typeController.text = widget.type;
    _brandController.text = widget.brand;
    _priceController.text = widget.price.toString();
    _descriptionController.text = widget.description;
  }

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

  Future<void> _updateProduct() async {
    final homeViewModel = Provider.of<HomeViewModel>(context, listen: false);

    try {
      await homeViewModel.updateProduct(
        id: widget.productId,
        name: _nameController.text,
        type: _typeController.text,
        brand: _brandController.text,
        price: double.tryParse(_priceController.text) ?? 0,
        description: _descriptionController.text,
        image: _imageFile,
        context: context, // Pass the context here for SnackBar messages
      );
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Product updated successfully.')),
      );
      Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => ViewSmartWatch(),
          ));
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to update product: ${e.toString()}')),
      );
    }
  }

  Future<void> _deleteProduct() async {
    final homeViewModel = Provider.of<HomeViewModel>(context, listen: false);

    try {
      final success =
          await homeViewModel.deleteProduct(widget.productId, context);

      if (success) {
        Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) => AdminPage(),
            )); // Navigate back to the previous screen
      }
    } catch (e) {
      // Error handling is already managed in the deleteProduct method
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Edit Smart Watch"),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              // Image selection and display section
              Row(
                children: [
                  _imageFile == null
                      ? (widget.img.isEmpty
                          ? Text('No image selected.')
                          : Image.network(
                              widget.img,
                              height: 150,
                              fit: BoxFit.cover,
                            ))
                      : Image.file(
                          _imageFile!,
                          height: 150,
                          fit: BoxFit.cover,
                        ),
                  SizedBox(width: 16),
                  ElevatedButton(
                    onPressed: _pickImage,
                    child: Text('Select Image'),
                  ),
                ],
              ),
              SizedBox(height: 20),

              // Form fields for product details
              TextfieldWidget(
                ctrl: _nameController,
                txt: 'Name',
              ),
              TextfieldWidget(
                ctrl: _typeController,
                txt: 'Type',
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

              // Update and delete buttons
              ElevatedButton(
                onPressed: _updateProduct,
                child: Text('Update Product'),
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: _deleteProduct,
                child: Text('Delete Product'),
                style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
