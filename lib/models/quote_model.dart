class Quote {
  String quoteText;
  int id;

  Quote({this.quoteText});
  Quote.withId({this.id, this.quoteText});

  factory Quote.fromJson(List<dynamic> json) {
    return Quote(quoteText: json[0]['text']);
  }

  factory Quote.fromMap(Map<String, dynamic> map) {
    return Quote.withId(id: map['id'], quoteText: map['quoteText']);
  }

  Map<String, dynamic> toMap() {
    final map = Map<String, dynamic>();
    if (id != null) {
      map['id'] = id;
    }
    map['quote_text'] = quoteText;
    return map;
  }
}
