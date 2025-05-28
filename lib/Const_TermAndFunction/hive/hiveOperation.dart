import 'package:hive_flutter/hive_flutter.dart';

class HiveService {
  static bool _initialized = false;

  late final String boxName;
  late Box _box;

  HiveService(this.boxName);

  // Call this in main() once
  static Future<void> init() async {
    if (!_initialized) {
      await Hive.initFlutter();
      _initialized = true;
    }
  }

  // Open box with provided name
  Future<void> openBox() async {
    _box = await Hive.openBox(boxName);
  }

  // Add or update
  Future<void> add(String key, dynamic value) async {
    await _box.put(key, value);
  }

  // Get value
  dynamic get(String key) {
    return _box.get(key);
  }

  // Delete key
  Future<void> delete(String key) async {
    await _box.delete(key);
  }

  // Clear all entries
  Future<void> clear() async {
    await _box.clear();
  }

  // Optional: Check if box is open
  bool get isOpen => _box.isOpen;

  // ✅ Get all data from the box as a Map<String, dynamic>
  Future<Map<String, dynamic>> readAllData() async {
    return _box.toMap().map((key, value) => MapEntry(key.toString(), value));
  }
}
