import '../models/user_model.dart';
import '../models/milestone_model.dart';
import 'dart:math';

class FinancialAnalysisService {
  final Random _random = Random();

  // List of realistic goal names
  List<String> realisticGoalNames = [
    'Home Purchase',
    'Debt Repayment',
    'Vacation Fund',
    'Education Savings',
    'Retirement Fund',
    'Investment Portfolio',
  ];

  String analyzeUserReadiness(UserModel user, MilestoneModel milestone) {
    if (user.savings >= milestone.targetAmount) {
      return "You are ready to achieve this milestone!";
    } else {
      double shortfall = milestone.targetAmount - user.savings;
      return "You need \$${shortfall.toStringAsFixed(2)} more to reach your target for ${milestone.name}.";
    }
  }

  double simulateInvestmentReturns(double principal, double annualRate, int compoundingFrequency, int years) {
    // Convert annual rate to decimal
    double r = annualRate / 100; // Convert percentage to decimal

    // Apply the future value formula for compound interest
    double futureValue = principal * pow((1 + (r / compoundingFrequency)), (compoundingFrequency * years));

    return futureValue; // Return the total future value after the investment period
  }

  List<MilestoneModel> generateGoalsBasedOnUserHistory(UserModel user) {
    List<MilestoneModel> generatedGoals = [];
    
    // Retrieve user history
    List<MilestoneModel> pastGoals = user.goalHistory;

    int achievedGoals = pastGoals.where((goal) => goal.isAchieved == true).length;
    int totalGoals = pastGoals.length;

    double achievementRate = totalGoals > 0 ? (achievedGoals / totalGoals) : 1.0;

    // Adjust goal difficulty based on past achievement
    double targetAmount = (1 + (1 - achievementRate)) * 10000; 

    // Select a random realistic goal name
    String goalName = realisticGoalNames[_random.nextInt(realisticGoalNames.length)];

    generatedGoals.add(MilestoneModel(
      name: goalName,
      targetAmount: targetAmount,
      description: 'This milestone is generated based on your financial goals and current progress.',
      isAchieved: false,  // Set to false since this is a generated goal
      isAIGenerated: true,
    ));

    return generatedGoals;
  }

  // Function to create random past goals
  List<MilestoneModel> createRandomPastGoals() {
    List<MilestoneModel> pastGoals = [];

    int numberOfGoals = _random.nextInt(6) + 3; // Create between 3 and 8 goals

    for (int i = 0; i < numberOfGoals; i++) {
      double targetAmount = 5000 + _random.nextDouble() * 25000; // Target between 5k and 30k
      bool isAchieved = _random.nextBool();

      pastGoals.add(
        MilestoneModel(
          name: 'Past Milestone ${i + 1}',
          targetAmount: targetAmount,
          description: 'A random past milestone with a target of \$${targetAmount.toStringAsFixed(2)}.',
          isAchieved: isAchieved,
          isAIGenerated: false, // Set to false for past milestones
        ),
      );
    }

    return pastGoals;
  }

  // Method to add random past goals to a user's goal history
  void addRandomPastGoalsToUser(UserModel user) {
    List<MilestoneModel> pastGoals = createRandomPastGoals();
    user.goalHistory.addAll(pastGoals); // Add the generated past goals to the user's goal history
  }
}
