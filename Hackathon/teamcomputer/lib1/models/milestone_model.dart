class MilestoneModel {
  final String name;
  final double targetAmount;
  final String description;
  final bool? isAIGenerated; // New field to identify AI-generated milestones

  MilestoneModel({
    required this.name,
    required this.targetAmount,
    required this.description,
    this.isAIGenerated = false, // Default to false for non-AI milestones
  });
}
