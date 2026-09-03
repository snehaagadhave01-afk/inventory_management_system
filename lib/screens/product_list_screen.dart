import 'package:flutter/material.dart';

import '../models/product.dart';
import '../services/database_helper.dart';
import 'add_product_screen.dart';
import 'edit_product_screen.dart';

class ProductListScreen extends StatefulWidget {
  const ProductListScreen({super.key});

  @override
  State<ProductListScreen> createState() =>
      _ProductListScreenState();
}

class _ProductListScreenState
    extends State<ProductListScreen> {
  List<Product> products = [];
  List<Product> filteredProducts = [];

  bool loading = true;

  @override
  void initState() {
    super.initState();
    loadProducts();
  }

  Future<void> loadProducts() async {
    setState(() {
      loading = true;
    });

    final data =
        await DatabaseHelper.instance.getProducts();

    if (!mounted) return;

    setState(() {
      products = data;
      filteredProducts = data;
      loading = false;
    });
  }

  void searchProducts(String query) {
    final result = products.where((product) {
      return product.name
              .toLowerCase()
              .contains(query.toLowerCase()) ||
          product.category
              .toLowerCase()
              .contains(query.toLowerCase());
    }).toList();

    setState(() {
      filteredProducts = result;
    });
  }

  Future<void> deleteProduct(Product product) async {
    if (product.id == null) return;

    await DatabaseHelper.instance
        .deleteProduct(product.id!);

    await loadProducts();
  }

  Future<void> addProduct() async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => const AddProductScreen(),
      ),
    );

    if (result == true) {
      await loadProducts();
    }
  }

  Future<void> editProduct(Product product) async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) =>
            EditProductScreen(product: product),
      ),
    );

    if (result == true) {
      await loadProducts();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Products'),
        backgroundColor: Colors.blue,
        foregroundColor: Colors.white,
        actions: [
          IconButton(
            onPressed: loadProducts,
            icon: const Icon(Icons.refresh),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: addProduct,
        child: const Icon(Icons.add),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            TextField(
              onChanged: searchProducts,
              decoration: InputDecoration(
                hintText: 'Search products...',
                prefixIcon:
                    const Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius:
                      BorderRadius.circular(14),
                ),
              ),
            ),

            const SizedBox(height: 20),

            Expanded(
              child: loading
                  ? const Center(
                      child:
                          CircularProgressIndicator(),
                    )
                  : filteredProducts.isEmpty
                      ? const Center(
                          child: Column(
                            mainAxisAlignment:
                                MainAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.inventory_2_outlined,
                                size: 70,
                                color: Colors.grey,
                              ),
                              SizedBox(height: 12),
                              Text(
                                'No products found',
                                style: TextStyle(
                                  fontSize: 20,
                                  color: Colors.grey,
                                ),
                              ),
                            ],
                          ),
                        )
                      : ListView.builder(
                          itemCount:
                              filteredProducts.length,
                          itemBuilder:
                              (context, index) {
                            final product =
                                filteredProducts[
                                    index];

                            return Card(
                              margin:
                                  const EdgeInsets.only(
                                bottom: 12,
                              ),
                              child: ListTile(
                                leading: CircleAvatar(
                                  backgroundColor:
                                      Colors.blue,
                                  child: Text(
                                    product.name
                                            .isNotEmpty
                                        ? product.name[0]
                                            .toUpperCase()
                                        : '?',
                                    style:
                                        const TextStyle(
                                      color: Colors.white,
                                    ),
                                  ),
                                ),
                                title: Text(
                                  product.name,
                                  style:
                                      const TextStyle(
                                    fontWeight:
                                        FontWeight.bold,
                                  ),
                                ),
                                subtitle: Text(
                                  '${product.category} • Qty: ${product.quantity} • ₹${product.price.toStringAsFixed(2)}',
                                ),
                                trailing: Row(
                                  mainAxisSize:
                                      MainAxisSize.min,
                                  children: [
                                    IconButton(
                                      onPressed: () =>
                                          editProduct(
                                              product),
                                      icon: const Icon(
                                        Icons.edit,
                                        color: Colors.blue,
                                      ),
                                    ),
                                    IconButton(
                                      onPressed: () =>
                                          deleteProduct(
                                              product),
                                      icon: const Icon(
                                        Icons.delete,
                                        color: Colors.red,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            );
                          },
                        ),
            ),
          ],
        ),
      ),
    );
  }
}