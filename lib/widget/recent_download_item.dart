import 'package:flutter/material.dart';
import '../../../core/constants/_values.dart';
import '../../../core/utils/glass_container.dart';
import '../../../core/utils/strings_service.dart';

class RecentDownloadItem extends StatelessWidget {
  final String title;
  final String size;
  final String type;
  final String? thumbnailUrl;
  final bool isDark;
  final VoidCallback? onMore;

  const RecentDownloadItem({
    super.key,
    required this.title,
    required this.size,
    required this.type,
    this.thumbnailUrl,
    this.isDark = true,
    this.onMore,
  });

  @override
  Widget build(BuildContext context) {
    final colors = StringsService.strings.colors;

    return GlassContainer(
      borderRadius: 14,
      isDark: isDark,
      opacity: 0.12,
      borderOpacity: 0.06,
      borderWidth: 1.0,
      blur: 14,
      showBorder: true,
      padding: const EdgeInsets.all(AppValues.homeRecentCardPad),
      margin: const EdgeInsets.only(bottom: AppValues.homeRecentCardGap),
      child: Row(
        children: [
          Container(
            width: AppValues.homeRecentThumb,
            height: AppValues.homeRecentThumb,
            decoration: BoxDecoration(
              borderRadius:
                  BorderRadius.circular(AppValues.homeRecentThumbRadius),
              gradient: colors.primaryGradient,
            ),
            child: ClipRRect(
              borderRadius:
                  BorderRadius.circular(AppValues.homeRecentThumbRadius),
              child: Stack(
                fit: StackFit.expand,
                children: [
                  if (thumbnailUrl != null)
                    Image.network(thumbnailUrl!,
                        fit: BoxFit.cover,
                        errorBuilder: (_, __, ___) => const SizedBox())
                  else
                    Container(color: const Color(0xFF2A2D45)),
                  Center(
                    child: Container(
                      width: 28,
                      height: 28,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: colors.white.withOpacity(0.9),
                      ),
                      child: Icon(Icons.play_arrow_rounded,
                          size: 18, color: colors.black),
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(width: AppValues.homeRecentThumbGap),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontSize: AppValues.homeRecentTitleSize,
                    fontWeight: FontWeight.w600,
                    color: isDark
                        ? colors.darkTextPrimary
                        : colors.lightTextPrimary,
                  ),
                ),
                const SizedBox(height: AppValues.homeRecentTitleGap),
                Text(
                  '$size  •  $type',
                  style: TextStyle(
                    fontSize: AppValues.homeRecentMetaSize,
                    color: isDark
                        ? colors.darkTextTertiary
                        : colors.lightTextTertiary,
                  ),
                ),
              ],
            ),
          ),
          GestureDetector(
            onTap: onMore,
            child: Icon(
              Icons.more_vert_rounded,
              size: AppValues.homeRecentMoreSize,
              color:
                  isDark ? colors.darkTextTertiary : colors.lightTextTertiary,
            ),
          ),
        ],
      ),
    );
  }
}
