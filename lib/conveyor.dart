import 'package:cogniosis/dimensions.dart';
import 'package:flutter/material.dart';

class ConveyorBeltWidget extends StatefulWidget {
  final List<String> imageUrls;
  final double height;
  final bool speedUp;

  const ConveyorBeltWidget({
    Key? key,
    required this.imageUrls,
    this.height = 200.0,
    this.speedUp = false,
  }) : super(key: key);

  @override
  _ConveyorBeltWidgetState createState() => _ConveyorBeltWidgetState();
}

class _ConveyorBeltWidgetState extends State<ConveyorBeltWidget>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final ScrollController _scrollController;

  @override
  void initState() {
    super.initState();

    // Initialize animation controller
    _controller = AnimationController(
      vsync: this,
      duration: widget.speedUp ? Duration(seconds: 10) : Duration(seconds: 20),
    )..repeat();

    // Initialize scroll controller
    _scrollController = ScrollController();

    // Start auto-scrolling
    WidgetsBinding.instance.addPostFrameCallback((_) => _startScrolling());
  }

  void _startScrolling() {
    _controller.addListener(() {
      if (_scrollController.hasClients) {
        final scrollPosition = _scrollController.position;
        final maxScrollExtent = scrollPosition.maxScrollExtent;

        if (scrollPosition.pixels >= maxScrollExtent) {
          // Reset to the start for a seamless loop
          _scrollController.jumpTo(0);
        } else {
          // Scroll slightly forward
          _scrollController.jumpTo(scrollPosition.pixels +
              (widget.speedUp ? 1 : 0.5));
        }
      }
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: getHeight(context, 148),
      child: ListView.builder(
        controller: _scrollController,
        scrollDirection: Axis.horizontal,
        physics: const NeverScrollableScrollPhysics(),
        itemBuilder: (context, index) {
          // Wrap the index to create a seamless loop
          final itemIndex = index % widget.imageUrls.length;
          return  Container(
              width: getWidth(context, 174),
              height: getHeight(context, 148),
              margin: const EdgeInsets.symmetric(horizontal: 4.0),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8.0),
                image: DecorationImage(
                  image: NetworkImage(widget.imageUrls[itemIndex]),
                  fit: BoxFit.cover,
                ),
              ),
          );
        },
      ),
    );
  }
}
