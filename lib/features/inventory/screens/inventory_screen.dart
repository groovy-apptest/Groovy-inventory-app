import 'package:flutter/material.dart';
import 'package:groovy_inventory/core/widgets/app_bar.dart';

class InventoryScreen extends StatelessWidget {
  const InventoryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        title: 'Inventory',
        bottomText: 'Stock levels & alerts',
      ),
      body: const Center(child: Text('Inventory')),
    );
  }
}
