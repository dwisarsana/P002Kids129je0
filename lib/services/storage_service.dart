import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/kids_room_model.dart';

class StorageService {
  static const String _historyKey = 'KidsRoom_history';

  Future<void> savekidsRooms(List<KidsRoomModel> kidsRooms) async {
    final prefs = await SharedPreferences.getInstance();
    final List<String> jsonList = kidsRooms.map((g) => jsonEncode(g.toJson())).toList();
    await prefs.setStringList(_historyKey, jsonList);
  }

  Future<List<KidsRoomModel>> loadkidsRooms() async {
    final prefs = await SharedPreferences.getInstance();
    final List<String>? jsonList = prefs.getStringList(_historyKey);
    
    if (jsonList == null) return [];

    return jsonList.map((jsonStr) {
      return KidsRoomModel.fromJson(jsonDecode(jsonStr));
    }).toList();
  }

  Future<void> toggleFavorite(String id) async {
    final kidsRooms = await loadkidsRooms();
    final index = kidsRooms.indexWhere((g) => g.id == id);
    if (index != -1) {
      final g = kidsRooms[index];
      kidsRooms[index] = KidsRoomModel(
        id: g.id,
        originalImagePath: g.originalImagePath,
        resultImagePath: g.resultImagePath,
        styleName: g.styleName,
        timestamp: g.timestamp,
        settings: g.settings,
        isFavorite: !g.isFavorite,
      );
      await savekidsRooms(kidsRooms);
    }
  }

  Future<void> clearAll() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.clear();
  }
}
