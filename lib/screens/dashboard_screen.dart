import 'package:flutter/material.dart';

import 'add_product_screen.dart';
import 'product_list_screen.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  int totalProducts = 0;
  int totalStock = 0;
  int lowStock = 0;
  double inventoryValue = 0;

  // TEMPORARY: database loading is disabled for testing.
  bool loading = false;

  @override
  void initState() {
    super.initState();
  }

  Widget statCard(
    String title,
    String value,
    IconData icon,
    Color color,
  ) {
    return Card(
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(22),
        child: Row(
          children: [
            CircleAvatar(
              radius: 28,
              backgroundColor: color.withOpacity(0.12),
              child: Icon(
                icon,
                color: color,
                size: 28,
              ),
            ),
            const SizedBox(width: 18),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      color: Colors.grey,
                      fontSize: 14,
                    ),
                  ),
                  const SizedBox(height: 5),
                  Text(
                    value,
                    style: const TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> openProducts() async {
    await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => const ProductListScreen(),
      ),
    );
  }

  Future<void> addProduct() async {
    await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => const AddProductScreen(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Dashboard',
          style: TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: Colors.blue,
        foregroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(
              maxWidth: 1100,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Inventory Overview',
                  style: TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                  ),
                ),

                const SizedBox(height: 8),

                const Text(
                  'Manage your products and inventory easily.',
                  style: TextStyle(
                    color: Colors.grey,
                    fontSize: 16,
                  ),
                ),

                const SizedBox(height: 25),

                GridView.count(
                  crossAxisCount:
                      MediaQuery.of(context).size.width > 800 ? 2 : 1,
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  crossAxisSpacing: 15,
                  mainAxisSpacing: 15,
                  childAspectRatio: 3.2,
                  children: [
                    statCard(
                      'Total Products',
                      '$totalProducts',
                      Icons.inventory_2,
                      Colors.blue,
                    ),
                    statCard(
                      'Total Stock',
                      '$totalStock',
                      Icons.warehouse,
                      Colors.green,
                    ),
                    statCard(
                      'Low Stock',
                      '$lowStock',
                      Icons.warning_amber,
                      Colors.orange,
                    ),
                    statCard(
                      'Inventory Value',
                      '₹${inventoryValue.toStringAsFixed(2)}',
                      Icons.currency_rupee,
                      Colors.purple,
                    ),
                  ],
                ),

                const SizedBox(height: 30),

                Row(
                  children: [
                    Expanded(
                      child: ElevatedButton.icon(
                        onPressed: addProduct,
                        icon: const Icon(Icons.add),
                        label: const Text('Add Product'),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.blue,
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(
                            vertical: 18,
                          ),
                        ),
                      ),
                    ),

                    const SizedBox(width: 15),

                    Expanded(
                      child: OutlinedButton.icon(
                        onPressed: openProducts,
                        icon: const Icon(Icons.inventory),
                        label: const Text('View Products'),
                        style: OutlinedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(
                            vertical: 18,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}