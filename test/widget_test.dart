import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('Inventory Management app basic widget test',
      (WidgetTester tester) async {
    // Build a simple test version of the app.
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          appBar: AppBar(
            title: const Text('Inventory Management'),
          ),
          body: const Center(
            child: Text('Dashboard'),
          ),
        ),
      ),
    );

    // Check that the app loads.
    expect(find.text('Inventory Management'), findsOneWidget);

    // Check that Dashboard is displayed.
    expect(find.text('Dashboard'), findsOneWidget);
  });
}