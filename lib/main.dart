import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'screens/home_screen.dart';
import 'services/language_service.dart';
import 'services/localization_service.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final prefs = await SharedPreferences.getInstance();
  final isTestMode = prefs.getBool('test_mode') ?? false;

  runApp(MyApp(isTestMode: isTestMode));
}

class MyApp extends StatefulWidget {
  final bool isTestMode;

  const MyApp({
    super.key,
    this.isTestMode = false,
  });

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  Locale? _locale;

  @override
  void initState() {
    super.initState();
    _loadLocale();
  }

  Future<void> _loadLocale() async {
    final locale = await LanguageService.getSelectedLocale();
    setState(() {
      _locale = locale;
    });
  }

  void _handleLocaleChange(Locale newLocale) async {
    await LanguageService.setLocale(newLocale);
    setState(() {
      _locale = newLocale;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (_locale == null) {
      return const MaterialApp(
        home: Scaffold(
          body: Center(
            child: CircularProgressIndicator(),
          ),
        ),
      );
    }

    return MaterialApp(
      title: 'Auth2',
      locale: _locale,
      supportedLocales: LanguageService.supportedLocales.values,
      localizationsDelegates: const [
        LocalizationDelegate(),
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
        useMaterial3: true,
      ),
      home: HomeScreen(onLocaleChanged: _handleLocaleChange),
    );
  }
}
