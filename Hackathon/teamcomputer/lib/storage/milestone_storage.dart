import '../models/milestone_model.dart';

class MilestoneStorage {
  // Singleton instance
  static final MilestoneStorage _instance = MilestoneStorage._internal();
  
  // Private constructor
  MilestoneStorage._internal();

  // Factory constructor for singleton access
  factory MilestoneStorage() {
    return _instance;
  }

  // Getter to access the singleton instance
  static MilestoneStorage get instance => _instance;

  final List<MilestoneModel> _milestones = [];

  // Getter to return an unmodifiable list of milestones
  List<MilestoneModel> get milestones => List.unmodifiable(_milestones);

  // Method to add a milestone to storage
  void addMilestone(MilestoneModel milestone) {
    _milestones.add(milestone);
    // Here you could implement saving to persistent storage if needed
    print("Milestone added: ${milestone.name}");
  }

  // Method to remove a milestone from storage
  void removeMilestone(MilestoneModel milestone) {
    _milestones.remove(milestone);
    // Implement any necessary actions after removal, e.g., saving changes
    print("Milestone removed: ${milestone.name}");
  }

  // Method to retrieve all milestones
  List<MilestoneModel> getAllMilestones() {
    return List.from(_milestones);
  }

  // Optionally, you can implement more methods as needed
  // For example: findMilestoneById, updateMilestone, etc.
}
