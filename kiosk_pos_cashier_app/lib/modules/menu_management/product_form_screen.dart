import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../config/theme.dart';
import '../../data/models/product_model.dart';
import '../../data/demo/demo_modifiers.dart';

class ProductFormScreen extends StatefulWidget {
  const ProductFormScreen({super.key});

  @override
  State<ProductFormScreen> createState() => _ProductFormScreenState();
}

class _ProductFormScreenState extends State<ProductFormScreen> {
  final _nameController = TextEditingController();
  final _priceController = TextEditingController();
  final _descriptionController = TextEditingController();
  String _selectedCategory = 'Meat';
  bool _isAvailable = true;
  List<int> _selectedModifierGroups = [];
  File? _imageFile;
  String? _imageUrl;

  bool get _isNew => _product == null;
  ProductModel? _product;
  List<String> _categories = ['Meat', 'Fish & Chips', 'Sides', 'Drinks', 'Desserts'];

  @override
  void initState() {
    super.initState();
    final args = Get.arguments as Map<String, dynamic>?;
    if (args != null) {
      if (args['categories'] != null) {
        _categories = List<String>.from(args['categories']);
      }
      if (args['isNew'] == false && args['product'] != null) {
        _product = args['product'] as ProductModel;
        _nameController.text = _product!.name;
        _priceController.text = _product!.basePrice.toString();
        _descriptionController.text = _product!.description ?? '';
        _selectedCategory = _product!.categoryName;
        _isAvailable = _product!.isAvailable;
        _selectedModifierGroups = List.from(_product!.modifierGroupIds);
        _imageUrl = _product!.imageUrl;
      }
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _priceController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  void _showImagePickerOptions() {
    Get.bottomSheet(
      Container(
        padding: EdgeInsets.all(24),
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: Colors.grey.shade300,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            SizedBox(height: 20),
            Text('Add Product Image',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            SizedBox(height: 24),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _buildImageOption(
                  Icons.camera_alt_rounded,
                  'Camera',
                  AppColors.primary,
                      () {
                    Get.back();
                    _pickImageFromCamera();
                  },
                ),
                _buildImageOption(
                  Icons.photo_library_rounded,
                  'Gallery',
                  AppColors.reading,
                      () {
                    Get.back();
                    _pickImageFromGallery();
                  },
                ),
                if (_imageFile != null || _imageUrl != null)
                  _buildImageOption(
                    Icons.delete_outline_rounded,
                    'Remove',
                    AppColors.error,
                        () {
                      Get.back();
                      setState(() {
                        _imageFile = null;
                        _imageUrl = null;
                      });
                    },
                  ),
              ],
            ),
            SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  Widget _buildImageOption(IconData icon, String label, Color color, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 64,
            height: 64,
            decoration: BoxDecoration(
              color: color.withOpacity(0.1),
              shape: BoxShape.circle,
            ),
            child: Icon(icon, size: 30, color: color),
          ),
          SizedBox(height: 8),
          Text(label, style: TextStyle(fontSize: 13, color: color, fontWeight: FontWeight.w600)),
        ],
      ),
    );
  }

  Future<void> _pickImageFromGallery() async {
    // For demo: simulate picking an image
    // In production, use image_picker package:
    // final picker = ImagePicker();
    // final picked = await picker.pickImage(source: ImageSource.gallery);
    // if (picked != null) setState(() => _imageFile = File(picked.path));

    setState(() {
      _imageUrl = 'https://images.unsplash.com/photo-1568901346375-23c9450c58cd?w=500';
    });
    Get.snackbar('Image Selected', 'Image added from gallery',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: AppColors.accent,
        colorText: Colors.white,
        duration: const Duration(seconds: 1),
        margin: const EdgeInsets.all(16),
        borderRadius: 12);
  }

