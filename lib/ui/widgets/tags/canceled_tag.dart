import 'package:flutter/material.dart';
import 'package:openmeter/core/helper/color_adjuster.dart';
import 'package:openmeter/ui/widgets/tags/tag_chip.dart';

import '../../../core/enums/tag_chip_state.dart';
import '../../../core/model/tag_dto.dart';
import '../../../utils/custom_colors.dart';

class CanceledTag extends StatelessWidget {
  const CanceledTag({super.key});

  @override
  Widget build(BuildContext context) {
    return TagChip(
      tag: TagDto.fromValue(
        name: 'gekündigt',
        color: CustomColors.canceled.toInt(),
      ),
      state: TagChipState.simple,
    );
  }
}
