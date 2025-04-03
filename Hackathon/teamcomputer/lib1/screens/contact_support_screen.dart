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
          _messages.add(Message("Richard", aiResponse));
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
      appBar: AppBar(title: Text('Contact Support')),
      body: Padding(
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
                  final isSender = index == 0 || message.sender != _messages[index - 1].sender;

                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      if (isSender)
                        Text(
                          message.sender,
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 14,
                          ),
                        ),
                      Container(
                        margin: const EdgeInsets.only(top: 4.0, bottom: 12.0),
                        padding: const EdgeInsets.all(10.0),
                        decoration: BoxDecoration(
                          color: message.sender == "You" ? Colors.blue[100] : Colors.grey[300], // Different background for user and AI
                          borderRadius: BorderRadius.circular(8.0),
                        ),
                        child: Text(
                          message.text,
                          style: TextStyle(fontSize: 16),
                        ),
                      ),
                    ],
                  );
                },
              ),
            ),
            TextField(
              controller: _controller,
              decoration: InputDecoration(
                labelText: 'Type your question...',
                suffixIcon: IconButton(
                  icon: Icon(Icons.send),
                  onPressed: _sendMessage, // Send message on button press
                ),
              ),
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
