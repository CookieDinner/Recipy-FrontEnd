
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_quill/flutter_quill.dart' as quill;
import 'package:recipy/Utilities/CustomTheme.dart';
import 'package:tuple/tuple.dart';

class Editor extends StatefulWidget {
  final Size mediaSize;
  final quill.QuillController quillController;
  final bool readOnly;
  const Editor(this.mediaSize, {Key? key, required this.quillController, this.readOnly = false}) : super(key: key);

  @override
  _EditorState createState() => _EditorState();
}

class _EditorState extends State<Editor> {
  final FocusNode _focusNode = FocusNode();
  final FocusNode _keyListenerNode = FocusNode();
  late int characterCount;
  @override
  void initState() {
    setState(() {
      characterCount = widget.quillController.document.length;
    });
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return RawKeyboardListener(
      focusNode: _keyListenerNode,
      onKey: !widget.readOnly ? (event) async{
        await Future.delayed(Duration(milliseconds: 10));
        if (event is RawKeyDownEvent){
          setState(() {
            characterCount = widget.quillController.document.length;
          });
        }
      } : null,
      child: SizedBox(
        height: 890,
        width: widget.mediaSize.width * 0.65,
        child: Column(
          children: [
            !widget.readOnly ? Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                quill.QuillToolbar.basic(
                  controller: widget.quillController,
                  locale: const Locale('en'),
                  showImageButton: false,
                  showVideoButton: false,
                  showCodeBlock: false,
                  showInlineCode: false,
                  showColorButton: false,
                  showLink: false,
                  showBackgroundColorButton: false,
                  iconTheme: quill.QuillIconTheme(
                      disabledIconColor: Colors.black26,
                      iconUnselectedFillColor: CustomTheme.accent2,
                      iconUnselectedColor: CustomTheme.textDark,
                      iconSelectedFillColor: CustomTheme.iconSelectedFill,
                      iconSelectedColor: CustomTheme.textDark
                  ),
                ),
                Text((characterCount - 1).toString() + " / 8000", style: TextStyle(color: (characterCount > 8000 || characterCount <= 1) ? Colors.red : Colors.black87, fontSize: 15),)
              ],
            ) : Container(),
            const SizedBox(height: 10,),
            Container(
                decoration: BoxDecoration(
                    color: CustomTheme.secondaryBackground,
                    border: Border.all(
                        color: CustomTheme.text,
                        width: 2
                    )
                ),
                height: 845,
                width: widget.mediaSize.width * 0.65,
                child: quill.QuillEditor(
                  controller: widget.quillController,
                  scrollController: ScrollController(),
                  scrollable: true,
                  focusNode: _focusNode,
                  autoFocus: false,
                  readOnly: widget.readOnly,
                  showCursor: !widget.readOnly,
                  placeholder: 'Dodaj tekst artykułu...',
                  expands: false,
                  padding: EdgeInsets.symmetric(horizontal: 16),
                  customStyles: quill.DefaultStyles(
                    h1: quill.DefaultTextBlockStyle(
                        TextStyle(
                          fontSize: 32,
                          color: CustomTheme.textDark,
                          height: 1.15,
                          fontWeight: FontWeight.w600,
                        ),
                        const Tuple2(16, 0),
                        const Tuple2(0, 0),
                        null),
                    h2: quill.DefaultTextBlockStyle(
                        TextStyle(
                          fontSize: 26,
                          color: CustomTheme.textDark,
                          height: 1.15,
                          fontWeight: FontWeight.w600,
                        ),
                        const Tuple2(16, 0),
                        const Tuple2(0, 0),
                        null),
                    h3: quill.DefaultTextBlockStyle(
                        TextStyle(
                          fontSize: 20,
                          color: CustomTheme.textDark,
                          height: 1.15,
                          fontWeight: FontWeight.w600,
                        ),
                        const Tuple2(16, 0),
                        const Tuple2(0, 0),
                        null),
                    paragraph: quill.DefaultTextBlockStyle(
                        TextStyle(
                          fontSize: 16,
                          color: CustomTheme.textDark,
                          height: 1.15,
                          fontWeight: FontWeight.w300,
                        ),
                        const Tuple2(12, 0),
                        const Tuple2(0, 0),
                        null),
                    small: TextStyle(fontSize: 12, color: CustomTheme.textDark),
                  )
                )
            ),
          ],
        ),
      ),
    );
  }
}
