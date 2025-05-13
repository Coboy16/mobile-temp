import 'package:flutter_dotenv/flutter_dotenv.dart';

enum Environment { development, production }

class AppConfig {
  static Environment environment = Environment.development;
  static String baseUrl = '';

  static Future<void> loadEnv() async {
    String envFileName;
    switch (environment) {
      case Environment.development:
        envFileName = 'dev.env';
        break;
      case Environment.production:
        envFileName = '.env';
        break;
    }
    await dotenv.load(fileName: envFileName);
    baseUrl = dotenv.env['BASE_URL']!;
  }
}
