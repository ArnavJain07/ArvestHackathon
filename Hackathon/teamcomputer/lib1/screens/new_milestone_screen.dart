import 'package:flutter/material.dart';
import '../models/milestone_model.dart';

class NewMilestoneScreen extends StatefulWidget {
  const NewMilestoneScreen({super.key});

  @override
  _NewMilestoneScreenState createState() => _NewMilestoneScreenState();
}

class _NewMilestoneScreenState extends State<NewMilestoneScreen> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _targetAmountController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();

  void _saveMilestone() {
    if (_nameController.text.isNotEmpty && _targetAmountController.text.isNotEmpty && _descriptionController.text.isNotEmpty) {
      final newMilestone = MilestoneModel(
        name: _nameController.text,
        targetAmount: double.tryParse(_targetAmountController.text) ?? 0,
        description: _descriptionController.text,
      );
      Navigator.pop(context, newMilestone);
    } else {
      // Show an error if fields are empty
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Please fill in all fields.')));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Create New Milestone')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextField(
              controller: _nameController,
              decoration: InputDecoration(labelText: 'Milestone Name'),
            ),
            SizedBox(height: 8),
            TextField(
              controller: _targetAmountController,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(labelText: 'Target Amount'),
            ),
            SizedBox(height: 8),
            TextField(
              controller: _descriptionController,
              decoration: InputDecoration(labelText: 'Description'),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: _saveMilestone,
              child: Text('Save Milestone'),
            ),
          ],
        ),
      ),
    );
  }
}
