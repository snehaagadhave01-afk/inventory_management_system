import 'package:flutter/material.dart';

import '../models/product.dart';
import '../services/database_helper.dart';

class AddProductScreen extends StatefulWidget {
  const AddProductScreen({super.key});

  @override
  State<AddProductScreen> createState() =>
      _AddProductScreenState();
}

class _AddProductScreenState extends State<AddProductScreen> {
  final _formKey = GlobalKey<FormState>();

  final nameController = TextEditingController();
  final quantityController = TextEditingController();
  final priceController = TextEditingController();

  String category = 'Electronics';
  bool saving = false;

  final categories = [
    'Electronics',
    'Furniture',
    'Clothing',
    'Food',
    'Stationery',
    'Other',
  ];

  @override
  void dispose() {
    nameController.dispose();
    quantityController.dispose();
    priceController.dispose();
    super.dispose();
  }

  Future<void> saveProduct() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() {
      saving = true;
    });

    try {
      final product = Product(
        name: nameController.text.trim(),
        category: category,
        quantity: int.parse(quantityController.text.trim()),
        price: double.parse(priceController.text.trim()),
      );

      await DatabaseHelper.instance.insertProduct(product);

      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Product saved successfully!'),
          backgroundColor: Colors.green,
        ),
      );

      Navigator.pop(context, true);
    } catch (e) {
      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error: $e'),
          backgroundColor: Colors.red,
        ),
      );
    } finally {
      if (mounted) {
        setState(() {
          saving = false;
        });
      }
    }
  }

  InputDecoration decoration(
    String label,
    IconData icon,
  ) {
    return InputDecoration(
      labelText: label,
      prefixIcon: Icon(icon),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add Product'),
        backgroundColor: Colors.blue,
        foregroundColor: Colors.white,
      ),
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: ConstrainedBox(
            constraints: const BoxConstraints(
              maxWidth: 700,
            ),
            child: Form(
              key: _formKey,
              child: Column(
                children: [
                  const Icon(
                    Icons.add_box,
                    size: 80,
                    color: Colors.blue,
                  ),

                  const SizedBox(height: 20),

                  const Text(
                    'Add New Product',
                    style: TextStyle(
                      fontSize: 30,
                      fontWeight: FontWeight.bold,
                    ),
                  ),

                  const SizedBox(height: 30),

                  TextFormField(
                    controller: nameController,
                    decoration: decoration(
                      'Product Name',
                      Icons.inventory_2_outlined,
                    ),
                    validator: (value) {
                      if (value == null ||
                          value.trim().isEmpty) {
                        return 'Enter product name';
                      }
                      return null;
                    },
                  ),

                  const SizedBox(height: 18),

                  DropdownButtonFormField<String>(
                    value: category,
                    decoration: decoration(
                      'Category',
                      Icons.category_outlined,
                    ),
                    items: categories.map((item) {
                      return DropdownMenuItem(
                        value: item,
                        child: Text(item),
                      );
                    }).toList(),
                    onChanged: (value) {
                      if (value != null) {
                        setState(() {
                          category = value;
                        });
                      }
                    },
                  ),

                  const SizedBox(height: 18),

                  TextFormField(
                    controller: quantityController,
                    keyboardType: TextInputType.number,
                    decoration: decoration(
                      'Quantity',
                      Icons.numbers,
                    ),
                    validator: (value) {
                      final number =
                          int.tryParse(value ?? '');

                      if (number == null || number < 0) {
                        return 'Enter valid quantity';
                      }

                      return null;
                    },
                  ),

                  const SizedBox(height: 18),

                  TextFormField(
                    controller: priceController,
                    keyboardType:
                        const TextInputType.numberWithOptions(
                      decimal: true,
                    ),
                    decoration: decoration(
                      'Price',
                      Icons.currency_rupee,
                    ),
                    validator: (value) {
                      final number =
                          double.tryParse(value ?? '');

                      if (number == null || number < 0) {
                        return 'Enter valid price';
                      }

                      return null;
                    },
                  ),

                  const SizedBox(height: 30),

                  SizedBox(
                    width: double.infinity,
                    height: 55,
                    child: ElevatedButton.icon(
                      onPressed:
                          saving ? null : saveProduct,
                      icon: saving
                          ? const SizedBox(
                              width: 20,
                              height: 20,
                              child:
                                  CircularProgressIndicator(
                                strokeWidth: 2,
                                color: Colors.white,
                              ),
                            )
                          : const Icon(Icons.save),
                      label: Text(
                        saving
                            ? 'Saving...'
                            : 'Save Product',
                      ),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.blue,
                        foregroundColor: Colors.white,
                        textStyle: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius:
                              BorderRadius.circular(14),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}