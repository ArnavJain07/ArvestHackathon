import 'package:flutter/material.dart';
import '../models/user_model.dart';
import '../services/user_service.dart';
import 'milestone_screen.dart';
import 'contact_support_screen.dart';
import 'financial_health_index_screen.dart'; // Import the new screen

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
      appBar: AppBar(
        toolbarHeight: 69,
        backgroundColor: Colors.blue.shade900,
        centerTitle: true,
        title: Text(
          'MilestoneMap',
          style: TextStyle(
            fontSize: 30,
            fontFamily: 'KayPhoDu',
            color: Colors.white,
          ),
        ),
      ),
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
                    SizedBox(
                      height: 150,
                      width: 440,
                      child: Image.asset(
                        'lib/assets/images/homepagestock.png',
                        fit: BoxFit.cover,
                      ),
                    ),
                    SizedBox(height: 20),
                    Text(
                      'Welcome, ${_user!.name}!',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 20),
                    _buildButton(
                      context,
                      'Start Milestone Planning',
                      MilestoneScreen(),
                    ),
                    SizedBox(height: 20),
                    _buildButton(
                      context,
                      'Financial Savings Calculator', // New button
                      FinancialHealthIndexScreen(),
                    ),
                    SizedBox(height: 20),
                    _buildButton(
                      context,
                      'RichBot',
                      ContactSupportScreen(),
                    ),
                    
                  ],
                ),
              ),
      ),
    );
  }

  Widget _buildButton(BuildContext context, String title, Widget targetScreen) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.blue[900],
        foregroundColor: Colors.white,
        padding: EdgeInsets.symmetric(horizontal: 40, vertical: 15),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
          side: BorderSide(color: Colors.blue[900]!),
        ),
      ),
      child: Text(
        title,
        style: TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.bold,
        ),
      ),
      onPressed: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => targetScreen),
        );
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Navigating to $title')),
        );
      },
    );
  }
}
