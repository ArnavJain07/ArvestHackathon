import 'package:flutter/material.dart';
import '../services/ai_service.dart'; // Import the AIService
import '../widgets/typing_indicator.dart'; // Import TypingIndicator

class Message {
  final String sender;
  final String text;

  Message(this.sender, this.text);
}

class ContactSupportScreen extends StatefulWidget {
  const ContactSupportScreen({super.key});

  @override
  _ContactSupportScreenState createState() => _ContactSupportScreenState();
}

class _ContactSupportScreenState extends State<ContactSupportScreen> {
  final TextEditingController _controller = TextEditingController();
  final List<Message> _messages = [];
  final AIService _aiService = AIService(); // Instantiate AIService
  bool _isTyping = false; // Variable to track if the AI is typing

  void _sendMessage() async {
    if (_controller.text.isNotEmpty) {
      String userMessage = _controller.text;

      // Add user's message to the messages list
      setState(() {
        _messages.add(Message("You", userMessage));
        _controller.clear();
      });

      // Set typing indicator to true
      setState(() {
        _isTyping = true;
      });

      // Get the AI response
      try {
        String aiResponse = await _aiService.getChatResponse(userMessage);
        
        // Add AI response to the messages list
        setState(() {
          _messages.add(Message("Rich", aiResponse));
          _isTyping = false; // Set typing indicator to false after response
        });
      } catch (e) {
        // Handle error (for example, show an error message)
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error: ${e.toString()}')),
        );

        // Make sure to stop the typing indicator in case of error
        setState(() {
          _isTyping = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Contact Support',
          style: TextStyle(
            color: Colors.white, // White color for text
            fontSize: 24, // Consistent font size
            fontFamily: 'KayPhoDu', // Bold font weight
          ),
        ),
        backgroundColor: Colors.blue.shade900, // Use a solid blue color for the AppBar
        centerTitle: true, // Center the title
      ),
      body: Container(
        decoration: BoxDecoration(
          color: Colors.blue[50], // Light blue background for the body
        ),
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Expanded(
              child: ListView.builder(
                itemCount: _messages.length + (_isTyping ? 1 : 0), // Add 1 if typing
                itemBuilder: (context, index) {
                  if (_isTyping && index == _messages.length) {
                    // Display typing indicator
                    return _buildTypingIndicator();
                  }

                  final message = _messages[index];

                  return Align(
                    alignment: message.sender == "You"
                        ? Alignment.centerRight // User messages on the right
                        : Alignment.centerLeft, // AI messages on the left
                    child: Container(
                      margin: const EdgeInsets.only(top: 4.0, bottom: 12.0),
                      padding: const EdgeInsets.all(10.0),
                      decoration: BoxDecoration(
                        color: message.sender == "You"
                            ? Colors.blue[200] // Light blue for user messages
                            : Colors.blue[300], // Darker blue for AI messages
                        borderRadius: BorderRadius.circular(8.0),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            message.sender,
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 14,
                              color: Colors.blue[900], // Dark blue for sender names
                            ),
                          ),
                          SizedBox(height: 4.0),
                          Text(
                            message.text,
                            style: TextStyle(fontSize: 16, color: Colors.black), // Black text color for messages
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
            TextField(
              controller: _controller,
              decoration: InputDecoration(
                labelText: 'Type your question...',
                labelStyle: TextStyle(color: Colors.blue[900]), // Dark blue for the label
                suffixIcon: IconButton(
                  icon: Icon(Icons.send, color: Colors.blue[900]), // Dark blue for the send icon
                  onPressed: _sendMessage, // Send message on button press
                ),
                enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.blue[900]!), // Dark blue for the border when enabled
                ),
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.blue[900]!), // Dark blue for the border when focused
                ),
              ),
              style: TextStyle(color: Colors.black), // Black text color for input
            ),
            SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  Widget _buildTypingIndicator() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: TypingIndicator(), // Use TypingIndicator widget here
    );
  }
}
