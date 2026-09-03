import 'package:flutter/material.dart';

import '../models/product.dart';
import '../services/database_helper.dart';

class EditProductScreen extends StatefulWidget {
  final Product product;

  const EditProductScreen({
    super.key,
    required this.product,
  });

  @override
  State<EditProductScreen> createState() =>
      _EditProductScreenState();
}

class _EditProductScreenState
    extends State<EditProductScreen> {
  final _formKey = GlobalKey<FormState>();

  late TextEditingController nameController;
  late TextEditingController quantityController;
  late TextEditingController priceController;

  late String category;

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
  void initState() {
    super.initState();

    nameController =
        TextEditingController(text: widget.product.name);

    quantityController = TextEditingController(
      text: widget.product.quantity.toString(),
    );

    priceController = TextEditingController(
      text: widget.product.price.toString(),
    );

    category = widget.product.category;

    if (!categories.contains(category)) {
      category = 'Other';
    }
  }

  @override
  void dispose() {
    nameController.dispose();
    quantityController.dispose();
    priceController.dispose();
    super.dispose();
  }

  Future<void> updateProduct() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() {
      saving = true;
    });

    final updatedProduct = Product(
      id: widget.product.id,
      name: nameController.text.trim(),
      category: category,
      quantity: int.parse(
        quantityController.text.trim(),
      ),
      price: double.parse(
        priceController.text.trim(),
      ),
    );

    await DatabaseHelper.instance
        .updateProduct(updatedProduct);

    if (!mounted) return;

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Product updated successfully!'),
        backgroundColor: Colors.green,
      ),
    );

    Navigator.pop(context, true);
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
        title: const Text('Edit Product'),
        backgroundColor: Colors.blue,
        foregroundColor: Colors.white,
      ),
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: ConstrainedBox(
            constraints:
                const BoxConstraints(maxWidth: 700),
            child: Form(
              key: _formKey,
              child: Column(
                children: [
                  TextFormField(
                    controller: nameController,
                    decoration: decoration(
                      'Product Name',
                      Icons.inventory_2_outlined,
                    ),
                    validator: (value) =>
                        value == null ||
                                value.trim().isEmpty
                            ? 'Enter product name'
                            : null,
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
                          saving ? null : updateProduct,
                      icon: const Icon(Icons.save),
                      label: Text(
                        saving
                            ? 'Updating...'
                            : 'Update Product',
                      ),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.blue,
                        foregroundColor: Colors.white,
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