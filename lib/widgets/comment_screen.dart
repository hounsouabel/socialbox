import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/get_all_comments_provider.dart';
import '../providers/general_provider.dart';
import 'comment_tile.dart';

class CommentScreen extends ConsumerStatefulWidget {
  final String postId;

  const CommentScreen({super.key, required this.postId});

  @override
  ConsumerState<CommentScreen> createState() => _CommentScreenState();
}

class _CommentScreenState extends ConsumerState<CommentScreen> {
  final formKey = GlobalKey<FormState>();
  late TextEditingController commentController;

  @override
  void initState() {
    super.initState();
    commentController = TextEditingController();
  }

  @override
  void dispose() {
    commentController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final commentStream = ref.watch(getAllCommentsProvider(widget.postId));

    return Scaffold(
      appBar: AppBar(
        title: const Text('Commentaires'),
        backgroundColor: Colors.pink,
      ),
      body: Column(
        children: [
          Expanded(
            child: commentStream.when(
              data: (comments) => comments.isEmpty
                  ? const Center(child: Text('Aucun commentaire pour le moment.'))
                  : ListView.builder(
                itemCount: comments.length,
                itemBuilder: (context, index) {
                  final comment = comments.elementAt(index);
                  return CommentTile(comment: comment);
                },
              ),
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (e, stack) => Center(child: Text('Erreur : $e')),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Form(
              key: formKey,
              child: Row(
                children: [
                  Expanded(
                    child: TextFormField(
                      controller: commentController,
                      decoration: const InputDecoration(
                        labelText: 'Donne ton avis...',
                        border: OutlineInputBorder(),
                      ),
                      validator: (value) {
                        if (value == null || value.trim().isEmpty) {
                          return 'Le commentaire ne peut pas être vide';
                        }
                        return null;
                      },
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.send, color: Colors.pink),
                    onPressed: () async {
                      if (formKey.currentState!.validate()) {
                        await ref.read(globalProvider).makeComment(
                          text: commentController.text.trim(),
                          postId: widget.postId,
                        );
                        commentController.clear();
                      }
                    },
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
