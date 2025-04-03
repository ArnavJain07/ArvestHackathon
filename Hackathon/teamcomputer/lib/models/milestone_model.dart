class MilestoneModel {
  final String name;
  final String description;
  final double targetAmount;
  final bool isAchieved;
  final bool isAIGenerated;
  final int targetYears;

  MilestoneModel({
    required this.name,
    required this.description,
    required this.targetAmount,
    required this.isAchieved,
    required this.isAIGenerated,
    this.targetYears = 1, // Default value for targetYears
  });

  MilestoneModel copyWith({
    String? name,
    String? description,
    double? targetAmount,
    bool? isAchieved,
    bool? isAIGenerated,
    int? targetYears,
  }) {
    return MilestoneModel(
      name: name ?? this.name,
      description: description ?? this.description,
      targetAmount: targetAmount ?? this.targetAmount,
      isAchieved: isAchieved ?? this.isAchieved,
      isAIGenerated: isAIGenerated ?? this.isAIGenerated,
      targetYears: targetYears ?? this.targetYears,
    );
  }
}
