import 'package:flutter/material.dart';

class InventoryDetailScreen extends StatelessWidget {
  const InventoryDetailScreen({
    super.key,
    required this.materailId,
  });

  final String materailId;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Material'),
      ),
      body: Center(
        child: Text(materailId),
      ),
    );
  }
}