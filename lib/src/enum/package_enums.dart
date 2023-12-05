enum CollapsedCardPosition {
  front(0.0),
  middle(0.1),
  rear(0.2);

  const CollapsedCardPosition(this._value);
  final double _value;

  double get position => _value;
}
