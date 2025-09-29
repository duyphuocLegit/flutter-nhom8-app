import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

class FilterPresetsService {
  static const String _keyFilterPresets = 'saved_filter_presets';
  static SharedPreferences? _prefs;

  // Initialize SharedPreferences
  static Future<void> init() async {
    _prefs ??= await SharedPreferences.getInstance();
  }

  // Get all saved filter presets
  static Future<List<Map<String, dynamic>>> getSavedPresets() async {
    await init();
    final presetsJson = _prefs?.getStringList(_keyFilterPresets) ?? [];
    return presetsJson
        .map((json) => jsonDecode(json) as Map<String, dynamic>)
        .toList();
  }

  // Save a new filter preset
  static Future<void> savePreset(
    String name,
    Map<String, dynamic> filters,
  ) async {
    await init();
    final presets = await getSavedPresets();

    // Check if preset with same name exists and update it
    final existingIndex = presets.indexWhere(
      (preset) => preset['name'] == name,
    );

    final newPreset = {
      'name': name,
      'filters': filters,
      'createdAt': DateTime.now().toIso8601String(),
    };

    if (existingIndex != -1) {
      presets[existingIndex] = newPreset;
    } else {
      presets.add(newPreset);
    }

    final presetsJson = presets.map((preset) => jsonEncode(preset)).toList();
    await _prefs?.setStringList(_keyFilterPresets, presetsJson);
  }

  // Delete a filter preset
  static Future<void> deletePreset(String name) async {
    await init();
    final presets = await getSavedPresets();
    presets.removeWhere((preset) => preset['name'] == name);

    final presetsJson = presets.map((preset) => jsonEncode(preset)).toList();
    await _prefs?.setStringList(_keyFilterPresets, presetsJson);
  }

  // Get a specific preset by name
  static Future<Map<String, dynamic>?> getPreset(String name) async {
    final presets = await getSavedPresets();
    try {
      return presets.firstWhere((preset) => preset['name'] == name);
    } catch (e) {
      return null;
    }
  }

  // Check if a preset name already exists
  static Future<bool> presetExists(String name) async {
    final presets = await getSavedPresets();
    return presets.any((preset) => preset['name'] == name);
  }

  // Get suggested preset names based on current filters
  static String getSuggestedPresetName(Map<String, dynamic> filters) {
    List<String> parts = [];

    if (filters['status'] != null && filters['status'] != 'all') {
      parts.add(filters['status'].toString().toLowerCase());
    }
    if (filters['priority'] != null && filters['priority'] != 'all') {
      parts.add('${filters['priority']} priority');
    }
    if (filters['category'] != null && filters['category'] != 'all') {
      parts.add(filters['category'].toString().toLowerCase());
    }
    if (filters['dueDate'] != null && filters['dueDate'] != 'all') {
      parts.add(filters['dueDate'].toString().toLowerCase());
    }

    if (parts.isEmpty) {
      return 'All Tasks';
    }

    return parts
        .join(' + ')
        .split(' ')
        .map((word) => word[0].toUpperCase() + word.substring(1))
        .join(' ');
  }
}
