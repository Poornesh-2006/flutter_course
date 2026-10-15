// One joke from https://official-joke-api.appspot.com/random_joke
// {"type":"general","setup":"...","punchline":"...","id":423}
class Joke {
  const Joke({required this.id, required this.type, required this.setup, required this.punchline});

  final int id;
  final String type;
  final String setup;
  final String punchline;

  factory Joke.fromJson(Map<String, dynamic> json) {
    return Joke(
      id: json['id'] as int,
      type: json['type'] as String,
      setup: json['setup'] as String,
      punchline: json['punchline'] as String,
    );
  }
}
