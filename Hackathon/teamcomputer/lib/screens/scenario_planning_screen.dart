import 'package:flutter/material.dart';
import '../models/milestone_model.dart';
import '../models/user_model.dart';

class ScenarioPlanningScreen extends StatelessWidget {
  final UserModel user;
  final MilestoneModel milestone;

  const ScenarioPlanningScreen({
    super.key,
    required this.user,
    required this.milestone,
  });

  // Function to generate a personalized achievement plan
  String _generateAchievementPlan() {
    // You can customize this plan generation logic based on user and milestone attributes
    String plan = 'To achieve your goal of "${milestone.name}", consider the following steps:\n\n';

    // Basic structure of the plan based on milestone
    plan += '1. Assess your current financial situation:\n';
    plan += '   - Income: \$${user.income.toStringAsFixed(2)}\n';
    plan += '   - Savings: \$${user.savings.toStringAsFixed(2)}\n';
    plan += '   - Credit Score: ${user.creditScore}\n';
    plan += '   - Age: ${user.age}\n\n';

    double remainingAmount = milestone.targetAmount - user.savings;

    // Ensure remainingAmount is positive before proceeding
    if (remainingAmount > 0) {
      double monthsNeeded = (remainingAmount > 0) ? 12 : 1; // Default to 1 month if remaining amount is greater than 0
      double monthlySavings = (remainingAmount / monthsNeeded).clamp(0.01, double.infinity); // Ensure a minimum value for monthly savings
      plan += '2. Set a monthly savings target:\n';
      plan += '   - You need to save approximately \$${monthlySavings.toStringAsFixed(2)} per month to reach your goal in 1 year.\n\n';
    } else {
      plan += '2. Congratulations! You have already achieved your savings goal.\n\n';
    }

    plan += '3. Create a budget:\n';
    plan += '   - Track your monthly expenses and find areas to cut back.\n';
    plan += '   - Consider using budgeting apps or financial advisors for better management.\n\n';

    plan += '4. Monitor your progress:\n';
    plan += '   - Check your savings regularly and adjust your plan as needed.\n';
    plan += '   - Celebrate small achievements to stay motivated.\n';

    return plan;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Achievement Planning'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'User: ${user.name}',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 16),
            Text(
              'Milestone: ${milestone.name}',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 8),
            Text('Description: ${milestone.description}'),
            SizedBox(height: 8),
            Text('Target Amount: \$${milestone.targetAmount}'),
            SizedBox(height: 8),
            Text('Achieved: ${milestone.isAchieved ? "Yes" : "No"}'),
            SizedBox(height: 16),
            // Display "Congratulations" if the milestone is achieved, otherwise show the Achievement Plan button
            milestone.isAchieved 
              ? Text(
                  'Congratulations!',
                  style: TextStyle(fontSize: 24, color: Colors.green, fontWeight: FontWeight.bold),
                )
              : ElevatedButton(
                  onPressed: () {
                    // Show a dialog with the dynamically generated achievement plan
                    showDialog(
                      context: context,
                      builder: (context) {
                        return Dialog( // Use Dialog to provide a full-screen look
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Container(
                            width: double.maxFinite,
                            constraints: BoxConstraints(maxHeight: 600), // Increased maximum height
                            child: Column(
                              children: [
                                Padding(
                                  padding: const EdgeInsets.all(16.0),
                                  child: Text(
                                    'Achievement Plan for ${milestone.name}',
                                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                                  ),
                                ),
                                Expanded(
                                  child: SingleChildScrollView(
                                    child: Padding(
                                      padding: const EdgeInsets.symmetric(horizontal: 16.0),
                                      child: Text(_generateAchievementPlan()), // Use the new plan generation function
                                    ),
                                  ),
                                ),
                                TextButton(
                                  onPressed: () {
                                    Navigator.of(context).pop();
                                  },
                                  child: Text('Close'),
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    );
                  },
                  child: Text('View Achievement Plan'),
                ),
          ],
        ),
      ),
    );
  }
}
