import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import 'package:t_store/utils/constants/colors.dart';
import 'package:t_store/utils/constants/sizes.dart';
import 'package:t_store/utils/helpers/helper_functions.dart';

import '../../../../common/widgets/appbar/appbar.dart';

class ChatPage extends StatefulWidget {
  static const routeName = '/chat';
  const ChatPage({super.key});

  @override
  State<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  final TextEditingController _chatController = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  List<Map<String, dynamic>> _chatHistory = [];

  @override
  Widget build(BuildContext context) {
    final dark = THelperFunctions.isDarkMode(context);
    void getAnswer() async {
      const url =
          "https://generativelanguage.googleapis.com/v1beta2/models/chat-bison-001:generateMessage?key=AIzaSyCImZTSZPgWkrLITVNPnrcr4MnF_FAUzm8";
      final uri = Uri.parse(url);
      List<Map<String, String>> msg = [];
      for (var i = 0; i < _chatHistory.length; i++) {
        msg.add({"content": _chatHistory[i]["message"]});
      }

      Map<String, dynamic> request = {
        "prompt": {
          "messages": [msg]
        },
        "temperature": 0.25,
        "candidateCount": 1,
        "topP": 1,
        "topK": 1
      };

      final response = await http.post(uri, body: jsonEncode(request));

      setState(() {
        _chatHistory.add({
          "time": DateTime.now(),
          "message": json.decode(response.body)["candidates"][0]["content"],
          "isSender": false,
        });
      });

      _scrollController.jumpTo(
        _scrollController.position.maxScrollExtent,
      );
    }

    return Scaffold(
      resizeToAvoidBottomInset: true,
      appBar: TAppBar(
        title: Text('Chat', style: Theme.of(context).textTheme.headlineSmall!),
        showBackArrow: true,
      ),
      body: Stack(
        children: [
          Container(
            //get max height
            height: MediaQuery.of(context).size.height - 160,
            child: ListView.builder(
              itemCount: _chatHistory.length,
              shrinkWrap: true,
              controller: _scrollController,
              padding: const EdgeInsets.only(top: 10, bottom: 10),
              physics: const BouncingScrollPhysics(),
              itemBuilder: (context, index) {
                return Container(
                  padding: const EdgeInsets.only(
                      left: 14, right: 14, top: 10, bottom: 10),
                  child: Align(
                    alignment: (_chatHistory[index]["isSender"]
                        ? Alignment.topRight
                        : Alignment.topLeft),
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20),
                        boxShadow: [
                          BoxShadow(
                            color: const Color.fromARGB(255, 242, 240, 240)
                                .withOpacity(0.5),
                            spreadRadius: 2,
                            blurRadius: 5,
                            offset: const Offset(0, 3),
                          ),
                        ],
                        color: (_chatHistory[index]["isSender"]
                            ? (dark
                                ? const Color.fromARGB(255, 116, 93, 220)
                                : const Color.fromARGB(255, 172, 160, 224))
                            : (dark
                                ? const Color.fromARGB(255, 63, 120, 235)
                                : const Color.fromARGB(255, 131, 212, 226))),
                      ),
                      padding: EdgeInsets.all(16),
                      child: Text(_chatHistory[index]["message"],
                          style: TextStyle(
                              fontSize: 15,
                              color: dark ? Colors.white : TColors.black)),
                    ),
                  ),
                );
              },
            ),
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: Container(
              padding:
                  const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
              height: 80,
              width: double.infinity,
              color: Colors.transparent,
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                        decoration: InputDecoration(
                            filled: true,
                            fillColor: dark ? TColors.dark : TColors.light,
                            hintText: "Type a message",
                            border: InputBorder.none,
                            contentPadding: const EdgeInsets.symmetric(
                                vertical: 22.0, horizontal: 12.0)),
                        controller: _chatController),
                  ),
                  const SizedBox(
                    width: TSizes.spaceBtwInputFields,
                  ),
                  ElevatedButton(
                    onPressed: () {
                      setState(() {
                        if (_chatController.text.isNotEmpty) {
                          _chatHistory.add({
                            "time": DateTime.now(),
                            "message": _chatController.text,
                            "isSender": true,
                          });
                          _chatController.clear();
                        }
                      });
                      _scrollController.jumpTo(
                        _scrollController.position.maxScrollExtent,
                      );

                      getAnswer();
                    },
                    child: const Icon(
                      Icons.send,
                      semanticLabel: 'Send Message',
                      size: TSizes.iconLg,
                    ),
                  ),
                ],
                // children: [
                //   Expanded(
                //     child: Container(
                //       decoration: const BoxDecoration(
                //         borderRadius: BorderRadius.all(Radius.circular(50.0)),
                //       ),
                //       child: Padding(
                //         padding: const EdgeInsets.all(4.0),
                //         child: TextField(
                //           decoration: const InputDecoration(
                //             hintText: "Type a message",
                //             border: InputBorder.none,
                //             contentPadding: EdgeInsets.all(8.0),
                //           ),
                //           controller: _chatController,
                //         ),
                //       ),
                //     ),
                //   ),
                //   const SizedBox(
                //     width: 4.0,
                //   ),
                //   ElevatedButton(
                //     onPressed: () {
                //       setState(() {
                //         if (_chatController.text.isNotEmpty) {
                //           _chatHistory.add({
                //             "time": DateTime.now(),
                //             "message": _chatController.text,
                //             "isSender": true,
                //           });
                //           _chatController.clear();
                //         }
                //       });
                //       _scrollController.jumpTo(
                //         _scrollController.position.maxScrollExtent,
                //       );

                //       getAnswer();
                //     },
                //     style: ElevatedButton.styleFrom(
                //       padding: const EdgeInsets.fromLTRB(24.0, 12.0, 12.0,
                //           24.0), // Adjust top padding as needed
                //     ),
                //     child: const Icon(
                //       Iconsax.edit,
                //       size: TSizes.iconLg,
                //     ),
                //   )
                // ],
              ),
            ),
          )
        ],
      ),
    );
  }
}
