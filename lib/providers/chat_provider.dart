import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/chat/chat_repository.dart';
final chatProvider = Provider(
  (ref) => ChatRepository(),
);
