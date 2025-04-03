import 'package:flutter/material.dart';
import '../models/milestone_model.dart';
import '../models/user_model.dart';
import '../services/financial_analysis_service.dart';
import '../storage/milestone_storage.dart';

class NewMilestoneScreen extends StatefulWidget {
  final UserModel user;

  const NewMilestoneScreen({super.key, required this.user});

  @override
  _NewMilestoneScreenState createState() => _NewMilestoneScreenState();
}

class _NewMilestoneScreenState extends State<NewMilestoneScreen> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _targetAmountController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final FinancialAnalysisService _financialAnalysisService = FinancialAnalysisService();
  List<MilestoneModel> generatedGoals = [];

  void _saveMilestone() {
    if (_nameController.text.isNotEmpty && 
        _targetAmountController.text.isNotEmpty && 
        _descriptionController.text.isNotEmpty) {
      double? targetAmount = double.tryParse(_targetAmountController.text);
      if (targetAmount != null && targetAmount > 0) {
        final newMilestone = MilestoneModel(
          name: _nameController.text,
          targetAmount: targetAmount,
          description: _descriptionController.text,
          isAchieved: false,
          isAIGenerated: false,
        );

        // Save the new milestone to storage
        MilestoneStorage.instance.addMilestone(newMilestone);
        Navigator.pop(context, newMilestone); // Return the new milestone

        // Clear text fields after saving
        _nameController.clear();
        _targetAmountController.clear();
        _descriptionController.clear();
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Please enter a valid target amount greater than zero.')),
        );
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Please fill in all fields.')),
      );
    }
  }

  void _generateAIGoal() {
    setState(() {
      generatedGoals = _financialAnalysisService.generateGoalsBasedOnUserHistory(widget.user);
    });
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('AI-generated goals have been created!')),
    );
  }

  void _saveAIGoal(MilestoneModel goal) {
    // Save the AI-generated goal to the storage
    MilestoneStorage.instance.addMilestone(goal);
    Navigator.pop(context, goal); // Save the selected AI-generated goal
  }

  @override
  void initState() {
    super.initState();
    _generatePastMilestones(); // Ensure to generate past milestones
  }

  void _generatePastMilestones() {
    List<MilestoneModel> milestones = [];

    // Example of generating past milestones
    milestones.add(MilestoneModel(
      name: 'Milestone 1',
      targetAmount: 1000.0,
      description: 'First savings milestone',
      isAchieved: true,
      isAIGenerated: false,
    ));

    milestones.add(MilestoneModel(
      name: 'Milestone 2',
      targetAmount: 500.0,
      description: 'Second savings milestone',
      isAchieved: false,
      isAIGenerated: false,
    ));

    // Debugging output
    for (var milestone in milestones) {
      print("Generated milestone: ${milestone.name} with target amount: ${milestone.targetAmount}");
    }

    // Add these milestones to your storage
    for (var milestone in milestones) {
      MilestoneStorage.instance.addMilestone(milestone);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Create New Milestone',
          style: TextStyle(
            color: Colors.white,
            fontSize: 24,
            fontFamily: 'KayPhoDu',
          ),
        ),
        backgroundColor: Colors.blue.shade900,
        centerTitle: true,
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              const Color.fromARGB(255, 16, 87, 146),
              const Color.fromARGB(255, 6, 37, 84),
            ],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextField(
              controller: _nameController,
              decoration: InputDecoration(
                labelText: 'Milestone Name',
                labelStyle: TextStyle(color: Colors.white), // Set label color to white
              ),
              style: TextStyle(color: Colors.white), // Set text color to white
            ),
            SizedBox(height: 8),
            TextField(
              controller: _targetAmountController,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                labelText: 'Target Amount',
                labelStyle: TextStyle(color: Colors.white), // Set label color to white
              ),
              style: TextStyle(color: Colors.white), // Set text color to white
            ),
            SizedBox(height: 8),
            TextField(
              controller: _descriptionController,
              decoration: InputDecoration(
                labelText: 'Description',
                labelStyle: TextStyle(color: Colors.white), // Set label color to white
              ),
              style: TextStyle(color: Colors.white), // Set text color to white
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: _saveMilestone,
              child: Text('Save Milestone'),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: _generateAIGoal,
              child: Text('Generate AI Goal'),
            ),
            SizedBox(height: 20),
            Expanded(
              child: ListView.builder(
                itemCount: generatedGoals.length,
                itemBuilder: (context, index) {
                  final goal = generatedGoals[index];
                  return ListTile(
                    title: Text(goal.name, style: TextStyle(color: Colors.white)), // Set text color to white
                    subtitle: Text('Target Amount: \$${goal.targetAmount.toStringAsFixed(2)}', style: TextStyle(color: Colors.white)), // Set text color to white
                    trailing: ElevatedButton(
                      onPressed: () => _saveAIGoal(goal),
                      child: Text('Save'),
                    ),
                  );
                },
              ),
            ),
            if (generatedGoals.isEmpty) 
              Center(child: Text('No AI-generated goals available.', style: TextStyle(color: Colors.white))), // Set text color to white
          ],
        ),
      ),
    );
  }
}
