import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'screens/home_screen.dart';
import 'services/language_service.dart';
import 'services/localization_service.dart';

import 'package:mpflutter_core/mpflutter_core.dart';
import 'package:mpflutter_wechat_api/mpflutter_wechat_api.dart';
import 'package:mpflutter_core/mpjs/mpjs.dart' as mpjs;

void main() {
  runMPApp(const MyApp());

  /**
   * 务必保留这段代码，否则第一次调用 wx 接口会提示异常。
   */
  if (kIsMPFlutter) {
    try {
      wx.$$context$$;
    } catch (e) {
      if (kDebugMode) {
        print('Failed to initialize wx context: $e');
      }
    }
  }

  /**
   * 使用 AppDelegate 响应应用生命周期事件、分享事件。
   */
  // ignore: unused_local_variable
  final appDelegate = MyAppDelegate();
}

class MyAppDelegate {
  late MPFlutterWechatAppDelegate appDelegate;

  MyAppDelegate() {
    appDelegate = MPFlutterWechatAppDelegate(
      onShow: () {
        if (kDebugMode) {
          print("当应用从后台回到前台，被回调。");
        }
      },
      onHide: () {
        if (kDebugMode) {
          print("当应用从前台切到后台，被回调。");
        }
      },
      onShareAppMessage: (detail) {
        if (kDebugMode) {
          print("当用户点击分享给朋友时，回调，应组装对应的 Map 信息，用于展示和回跳。");
        }
        return onShareAppMessage(detail);
      },
      onLaunch: (query, launchptions) async {
        if (kDebugMode) {
          print(launchptions['path']);
          print("应用冷启动时，会收到回调，应根据 query 决定是否要跳转页面。");
        }
        await Future.delayed(
            const Duration(seconds: 1)); // 加个延时，保障 navigator 已初始化。
        onLaunchOrEnter(query);
      },
      onEnter: (query, launchptions) {
        if (kDebugMode) {
          print("应用热启动（例如用户从分享卡片进入小程序）时，会收到回调，应根据 query 决定是否要跳转页面。");
        }
        onLaunchOrEnter(query);
      },
    );
  }

  /// 存在两种返回 Share Info 的方法
  /// - MPFlutterWechatAppShareManager.onShareAppMessage 配合 MPFlutterWechatAppShareManager.setAppShareInfo 使用
  /// - 直接返回符合微信小程序要求的 Map
  Map onShareAppMessage(mpjs.JSObject detail) {
    return MPFlutterWechatAppShareManager.onShareAppMessage(detail);
    // final currentRoute = MPNavigatorObserver.currentRoute;
    // if (currentRoute != null) {
    //   final routeName = currentRoute.settings.name;
    //   return {
    //     "title": (() {
    //       if (routeName == "/map_demo") {
    //         return "Map Demo";
    //       } else {
    //         return "Awesome Project";
    //       }
    //     })(),
    //     "path":
    //         "pages/index/index?routeName=${routeName}", // 这个 query 会在 onLaunch 和 onEnter 中带回来。
    //   };
    // } else {
    //   return {};
    // }
  }

  void onLaunchOrEnter(Map query) {
    final navigator = MPNavigatorObserver.currentRoute?.navigator;
    if (navigator != null) {
      final routeName = query["routeName"];
      if (routeName == "/map_demo") {
        navigator.pushNamed("/map_demo");
      }
    }
  }
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

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
