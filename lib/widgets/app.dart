import 'package:flutter/widgets.dart';
import 'package:my_ui/widgets.dart';

class App extends StatelessWidget {
  final String title;
  final Theme theme;
  final Widget child;

  App({
    super.key,
    required this.title,
    Theme? theme,
    required this.child
  }) : theme = (theme == null) ? Theme.light() : theme;

  @override
  Widget build(BuildContext context) {
    return WidgetsApp(
      title: title,
      color: Color.fromARGB(255, 255, 255, 255),
      debugShowCheckedModeBanner: false,
      builder: (_, _) {
        return ThemeProvider(
          theme: theme,
          builder: (BuildContext context, _) => Container(
            color: theme.colorScheme.backgroundPrimaryColor,
            child: DefaultTextStyle(
              style: theme.textStyle,
              child: child,
            ),
          ),
        );
      }
    );
  }
}