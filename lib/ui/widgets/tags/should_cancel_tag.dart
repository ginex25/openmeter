import 'package:flutter/material.dart';
import 'package:openmeter/core/helper/color_adjuster.dart';

import '../../../core/enums/tag_chip_state.dart';
import '../../../core/model/tag_dto.dart';
import '../../../utils/custom_colors.dart';
import 'tag_chip.dart';

class ShouldCancelTag extends StatelessWidget {
  const ShouldCancelTag({super.key});

  @override
  Widget build(BuildContext context) {
    return TagChip(
      tag: TagDto.fromValue(
        name: 'kündigen',
        color: CustomColors.yellow.toInt(),
      ),
      state: TagChipState.simple,
    );
  }
}
