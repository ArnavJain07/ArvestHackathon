import 'milestone_model.dart'; // Ensure this import is added

class UserModel {
  String name;
  double income;
  double savings;
  int creditScore;
  List<MilestoneModel> goalHistory; // To track past milestones

  UserModel({
    required this.name,
    required this.income,
    required this.savings,
    required this.creditScore,
    this.goalHistory = const [], // Default to an empty list
  });
}
