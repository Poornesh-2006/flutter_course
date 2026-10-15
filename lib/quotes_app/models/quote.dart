// One quote from https://dummyjson.com/quotes
// {"id":1,"quote":"Your heart is the size of an ocean...","author":"Rumi"}
class Quote {
  const Quote({required this.id, required this.text, required this.author});

  final int id;
  final String text;
  final String author;

  // JSON → Quote (reading from the API, and from storage).
  factory Quote.fromJson(Map<String, dynamic> json) {
    return Quote(
      id: json['id'] as int,
      text: json['quote'] as String,
      author: json['author'] as String,
    );
  }

  // Quote → JSON (saving to storage). Same keys as the API, so fromJson reads both.
  Map<String, dynamic> toJson() => {'id': id, 'quote': text, 'author': author};
}
