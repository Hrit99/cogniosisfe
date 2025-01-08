import 'dart:convert';

import 'package:audioplayers/audioplayers.dart';
import 'package:cogniosis/configmanager.dart';
import 'package:cogniosis/dimensions.dart';
import 'package:cogniosis/exercise_provider.dart';
import 'package:cogniosis/mood_provider.dart';
import 'package:cogniosis/music_provider.dart';
import 'package:cogniosis/providers/habit_provider.dart';
import 'package:cogniosis/splash_screen.dart';
import 'package:cogniosis/video_provider.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:record/record.dart';
import 'package:web_socket_channel/web_socket_channel.dart';
import 'package:flutter/services.dart'; // Import the services package
import 'package:provider/provider.dart';
import 'package:cogniosis/task_provider.dart';
import 'package:cogniosis/home_screen.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'chat_card.dart';
import 'evi_message.dart' as evi;

void main() async {
  // Ensure Flutter binding is initialized before calling asynchronous operations
  WidgetsFlutterBinding.ensureInitialized();

  // Load config in singleton
  await ConfigManager.instance.loadConfig();

  SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
    statusBarColor: Colors.transparent, // Make status bar transparent
    statusBarIconBrightness:
        Brightness.dark, // Set icon color in status bar (dark or light)
    systemNavigationBarColor:
        Colors.transparent, // Make system navigation bar transparent
    systemNavigationBarIconBrightness:
        Brightness.dark, // Set icon color in navigation bar
  ));

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  FlutterError.onError = FirebaseCrashlytics.instance.recordFlutterFatalError;

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => ThemeProvider()),
        ChangeNotifierProvider(
            create: (_) => TaskProvider()), // Provide TaskProvider
        ChangeNotifierProvider(create: (_) => MusicProvider()),
        ChangeNotifierProvider(create: (_) => VideoProvider()),
        ChangeNotifierProvider(create: (_) => ExerciseProvider()),
        ChangeNotifierProvider(create: (_) => MoodProvider()),
        ChangeNotifierProvider(create: (_) => HabitProvider())
      ],
      child: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Cogniosis',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: FutureBuilder(
        future: _checkAccessToken(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return CircularProgressIndicator(); // Show a loading indicator while checking
          } else {
            if (snapshot.data == true) {
              return HomeScreen(); // Navigate to HomeScreen if access token exists
            } else {
              return SplashScreen(); // Navigate to IntroScreen if no access token
            }
          }
        },
      ),
    );
  }

  Future<bool> _checkAccessToken() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.containsKey('access_token');
  }

  static List<Score> extractTopThreeEmotions(evi.Inference models) {
    // extract emotion scores from the message
    final scores = models.prosody?.scores ?? {};

    // convert the emotions object into an array of key-value pairs
    final scoresArray = scores.entries.toList();

    // sort the array by the values in descending order
    scoresArray.sort((a, b) => b.value.compareTo(a.value));

    // extract the top three emotions and convert them back to an object
    final topThreeEmotions = scoresArray.take(3).map((entry) {
      return Score(emotion: entry.key, score: entry.value);
    }).toList();

    return topThreeEmotions;
  }
}

class ErrorMessage extends StatelessWidget {
  final String message;

  const ErrorMessage({super.key, required this.message});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text(
        message,
        style: Theme.of(context).textTheme.headlineLarge,
      ),
    );
  }
}

class MyHomePage extends StatefulWidget {
  final String title;
  final bool isDarkMode;

  const MyHomePage({super.key, required this.title, required this.isDarkMode});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  // define config here for recorder
  static const config = RecordConfig(
    encoder: AudioEncoder.pcm16bits,
    bitRate: 48000 * 2 *
        16, // 48000 samples per second * 2 channels (stereo) * 16 bits per sample
    sampleRate: 48000,
    androidConfig: AndroidRecordConfig(
      audioSource: AndroidAudioSource.voiceCommunication,
      muteAudio: false,
    ),
    iosConfig: IosRecordConfig(
      categoryOptions: [
        IosAudioCategoryOption.defaultToSpeaker,
        IosAudioCategoryOption.allowBluetooth,
      ],
      manageAudioSession: false
    ),
    numChannels: 1,
    autoGain: true,
    echoCancel: true,
    noiseSuppress: true,
  );
  static final audioInputBufferSize = config.bitRate ~/
      500; // bitrate is "number of bits per second". Dividing by 10 should buffer approximately 100ms of audio at a time.

