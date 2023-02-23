import 'package:flutter/material.dart';
import 'package:flutter_quill/flutter_quill.dart' as quill hide Text;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:wordonline/colors.dart';
// import 'package:wordonline/repository/document_repository.dart';

class DocumentScreen extends ConsumerStatefulWidget {
  final String id;
  const DocumentScreen({super.key, required this.id});

  @override
  ConsumerState<DocumentScreen> createState() => _DocumentScreenState();
}

class _DocumentScreenState extends ConsumerState<DocumentScreen> {
  TextEditingController titleController =
      TextEditingController(text: "Untitled Document");
  final quill.QuillController _controller = quill.QuillController.basic();

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    titleController.dispose();
    _controller.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: kWhiteColor,
        actions: [
          Container(
            // margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
            padding: const EdgeInsets.all(10),
            child: ElevatedButton.icon(
                style: ElevatedButton.styleFrom(backgroundColor: kblueColor),
                onPressed: () {},
                icon: const Icon(
                  Icons.lock,
                  size: 16,
                  color: kWhiteColor,
                ),
                label: const Text('Share')),
          ),
        ],
        title: Padding(
          padding: const EdgeInsets.all(9.0),
          child: Row(
            children: [
              Image.asset(
                'assets/images/docs-logo.png',
                height: 40,
              ),
              const SizedBox(
                height: 10,
              ),
              SizedBox(
                width: 180,
                child: TextField(
                  controller: titleController,
                  decoration: const InputDecoration(
                    border: InputBorder.none,
                    focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: kblueColor)),
                    contentPadding: EdgeInsets.only(left: 10),
                  ),
                ),
              ),
            ],
          ),
        ),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(1),
          child: Container(
            decoration: BoxDecoration(
                border: Border.all(color: kgreyColor, width: 0.1)),
          ),
        ),
      ),
      body: Column(
        children: [
          quill.QuillToolbar.basic(controller: _controller),
          Expanded(
              child: quill.QuillEditor.basic(
                controller: _controller,
                readOnly: false, // true for view only mode
              
            ),
          )
        ],
      ),
    );
  }
}
