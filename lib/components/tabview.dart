import 'package:flutter/material.dart';

class CustomTabView extends StatelessWidget {
  final List<Tab> tabs;
  final List<Widget> tabViews;
  final String title;
  final EdgeInsetsGeometry padding;

  const CustomTabView({
    super.key,
    required this.tabs,
    required this.tabViews,
    this.title = '',
    this.padding = const EdgeInsets.all(16.0),
  }) : assert(tabs.length == tabViews.length, 'Tabs and tab views must have the same length');

  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15),
        side: BorderSide(color: Colors.grey.shade300, width: 0.1),
      ),
      elevation: 0,
      child: Padding(
        padding: padding,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (title.isNotEmpty)
              Padding(
                padding: const EdgeInsets.only(bottom: 16.0),
                child: Text(
                  title,
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            DefaultTabController(
              length: tabs.length,
              child: Column(
                children: [
                  TabBar(
                    tabs: tabs,
                    labelStyle: Theme.of(context).textTheme.titleLarge,
                    unselectedLabelColor: Theme.of(context).hintColor,
                    indicatorSize: TabBarIndicatorSize.tab,
                    indicator: BoxDecoration(
                      borderRadius: BorderRadius.circular(14),
                      color: Theme.of(context).secondaryHeaderColor.withOpacity(0.7),
                    ),
                    dividerHeight: 0.2,
                  ),
                  SizedBox(
                    height:300, // Fixed height, adjust as needed
                    child: TabBarView(
                      children: tabViews,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