  final AudioPlayer _audioPlayer = AudioPlayer();
  final AudioRecorder _audioRecorder = AudioRecorder();
   static const _platform = MethodChannel('com.example.audio');
  WebSocketChannel? _chatChannel;
  bool _isConnected = false;
  //bool _isMuted = false;
  var chatEntries = <ChatEntry>[];

  // As EVI speaks, it will send audio segments to be played back. Sometimes a new segment
  // will arrive before the old audio segment has had a chance to finish playing, so -- instead
  // of directly playing an audio segment as it comes back, we queue them up here.
  final List<Source> _playbackAudioQueue = [];

  // Holds bytes of audio recorded from the user's microphone.
  List<int> _audioInputBuffer = <int>[];

  // EVI sends back transcripts of both the user's speech and the assistants speech, along
  // with an analysis of the emotional content of the speech. This method takes
  // of a message from EVI, parses it into a `ChatMessage` type and adds it to `chatEntries` so
  // it can be displayed.
  void appendNewChatMessage(evi.ChatMessage chatMessage, evi.Inference models) {
    final role = chatMessage.role == 'assistant' ? Role.assistant : Role.user;
    final entry = ChatEntry(
        role: role,
        timestamp: DateTime.now().toString(),
        content: chatMessage.content,
        scores: MyApp.extractTopThreeEmotions(models));
    setState(() {
      chatEntries.add(entry);
    });
  }

  @override
  Widget build(BuildContext context) {
    final connectButton = Container(
      decoration: BoxDecoration(
        gradient: RadialGradient(
          center: Alignment.center,
          radius: 0.5,
          colors: [
            Color(0xFFE69092),
            Color(0xFFBE3D40),
          ],
          stops: [0.0, 1.0],
        ),
        borderRadius: BorderRadius.circular(24.0),
      ),
      child: ElevatedButton(
        onPressed: () => _disconnect(),
        style: ElevatedButton.styleFrom(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(24),
          ),
          backgroundColor: Colors.transparent, // Transparent background
          shadowColor: Colors.transparent, // Remove shadow
        ),
        child: Container(
          alignment: Alignment.center,
          child: Text(
            'End Call',
            style: TextStyle(color: Colors.white),
          ),
        ),
      ),
    );

