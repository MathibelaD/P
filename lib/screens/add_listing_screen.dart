import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import '../services/storage_service.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class AddListingScreen extends StatefulWidget {
  const AddListingScreen({super.key});

  @override
  State<AddListingScreen> createState() => _AddListingScreenState();
}

class _AddListingScreenState extends State<AddListingScreen> {
  final _formKey = GlobalKey<FormState>();
  bool _isLoading = false;

  final _titleController = TextEditingController();
  final _descController = TextEditingController();
  final _priceController = TextEditingController();
  final _typeController = TextEditingController();
  final _locationController = TextEditingController();
  final _bedroomsController = TextEditingController();
  final _bathroomsController = TextEditingController();
  final _areaController = TextEditingController();
  final _amenitiesController = TextEditingController();

  File? _pickedImage;

  Future<void> _pickImage() async {
    final picker = ImagePicker();
    final picked = await picker.pickImage(source: ImageSource.gallery);
    if (picked != null) {
      setState(() {
        _pickedImage = File(picked.path);
      });
    }
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate() || _pickedImage == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please fill all fields & pick an image')),
      );
      return;
    }

    setState(() => _isLoading = true);

    try {
      // Upload image
      final storageService = StorageService();
      final imageUrl = await storageService.uploadImage(
        file: _pickedImage!,
        bucket: 'property-images',
        pathPrefix: 'listings',
      );

      if (imageUrl == null) throw Exception('Image upload failed');

      // Insert listing
      final userId = Supabase.instance.client.auth.currentUser?.id;
      await Supabase.instance.client.from('listings').insert({
        'title': _titleController.text.trim(),
        'description': _descController.text.trim(),
        'price': double.parse(_priceController.text),
        'type': _typeController.text.trim(),
        'image_url': imageUrl,
        'location': _locationController.text.trim(),
        'bedrooms': int.parse(_bedroomsController.text),
        'bathrooms': int.parse(_bathroomsController.text),
        'area_sq_ft': double.parse(_areaController.text),
        'amenities': _amenitiesController.text.split(',').map((e) => e.trim()).toList(),
        'owner_id': userId,
      });

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Listing added successfully!')),
      );
      Navigator.of(context).pop(); // Go back after adding
    } catch (e) {
      print('❌ Add listing error: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: $e')),
      );
    }

    setState(() => _isLoading = false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add New Listing'),
        backgroundColor: const Color(0xff4facfe),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              if (_pickedImage != null)
                Image.file(_pickedImage!, height: 180, fit: BoxFit.cover)
              else
                TextButton.icon(
                  onPressed: _pickImage,
                  icon: const Icon(Icons.image),
                  label: const Text('Pick main image'),
                ),
              const SizedBox(height: 16),
              _buildTextField(_titleController, 'Title'),
              _buildTextField(_descController, 'Description', maxLines: 3),
              _buildTextField(_priceController, 'Price', inputType: TextInputType.number),
              _buildTextField(_typeController, 'Type (e.g. apartment)'),
              _buildTextField(_locationController, 'Location'),
              _buildTextField(_bedroomsController, 'Bedrooms', inputType: TextInputType.number),
              _buildTextField(_bathroomsController, 'Bathrooms', inputType: TextInputType.number),
              _buildTextField(_areaController, 'Area (sq ft)', inputType: TextInputType.number),
              _buildTextField(_amenitiesController, 'Amenities (comma separated)'),
              const SizedBox(height: 20),
              _isLoading
                  ? const CircularProgressIndicator()
                  : SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: _submit,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xff4facfe),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30),
                          ),
                        ),
                        child: const Text('Add Listing', style: TextStyle(color: Colors.white)),
                      ),
                    ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTextField(
    TextEditingController controller,
    String label, {
    int maxLines = 1,
    TextInputType inputType = TextInputType.text,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: TextFormField(
        controller: controller,
        maxLines: maxLines,
        keyboardType: inputType,
        validator: (value) => (value == null || value.isEmpty) ? 'Required' : null,
        decoration: InputDecoration(
          labelText: label,
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
        ),
      ),
    );
  }
}
