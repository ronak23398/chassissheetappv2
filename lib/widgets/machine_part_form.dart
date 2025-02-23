import 'package:flutter/material.dart';

class MachinePartForm extends StatelessWidget {
  final TextEditingController nameController;
  final TextEditingController idController;

  const MachinePartForm({
    super.key,
    required this.nameController,
    required this.idController,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Machine Part Details',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: nameController,
              decoration: const InputDecoration(
                labelText: 'Machine Part Name',
                border: OutlineInputBorder(),
              ),
              validator: (value) =>
                  value?.isEmpty ?? true ? 'Required field' : null,
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: idController,
              decoration: const InputDecoration(
                labelText: 'Machine Part ID',
                border: OutlineInputBorder(),
              ),
              validator: (value) =>
                  value?.isEmpty ?? true ? 'Required field' : null,
            ),
          ],
        ),
      ),
    );
  }
}
