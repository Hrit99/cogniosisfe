import 'package:cogniosis/configmanager.dart';
import 'package:cogniosis/dimensions.dart';
import 'package:flutter/material.dart';
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
  List<Message> _messages = [];


   
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
  void _connect() {
    try {
      print(
          "ConfigManager.instance.humeAccessToken: ${ConfigManager.instance.humeAccessToken}");
      print(
          "ConfigManager.instance.humeApiKey: ${ConfigManager.instance.humeApiKey}");
      print(
          "ConfigManager.instance.humeConfigIdChat: ${ConfigManager.instance.humeConfigIdChat}");
 
      // if (ConfigManager.instance.humeApiKey.isNotEmpty &&
      //     ConfigManager.instance.humeAccessToken.isNotEmpty) {
      //   throw Exception(
      //       'Please use either an API key or an access token, not both');
      // }

      var uri = 'wss://api.hume.ai/v0/evi/chat';
      if (ConfigManager.instance.humeAccessToken.isNotEmpty) {
        uri +=
            '?access_token=${ConfigManager.instance.humeAccessToken}&config_id=${ConfigManager.instance.humeConfigIdChat}';
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
        print("message: $message");
        debugPrint("Received message: ${message.type}");
        // _messages.add(Message(text: message.toString(), isUser: false));
        // This message contains audio data for playback.
        switch (message) {
          case (evi.AssistantMessage assistantMessage):
          print("Assistant message: ${assistantMessage.message.content}");
           setState(() {
             _messages.add(Message(text: assistantMessage.message.content, isUser: false));
           });
            break;
          default:
            debugPrint("Unknown message: ${message.rawJson}");
            break;
        }
      },
      onError: (error) {
        debugPrint("Connection error: $error");
       
      },
      onDone: () {
        debugPrint("Connection closed");

      },
    );

      debugPrint("Connected");
    } catch (e) {
      debugPrint("Error connecting: $e");
    }
  }

  void _disconnect() {
    try {

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
      });
      _messageController.clear();

      try {
        // final response = await http.post(
        //   Uri.parse(_apiUrl),
        //   headers: {
        //     "Content-Type": "application/json",
        //     "Authorization": "Bearer $_apiKey",
        //   },
        //   body: jsonEncode({
        //     "model": "gpt-3.5-turbo", // Use "gpt-4" if available
        //     "messages": [
        //       {"role": "user", "content": text}
        //     ]
        //   }),
        // );
        // print("response: ${response.body}");
        // if (response.statusCode == 200) {
        //   print("response: ${response.body}");
        //   final jsonResponse = jsonDecode(response.body);
        //   final botReply = jsonResponse['choices'][0]['message']['content'] ?? "No response";

        //   setState(() {
        //     _messages.add(Message(text: botReply, isUser: false));
        //   });
        // } else {
        //   setState(() {
        //     print("error: ${response.reasonPhrase}");
        //     _messages.add(Message(text: "Errors: ${response.reasonPhrase}", isUser: false));
        //   });
        // }
      print("ConfigManager.instance.humeConfigIdChat: ${ConfigManager.instance.humeConfigIdChat}");
           _chatChannel!.sink.add(jsonEncode({
      'type': 'user_input',
      'text': text,
    }));
        
      } catch (e) {
        setState(() {
          print("error: $e");
          _messages.add(Message(text: "Error: $e", isUser: false));
        });
      }
    }
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
                    Navigator.pop(context);
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
                          title: "Design a mobile application",
                          subtitle: "Hac aliquet diam odio amet viverra elit commodo",
                          onTap: () {
                            _messageController.text = "Design a mobile application";
                            _sendMessage();
                          },
                      ),
                      SizedBox(height: 10),
                      ChatOptionCard(
                        isDarkMode: widget.isDarkMode,
                        title: "Build a new AI project",
                        subtitle: "Describe your ideas and requirements",
                        onTap: () {
                          _messageController.text = "Build a new AI project";
                          _sendMessage();
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
                      child: Text(
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

  Message({required this.text, required this.isUser});
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





