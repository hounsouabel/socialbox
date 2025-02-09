import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:readmore/readmore.dart';
import '../models/post.dart';
import '../providers/get_user_info_by_id_provider.dart';
import 'comment_screen.dart';

class PostFooter extends ConsumerWidget {
  final String userId;
  final Post post;

  const PostFooter({super.key, required this.userId, required this.post});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final userInfo = ref.watch(getUserInfoByIdProvider(userId));
    bool isDarkMode = MediaQuery.of(context).platformBrightness == Brightness.dark;

    return userInfo.when(
      loading: () => const CircularProgressIndicator(),
      error: (error, stackTrace) => Text('Erreur: $error'),
      data: (userData) {
        return Padding(
          padding: const EdgeInsets.only(left: 10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 5),
              // Utilisation du widget ExpandableRichText pour fusionner le pseudo et le contenu
              ExpandableRichText(
                pseudo: userData["pseudo"],
                content: post.content,
                trimLines: 3,
                pseudoStyle: TextStyle(
                  fontWeight: FontWeight.w700,
                  color: isDarkMode ? Colors.white : Colors.black,
                ),
                contentStyle: TextStyle(
                  fontWeight: FontWeight.w400,
                  color: isDarkMode ? Colors.white : Colors.black,
                ),
              ),
              const SizedBox(height: 3),
              TextButton(
                onPressed: () {
                  showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return Dialog(
                        insetPadding: const EdgeInsets.all(10),
                        child: CommentScreen(postId: post.postId),
                      );
                    },
                  );
                },
                child: const Text(
                  'Voir tous les commentaires',
                  style: TextStyle(color: Colors.grey),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}



class ExpandableRichText extends StatefulWidget {
  final String pseudo;
  final String content;
  final TextStyle pseudoStyle;
  final TextStyle contentStyle;
  final int trimLines;

  const ExpandableRichText({
    super.key,
    required this.pseudo,
    required this.content,
    required this.pseudoStyle,
    required this.contentStyle,
    this.trimLines = 3,
  });

  @override
  _ExpandableRichTextState createState() => _ExpandableRichTextState();
}

class _ExpandableRichTextState extends State<ExpandableRichText> {
  bool _isExpanded = false;

  @override
  Widget build(BuildContext context) {
    // Construit le TextSpan combiné : le pseudo en gras et le reste en style normal.
    final combinedText = TextSpan(
      children: [
        TextSpan(text: widget.pseudo, style: widget.pseudoStyle),
        const TextSpan(text: ' '),
        TextSpan(text: widget.content, style: widget.contentStyle),
      ],
    );

    return LayoutBuilder(
      builder: (context, constraints) {
        // Calculer si le texte dépasse le nombre de lignes souhaité.
        final textPainter = TextPainter(
          text: combinedText,
          maxLines: widget.trimLines,
          textDirection: TextDirection.ltr,
        );
        textPainter.layout(maxWidth: constraints.maxWidth);
        final didOverflow = textPainter.didExceedMaxLines;

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text.rich(
              combinedText,
              maxLines: _isExpanded ? null : widget.trimLines,
              overflow: _isExpanded ? TextOverflow.visible : TextOverflow.ellipsis,
            ),
            if (didOverflow)
              GestureDetector(
                onTap: () {
                  setState(() {
                    _isExpanded = !_isExpanded;
                  });
                },
                child: Text(
                  _isExpanded ? 'Voir moins' : 'Voir plus',
                  style: const TextStyle(color: Colors.blue),
                ),
              ),
          ],
        );
      },
    );
  }
}
