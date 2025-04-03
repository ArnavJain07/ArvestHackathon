import '../models/user_model.dart';
import '../models/milestone_model.dart';

class FinancialAnalysisService {
  String analyzeUserReadiness(UserModel user, MilestoneModel milestone) {
    if (user.savings >= milestone.targetAmount) {
      return "You are ready to achieve this milestone!";
    } else {
      double shortfall = milestone.targetAmount - user.savings;
      return "You need \$${shortfall.toStringAsFixed(2)} more to reach your target for ${milestone.name}.";
    }
  }

  double simulateInvestmentReturns(double initialAmount, double monthlyContribution, double annualReturnRate, int years) {
    double totalAmount = initialAmount;

    for (int year = 0; year < years; year++) {
      for (int month = 0; month < 12; month++) {
        totalAmount += monthlyContribution; // Add monthly contribution
        totalAmount *= (1 + annualReturnRate / 12); // Compound interest monthly
      }
    }

    return totalAmount; // Return the total amount after the investment period
  }

  List<MilestoneModel> generateGoalsBasedOnUserHistory(UserModel user) {
    List<MilestoneModel> generatedGoals = [];

    // Check if user has enough savings to create a basic savings goal
    if (user.savings < 1000) {
      generatedGoals.add(MilestoneModel(
        name: 'Save for Emergency Fund',
        targetAmount: 1000,
        description: 'Start building your emergency fund.',
      ));
    }

    // Generate a goal based on user's historical goals if available
    if (user.goalHistory.isNotEmpty) {
      double averageGoal = user.goalHistory
          .map((MilestoneModel goal) => goal.targetAmount) // Specify the type here
          .reduce((a, b) => a + b) / user.goalHistory.length;
      generatedGoals.add(MilestoneModel(
        name: 'Maintain Average Savings',
        targetAmount: averageGoal,
        description: 'Keep saving based on your average previous goals.',
      ));
    } else {
      // If there are no historical goals, suggest a default savings goal
      generatedGoals.add(MilestoneModel(
        name: 'Create Your First Savings Goal',
        targetAmount: 500,
        description: 'Start your savings journey with a simple goal.',
      ));
    }

    // Additional goal based on credit score
    if (user.creditScore < 650) {
      generatedGoals.add(MilestoneModel(
        name: 'Improve Credit Score',
        targetAmount: 700,
        description: 'Take steps to improve your credit score to 700.',
      ));
    }

    return generatedGoals;
  }
}
