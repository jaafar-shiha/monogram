import 'package:flutter/material.dart';
import 'package:monogram/Constants/app_styles.dart';
import 'package:monogram/SharedWidgets/main_scaffold.dart';
import 'package:monogram/generated/l10n.dart';
class EditCommentPage extends StatefulWidget {
  final String content;
  const EditCommentPage({Key? key,required this.content}) : super(key: key);

  @override
  _EditCommentPageState createState() => _EditCommentPageState();
}

class _EditCommentPageState extends State<EditCommentPage> {

  late TextEditingController contentController = TextEditingController(text: widget.content);
  @override
  Widget build(BuildContext context) {
    return MainScaffold(
      body: Column(
        children: [
          Expanded(
            child: TextField(
              controller: contentController,
              maxLines: null,
              minLines: null,
              expands: true,
              decoration: InputDecoration(
                hintStyle: AppStyles.h3,
              ),
            ),
          ),
        ],
      ),
      appBarTitle: S.of(context).editComment,
      appBarLeading: Padding(
        padding: const EdgeInsets.all(8.0),
        child: GestureDetector(
          onTap: () {},
          child: IconButton(
            onPressed: () {
              Navigator.pop(context,);
            },
            icon: const Icon(
              Icons.arrow_back,
            ),
          ),
        ),
      ),
      appBarActions: [
        TextButton(onPressed: (){
          Navigator.pop(context,contentController.text);
        }, child: Text(S.of(context).edit, style: AppStyles.h2,))
      ],
      appBarLeadingWidth: 60,
    );
  }
}
