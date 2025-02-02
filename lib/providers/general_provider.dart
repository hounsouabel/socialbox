import 'package:groupe7/models/posts/repository/repsitory.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final globalProvider = Provider((ref) {
  return PostRepository();
});