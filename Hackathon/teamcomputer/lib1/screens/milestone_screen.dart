import 'package:flutter/material.dart';
import '../models/milestone_model.dart';
import '../models/user_model.dart'; // Import UserModel
import '../services/financial_analysis_service.dart'; // Import FinancialAnalysisService
import 'scenario_planning_screen.dart';
import 'new_milestone_screen.dart';

class MilestoneStorage {
  MilestoneStorage._privateConstructor();
  static final MilestoneStorage _instance = MilestoneStorage._privateConstructor();
  factory MilestoneStorage() => _instance;

  final List<MilestoneModel> _milestones = [];
  List<MilestoneModel> get milestones => _milestones;

  void addMilestone(MilestoneModel milestone) {
    _milestones.add(milestone);
  }
}

class MilestoneScreen extends StatefulWidget {
  const MilestoneScreen({super.key});

  @override
  _MilestoneScreenState createState() => _MilestoneScreenState();
}

class _MilestoneScreenState extends State<MilestoneScreen> {
  final FinancialAnalysisService _financialService = FinancialAnalysisService(); // Initialize the financial service

  void _addNewMilestone(MilestoneModel milestone) {
    setState(() {
      MilestoneStorage().addMilestone(milestone);
    });
  }

  void _generateMilestoneWithAI() {
    // Replace with actual user data retrieval
    final user = UserModel(
      name: 'John Doe',
      income: 60000,
      savings: 5000,
      creditScore: 700,
      goalHistory: [], // Populate this with the actual user's goal history
    );

    final generatedGoals = _financialService.generateGoalsBasedOnUserHistory(user);
    
    for (var milestone in generatedGoals) {
      _addNewMilestone(milestone);
    }

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          'AI-generated goals have been created based on your financial history!',
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: Colors.green,
        duration: Duration(seconds: 3),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final milestones = MilestoneStorage().milestones;

    return Scaffold(
      appBar: AppBar(title: Text('Select Your Milestone')),
      body: milestones.isEmpty
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text('No milestones added.', style: TextStyle(fontSize: 20)),
                  SizedBox(height: 16),
                  Text('Click the plus to add one.', style: TextStyle(fontSize: 16)),
                ],
              ),
            )
          : ListView.builder(
              itemCount: milestones.length,
              itemBuilder: (context, index) {
                final milestone = milestones[index];
                final isAIGenerated = milestone.isAIGenerated ?? false;

                return Card(
                  color: isAIGenerated ? Colors.lightBlueAccent.shade100 : Colors.white,
                  elevation: 3,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                  child: ListTile(
                    leading: Icon(
                      isAIGenerated ? Icons.lightbulb : Icons.flag,
                      color: isAIGenerated ? Colors.orangeAccent : Colors.grey,
                    ),
                    title: Text(
                      milestone.name,
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: isAIGenerated ? Colors.orange : Colors.black,
                      ),
                    ),
                    subtitle: Text(milestone.description),
                    trailing: Icon(Icons.arrow_forward),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => ScenarioPlanningScreen(milestone: milestone),
                        ),
                      );
                    },
                  ),
                );
              },
            ),
      floatingActionButton: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          FloatingActionButton(
            onPressed: () async {
              final newMilestone = await Navigator.push<MilestoneModel>(
                context,
                MaterialPageRoute(builder: (context) => NewMilestoneScreen()),
              );
              if (newMilestone != null) {
                _addNewMilestone(newMilestone);
              }
            },
            tooltip: 'Add New Milestone',
            heroTag: 'addMilestoneFAB',
            child: Icon(Icons.add),
          ),
          SizedBox(height: 16),
          FloatingActionButton(
            onPressed: _generateMilestoneWithAI,
            tooltip: 'Generate Milestone with AI',
            backgroundColor: Colors.orangeAccent,
            heroTag: 'generateMilestoneWithAIFAB',
            child: Icon(Icons.lightbulb),
          ),
        ],
      ),
    );
  }
}
