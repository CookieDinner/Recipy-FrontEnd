import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_quill/flutter_quill.dart' as quill;
import 'package:recipy/Utilities/Constants.dart';
import 'package:recipy/Utilities/CustomTheme.dart';
import 'package:tuple/tuple.dart';

class Editor extends StatefulWidget {
  final Size mediaSize;
  const Editor(this.mediaSize, {Key? key}) : super(key: key);

  @override
  _EditorState createState() => _EditorState();
}

class _EditorState extends State<Editor> {

  String jsonText = jsonEncode([{"insert":"Lorem ipsum dolor sit amet","attributes":{"bold":true,"underline":true}},{"insert":"\n","attributes":{"header":1,"indent":22}},{"insert":"Consectetur adipiscing elit. Pellentesque congue odio vitae aliquet elementum. Nullam posuere nibh sapien, in suscipit lorem pellentesque at. Aliquam scelerisque nisi ex, efficitur tempus mauris fermentum sed. Nulla facilisi. Praesent urna tortor, fermentum id dolor in, cursus gravida urna. Maecenas in pretium massa. Donec in malesuada ligula. Donec faucibus libero ac arcu ultricies pulvinar. Nunc lobortis, odio sed consequat vulputate, velit tellus elementum justo, a varius velit est a sem. Sed nec scelerisque massa. In volutpat sollicitudin nibh. Proin pharetra","attributes":{"color":"#004d40"}},{"insert":" congue tempus. Curabitur facilisis eli","attributes":{"color":"#004d40","background":"#f44336","strike":true}},{"insert":"t vel hendrerit elementum. Praesent ultrices consequat luctus. Etiam mattis est nec enim facilisis ornare. Cras elementum, neque quis commodo condimentum, lacus erat bibendum massa, ac viverra ante sapien nec lorem.","attributes":{"color":"#004d40"}},{"insert":"\n"}]);
  String jsonTextTest = "[{\"insert\":\"Lorem ipsum dolor sit amet\",\"attributes\":{\"bold\":true,\"underline\":true}},{\"insert\":\"\\n\",\"attributes\":{\"header\":1,\"indent\":22}},{\"insert\":\"Consectetur adipiscing elit. Pellentesque congue odio vitae aliquet elementum. Nullam posuere nibh sapien, in suscipit lorem pellentesque at. Aliquam scelerisque nisi ex, efficitur tempus mauris fermentum sed. Nulla facilisi. Praesent urna tortor, fermentum id dolor in, cursus gravida urna. Maecenas in pretium massa. Donec in malesuada ligula. Donec faucibus libero ac arcu ultricies pulvinar. Nunc lobortis, odio sed consequat vulputate, velit tellus elementum justo, a varius velit est a sem. Sed nec scelerisque massa. In volutpat sollicitudin nibh. Proin pharetra\",\"attributes\":{\"color\":\"#004d40\"}},{\"insert\":\" congue tempus. Curabitur facilisis eli\",\"attributes\":{\"color\":\"#004d40\",\"background\":\"#f44336\",\"strike\":true}},{\"insert\":\"t vel hendrerit elementum. Praesent ultrices consequat luctus. Etiam mattis est nec enim facilisis ornare. Cras elementum, neque quis commodo condimentum, lacus erat bibendum massa, ac viverra ante sapien nec lorem.\",\"attributes\":{\"color\":\"#004d40\"}},{\"insert\":\"\\n\"}]";
  final FocusNode _focusNode = FocusNode();
  @override
  Widget build(BuildContext context) {
    var json = jsonDecode(jsonTextTest);
    quill.QuillController _quillController = quill.QuillController(
        document: quill.Document.fromJson(json),
        selection: TextSelection.collapsed(offset: 0));
    return Container(
      color: CustomTheme.secondaryBackground,
      height: 900,
      width: widget.mediaSize.width,
      child: SizedBox(
        height: 500,
        width: 1000,
        child: Column(
          children: [
            quill.QuillToolbar.basic(
              controller: _quillController,
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
            const SizedBox(height: 10,),
            Container(
                decoration: BoxDecoration(
                    color: CustomTheme.secondaryBackground,
                    border: Border.all(
                        color: CustomTheme.accent2,
                        width: 1.0
                    )
                ),
                height: 800,
                width: 1200,
                child: quill.QuillEditor(
                    controller: _quillController,
                    scrollController: ScrollController(),
                    scrollable: true,
                    focusNode: _focusNode,
                    autoFocus: false,
                    readOnly: true,
                    showCursor: false,
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
                      sizeSmall: const TextStyle(fontSize: 9),
                    ))
            ),
            TextButton(
              onPressed: ()=> debugPrint(jsonEncode(_quillController.document.toDelta().toJson())),
              style: TextButton.styleFrom(
                  backgroundColor: CustomTheme.buttonSecondary
              ),
              child: Center(
                child: Text(
                    "ZALOGUJ",
                    style: Constants.textStyle(
                        textStyle: const TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w500,
                            color: Colors.white
                        )
                    )
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