  Future<void> _pickImageFromCamera() async {
    // For demo: simulate taking a photo
    // In production, use image_picker package:
    // final picker = ImagePicker();
    // final picked = await picker.pickImage(source: ImageSource.camera);
    // if (picked != null) setState(() => _imageFile = File(picked.path));

    setState(() {
      _imageUrl = 'https://images.unsplash.com/photo-1555396273-367ea4eb4db5?w=500';
    });
    Get.snackbar('Photo Taken', 'Image captured from camera',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: AppColors.accent,
        colorText: Colors.white,
        duration: const Duration(seconds: 1),
        margin: const EdgeInsets.all(16),
        borderRadius: 12);
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Column(
          children: [
            // Top bar
            Container(
              height: size.height * 0.08,
              padding: EdgeInsets.symmetric(horizontal: size.width * 0.04),
              decoration: BoxDecoration(color: Colors.white, boxShadow: [
                BoxShadow(color: Colors.black.withOpacity(0.04), blurRadius: 4, offset: const Offset(0, 2))
              ]),
              child: Row(children: [
                GestureDetector(
                    onTap: () => Get.back(),
                    child: Icon(Icons.arrow_back_ios_rounded,
                        size: size.width * 0.045, color: AppColors.textPrimary)),
                SizedBox(width: size.width * 0.03),
                Text(_isNew ? 'Add Product' : 'Edit Product',
                    style: TextStyle(fontSize: size.width * 0.045, fontWeight: FontWeight.bold)),
                const Spacer(),
                if (!_isNew)
                  GestureDetector(
                    onTap: () {
                      Get.back();
                      Get.snackbar('Deleted', '${_product!.name} removed',
                          snackPosition: SnackPosition.BOTTOM,
                          backgroundColor: AppColors.error,
                          colorText: Colors.white,
                          margin: const EdgeInsets.all(16),
                          borderRadius: 12);
                    },
                    child: Icon(Icons.delete_outline_rounded,
                        size: size.width * 0.05, color: AppColors.error),
                  ),
              ]),
            ),

            // Form content
            Expanded(
              child: SingleChildScrollView(
                padding: EdgeInsets.all(size.width * 0.05),
                child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                  // ============ IMAGE PICKER ============
                  GestureDetector(
                    onTap: _showImagePickerOptions,
                    child: Center(
                      child: Container(
                        width: size.width * 0.5,
                        height: size.width * 0.4,
                        decoration: BoxDecoration(
                          color: Colors.grey.shade100,
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(
                            color: (_imageFile != null || _imageUrl != null)
                                ? AppColors.primary
                                : Colors.grey.shade300,
                            width: (_imageFile != null || _imageUrl != null) ? 2 : 1,
                          ),
                        ),
                        child: (_imageFile != null || _imageUrl != null)
                            ? ClipRRect(
                          borderRadius: BorderRadius.circular(15),
                          child: Stack(
                            fit: StackFit.expand,
                            children: [
                              // Show image
                              if (_imageFile != null)
                                Image.file(_imageFile!, fit: BoxFit.cover)
                              else if (_imageUrl != null)
                                Image.network(_imageUrl!, fit: BoxFit.cover,
                                    errorBuilder: (_, __, ___) => _buildPlaceholder(size)),
                              // Edit overlay
                              Positioned(
                                bottom: 0,
                                left: 0,
                                right: 0,
                                child: Container(
                                  padding: EdgeInsets.symmetric(vertical: size.height * 0.012),
                                  decoration: BoxDecoration(
                                    color: Colors.black.withOpacity(0.6),
                                    borderRadius: const BorderRadius.vertical(bottom: Radius.circular(15)),
                                  ),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Icon(Icons.edit_rounded, color: Colors.white, size: size.width * 0.04),
                                      SizedBox(width: size.width * 0.02),
                                      Text('Change Image',
                                          style: TextStyle(color: Colors.white, fontSize: size.width * 0.03, fontWeight: FontWeight.w500)),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                        )
                            : _buildPlaceholder(size),
                      ),
                    ),
                  ),
                  SizedBox(height: size.height * 0.03),

                  // ============ NAME ============
                  _buildLabel('Product Name *', size),
                  SizedBox(height: size.height * 0.01),
                  TextField(
                    controller: _nameController,
                    decoration: InputDecoration(
                      hintText: 'Enter product name',
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                      prefixIcon: Icon(Icons.restaurant_rounded, size: size.width * 0.05),
                    ),
                    style: TextStyle(fontSize: size.width * 0.038),
                  ),
                  SizedBox(height: size.height * 0.025),

                  // ============ CATEGORY ============
                  _buildLabel('Category', size),
                  SizedBox(height: size.height * 0.01),
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: size.width * 0.04),
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.grey.shade300),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: DropdownButtonHideUnderline(
                      child: DropdownButton<String>(
                        value: _categories.contains(_selectedCategory)
                            ? _selectedCategory
                            : _categories.first,
                        isExpanded: true,
                        items: _categories
                            .map((c) => DropdownMenuItem(
                            value: c,
                            child: Text(c, style: TextStyle(fontSize: size.width * 0.036))))
                            .toList(),
                        onChanged: (v) => setState(() => _selectedCategory = v!),
                      ),
                    ),
                  ),
                  SizedBox(height: size.height * 0.025),

                  // ============ PRICE ============
                  _buildLabel('Price *', size),
                  SizedBox(height: size.height * 0.01),
                  TextField(
                    controller: _priceController,
                    keyboardType: TextInputType.numberWithOptions(decimal: true),
                    decoration: InputDecoration(
                      hintText: '0.00',
                      prefixText: '\$ ',
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                      prefixIcon: Icon(Icons.money_rounded, size: size.width * 0.05),
                    ),
                    style: TextStyle(fontSize: size.width * 0.05, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: size.height * 0.025),

                  // ============ DESCRIPTION ============
                  _buildLabel('Description', size),
                  SizedBox(height: size.height * 0.01),
                  TextField(
                    controller: _descriptionController,
                    maxLines: 3,
                    decoration: InputDecoration(
                      hintText: 'Enter description',
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                    ),
                    style: TextStyle(fontSize: size.width * 0.035),
                  ),
                  SizedBox(height: size.height * 0.025),

                  // ============ MODIFIER GROUPS ============
                  _buildLabel('Modifier Groups', size),
                  SizedBox(height: size.height * 0.01),
                  Text('Select which modifier groups apply to this product',
                      style: TextStyle(fontSize: size.width * 0.028, color: Colors.grey.shade500)),
                  SizedBox(height: size.height * 0.01),
                  Wrap(
                    spacing: size.width * 0.03,
                    runSpacing: size.width * 0.03,
                    children: DemoModifiers.allGroups.map((group) {
                      final isSelected = _selectedModifierGroups.contains(group.id);
                      return GestureDetector(
                        onTap: () {
                          setState(() {
                            if (isSelected) {
                              _selectedModifierGroups.remove(group.id);
                            } else {
                              _selectedModifierGroups.add(group.id);
                            }
                          });
                        },
                        child: Container(
                          padding: EdgeInsets.symmetric(
                              horizontal: size.width * 0.04, vertical: size.height * 0.012),
                          decoration: BoxDecoration(
                            color: isSelected ? AppColors.primary : Colors.white,
                            borderRadius: BorderRadius.circular(20),
                            border: Border.all(
                                color: isSelected ? AppColors.primary : Colors.grey.shade300),
                          ),
                          child: Text(
                            group.name,
                            style: TextStyle(
                                fontSize: size.width * 0.03,
                                fontWeight: FontWeight.w500,
                                color: isSelected ? Colors.white : Colors.grey.shade700),
                          ),
                        ),
                      );
                    }).toList(),
                  ),
                  SizedBox(height: size.height * 0.025),

                  // ============ AVAILABILITY ============
                  SwitchListTile(
                    contentPadding: EdgeInsets.zero,
                    title: Text('Available for ordering',
                        style: TextStyle(fontSize: size.width * 0.035, fontWeight: FontWeight.w600)),
                    subtitle: Text(_isAvailable ? 'Product is visible on the menu' : 'Product is hidden from menu',
                        style: TextStyle(fontSize: size.width * 0.026, color: Colors.grey.shade500)),
                    value: _isAvailable,
                    onChanged: (v) => setState(() => _isAvailable = v),
                    activeColor: AppColors.accent,
                  ),
                ]),
              ),
            ),

            // Save button
            Container(
              padding: EdgeInsets.all(size.width * 0.04),
              decoration: BoxDecoration(color: Colors.white, boxShadow: [
                BoxShadow(color: Colors.black.withOpacity(0.08), blurRadius: 10, offset: const Offset(0, -3))
              ]),
              child: SafeArea(
                child: SizedBox(
                  width: double.infinity,
                  height: size.height * 0.065,
                  child: ElevatedButton(
                    onPressed: (_nameController.text.isNotEmpty && _priceController.text.isNotEmpty)
                        ? () {
                      Get.snackbar(
                        _isNew ? '✅ Product Added!' : '✅ Product Updated!',
                        '${_nameController.text} has been saved',
                        snackPosition: SnackPosition.BOTTOM,
                        backgroundColor: AppColors.accent,
                        colorText: Colors.white,
                        margin: const EdgeInsets.all(16),
                        borderRadius: 12,
                      );
                      Get.back();
                    }
                        : null,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.accent,
                      disabledBackgroundColor: Colors.grey.shade300,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                    ),
                    child: Text(
                      _isNew ? 'ADD PRODUCT' : 'SAVE CHANGES',
                      style: TextStyle(fontSize: size.width * 0.04, fontWeight: FontWeight.bold, color: Colors.white),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPlaceholder(Size size) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(Icons.add_photo_alternate_rounded,
            size: size.width * 0.08, color: Colors.grey.shade400),
        SizedBox(height: size.height * 0.01),
        Text('Tap to Add Image',
            style: TextStyle(
                fontSize: size.width * 0.03, color: Colors.grey.shade500)),
        SizedBox(height: size.height * 0.005),
        Text('Gallery or Camera',
            style: TextStyle(
                fontSize: size.width * 0.025, color: Colors.grey.shade400)),
      ],
    );
  }

  Widget _buildLabel(String text, Size size) {
    return Text(text,
        style: TextStyle(
            fontSize: size.width * 0.035,
            fontWeight: FontWeight.w600,
            color: AppColors.textPrimary));
  }
}