class DeckItem {
  final String title;
  final DateTime time;

  const DeckItem({
    required this.title,
    required this.time,
  });

  factory DeckItem.fromJson(Map json) {
    return DeckItem(
      title: json['title'],
      time: DateTime.parse(json['time']),
    );
  }

  Map toJson() {
    return {
      'title': title,
      'time': time.toString(),
    };
  }
}
