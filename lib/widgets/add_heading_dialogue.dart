import 'package:flutter/material.dart';
import 'package:get/get.dart';

class AddHeadingDialog extends StatelessWidget {
  final Function(String) onAdd;
  final TextEditingController _controller = TextEditingController();

  AddHeadingDialog({
    super.key,
    required this.onAdd,
  });

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Add Heading'),
      content: TextField(
        controller: _controller,
        decoration: const InputDecoration(
          labelText: 'Heading Name',
          hintText: 'Enter heading name',
        ),
        autofocus: true,
      ),
      actions: [
        TextButton(
          onPressed: () => Get.back(),
          child: const Text('Cancel'),
        ),
        ElevatedButton(
          onPressed: () {
            if (_controller.text.isNotEmpty) {
              onAdd(_controller.text);
              Get.back();
            }
          },
          child: const Text('Add'),
        ),
      ],
    );
  }

  @override
  void dispose() {
    _controller.dispose();
  }
}
