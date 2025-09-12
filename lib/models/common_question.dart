class CommonQuestion {
  final String question;
  final String response;

  const CommonQuestion({required this.question, required this.response});

  Map<String, dynamic> get toMap {
    return {
      "question": question,
      "response": response,
    };
  }
}
