// Copyright 2022, the Flutter project authors. Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:logging/logging.dart';

import '../audio/audio_controller.dart';
import '../audio/sounds.dart';
import '../player_progress/player_progress.dart';
import '../style/palette.dart';
import '../style/responsive_screen.dart';
import 'levels.dart';

class LevelSelectionScreen extends StatelessWidget {
  const LevelSelectionScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final palette = context.watch<Palette>();
    final playerProgress = context.watch<PlayerProgress>();

    return Scaffold(
      backgroundColor: palette.backgroundLevelSelection,
      body: ResponsiveScreen(
        squarishMainArea: Column(
          children: [
            const Padding(
              padding: EdgeInsets.all(16),
              child: Center(
                child: Text(
                  'Select level',
                  style:
                      TextStyle(fontFamily: 'Permanent Marker', fontSize: 30),
                ),
              ),
            ),
            const SizedBox(height: 50),
            Expanded(
              child: ListView.separated(
                itemCount: gameLevels.length,
                itemBuilder: (BuildContext context, int index) {
                  return _LevelButton(
                      gameLevels[index].number, gameLevels[index].description);
                },
                separatorBuilder: (BuildContext context, int index) =>
                    const SizedBox(height: 10),
              ),
            ),
          ],
        ),
        rectangularMenuArea: FilledButton(
          onPressed: () {
            GoRouter.of(context).go('/');
          },
          child: const Text('Back'),
        ),
      ),
    );
  }
}

class _LevelButton extends StatelessWidget {
  final int number;
  final String label;
  // static final _log = Logger('LevelSelectionScreen');
  const _LevelButton(this.number, this.label, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final playerProgress = context.watch<PlayerProgress>();
    final palette = context.watch<Palette>();
    // final audioController = context.read<AudioController>();

    /// Level is either one that the player has already bested, on one above.
    final available = playerProgress.highestLevelReached + 1 >= number;

    /// We allow the player to skip one level.
    final availableWithSkip = playerProgress.highestLevelReached + 2 >= number;

    bool isEligibleForLevel(int number) {
      return playerProgress.highestLevelReached >= number - 1;
    }

    return FloatingActionButton(
      onPressed: isEligibleForLevel(number)
          ? null
          : () {
              audioController.playSfx(SfxType.buttonTap);
              GoRouter.of(context).go('/play/session/$number');
            }(),
      child: Text('$label',
          style: TextStyle(fontFamily: 'Permanent Marker', fontSize: 20)),
      backgroundColor: available
          ? palette.redPen
          : availableWithSkip
              ? Color.alphaBlend(palette.redPen.withOpacity(0.6), palette.ink)
              : palette.ink,
    );
  }
}
