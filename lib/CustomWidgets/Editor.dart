import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_quill/flutter_quill.dart' as quill;
import 'package:recipy/Utilities/Constants.dart';
import 'package:recipy/Utilities/CustomTheme.dart';
import 'package:tuple/tuple.dart';

class Editor extends StatefulWidget {
  final Size mediaSize;
  final quill.QuillController quillController;
  const Editor(this.mediaSize, {Key? key, required this.quillController}) : super(key: key);

  @override
  _EditorState createState() => _EditorState();
}

class _EditorState extends State<Editor> {

  String jsonText = jsonEncode([{"insert":"Lorem ipsum dolor sit amet","attributes":{"bold":true,"underline":true}},{"insert":"\n","attributes":{"header":1,"indent":22}},{"insert":"Consectetur adipiscing elit. Pellentesque congue odio vitae aliquet elementum. Nullam posuere nibh sapien, in suscipit lorem pellentesque at. Aliquam scelerisque nisi ex, efficitur tempus mauris fermentum sed. Nulla facilisi. Praesent urna tortor, fermentum id dolor in, cursus gravida urna. Maecenas in pretium massa. Donec in malesuada ligula. Donec faucibus libero ac arcu ultricies pulvinar. Nunc lobortis, odio sed consequat vulputate, velit tellus elementum justo, a varius velit est a sem. Sed nec scelerisque massa. In volutpat sollicitudin nibh. Proin pharetra","attributes":{"color":"#004d40"}},{"insert":" congue tempus. Curabitur facilisis eli","attributes":{"color":"#004d40","background":"#f44336","strike":true}},{"insert":"t vel hendrerit elementum. Praesent ultrices consequat luctus. Etiam mattis est nec enim facilisis ornare. Cras elementum, neque quis commodo condimentum, lacus erat bibendum massa, ac viverra ante sapien nec lorem.","attributes":{"color":"#004d40"}},{"insert":"\n"}]);
  String jsonTextTest = "[{\"insert\":\"Lorem ipsum dolor sit amet\",\"attributes\":{\"bold\":true,\"underline\":true}},{\"insert\":\"\\n\",\"attributes\":{\"header\":1,\"indent\":22}},{\"insert\":\"Consectetur adipiscing elit. Pellentesque congue odio vitae aliquet elementum. Nullam posuere nibh sapien, in suscipit lorem pellentesque at. Aliquam scelerisque nisi ex, efficitur tempus mauris fermentum sed. Nulla facilisi. Praesent urna tortor, fermentum id dolor in, cursus gravida urna. Maecenas in pretium massa. Donec in malesuada ligula. Donec faucibus libero ac arcu ultricies pulvinar. Nunc lobortis, odio sed consequat vulputate, velit tellus elementum justo, a varius velit est a sem. Sed nec scelerisque massa. In volutpat sollicitudin nibh. Proin pharetra\",\"attributes\":{\"color\":\"#004d40\"}},{\"insert\":\" congue tempus. Curabitur facilisis eli\",\"attributes\":{\"color\":\"#004d40\",\"background\":\"#f44336\",\"strike\":true}},{\"insert\":\"t vel hendrerit elementum. Praesent ultrices consequat luctus. Etiam mattis est nec enim facilisis ornare. Cras elementum, neque quis commodo condimentum, lacus erat bibendum massa, ac viverra ante sapien nec lorem.\",\"attributes\":{\"color\":\"#004d40\"}},{\"insert\":\"\\n\"}]";
  final FocusNode _focusNode = FocusNode();
  final FocusNode _keyListenerNode = FocusNode();
  String characterCount = "";
  @override
  void initState() {
    setState(() {
      characterCount = widget.quillController.document.length.toString();
    });
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return RawKeyboardListener(
      focusNode: _keyListenerNode,
      onKey: (event) async{
        await Future.delayed(Duration(milliseconds: 10));
        if (event is RawKeyDownEvent){
          setState(() {
            characterCount = characterCount = widget.quillController.document.length.toString();
          });
          if (widget.quillController.document.length > 900){

          }
        }
      },
      child: SizedBox(
        height: widget.mediaSize.height * 0.92,
        width: widget.mediaSize.width * 0.65,
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                quill.QuillToolbar.basic(
                  controller: widget.quillController,
                  locale: const Locale('en'),
                  showImageButton: false,
                  showVideoButton: false,
                  showCodeBlock: false,
                  showInlineCode: false,
                  iconTheme: quill.QuillIconTheme(
                      disabledIconColor: Colors.black26,
                      iconUnselectedFillColor: CustomTheme.accent2,
                      iconUnselectedColor: CustomTheme.textDark,
                      iconSelectedFillColor: CustomTheme.iconSelectedFill,
                      iconSelectedColor: CustomTheme.textDark
                  ),
                ),
                Text(characterCount)
              ],
            ),
            const SizedBox(height: 10,),
            Container(
                decoration: BoxDecoration(
                    color: CustomTheme.secondaryBackground,
                    border: Border.all(
                        color: CustomTheme.accent2,
                        width: 3.0
                    )
                ),
                height: widget.mediaSize.height * 0.87,
                width: widget.mediaSize.width * 0.65,
                child: quill.QuillEditor(
                  controller: widget.quillController,
                  scrollController: ScrollController(),
                  scrollable: true,
                  focusNode: _focusNode,
                  autoFocus: false,
                  readOnly: false,
                  showCursor: true,
                  placeholder: 'Dodaj tekst artykułu...',
                  expands: false,
                  padding: EdgeInsets.zero,
                  customStyles: quill.DefaultStyles(
                    h1: quill.DefaultTextBlockStyle(
                        const TextStyle(
                          fontSize: 32,
                          color: Colors.black,
                          height: 1.15,
                          fontWeight: FontWeight.w300,
                        ),
                        const Tuple2(16, 0),
                        const Tuple2(0, 0),
                        null),
                    sizeSmall: const TextStyle(fontSize: 12),

                  )
                )
            ),
          ],
        ),
      ),
    );
  }
}
