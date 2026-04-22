// lib/services/kids_room_generation_service.dart
import 'dart:io';

import 'package:flutter/foundation.dart';

import '../replicate_nano_banana_service_multi.dart';
import '../safe_prompt_filter.dart';

export '../replicate_nano_banana_service_multi.dart'
    show GenerationConfig, UnsafePromptException, NetworkException;

/// Builds an optimised Imagen / Replicate prompt from the settings that the
/// user selected in [CustomStudioScreen].
class KidsRoomPromptBuilder {
  static String build({
    required String styleName,
    required Map<String, dynamic> settings,
  }) {
    final parts = <String>[];

    // ── Preservation prefix ──────────────────────────────────────────────
    parts.add(
      'Transform this existing indoor kids room photo while preserving the '
      'exact same camera angle, perspective, spatial layout, '
      'and surrounding architecture.',
    );

    // ── Style ────────────────────────────────────────────────────────────
    parts.add('Apply a $styleName KidsRoom design style to the indoor space.');

    // ── Season ───────────────────────────────────────────────────────────
    final season = settings['season'] as String?;
    if (season != null && season.isNotEmpty) {
      parts.add('Set the kids room with appropriate toys, colors, and atmosphere.');
    }

    // ── Time of Day ──────────────────────────────────────────────────────
    final timeOfDay = settings['timeOfDay'] as String?;
    if (timeOfDay != null && timeOfDay.isNotEmpty) {
      parts.add('Lighting should reflect $timeOfDay ambiance.');
    }

    // ── Plant density ────────────────────────────────────────────────────
    final density = (settings['density'] as num?)?.toDouble() ?? 0.5;
    if (density > 0.7) {
      parts.add('Filled with lots of toys, posters, and play areas.');
    } else if (density < 0.3) {
      parts.add('Sparse, minimalist room with open space and breathing room.');
    } else {
      parts.add('Balanced toy density with well-spaced play areas.');
    }

    // ── Flower intensity ─────────────────────────────────────────────────
    final flowers = (settings['flowers'] as num?)?.toDouble() ?? 0.3;
    if (flowers > 0.6) {
      parts.add(
          'Abundant colorful toys and decorations.');
    } else if (flowers > 0.2) {
      parts.add('Moderate toy accents and decorations.');
    }

    // ── Water ────────────────────────────────────────────────────────────
    final water = (settings['water'] as num?)?.toDouble() ?? 0.0;
    if (water > 0.4) {
      parts.add('Include play features such as a slide or tent.');
    }

    // ── Sunlight ─────────────────────────────────────────────────────────
    final sunlight = (settings['sunlight'] as num?)?.toDouble() ?? 0.7;
    final lightDesc = sunlight > 0.6
        ? 'bright, sun-drenched'
        : sunlight > 0.3
            ? 'partially shaded, dappled light'
            : 'softly shaded, cool tones';
    parts.add('Room has $lightDesc lighting conditions.');

    // ── Tree size ────────────────────────────────────────────────────────
    final treeSize = (settings['treeSize'] as num?)?.toDouble() ?? 0.5;
    if (treeSize > 0.7) {
      parts.add('Include tall furniture like bunk beds for scale.');
    } else if (treeSize < 0.3) {
      parts.add('Small furniture and compact storage bins only.');
    }

    // ── Color vibrancy ───────────────────────────────────────────────────
    final vibrancy = (settings['colorVibrancy'] as num?)?.toDouble() ?? 0.6;
    if (vibrancy > 0.7) {
      parts.add('Bold, vibrant color palette with high saturation.');
    } else if (vibrancy < 0.3) {
      parts.add('Muted, neutral, and earthy tones throughout.');
    }

    // ── Pathway ──────────────────────────────────────────────────────────
    final pathwayIdx = (settings['pathway'] as num?)?.toInt() ?? 0;
    const furniture = [
      'Bunk Bed',
      'Desk',
      'Bookshelf',
      'Toy Box',
      'Rug',
      'Wardrobe',
    ];
    if (pathwayIdx < furniture.length) {
      parts.add(
          'Furniture includes ${furniture[pathwayIdx]}.');
    }

    // ── Lighting fixture ─────────────────────────────────────────────────
    final lightingIdx = (settings['lighting'] as num?)?.toInt() ?? 0;
    const lightingNames = [
      'warm ambient lamps',
      'moonlight-style cool lighting',
      'fairy string lights',
      'directional spotlights',
      'decorative lanterns',
      'solar path lights',
    ];
    if (lightingIdx < lightingNames.length) {
      parts.add('Kids room lighting uses ${lightingNames[lightingIdx]}.');
    }

    // ── Water feature ────────────────────────────────────────────────────
    final waterFeatureIdx = (settings['waterFeature'] as num?)?.toInt() ?? -1;
    const playFeatures = [
      'Slide',
      'Tent',
      'Rock Wall',
      'Swing',
      'Ball Pit',
      'Chalkboard',
    ];
    if (waterFeatureIdx >= 0 && waterFeatureIdx < playFeatures.length) {
      parts.add(
          'Include a decorative ${playFeatures[waterFeatureIdx]} as a focal point.');
    }

    // ── Quality suffix ───────────────────────────────────────────────────
    parts.add(
      'Photorealistic result, professional interior design photography, '
      'consistent lighting and shadows, high resolution, 8K quality, '
      'maintaining exact same indoor space proportions and surroundings.',
    );

    return parts.join(' ');
  }
}

/// Thin wrapper that loads image bytes from a file path and calls the API.
class KidsRoomGenerationService {
  KidsRoomGenerationService()
      : _api = ReplicateKidsRoomAIService(
          filter: SafePromptFilter(mode: 'strict'),
        );

  final ReplicateKidsRoomAIService _api;

  /// [imagePath] — absolute path of the uploaded KidsRoom photo.
  /// [styleName] — selected style name.
  /// [settings]  — map of all custom-studio slider / picker values.
  Future<String?> generate({
    required String imagePath,
    required String styleName,
    required Map<String, dynamic> settings,
    GenerationConfig config = const GenerationConfig(),
  }) async {
    final bytes = await File(imagePath).readAsBytes();
    final prompt = KidsRoomPromptBuilder.build(
      styleName: styleName,
      settings: settings,
    );
    debugPrint('[KidsRoomGeneration] Prompt: $prompt');

    return _api.generateMultiBytes(
      images: [bytes],
      prompt: prompt,
      config: config,
    );
  }

  void dispose() => _api.dispose();
}
