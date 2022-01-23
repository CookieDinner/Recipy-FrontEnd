import 'package:flutter/material.dart';
import 'package:flutter_quill/flutter_quill.dart';
import 'package:recipy/Utilities/CustomTheme.dart';
import 'package:tuple/tuple.dart';

class Editor extends StatefulWidget {
  final Size mediaSize;
  const Editor(this.mediaSize, {Key? key}) : super(key: key);

  @override
  _EditorState createState() => _EditorState();
}

class _EditorState extends State<Editor> {
  QuillController _quillController = QuillController.basic();
  final FocusNode _focusNode = FocusNode();
  @override
  Widget build(BuildContext context) {
    return Container(
      color: CustomTheme.tertiaryBackground,
      height: 900,
      width: widget.mediaSize.width,
      child: SizedBox(
        height: 500,
        width: 1000,
        child: Column(
          children: [
            QuillToolbar.basic(
              controller: _quillController,
              locale: const Locale('en'),
              showImageButton: false,
              showVideoButton: false,
              showCodeBlock: false,
              showInlineCode: false,
              iconTheme: QuillIconTheme(
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
                child: QuillEditor(
                    controller: _quillController,
                    scrollController: ScrollController(),
                    scrollable: true,
                    focusNode: _focusNode,
                    autoFocus: false,
                    readOnly: false,
                    placeholder: 'Add content',
                    expands: false,
                    padding: EdgeInsets.zero,
                    customStyles: DefaultStyles(
                      h1: DefaultTextBlockStyle(
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
            )
          ],
        ),
      ),
    );
  }
}
