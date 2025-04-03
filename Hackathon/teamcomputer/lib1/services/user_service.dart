import '../models/user_model.dart';

class UserService {
  // Simulates fetching user data from a server or local storage
  Future<UserModel> getUser() async {
    return UserModel(
      name: 'John Doe',
      income: 60000,
      savings: 5000,
      creditScore: 700,
    );
  }
}
