import 'package:flutter_dotenv/flutter_dotenv.dart';

enum Environment { dev, prod }

class EnvConfig {
  static final EnvConfig _instance = EnvConfig._internal();
  factory EnvConfig() => _instance;
  EnvConfig._internal();

  late Environment environment;
  late String apiBaseUrl;

  Future<void> initialize(Environment env) async {
    environment = env;
    // 根据环境加载不同的 .env 文件
    await dotenv.load(fileName: env == Environment.dev ? '.env.dev' : '.env.prod');

    switch (environment) {
      case Environment.dev:
        apiBaseUrl = 'http://localhost:4000';

      case Environment.prod:
        apiBaseUrl = 'https://api.yyuu.cyou/';
    }
  }

  String get debugToken => dotenv.env['DEBUG_TOKEN'] ?? "";
}
