
class AIService {
  final String apiUrl = 'https://api.openai.com/v1/chat/completions'; // Your actual API URL
  final String apiKey = ''; // Your actual API Key

  // Simulated responses based on keywords
  String getResponseBasedOnKeywords(String message) {
    final lowerMessage = message.toLowerCase();

    if (lowerMessage.contains('buying a home')) {
      return "It's important to consider your mortgage options and down payment. Typically, you should save at least 20% of the home's price.";
    } else if (lowerMessage.contains('saving for college')) {
      return "A common recommendation is to aim for about \$10,000 per year. Consider 529 plans for tax advantages!";
    } else if (lowerMessage.contains('retirement')) {
      return "Start contributing to a retirement fund as early as possible. Aim for at least 15% of your income.";
    } else if (lowerMessage.contains('financial advice')) {
      return "It's wise to consult a financial advisor for personalized guidance based on your financial situation.";
    } else if (lowerMessage.contains('budgeting tips')) {
      return "A good budgeting strategy is the 50/30/20 rule: allocate 50% of your income to needs, 30% to wants, and 20% to savings.";
    } else if (lowerMessage.contains('milestone progress')) {
      return "To track your progress, consider setting monthly savings goals and reviewing them regularly to stay on track.";
    } else if (lowerMessage.contains('milestone issues')) {
      return "Common issues include unexpected expenses or changes in income. It's essential to revisit your budget and adjust your goals as needed.";
    } else if (lowerMessage.contains('financial tips')) {
      return "Regularly review your expenses, avoid high-interest debt, and make saving a priority to build a healthy financial future.";
    } else if (lowerMessage.contains('hello') || lowerMessage.contains('hi') || lowerMessage.contains('hey')) {
      return "Hi, how can I assist you today?";
    } else {
      return "I'm not sure how to help with that. Can you ask about budgeting tips, milestone progress, or general financial advice?";
    }
  }

  Future<String> getChatResponse(String message) async {
    // Simulate a thinking delay
    await Future.delayed(Duration(seconds: 2));

    // Try to get a response based on keywords first
    String keywordResponse = getResponseBasedOnKeywords(message);

    // Return the response
    return keywordResponse;

    // Uncomment below if you want to make an actual API call for fallback
    /*
    final response = await http.post(
      Uri.parse(apiUrl),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $apiKey',
      },
      body: json.encode({
        'model': 'gpt-3.5-turbo', // Adjust according to your model
        'messages': [
          {'role': 'user', 'content': message}
        ],
      }),
    );

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      return data['choices'][0]['message']['content'];
    } else {
      final errorData = json.decode(response.body);
      throw Exception('Failed to load response: ${errorData['error']['message']}');
    }
    */
  }
}
