import 'milestone_model.dart';

// user_model.dart
class UserModel {
  final String name;
  final double income;
  final double savings;
  final int creditScore;
  final int age;
  final List<MilestoneModel> goalHistory; // Add this line

  UserModel({
    required this.name,
    required this.income,
    required this.savings,
    required this.creditScore,
    required this.age,
    required this.goalHistory, // Ensure this is in the constructor
  });
}

