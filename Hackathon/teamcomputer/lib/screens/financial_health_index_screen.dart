import 'package:flutter/material.dart';
import '../services/financial_analysis_service.dart';

class FinancialHealthIndexScreen extends StatefulWidget {
  const FinancialHealthIndexScreen({super.key});

  @override
  _FinancialHealthIndexScreenState createState() => _FinancialHealthIndexScreenState();
}

class _FinancialHealthIndexScreenState extends State<FinancialHealthIndexScreen> {
  final FinancialAnalysisService _financialService = FinancialAnalysisService();

  final TextEditingController loanTermController = TextEditingController();
  final TextEditingController plannedSavingsAmountController = TextEditingController();
  final TextEditingController investmentReturnController = TextEditingController();
  final TextEditingController yearsController = TextEditingController();

  double? result;

  void calculateFinancialHealth() {
    if (loanTermController.text.isEmpty ||
        plannedSavingsAmountController.text.isEmpty ||
        investmentReturnController.text.isEmpty ||
        yearsController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('Please fill in all fields before calculating.'),
        backgroundColor: Colors.red,
      ));
      return;
    }

    try {
      double plannedSavingsAmount = double.parse(plannedSavingsAmountController.text);
      int loanTermYears = int.parse(loanTermController.text);
      // Parse investment return as double
      double investmentReturn = double.parse(investmentReturnController.text); // Keep it as double
      int investmentYears = int.parse(yearsController.text);

      // Calculate monthly contribution needed to reach the planned savings goal
      double monthlyContribution = plannedSavingsAmount / (loanTermYears * 12);

      // Calculate the expected future value using the financial analysis service
      double futureValue = _financialService.simulateInvestmentReturns(
        plannedSavingsAmount, // Principal
        investmentReturn,     // Annual interest rate (as a double)
        1,                    // Compounding frequency (compounded annually)
        investmentYears,      // Investment period in years
      );

      // Calculate the amount of money that will grow (future value - planned savings)
      double growthAmount = futureValue - plannedSavingsAmount;

      setState(() {
        result = growthAmount; // Set result to the growth amount
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
    return Scaffold(
      appBar: AppBar(
        title: Text('Financial Savings Calculator'),
        backgroundColor: Colors.blue.shade900,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Calculate Your Financial Savings', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            SizedBox(height: 16),
            TextField(
              controller: plannedSavingsAmountController,
              decoration: InputDecoration(
                labelText: 'Total Savings Goal (e.g., 5000)',
                hintText: 'Enter the amount you plan to save',
              ),
              keyboardType: TextInputType.number,
            ),
            TextField(
              controller: loanTermController,
              decoration: InputDecoration(
                labelText: 'Loan or Investment Period (in Years)',
                hintText: 'Enter the number of years for this plan',
              ),
              keyboardType: TextInputType.number,
            ),
            TextField(
              controller: investmentReturnController,
              decoration: InputDecoration(
                labelText: 'Expected Annual Interest Rate (%)',
                hintText: 'Enter the yearly growth rate (e.g., 5%)',
              ),
              keyboardType: TextInputType.number,
            ),
            TextField(
              controller: yearsController,
              decoration: InputDecoration(
                labelText: 'Number of Years for Investment Growth',
                hintText: 'Enter the years you’ll invest or grow savings',
              ),
              keyboardType: TextInputType.number,
            ),
            SizedBox(height: 16),
            ElevatedButton(
              onPressed: calculateFinancialHealth,
              child: Text('Calculate'),
            ),
            SizedBox(height: 16),
            if (result != null)
              Text(
                'Expected Return Amount: \$${result?.toStringAsFixed(2)}',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
          ],
        ),
      ),
    );
  }
}
