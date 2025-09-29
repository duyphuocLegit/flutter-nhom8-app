import 'package:flutter_test/flutter_test.dart';
import 'package:nhom10/services/filter_presets_service.dart';

void main() {
  group('Filter Presets Business Logic Tests', () {
    test('should generate suggested preset names correctly', () {
      final filters1 = {
        'status': 'pending',
        'priority': 'high',
        'category': 'all',
        'dueDate': 'all',
      };
      final suggested1 = FilterPresetsService.getSuggestedPresetName(filters1);
      expect(suggested1, 'Pending + High Priority');

      final filters2 = {
        'status': 'all',
        'priority': 'all',
        'category': 'work',
        'dueDate': 'today',
      };
      final suggested2 = FilterPresetsService.getSuggestedPresetName(filters2);
      expect(suggested2, 'Work + Today');

      final filters3 = {
        'status': 'completed',
        'priority': 'low',
        'category': 'personal',
        'dueDate': 'week',
      };
      final suggested3 = FilterPresetsService.getSuggestedPresetName(filters3);
      expect(suggested3, 'Completed + Low Priority + Personal + Week');

      final filters4 = {
        'status': 'all',
        'priority': 'all',
        'category': 'all',
        'dueDate': 'all',
      };
      final suggested4 = FilterPresetsService.getSuggestedPresetName(filters4);
      expect(suggested4, 'All Tasks');
    });

    test('should handle edge cases in suggested names', () {
      final emptyFilters = <String, dynamic>{};
      final suggested = FilterPresetsService.getSuggestedPresetName(
        emptyFilters,
      );
      expect(suggested, 'All Tasks');

      final nullFilters = {
        'status': null,
        'priority': null,
        'category': null,
        'dueDate': null,
      };
      final suggestedNull = FilterPresetsService.getSuggestedPresetName(
        nullFilters,
      );
      expect(suggestedNull, 'All Tasks');
    });
  });
}
