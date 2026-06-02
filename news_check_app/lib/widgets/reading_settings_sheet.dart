import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:news_check_app/controllers/reading_settings_controller.dart';

class ReadingSettingsSheet extends StatefulWidget {
  const ReadingSettingsSheet({super.key});

  @override
  State<ReadingSettingsSheet> createState() => _ReadingSettingsSheetState();
}

class _ReadingSettingsSheetState extends State<ReadingSettingsSheet> {
  late final ReadingSettingsController _ctrl;

  @override
  void initState() {
    super.initState();
    _ctrl = Get.find<ReadingSettingsController>();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      padding: EdgeInsets.only(
        left: 24, right: 24, top: 16,
        bottom: MediaQuery.of(context).padding.bottom + 16,
      ),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
      ),
      child: Obx(() => Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Center(
            child: Container(
              width: 32, height: 4,
              decoration: BoxDecoration(
                color: theme.colorScheme.onSurfaceVariant.withAlpha(60),
                borderRadius: BorderRadius.circular(2),
              ),
            ),
          ),
          const SizedBox(height: 16),
          Text('阅读设置', style: theme.textTheme.titleMedium),
          const SizedBox(height: 20),

          _buildSliderLabel('字号', '${_ctrl.fontSize.value.round()}'),
          _buildSlider(
            value: _ctrl.fontSize.value,
            min: ReadingSettingsController.minFontSize,
            max: ReadingSettingsController.maxFontSize,
            divisions: 10,
            onChanged: (v) {
              _ctrl.fontSize.value = v;
              _ctrl.saveToPrefs();
            },
          ),
          const SizedBox(height: 16),

          _buildSliderLabel('行距', _ctrl.lineSpacing.value.toStringAsFixed(2)),
          _buildSlider(
            value: _ctrl.lineSpacing.value,
            min: ReadingSettingsController.minLineSpacing,
            max: ReadingSettingsController.maxLineSpacing,
            divisions: 26,
            onChanged: (v) {
              _ctrl.lineSpacing.value = v;
              _ctrl.saveToPrefs();
            },
          ),
          const SizedBox(height: 16),

          _buildSliderLabel('阅读模式', ''),
          const SizedBox(height: 8),
          Row(
            children: [
              _modeChip('白色', ReadingBgMode.normal),
              const SizedBox(width: 8),
              _modeChip('护眼', ReadingBgMode.sepia),
              const SizedBox(width: 8),
              _modeChip('深色', ReadingBgMode.dark),
            ],
          ),
          const SizedBox(height: 20),

          Center(
            child: TextButton(
              onPressed: () {
                _ctrl.resetToDefaults();
                _ctrl.fontSize.refresh();
              },
              child: const Text('恢复默认设置'),
            ),
          ),
        ],
      )),
    );
  }

  Widget _buildSliderLabel(String label, String value) {
    return Row(
      children: [
        Text(label, style: const TextStyle(fontSize: 14)),
        const Spacer(),
        Text(value, style: Theme.of(context).textTheme.bodySmall),
      ],
    );
  }

  Widget _buildSlider({
    required double value,
    required double min,
    required double max,
    required int divisions,
    required ValueChanged<double> onChanged,
  }) {
    return Slider(
      value: value,
      min: min,
      max: max,
      divisions: divisions,
      onChanged: onChanged,
    );
  }

  Widget _modeChip(String label, ReadingBgMode mode) {
    final selected = _ctrl.readingBg.value == mode;
    return ChoiceChip(
      label: Text(label),
      selected: selected,
      onSelected: (_) {
        _ctrl.readingBg.value = mode;
        _ctrl.saveToPrefs();
      },
    );
  }
}

Future<void> showReadingSettingsSheet(BuildContext context) {
  return showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.transparent,
    builder: (_) => const ReadingSettingsSheet(),
  );
}