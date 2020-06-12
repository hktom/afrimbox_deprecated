import 'package:afrimbox/helpers/style.dart';
import 'package:afrimbox/provider/loginProvider.dart';
import 'package:afrimbox/provider/streamingProvider.dart';
import 'package:afrimbox/routes/routes.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:dynamic_theme/dynamic_theme.dart';
import 'package:get/get.dart';

void main() => runApp(MyApp());

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
        providers: [
          ChangeNotifierProvider(create: (_) => LoginProvider()),
          ChangeNotifierProvider(create: (_) => StreamingProvider()),
        ],
        child: DynamicTheme(
            defaultBrightness: Brightness.light,
            data: (brightness) => brightness == Brightness.light ? Style.mainstyle() : Style.darkStyle(),
            themedWidgetBuilder: (context, theme) {
              return GetMaterialApp(
                theme: theme,
                initialRoute: '/landing',
                routes: Routes.list,
              );
            }));
  }
}
// Style.mainstyle()