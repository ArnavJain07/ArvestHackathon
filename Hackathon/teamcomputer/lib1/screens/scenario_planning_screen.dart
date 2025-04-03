import 'package:flutter/material.dart';
import '../models/user_model.dart';
import '../models/milestone_model.dart';
import '../services/financial_analysis_service.dart';
import '../widgets/progress_tracker.dart';
import 'dart:math';

class ScenarioPlanningScreen extends StatefulWidget {
  final UserModel user = UserModel(name: 'John Doe', income: 60000, savings: 5000, creditScore: 700);
  final MilestoneModel milestone;

  ScenarioPlanningScreen({super.key, required this.milestone});

  @override
  _ScenarioPlanningScreenState createState() => _ScenarioPlanningScreenState();
}

class _ScenarioPlanningScreenState extends State<ScenarioPlanningScreen> {
  final FinancialAnalysisService _financialService = FinancialAnalysisService();

  final TextEditingController loanTermController = TextEditingController();
  final TextEditingController plannedSavingsAmountController = TextEditingController();
  final TextEditingController investmentReturnController = TextEditingController();
  final TextEditingController yearsController = TextEditingController();

  double? result;

  void calculateScenarios() {
    if (loanTermController.text.isEmpty || plannedSavingsAmountController.text.isEmpty ||
        investmentReturnController.text.isEmpty || yearsController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('Please fill in all fields before calculating the scenario.'),
        backgroundColor: Colors.red,
      ));
      return;
    }

    try {
      int loanTerm = int.parse(loanTermController.text);
      double plannedSavingsAmount = double.parse(plannedSavingsAmountController.text);
      double investmentReturn = double.parse(investmentReturnController.text) / 100;
      int years = int.parse(yearsController.text);

      double monthlyContribution = plannedSavingsAmount / loanTerm;

      double calculatedResult = _financialService.simulateInvestmentReturns(
        plannedSavingsAmount,
        monthlyContribution,
        investmentReturn,
        years,
      );

      setState(() {
        result = calculatedResult;
      });
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('Invalid input values! Please enter correct numbers.'),
        backgroundColor: Colors.red,
      ));
    }
  }

  @override
  Widget build(BuildContext context) {
    // Calculate progress
    double progress = widget.user.savings / widget.milestone.targetAmount;
    
    return Scaffold(
      appBar: AppBar(
        title: Text('Scenario Planning for ${widget.milestone.name}'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Plan Financial Scenarios', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            SizedBox(height: 16),
            ProgressTracker(progress: progress.clamp(0.0, 1.0)), // Show the progress tracker
            SizedBox(height: 16),
            TextField(
              controller: plannedSavingsAmountController,
              decoration: InputDecoration(labelText: 'Planned Savings Amount'),
              keyboardType: TextInputType.number,
            ),
            TextField(
              controller: loanTermController,
              decoration: InputDecoration(labelText: 'Loan Term (Years)'),
              keyboardType: TextInputType.number,
            ),
            TextField(
              controller: investmentReturnController,
              decoration: InputDecoration(labelText: 'Expected Annual Return (%)'),
              keyboardType: TextInputType.number,
            ),
            TextField(
              controller: yearsController,
              decoration: InputDecoration(labelText: 'Years for Investment'),
              keyboardType: TextInputType.number,
            ),
            SizedBox(height: 16),
            ElevatedButton(
              onPressed: calculateScenarios,
              child: Text('Calculate'),
            ),
            SizedBox(height: 16),
            if (result != null)
              Text(
                'Expected Returns: \$${result?.toStringAsFixed(2)}',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
          ],
        ),
      ),
    );
  }
}