    return Scaffold(
      backgroundColor: widget.isDarkMode ? Colors.black : Colors.white,
      body: Stack(
        children: [
          Container(
            decoration: BoxDecoration(
              image: DecorationImage(
                image: widget.isDarkMode
                    ? AssetImage("assets/voicecallerbgdark.png")
                    : AssetImage(
                        "assets/voicecallerbg.png"), // Replace with your image path
                fit: BoxFit.cover,
              ),
            ),
          ),
          Positioned(
            top: getHeight(context, 100),
            left: (MediaQuery.of(context).size.width - getWidth(context, 300)) /
                2,
            child: widget.isDarkMode
                ? Image.asset("assets/logodark.png",
                    height: getHeight(context, 300),
                    width: getWidth(context, 300))
                : Image.asset("assets/logo.png",
                    height: getHeight(context, 300),
                    width: getWidth(context, 300)),
          ),
          Positioned(
            bottom: getHeight(context, 30),
            left: (MediaQuery.of(context).size.width - getWidth(context, 362)) /
                2,
            child: Container(
              height: getHeight(context, 56),
              width: getWidth(context, 362),
              child: connectButton,
            ),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _tunePlayer.dispose(); // Dispose the tune player
    _audioPlayer.dispose();
    _audioRecorder.dispose();
    _disconnect();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    _setVoiceChatMode();
    final AudioContext audioContext = AudioContext(
      iOS: AudioContextIOS(
        category: AVAudioSessionCategory.playAndRecord,
        options: {
          AVAudioSessionOptions.defaultToSpeaker,
          AVAudioSessionOptions.allowBluetooth,
        }
      ),
      android: AudioContextAndroid(
        isSpeakerphoneOn: false,
        audioMode: AndroidAudioMode.inCall,
        stayAwake: true,
        contentType: AndroidContentType.speech,
        usageType: AndroidUsageType.voiceCommunication,
        audioFocus: AndroidAudioFocus.gain,
      ),

    );

    AudioPlayer.global.setAudioContext(audioContext);
    _audioPlayer.onPlayerComplete.listen((event) {
      _playNextAudioSegment();
    });


    // Automatically connect when the screen renders
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _connect();
    });

    // Play the tune repeatedly when the screen is rendered
    // _playTune();
  }


    Future<void> _setVoiceChatMode() async {
    try {
      await _platform.invokeMethod('setVoiceChatMode');
      print("Voice chat mode set successfully.");
    } on PlatformException catch (e) {
      print("Failed to set voice chat mode: ${e.message}");
    }
  }

  final AudioPlayer _tunePlayer = AudioPlayer();

  void _playTune() async {
    try {
      await _tunePlayer.setReleaseMode(ReleaseMode.loop);
      await _tunePlayer.play(AssetSource('tune.mp3'));
    } catch (e) {
      debugPrint("Error playing tune: $e");
    }
  }

  void _stopTune() {
    try {
      _tunePlayer.stop();
      _tunePlayer.dispose();
    } catch (e) {
      debugPrint("Error stopping tune: $e");
    }
  }

  // Opens a websocket connection to the EVI API and registers a listener to handle
  // incoming messages.
  void _connect() {
    _audioInputBuffer.clear();
    try {
      print(
          "ConfigManager.instance.humeAccessToken: ${ConfigManager.instance.humeAccessToken}");
      print(
          "ConfigManager.instance.humeApiKey: ${ConfigManager.instance.humeApiKey}");
      print(
          "ConfigManager.instance.humeConfigId: ${ConfigManager.instance.humeConfigId}");
      setState(() {
        // _stopTune();
        _isConnected = true;
      });
      // if (ConfigManager.instance.humeApiKey.isNotEmpty &&
      //     ConfigManager.instance.humeAccessToken.isNotEmpty) {
      //   throw Exception(
      //       'Please use either an API key or an access token, not both');
      // }

      var uri = 'wss://api.hume.ai/v0/evi/chat';
      if (ConfigManager.instance.humeAccessToken.isNotEmpty) {
        uri +=
            '?access_token=${ConfigManager.instance.humeAccessToken}&config_id=${ConfigManager.instance.humeConfigId}';
      } else if (ConfigManager.instance.humeApiKey.isNotEmpty) {
        print(
            "ConfigManager.instance.humeApiKey: ${ConfigManager.instance.humeApiKey}");
        uri += '?api_key=${ConfigManager.instance.humeApiKey}';
      } else {
        throw Exception('Please set your Hume API credentials in main.dart');
      }

      _chatChannel = WebSocketChannel.connect(Uri.parse(uri));

      print("uri: $uri");

     _chatChannel!.stream.listen(
      (event) async {
        final message = evi.EviMessage.decode(event);
        debugPrint("Received message: ${message.type}");
        // This message contains audio data for playback.
        switch (message) {
          case (evi.ErrorMessage errorMessage):
            debugPrint("Error: ${errorMessage.message}");
            break;
          case (evi.ChatMetadataMessage chatMetadataMessage):
            debugPrint("Chat metadata: ${chatMetadataMessage.rawJson}");
            _prepareAudioSettings();
            _startRecording();
            break;
          case (evi.AudioOutputMessage audioOutputMessage):
            final data = audioOutputMessage.data;
            final rawAudio = base64Decode(data);
            Source source;
            if (!kIsWeb) {
              source = _urlSourceFromBytes(rawAudio);
            } else {
              source = BytesSource(rawAudio);
            }
            print("Source:");
             _enqueueAudioSegment(source);
            // _audioPlayer.play(source);
            break;
          case (evi.UserInterruptionMessage _):
            _handleInterruption();
            break;
          // These messages contain the transcript text of the user's or the assistant's speech
          // as well as emotional analysis of the speech.
          case (evi.AssistantMessage assistantMessage):
          print("Assistant message: ${assistantMessage.message.content}");
            appendNewChatMessage(
                assistantMessage.message, assistantMessage.models);
            break;
          case (evi.UserMessage userMessage):
          print("User message: ${userMessage.message.content}");
            appendNewChatMessage(userMessage.message, userMessage.models);
            _handleInterruption();
            break;
          case (evi.UnknownMessage unknownMessage):
            debugPrint("Unknown message: ${unknownMessage.rawJson}");
            break;
        }
      },
      onError: (error) {
        debugPrint("Connection error: $error");
        _handleConnectionClosed();
      },
      onDone: () {
        debugPrint("Connection closed");
        _handleConnectionClosed();
      },
    );

      debugPrint("Connected");
    } catch (e) {
      debugPrint("Error connecting: $e");
    }
  }

  void _disconnect() {
    try {
      _handleInterruption();
      _handleConnectionClosed();

      _chatChannel?.sink.close();

      debugPrint("Disconnected");
      Navigator.pop(context);
    } catch (e) {
      debugPrint("Error disconnecting: $e");
    }
  }

  void _enqueueAudioSegment(Source audioSegment) {
    debugPrint("Enqueueing audio segment");
    if (!_isConnected) {
      return;
    }
    if (_audioPlayer.state == PlayerState.playing) {
      _playbackAudioQueue.add(audioSegment);
    } else {
      _audioPlayer.play(audioSegment);
    }
  }

  void _flushAudio() {
    try {
      if (_audioInputBuffer.isNotEmpty) {
        _sendAudio(_audioInputBuffer);
        _audioInputBuffer.clear();
      }
    } catch (e) {
      debugPrint("Error flushing audio: $e");
    }
  }

  void _handleConnectionClosed() {
    setState(() {
      _isConnected = false;
    });
    _audioInputBuffer.clear();
    _stopRecording();
  }

  void _handleInterruption() {
    _playbackAudioQueue.clear();
    _audioPlayer.stop();
  }

  void _playNextAudioSegment() {
    try {
      if (_playbackAudioQueue.isNotEmpty) {
        final audioSegment = _playbackAudioQueue.removeAt(0);
        _audioPlayer.play(audioSegment);
      }
    } catch (e) {
      debugPrint("Error playing next audio segment: $e");
    }
  }

  void _prepareAudioSettings() {
    // set session settings to prepare EVI for receiving linear16 encoded audio
    // https://dev.hume.ai/docs/empathic-voice-interface-evi/configuration#session-settings
    _chatChannel!.sink.add(jsonEncode({
      'type': 'session_settings',
      'audio': {
        'encoding': 'linear16',
        'sample_rate': 48000,
        'channels': 1,
      },
    }));
  }

  void _sendAudio(List<int> audioBytes) {
    final base64 = base64Encode(audioBytes);
    _chatChannel!.sink.add(jsonEncode({
      'type': 'audio_input',
      'data': base64,
    }));
  }

  void _startRecording() async {
    if (!await _audioRecorder.hasPermission()) {
      return;
    }

    final audioStream = await _audioRecorder.startStream(config);

    audioStream.listen((data) async {
      _audioInputBuffer.addAll(data);

      if (_audioInputBuffer.length >= audioInputBufferSize) {
        final bufferWasEmpty =
            !_audioInputBuffer.any((element) => element != 0);
        if (bufferWasEmpty) {
          _audioInputBuffer = [];
          return;
        }
        
        _sendAudio(_audioInputBuffer);
        _audioInputBuffer = [];
      }
    });
    audioStream.handleError((error) {
      debugPrint("Error recording audio: $error");
    });
  }


  void _stopRecording() {
    try {
      _audioRecorder.stop();
    } catch (e) {
      debugPrint("Error stopping recording: $e");
    }
  }

  // In the `audioplayers` library, iOS does not support playing audio from a `ByteSource` but
  // we can use a `UrlSource` with a data URL.
  UrlSource _urlSourceFromBytes(List<int> bytes,
      {String mimeType = "audio/wav"}) {
    try {
      return UrlSource(Uri.dataFromBytes(bytes, mimeType: mimeType).toString());
    } catch (e) {
      debugPrint("Error creating URL source from bytes: $e");
      rethrow;
    }
  }
}

// void configureAudioSession() async {
//   final session = AVAudioSession.sharedInstance();

//   try {
//     // Set the category to play and record
//     await session.setCategory(
//       AVAudioSessionCategory.playAndRecord,
//       options: [
//         AVAudioSessionCategoryOptions.allowBluetooth,
//         AVAudioSessionCategoryOptions.defaultToSpeaker,
//       ],
//     );

//     // Set the mode to voice chat
//     await session.setMode(AVAudioSessionMode.voiceChat);

//     // Activate the audio session
//     await session.setActive(true);
//   } on PlatformException catch (e) {
//     print("Failed to configure audio session: $e");
//   }
// }
