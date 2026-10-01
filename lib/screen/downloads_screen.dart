import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../../core/constants/_values.dart';
import '../../../core/utils/glass_container.dart';
import '../../../core/utils/strings_service.dart';
import '../../../data/download_record.dart';
import '../../../data/download_storage.dart';

class DownloadsScreen extends StatefulWidget {
  const DownloadsScreen({super.key});

  @override
  State<DownloadsScreen> createState() => _DownloadsScreenState();
}

class _DownloadsScreenState extends State<DownloadsScreen> {
  int _tabIndex = 0;

  @override
  void initState() {
    super.initState();
    DownloadStorage.instance.addListener(_onStorage);
  }

  @override
  void dispose() {
    DownloadStorage.instance.removeListener(_onStorage);
    super.dispose();
  }

  void _onStorage() {
    if (mounted) setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final strings = StringsService.strings;
    final colors = strings.colors;
    final d = strings.downloads;
    final tabKeys = ['all', 'active', 'completed', 'failed'];
    final status = tabKeys[_tabIndex];
    final items = DownloadStorage.instance.filter(
      status: status == 'all' ? 'all' : status,
    );

    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: isDark ? SystemUiOverlayStyle.light : SystemUiOverlayStyle.dark,
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        body: Stack(
          children: [
            Positioned.fill(
              child: Image.asset(
                isDark ? strings.images.homeBgDark : strings.images.homeBgLight,
                fit: BoxFit.cover,
              ),
            ),
            Positioned.fill(
              child: BackdropFilter(
                filter: ImageFilter.blur(
                    sigmaX: AppValues.homeBgBlur, sigmaY: AppValues.homeBgBlur),
                child: Container(
                  color: isDark
                      ? colors.black.withOpacity(AppValues.homeBgOverlayOpacity)
                      : colors.white
                          .withOpacity(AppValues.homeBgOverlayOpacity * 0.6),
                ),
              ),
            ),
            SafeArea(
              bottom: false,
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.fromLTRB(20, 8, 20, 0),
                    child: Text(
                      d.title,
                      style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.w700,
                        color: isDark
                            ? colors.darkTextPrimary
                            : colors.lightTextPrimary,
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  SizedBox(
                    height: 36,
                    child: ListView.separated(
                      scrollDirection: Axis.horizontal,
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      itemCount: tabKeys.length,
                      separatorBuilder: (_, __) => const SizedBox(width: 8),
                      itemBuilder: (_, i) {
                        final selected = _tabIndex == i;
                        return GestureDetector(
                          onTap: () => setState(() => _tabIndex = i),
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 16, vertical: 8),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(20),
                              gradient:
                                  selected ? colors.threeColorGradient : null,
                              color: selected
                                  ? null
                                  : (isDark
                                      ? colors.white.withOpacity(0.08)
                                      : colors.white.withOpacity(0.5)),
                            ),
                            child: Text(
                              d.tabs[tabKeys[i]]!,
                              style: TextStyle(
                                fontSize: 13,
                                fontWeight: FontWeight.w600,
                                color: selected
                                    ? colors.white
                                    : (isDark
                                        ? colors.darkTextSecondary
                                        : colors.lightTextSecondary),
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                  const SizedBox(height: 16),
                  Expanded(
                    child: items.isEmpty
                        ? Center(
                            child: Text(
                              'No downloads yet',
                              style: TextStyle(
                                color: isDark
                                    ? colors.darkTextTertiary
                                    : colors.lightTextTertiary,
                              ),
                            ),
                          )
                        : ListView.builder(
                            padding: const EdgeInsets.fromLTRB(20, 0, 20, 100),
                            itemCount: items.length,
                            itemBuilder: (_, i) => _DownloadTile(
                              item: items[i],
                              isDark: isDark,
                              statusLabel: _statusLabel(d, items[i].status),
                            ),
                          ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _statusLabel(dynamic d, String status) {
    switch (status) {
      case 'completed':
        return d.statusCompleted as String;
      case 'active':
        return d.statusActive as String;
      case 'failed':
        return d.statusFailed as String;
      default:
        return status;
    }
  }
}

class _DownloadTile extends StatelessWidget {
  final DownloadRecord item;
  final bool isDark;
  final String statusLabel;

  const _DownloadTile({
    required this.item,
    required this.isDark,
    required this.statusLabel,
  });

  @override
  Widget build(BuildContext context) {
    final colors = StringsService.strings.colors;
    return GlassContainer(
      borderRadius: 14,
      isDark: isDark,
      opacity: 0.12,
      borderOpacity: 0.06,
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.all(12),
      child: Row(
        children: [
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
              gradient: colors.primaryGradient,
            ),
            child: Icon(
              item.kind == 'image'
                  ? Icons.image_rounded
                  : Icons.play_arrow_rounded,
              color: colors.white,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  item.title,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: isDark
                        ? colors.darkTextPrimary
                        : colors.lightTextPrimary,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  '${item.size}  •  $statusLabel',
                  style: TextStyle(
                    fontSize: 12,
                    color: item.status == 'completed'
                        ? colors.success
                        : (isDark
                            ? colors.darkTextTertiary
                            : colors.lightTextTertiary),
                  ),
                ),
              ],
            ),
          ),
          Icon(Icons.more_vert_rounded,
              size: 20,
              color:
                  isDark ? colors.darkTextTertiary : colors.lightTextTertiary),
        ],
      ),
    );
  }
}
