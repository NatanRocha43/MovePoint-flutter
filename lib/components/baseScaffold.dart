import 'package:flutter/material.dart';
import 'package:nome_do_projeto/components/menu.dart';

class BaseScaffold extends StatelessWidget {
  final String title;
  final Widget body;
  final Widget? bottomNavigationBar;

  const BaseScaffold({
    Key? key,
    required this.title,
    required this.body,
    this.bottomNavigationBar,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(title)),
      drawer: const AppDrawer(),
      body: body,
      bottomNavigationBar: bottomNavigationBar,
    );
  }
}
