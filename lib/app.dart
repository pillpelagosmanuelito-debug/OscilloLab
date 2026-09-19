import 'package:flutter/material.dart';

import 'modules/home/view/home_shell.dart';
import 'theme/app_theme.dart';

class OscilloLabApp extends StatelessWidget {
  const OscilloLabApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'OscilloLab',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.tema,
      home: const HomeShell(),
    );
  }
}
