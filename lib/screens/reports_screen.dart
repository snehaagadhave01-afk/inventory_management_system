import 'package:flutter/material.dart';

class ReportsScreen extends StatelessWidget {
  const ReportsScreen({super.key});

  Widget reportCard(
      String title,
      String value,
      Color color,
      IconData icon,
      ) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15),
      ),
      child: Padding(
        padding: const EdgeInsets.all(18),
        child: Column(
          children: [

            CircleAvatar(
              radius: 28,
              backgroundColor: color.withOpacity(0.15),
              child: Icon(icon, color: color),
            ),

            const SizedBox(height: 12),

            Text(
              value,
              style: const TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 8),

            Text(title),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      backgroundColor: const Color(0xffF5F7FA),

      appBar: AppBar(
        title: const Text("Reports"),
        backgroundColor: const Color(0xff2962FF),
        foregroundColor: Colors.white,
      ),

      body: Padding(
        padding: const EdgeInsets.all(18),
        child: GridView.count(
          crossAxisCount: 2,
          crossAxisSpacing: 18,
          mainAxisSpacing: 18,
          children: [

            reportCard(
              "Products",
              "120",
              Colors.blue,
              Icons.inventory,
            ),

            reportCard(
              "Categories",
              "15",
              Colors.green,
              Icons.category,
            ),

            reportCard(
              "Low Stock",
              "08",
              Colors.red,
              Icons.warning,
            ),

            reportCard(
              "Sold",
              "340",
              Colors.orange,
              Icons.shopping_cart,
            ),
          ],
        ),
      ),
    );
  }
}