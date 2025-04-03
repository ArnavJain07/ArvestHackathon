import 'dart:math'; // Import to use Random
import 'package:flutter/material.dart';
import '../models/milestone_model.dart';
import '../models/user_model.dart'; // Import UserModel
import '../services/financial_analysis_service.dart'; // Import FinancialAnalysisService
import 'scenario_planning_screen.dart'; // Ensure this is imported correctly
import 'new_milestone_screen.dart';

class MilestoneStorage {
  // Private constructor
  MilestoneStorage._privateConstructor();

  // Singleton instance
  static final MilestoneStorage _instance = MilestoneStorage._privateConstructor();

  // List to hold milestones
  final List<MilestoneModel> _milestones = [];

  static MilestoneStorage get instance => _instance; // Getter for the singleton instance

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
  final Random _random = Random(); // Random generator for user data

  // Store the random user
  late UserModel _randomUser;

  @override
  void initState() {
    super.initState();
    _randomUser = _generateRandomUser(); // Generate a random user
    _generatePastMilestones(); // Generate random past milestones when app opens
  }

  // Function to generate random user data
  UserModel _generateRandomUser() {
    double randomIncome = 30000 + _random.nextDouble() * 100000; 
    double randomSavings = _random.nextDouble() * 20000; 
    int randomCreditScore = 300 + _random.nextInt(550); 
    int randomAge = 18 + _random.nextInt(48); 

    return UserModel(
      name: 'John Doe',
      income: randomIncome,
      savings: randomSavings,
      creditScore: randomCreditScore,
      age: randomAge,
      goalHistory: [], // Provide an empty list for goalHistory
    );
  }

  // Function to generate random past milestones
  void _generatePastMilestones() {
    // Create a list with one achieved and one failed milestone
    List<Map<String, dynamic>> milestoneData = [
      {
        'name': 'Emergency Fund',
        'targetAmount': 5000.0,
        'description': 'Saved \$5,000 for emergencies.',
        'isAchieved': true
      },
      {
        'name': 'Car Purchase',
        'targetAmount': 20000.0,
        'description': 'Save \$20,000 for a car by next year.',
        'isAchieved': false
      },
    ];

    for (var data in milestoneData) {
      MilestoneModel milestone = MilestoneModel(
        name: data['name'],
        targetAmount: data['targetAmount'].toDouble(), // Ensure targetAmount is a double
        description: data['description'],
        isAchieved: data['isAchieved'],
        isAIGenerated: false,
        targetYears: 1 + _random.nextInt(4), // Random target year between 1 and 4
      );

      // Debugging output
      print("Adding milestone: ${milestone.name} with target amount: ${milestone.targetAmount}");

      MilestoneStorage.instance.addMilestone(milestone);
    }

    // Show a confirmation message to the user after the current frame
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'Past milestones created!',
            style: TextStyle(color: Colors.white),
          ),
          backgroundColor: Colors.green,
          duration: Duration(seconds: 3),
        ),
      );
    });
  }

  void _generateMilestoneWithAI() {
    // Show a loading indicator or a message while the AI goals are being generated
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Generating AI goals, please wait...'),
        duration: Duration(seconds: 1),
      ),
    );

    // Introduce a small delay before generating the goals
    Future.delayed(Duration(seconds: 2), () {
      // Generate AI-based goals based on the random user
      final generatedGoals = _financialService.generateGoalsBasedOnUserHistory(_randomUser);

      // Add each generated milestone to the storage
      for (var milestone in generatedGoals) {
        milestone = milestone.copyWith(description: _generateRealisticDescription(milestone)); // Use copyWith to create a new milestone with a realistic description
        _addNewMilestone(milestone);
      }

      // Show a confirmation message to the user after goals are generated
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'AI-generated goals created based on your financial history!',
            style: TextStyle(color: Colors.white),
          ),
          backgroundColor: Colors.green,
          duration: Duration(seconds: 3),
        ),
      );
    });
  }

  String _generateRealisticDescription(MilestoneModel milestone) {
    // Generate a realistic description based on the goal type
    switch (milestone.name) {
      case 'Home Purchase':
        return 'Save \$50,000 for a down payment on a house.';
      case 'Debt Reduction':
        return 'Pay off \$15,000 in credit card debt over the next year.';
      case 'Retirement Savings':
        return 'Contribute \$10,000 to your retirement account this year.';
      default:
        return 'Save money for your future needs.';
    }
  }

  void _addNewMilestone(MilestoneModel milestone) {
    setState(() {
      MilestoneStorage.instance.addMilestone(milestone); // Add the milestone to the storage
    });
  }

  @override
  Widget build(BuildContext context) {
    final milestones = MilestoneStorage.instance.milestones;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Select Your Milestone',
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
        child: milestones.isEmpty
            ? Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'No milestones added.',
                      style: TextStyle(fontSize: 20, color: Colors.white),
                    ),
                    SizedBox(height: 16),
                    Text(
                      'Click the plus to add one.',
                      style: TextStyle(fontSize: 16, color: Colors.white),
                    ),
                  ],
                ),
              )
            : ListView.builder(
                itemCount: milestones.length,
                itemBuilder: (context, index) {
                  final milestone = milestones[index];
                  final isAIGenerated = milestone.isAIGenerated;

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
                          color: Colors.black,
                        ),
                      ),
                      subtitle: Text(milestone.description),
                      trailing: Icon(Icons.arrow_forward),
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => ScenarioPlanningScreen(
                              user: _randomUser, // Pass the user to the ScenarioPlanningScreen
                              milestone: milestone,
                            ),
                          ),
                        );
                      },
                    ),
                  );
                },
              ),
      ),
      floatingActionButton: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          FloatingActionButton(
            heroTag: 'add_milestone',
            onPressed: () async {
              final result = await Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => NewMilestoneScreen(user: _randomUser),
                ),
              );

              if (result != null) {
                _addNewMilestone(result); // Add the new milestone if available
              }
            },
            tooltip: 'Add New Milestone',
            child: Icon(Icons.add),
          ),
          SizedBox(width: 16),
          FloatingActionButton(
            heroTag: 'generate_ai_goals',
            onPressed: _generateMilestoneWithAI,
            tooltip: 'Generate AI Goals',
            child: Icon(Icons.lightbulb),
          ),
        ],
      ),
    );
  }
}
