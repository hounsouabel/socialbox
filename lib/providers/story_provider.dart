
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../models/stories/story_repository.dart';

final storyProvider = Provider((ref) {
  return StoryRepository();
});