import 'package:flutter/material.dart';
import '../../../core/constants/_values.dart';
import '../../../core/utils/glass_container.dart';
import '../../../core/utils/strings_service.dart';

class GlassInputField extends StatelessWidget {
  final TextEditingController? controller;
  final String hintText;
  final VoidCallback? onPaste;
  final bool isDark;

  const GlassInputField({
    super.key,
    this.controller,
    required this.hintText,
    this.onPaste,
    this.isDark = true,
  });

  @override
  Widget build(BuildContext context) {
    final colors = StringsService.strings.colors;

    return GlassContainer(
      height: AppValues.homeInputHeight,
      borderRadius: 28,
      isDark: isDark,
      opacity: 0.12,
      borderOpacity: 0.10,
      borderWidth: 1.0,
      blur: 18,
      showBorder: true,
      padding: const EdgeInsets.symmetric(horizontal: AppValues.homeInputPadH),
      child: Row(
        children: [
          Icon(
            Icons.link_rounded,
            size: AppValues.homeInputIconSize,
            color: colors.darkTextTertiary,
          ),
          const SizedBox(width: AppValues.homeInputIconGap),
          Expanded(
            child: TextField(
              controller: controller,
              style: TextStyle(
                color: colors.darkTextPrimary,
                fontSize: AppValues.homeInputFontSize,
              ),
              decoration: InputDecoration(
                hintText: hintText,
                hintStyle: TextStyle(
                  color: colors.darkTextTertiary,
                  fontSize: AppValues.homeInputFontSize,
                ),
                border: InputBorder.none,
                isDense: true,
                contentPadding: EdgeInsets.zero,
              ),
            ),
          ),
          GestureDetector(
            onTap: onPaste,
            child: Icon(
              Icons.content_paste_rounded,
              size: AppValues.homePasteIconSize,
              color: colors.darkTextTertiary,
            ),
          ),
        ],
      ),
    );
  }
}
