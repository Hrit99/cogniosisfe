import 'package:http/http.dart' as http;
import 'dart:convert';




class ConfigManager {
  static final ConfigManager _instance = ConfigManager._internal();

  String humeApiKey = "";
  String humeSecretKey = "";
  String humeAccessToken = "";
  late final String humeConfigId;
  late final String humeConfigIdChat;
  String openaiApiKey = "";
  ConfigManager._internal();

  static ConfigManager get instance => _instance;

  // WARNING! For development only. In production, the app should hit your own backend server to get an access token, using "token authentication" (see https://dev.hume.ai/docs/introduction/api-key#token-authentication)
  String fetchHumeApiKey() {
    return const String.fromEnvironment('HUME_API_KEY', defaultValue: '');
  }

  Future<String> fetchAccessToken() async {

    // if (humeApiKey == null || humeSecretKey == null) {
    //   throw Exception('Please set HUME_API_KEY and HUME_SECRET_KEY in your .env file');
    // }

    final response = await http.post(
      Uri.parse('https://api.hume.ai/oauth2-cc/token'),
      headers: {
        'Authorization': 'Basic ${base64Encode(utf8.encode('$humeApiKey:$humeSecretKey'))}',
        'Content-Type': 'application/x-www-form-urlencoded',
      },
      body: 'grant_type=client_credentials',
    );
    if (response.statusCode == 200) {
      print("response.body.access_token: ${jsonDecode(response.body)['access_token']}");
      return jsonDecode(response.body)['access_token'];
    } else {
      throw Exception('Failed to load access token');
    }
  }

  Future<void> loadConfig() async {
    

    final response = await http.get(
      Uri.parse('https://cogniosisbe-1366da2257bb.herokuapp.com/get-keys')
    );

    print("response.body: ${response.body}");

    if (response.statusCode == 200) {
      final keys = jsonDecode(response.body);
      humeApiKey = keys['hume_api_key'];
      humeSecretKey = keys['hume_secret_key'];
      humeConfigId = keys['hume_config_id'];
      humeConfigIdChat = keys['hume_config_id_chat'];
      openaiApiKey = keys['openai_key'];
    } else {
      throw Exception('Failed to load keys from server');
    }

    // Make sure to create a .env file in your root directory which mirrors the .env.example file
    // and add your API key and an optional EVI config ID.
    // await dotenv.load();

    // // WARNING! For development only.
    // humeApiKey = fetchHumeApiKey();

    // Uncomment this to use an access token in production.
    // humeAccessToken = await fetchAccessToken();
}
}
