/*import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter/material.dart';

import '../models/post.dart';
import '../providers/get_all_comments_provider.dart';
import '../widgets/post_footer.dart';
import '../widgets/post_header.dart';
import '../widgets/post_widget.dart';

class FullPostDetailsScreen extends ConsumerWidget {
  final Post post;

  const FullPostDetailsScreen({super.key, required this.post});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
        child: Column(
          children: [
            _buildAppBar(context),
            Expanded(
              child: CustomScrollView(
                slivers: [
                  _buildMediaSection(),
                  SliverToBoxAdapter(child: PostHeader(userId: post.posterId, postId: post.postId,)),
                  SliverToBoxAdapter(child: PostFooter(userId: post.posterId, post: post,)),
                  _buildCommentsSection(ref),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAppBar(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        children: [
          IconButton(
            icon: const Icon(Icons.arrow_back, color: Colors.white),
            onPressed: () => Navigator.pop(context),
          ),
          const Spacer(),
          Text(
            'Publication',
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
          const Spacer(),
        ],
      ),
    );
  }

  Widget _buildMediaSection() {
    return SliverToBoxAdapter(
      child: AspectRatio(
        aspectRatio: 1,
        child: post.postType == 'image'
            ? Image.network(post.fileUrl, fit: BoxFit.cover)
            : VideoPlayerWidget(
          videoUrl: post.fileUrl,
          autoPlay: true,
          //showControls: true,
        ),
      ),
    );
  }

  Widget _buildCommentsSection(WidgetRef ref) {
    final commentsAsync = ref.watch(getAllCommentsProvider(post.postId));

    return SliverList(
      delegate: commentsAsync.when(
        loading: () => _buildLoadingDelegate(),
        error: (error, _) => _buildErrorDelegate(error),
        data: (comments) => SliverChildBuilderDelegate(
              (context, index) => CommentItem(comment: comments[index]),
          childCount: comments.length,
        ),
      ),
    );
  }

  SliverChildDelegate _buildLoadingDelegate() {
    return SliverChildBuilderDelegate(
          (context, index) => const Center(child: CircularProgressIndicator()),
      childCount: 1,
    );
  }

  SliverChildDelegate _buildErrorDelegate(dynamic error) {
    return SliverChildBuilderDelegate(
          (context, index) => Text('Erreur: $error', style: const TextStyle(color: Colors.red)),
      childCount: 1,
    );
  }
}*/