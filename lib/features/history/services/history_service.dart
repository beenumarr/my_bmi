import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../core/constants/app_constants.dart';
import '../models/history_entry.dart';

/// Service managing offline persistence for calculation history.
class HistoryService extends ChangeNotifier {
  List<HistoryEntry> _entries = [];
  bool _isLoaded = false;

  List<HistoryEntry> get entries => List.unmodifiable(_entries);
  bool get isLoaded => _isLoaded;
  bool get isEmpty => _isLoaded && _entries.isEmpty;

  Future<void> init() async {
    if (_isLoaded) return;
    await loadHistory();
  }

  Future<void> loadHistory() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final jsonList = prefs.getStringList(AppConstants.keyHistory) ?? [];
      _entries = jsonList
          .map((item) {
            try {
              return HistoryEntry.fromJson(item);
            } catch (e) {
              return null;
            }
          })
          .whereType<HistoryEntry>()
          .toList();

      // Sort newest first
      _entries.sort((a, b) => b.timestamp.compareTo(a.timestamp));
    } catch (e) {
      debugPrint('Error loading history: $e');
      _entries = [];
    } finally {
      _isLoaded = true;
      notifyListeners();
    }
  }

  Future<void> addEntry(HistoryEntry entry) async {
    // Avoid exact duplicate at the same second
    _entries.removeWhere((item) => item.id == entry.id);
    _entries.insert(0, entry);
    notifyListeners();
    await _saveToDisk();
  }

  Future<void> deleteEntry(String id) async {
    _entries.removeWhere((item) => item.id == id);
    notifyListeners();
    await _saveToDisk();
  }

  Future<void> clearHistory() async {
    _entries.clear();
    notifyListeners();
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(AppConstants.keyHistory);
  }

  Future<void> _saveToDisk() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final stringList = _entries.map((e) => json.encode(e.toMap())).toList();
      await prefs.setStringList(AppConstants.keyHistory, stringList);
    } catch (e) {
      debugPrint('Error persisting history: $e');
    }
  }
}
