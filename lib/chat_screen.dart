import 'package:cogniosis/configmanager.dart';
import 'package:cogniosis/dimensions.dart';
import 'package:cogniosis/listing_widget.dart';
import 'package:cogniosis/media_item_screen.dart';
import 'package:cogniosis/music_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'dart:convert';
import 'evi_message.dart' as evi;

import 'package:web_socket_channel/web_socket_channel.dart';

class ChatPage extends StatefulWidget {
  final bool isDarkMode;
  const ChatPage({super.key, required this.isDarkMode});
  @override
  _ChatPageState createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  final TextEditingController _messageController = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  List<Message> _messages = [];
  String chatgroupid = "";
  bool connected = false;

  WebSocketChannel? _chatChannel;

  @override
  void initState() {
    super.initState();
    // Automatically connect when the screen renders
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _connect();
    });
  }

  // Opens a websocket connection to the EVI API and registers a listener to handle
  // incoming messages.
  void _connect() async {
    try {
      // print(
      //     "ConfigManager.instance.humeAccessToken: ${ConfigManager.instance.humeAccessToken}");
      print(
          "ConfigManager.instance.humeApiKey: ${ConfigManager.instance.humeApiKey}");
      print(
          "ConfigManager.instance.humeConfigIdChat: ${ConfigManager.instance.humeConfigIdChat}");

      try {
        final accessToken = await ConfigManager.instance.fetchAccessToken();
        ConfigManager.instance.humeAccessToken = accessToken;
      } catch (error) {
        debugPrint("Error fetching access token: $error");
      }

      print("ConfigManager.instance.humeAccessToken: ${ConfigManager.instance.humeAccessToken}");

      var uri = 'wss://api.hume.ai/v0/evi/chat';
      if (ConfigManager.instance.humeAccessToken.isNotEmpty) {
        print("chatgroupid: $chatgroupid");
        uri +=
            '?access_token=${ConfigManager.instance.humeAccessToken}&config_id=${ConfigManager.instance.humeConfigIdChat}';
        if (chatgroupid.isNotEmpty) {
          uri += '&resumed_chat_group_id=$chatgroupid';
        }
      } else if (ConfigManager.instance.humeApiKey.isNotEmpty) {
        print(
            "ConfigManager.instance.humeApiKey: ${ConfigManager.instance.humeApiKey}");
        uri += '?api_key=${ConfigManager.instance.humeApiKey}';
      } else {
        throw Exception('Please set your Hume API credentials in main.dart');
      }

      _chatChannel = WebSocketChannel.connect(Uri.parse(uri));

      // print("uri: $uri");
      connected = true;

      _chatChannel!.stream.listen(
        (event) async {
          final message = evi.EviMessage.decode(event);
          // print("message: ${message.rawJson}");
          if(chatgroupid.isEmpty){
            chatgroupid = message.rawJson["chat_group_id"] ?? '';
          }
         
          switch (message) {
            case (evi.AssistantMessage assistantMessage):
              if (!(assistantMessage.message.content == "Hi I am Sofie. I am a Mental health AI assistant." && _messages.isNotEmpty)) {
                if (assistantMessage.message.content.contains("Recommendation: ")) {
                  final recommendation = assistantMessage.message.content.substring("Recommendation:".length).trim();
                  final parts = recommendation.split(" - ");
                  if (parts.length == 2) {
                    final title = parts[0].trim();
                    final description = parts[1].trim();

                    final musicProvider = Provider.of<MusicProvider>(context, listen: false);
                    final matchingMusic = musicProvider.getMusic().firstWhere(
                      (music) => music.title == title && music.description == description
                    );

                    print("matchingMusic: $matchingMusic");

                    // Add the music tile to the messages
                    setState(() {
                      _messages.add(Message(text: assistantMessage.message.content, isUser: false));
                      _messages.add(Message(text: '', isUser: false, widget: _buildMusicTile(matchingMusic)));
                      _scrollToBottom();
                    });
                  }
                } else {
                  setState(() {
                    _messages.add(Message(text: assistantMessage.message.content, isUser: false));
                    _scrollToBottom();
                  });
                }
              }
              break;
            default:
              break;
          }
        },
        onError: (error) {
          _connect();
          debugPrint("Connection error: $error");
        },
        onDone: () {
          if(connected){
            _connect();
          }
          debugPrint("Connection closed");
        },
      );

      debugPrint("Connected");
    } catch (e) {
      _connect();
      debugPrint("Error connecting: $e");
    }
  }

  void _disconnect() {
    try {
      connected = false;
      _chatChannel?.sink.close();
      debugPrint("Disconnected");
      Navigator.pop(context);
    } catch (e) {
      debugPrint("Error disconnecting: $e");
    }
  }

  Future<void> _sendMessage() async {
    final text = _messageController.text;
    if (text.isNotEmpty) {
      setState(() {
        _messages.add(Message(text: text, isUser: true));
        _scrollToBottom();
      });
      _messageController.clear();

      try {
        _chatChannel!.sink.add(jsonEncode({
          'type': 'user_input',
          'text': text,
        }));
      } catch (e) {
        setState(() {
          print("error: $e");
          _messages.add(Message(text: "Error: $e", isUser: false));
          _scrollToBottom();
        });
      }
    }
  }

  void _scrollToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }

  // New widget to display music tile
  Widget _buildMusicTile(MediaItem music) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => MediaItemScreen(mediaItem: music),
          ),
        );
      },
      child: Container(
        margin: EdgeInsets.symmetric(vertical: 5.0),
        padding: EdgeInsets.all(12.0),
        decoration: BoxDecoration(
          color: widget.isDarkMode ? Color(0xFF292B2A) : Colors.grey.shade300,
          borderRadius: BorderRadius.circular(10.0),
        ),
        child: Row(
          children: [
            Image.network(music.image, width: 50, height: 50), // Assuming imageUrl is a property of Music
            SizedBox(width: 10),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  music.title,
                  style: TextStyle(
                    color: widget.isDarkMode ? Colors.white : Colors.black,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  music.author,
                  style: TextStyle(
                    color: widget.isDarkMode ? Colors.white70 : Colors.black54,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: widget.isDarkMode ? Color(0xFF0D1314) : Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            // Back Button
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Align(
                alignment: Alignment.centerLeft,
                child: IconButton(
                  icon: Icon(Icons.arrow_back, color: widget.isDarkMode ? Colors.white : Colors.black),
                  onPressed: () {
                     _disconnect();
                  },
                ),
              ),
            ),

            // Header Section
            Visibility(
              visible: _messages.isEmpty && MediaQuery.of(context).viewInsets.bottom == 0,
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    widget.isDarkMode ? Image.asset("assets/chatscreenlogodark.png", height: getHeight(context, 154), width : getWidth(context, 327))  :Image.asset("assets/chatscreenlogo.png", height: getHeight(context, 154), width : getWidth(context, 327)),
                    SizedBox(height: 10),
                    if (_messages.isEmpty) ...[
                      ChatOptionCard(
                        isDarkMode: widget.isDarkMode,
                        title: "Talk to Someone Who Understands",
                        subtitle: "Get personalized guidance to improve your well-being.",
                        onTap: () {
                          // _messageController.text = "Design a mobile application";
                          // _sendMessage();
                        },
                      ),
                      SizedBox(height: 10),
                      ChatOptionCard(
                        isDarkMode: widget.isDarkMode,
                        title: "Build a Path to Better Mental Health",
                        subtitle: "Share your concerns, and let's work together to find solutions.",
                        onTap: () {
                          // _messageController.text = "Build a new AI project";
                          // _sendMessage();
                        },
                      ),
                    ]
                  ],
                ),
              ),
            ),

            // Chat Messages
            Expanded(
              child: ListView.builder(
                controller: _scrollController,
                padding: EdgeInsets.symmetric(horizontal: 16.0),
                itemCount: _messages.length,
                itemBuilder: (context, index) {
                  final message = _messages[index];
                  return Align(
                    alignment: message.isUser
                        ? Alignment.centerRight
                        : Alignment.centerLeft,
                    child: Container(
                      margin: EdgeInsets.symmetric(vertical: 5.0),
                      padding: EdgeInsets.all(12.0),
                      decoration: BoxDecoration(
                        color: message.isUser
                            ? Color(0xFF099AA8)
                            : widget.isDarkMode ? Color(0xFF292B2A) : Colors.grey.shade300,
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                      child: message.widget ?? Text(
                        message.text,
                        style: TextStyle(
                          color: message.isUser
                              ? widget.isDarkMode ? Colors.black : Colors.white
                              : widget.isDarkMode ? Colors.white : Colors.black,
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),

            // Input Section
            Container(
              padding: EdgeInsets.symmetric(horizontal: getWidth(context, 10), vertical: getHeight(context, 4)),
              margin: EdgeInsets.symmetric(horizontal: getWidth(context, 16), vertical: getHeight(context, 10)),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(35.0),
                border: Border.all(color: Colors.grey.shade300),
              ),
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: _messageController,
                      style: TextStyle(
                        fontFamily: 'Satoshi',
                        fontSize: getHeight(context, 17),
                        color: widget.isDarkMode ? Colors.white : Colors.black,
                      ),
                      decoration: InputDecoration(
                        hintText: "Type message...",
                        hintStyle: TextStyle(
                          fontFamily: 'Satoshi',
                          fontSize: getHeight(context, 17),
                          color: widget.isDarkMode ? Colors.white : Colors.black,
                        ),
                        filled: true,
                        fillColor: Colors.transparent,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(25.0),
                          borderSide: BorderSide.none,
                        ),
                      ),
                    ),
                  ),
                  SizedBox(width: 10),
                  GestureDetector(
                    onTap: _sendMessage,
                    child: CircleAvatar(
                      backgroundColor: Colors.black,
                      child: Icon(Icons.send, color: Colors.white),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// Message Model
class Message {
  final String text;
  final bool isUser;
  final Widget? widget; // Add a widget property to display custom widgets

  Message({required this.text, required this.isUser, this.widget});
}

// Predefined Chat Option Widget
class ChatOptionCard extends StatelessWidget {
  final String title;
  final bool isDarkMode;
  final String subtitle;
  final VoidCallback onTap;

  const ChatOptionCard({
    required this.title,
    required this.subtitle,
    required this.onTap,
    required this.isDarkMode,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.all(16.0),
        width: getWidth(context, 362),
        decoration: BoxDecoration(
          color: isDarkMode ? Color(0xFF292B2A) : Color(0xFFE0E0E0),
          border: Border.all(color: Colors.grey.shade300),
          borderRadius: BorderRadius.circular(10.0),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                fontFamily: 'Satoshi',
                color: isDarkMode ? Colors.white : Colors.black,
              ),
            ),
            SizedBox(height: 5),
            Text(
              subtitle,
              style: TextStyle(
                color: isDarkMode ? Colors.white : Colors.grey.shade600,
                fontFamily: 'Satoshi',
                fontSize: 12,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
