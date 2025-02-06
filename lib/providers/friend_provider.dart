
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../models/friends/friend_repository.dart';

final friendProvider = Provider((ref) {
  return FriendRepository();
});