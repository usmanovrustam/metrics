import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class SlidingSegment extends StatefulWidget {
  final List<String> tabs;
  final List<Widget> views;

  SlidingSegment({
    Key? key,
    required this.tabs,
    required this.views,
  })  : assert(tabs.length == views.length),
        super(key: key);

  @override
  State<SlidingSegment> createState() => _SlidingSegmentState();
}

class _SlidingSegmentState extends State<SlidingSegment> {
  int segmentedControlValue = 0;
  final controller = PageController();

  Map<int, Widget> get children {
    Map<int, Widget> children = {};
    List<int> indexes = [];

    for (var index = 0; index < widget.tabs.length; index++) {
      indexes.add(index);
    }

    indexes.forEach(
      (index) {
        children.addAll({
          index: Padding(
            padding: EdgeInsets.all(12),
            child: Text(widget.tabs[index],
                style: TextStyle(
                  fontSize: 12,
                  color: segmentedControlValue == index
                      ? CupertinoColors.white
                      : Colors.grey,
                )),
          ),
        });
      },
    );

    return children;
  }

  Widget get tabView => Container(
        width: double.infinity,
        padding: EdgeInsets.symmetric(vertical: 16),
        child: CupertinoSlidingSegmentedControl(
          groupValue: segmentedControlValue,
          padding: EdgeInsets.all(4),
          backgroundColor: Colors.grey[200]!,
          thumbColor: CupertinoColors.systemBlue,
          onValueChanged: (int? value) {
            setState(() {
              segmentedControlValue = value as int;
            });
          },
          children: children,
        ),
      );

  Widget get body => Expanded(
        child: PageView.builder(
          itemCount: widget.tabs.length,
          controller: controller,
          onPageChanged: (int? value) {
            segmentedControlValue = value as int;
            setState(() {});
          },
          itemBuilder: (_, __) {
            List<Widget> children = [];

            widget.views.forEach((widget) {
              children.add(widget);
            });

            return children[segmentedControlValue];
          },
        ),
      );

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [tabView, body],
    );
  }
}
