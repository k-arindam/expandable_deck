library expandable_deck;

import 'package:expandable_deck/src/data/constants.dart';
import 'package:expandable_deck/src/models/deck_item.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

enum CollapsedCardPosition {
  front(0.0),
  middle(0.1),
  rear(0.2);

  const CollapsedCardPosition(this._value);
  final double _value;

  double get position => _value;
}

class ExpandableDeck extends StatefulWidget {
  final List<DeckItem> items;

  const ExpandableDeck({
    super.key,
    required this.items,
  }) : assert(items.length == 3, "Three DeckItems() must be provided!");

  @override
  State<ExpandableDeck> createState() => _ExpandableDeckState();
}

class _ExpandableDeckState extends State<ExpandableDeck>
    with SingleTickerProviderStateMixin {
  late final AnimationController _animationController;

  @override
  void initState() {
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 200),
    );

    super.initState();
  }

  Color _generateCardColor(CollapsedCardPosition position) {
    switch (position) {
      case CollapsedCardPosition.front:
        return Constants.kBlack;

      case CollapsedCardPosition.middle:
        return Constants.kGreen;

      case CollapsedCardPosition.rear:
        return Constants.kGrey;
    }
  }

  DeckItem _generateItem(CollapsedCardPosition position) {
    switch (position) {
      case CollapsedCardPosition.front:
        return widget.items.first;

      case CollapsedCardPosition.middle:
        return widget.items[1];

      case CollapsedCardPosition.rear:
        return widget.items.last;
    }
  }

  Widget _buildCollapsedCard(CollapsedCardPosition position) {
    final item = _generateItem(position);

    return Transform.scale(
      scale: 1.0 - (position.position * (1.0 - _animationController.value)),
      child: Container(
        height: 80 + (_animationController.value * 50),
        width: double.maxFinite,
        margin: const EdgeInsets.all(5.0),
        padding: const EdgeInsets.symmetric(vertical: 5.0, horizontal: 15.0),
        decoration: BoxDecoration(
          color: _generateCardColor(position),
          borderRadius: BorderRadius.circular(30.0),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              item.title,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                  color: Constants.kWhite,
                  fontSize: 20.0 -
                      (75.0 *
                          position.position *
                          (1.0 - _animationController.value))),
            ),
            if (_animationController.value > 0.7) ...{
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 3.0),
                child: Row(
                  children: [
                    const Icon(
                      Icons.calendar_today_rounded,
                      color: Constants.kWhite,
                      size: 14.0,
                    ),
                    const SizedBox(width: 5.0),
                    Text(
                      DateFormat("dd MMMM yyyy").format(item.time),
                      style: const TextStyle(color: Constants.kWhite),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 3.0),
                child: Row(
                  children: [
                    const Icon(
                      Icons.schedule_rounded,
                      color: Constants.kWhite,
                      size: 14.0,
                    ),
                    const SizedBox(width: 5.0),
                    Text(
                      DateFormat("hh:mm a").format(item.time),
                      style: const TextStyle(color: Constants.kWhite),
                    ),
                  ],
                ),
              ),
            },
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _animationController,
      builder: (context, _) {
        return Container(
          height: 125 + (315 * _animationController.value),
          width: double.maxFinite,
          margin: const EdgeInsets.all(8.0),
          padding: const EdgeInsets.all(5.0),
          child: GestureDetector(
            onVerticalDragEnd: (details) {
              final drag = details.primaryVelocity;

              if (drag == null || _animationController.isAnimating) return;

              if (drag > 0 && !_animationController.isCompleted) {
                debugPrint("Unfolding Stack !!!");
                _animationController.forward();
              }

              if (drag < 0 && _animationController.isCompleted) {
                debugPrint("Folding Stack !!!");
                _animationController.reverse();
              }
            },
            child: Stack(
              alignment: Alignment.bottomCenter,
              clipBehavior: Clip.antiAlias,
              children: CollapsedCardPosition.values.reversed
                  .map(
                    (p) => Padding(
                      padding: EdgeInsets.only(
                          bottom: (p.position * 100) *
                              (1 + (13 * _animationController.value))),
                      child: _buildCollapsedCard(p),
                    ),
                  )
                  .toList(),
            ),
          ),
        );
      },
    );
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }
}
