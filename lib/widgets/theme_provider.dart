import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';

import 'theme.dart';

class ThemeProvider extends StatelessWidget {
  final Theme theme;
  final Widget Function(BuildContext, Widget?)? builder;
  
  const ThemeProvider({super.key, required this.theme, this.builder});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<Theme>(
        create: (_) => theme,
        builder: builder
      );
  }
}
