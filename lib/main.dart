import 'package:afrimbox/helpers/style.dart';
import 'package:afrimbox/provider/ChannelProvider.dart';
import 'package:afrimbox/provider/loginProvider.dart';
import 'package:afrimbox/provider/moviesProvider.dart';
import 'package:afrimbox/provider/streamingProvider.dart';
import 'package:afrimbox/provider/userProvider.dart';
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
          ChangeNotifierProvider(create: (_) => UserProvider()),
          ChangeNotifierProvider(create: (_) => LoginProvider()),
          ChangeNotifierProvider(create: (_) => StreamingProvider()),
          ChangeNotifierProvider(create: (_) => ChannelProvider()),
          ChangeNotifierProvider(create: (_) => MoviesProvider()),
        ],
        child: DynamicTheme(
            defaultBrightness: Brightness.light,
            data: (brightness) => brightness == Brightness.light
                ? Style.lightTheme()
                : Style.darkTheme(),
            themedWidgetBuilder: (context, theme) {
              return GetMaterialApp(
                theme: theme,
                initialRoute: '/splash',
                routes: Routes.list,
              );
            }));
  }
}
// Style.mainstyle()
