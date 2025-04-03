import 'package:flutter/material.dart';
import '../models/user_model.dart';
import '../services/user_service.dart';
import 'milestone_screen.dart';
import 'contact_support_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final UserService _userService = UserService();
  UserModel? _user;

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  void _loadUserData() async {
    UserModel user = await _userService.getUser();
    setState(() {
      _user = user;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('MilestoneMap')),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              const Color.fromARGB(255, 20, 88, 156),
              const Color.fromARGB(255, 6, 25, 53),
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: _user == null
            ? Center(child: CircularProgressIndicator())
            : Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'Welcome, ${_user!.name}!',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 24, // Increased font size
                        fontWeight: FontWeight.bold, // Optional: make it bold
                      ),
                    ),
                    SizedBox(height: 20), // Add some space below the welcome message
                    SizedBox(height: 20),
                    ElevatedButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => MilestoneScreen()),
                        );
                      },
                      child: Text('Start Milestone Planning'),
                    ),
                    SizedBox(height: 20),
                    ElevatedButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => ContactSupportScreen()),
                        );
                      },
                      child: Text('Contact Support'),
                    ),
                  ],
                ),
              ),
      ),
    );
  }
}
