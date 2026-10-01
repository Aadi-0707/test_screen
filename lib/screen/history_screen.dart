import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../../core/constants/_values.dart';
import '../../../core/utils/glass_container.dart';
import '../../../core/utils/strings_service.dart';
import '../../../data/download_record.dart';
import '../../../data/download_storage.dart';

class HistoryScreen extends StatefulWidget {
  const HistoryScreen({super.key});

  @override
  State<HistoryScreen> createState() => _HistoryScreenState();
}

class _HistoryScreenState extends State<HistoryScreen> {
  int _filterIndex = 0;
  final TextEditingController _search = TextEditingController();

  @override
  void initState() {
    super.initState();
    DownloadStorage.instance.addListener(_onStorage);
  }

  @override
  void dispose() {
    DownloadStorage.instance.removeListener(_onStorage);
    _search.dispose();
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
    final h = strings.history;
    final filterKeys = ['all', 'video', 'image', 'other'];
    final kind = filterKeys[_filterIndex];
    final items = DownloadStorage.instance.filter(
      kind: kind == 'all' ? 'all' : kind,
      query: _search.text.trim(),
    );

    final today = items.where((e) => e.group == 'today').toList();
    final yesterday = items.where((e) => e.group == 'yesterday').toList();
    final earlier = items.where((e) => e.group == 'earlier').toList();

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
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.fromLTRB(20, 8, 20, 0),
                    child: Text(
                      h.title,
                      style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.w700,
                        color: isDark
                            ? colors.darkTextPrimary
                            : colors.lightTextPrimary,
                      ),
                    ),
                  ),
                  const SizedBox(height: 14),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: GlassContainer(
                      height: 46,
                      borderRadius: 14,
                      isDark: isDark,
                      opacity: 0.12,
                      borderOpacity: 0.08,
                      padding: const EdgeInsets.symmetric(horizontal: 14),
                      child: Row(
                        children: [
                          Icon(Icons.search_rounded,
                              size: 20,
                              color: isDark
                                  ? colors.darkTextTertiary
                                  : colors.lightTextTertiary),
                          const SizedBox(width: 10),
                          Expanded(
                            child: TextField(
                              controller: _search,
                              onChanged: (_) => setState(() {}),
                              style: TextStyle(
                                fontSize: 14,
                                color: isDark
                                    ? colors.darkTextPrimary
                                    : colors.lightTextPrimary,
                              ),
                              decoration: InputDecoration(
                                hintText: h.searchHint,
                                hintStyle: TextStyle(
                                  color: isDark
                                      ? colors.darkTextTertiary
                                      : colors.lightTextTertiary,
                                  fontSize: 14,
                                ),
                                border: InputBorder.none,
                                isDense: true,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 14),
                  SizedBox(
                    height: 36,
                    child: ListView.separated(
                      scrollDirection: Axis.horizontal,
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      itemCount: filterKeys.length,
                      separatorBuilder: (_, __) => const SizedBox(width: 8),
                      itemBuilder: (_, i) {
                        final selected = _filterIndex == i;
                        return GestureDetector(
                          onTap: () => setState(() => _filterIndex = i),
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
                              h.filters[filterKeys[i]]!,
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
                  const SizedBox(height: 12),
                  Expanded(
                    child: items.isEmpty
                        ? Center(
                            child: Text(
                              'No history yet',
                              style: TextStyle(
                                color: isDark
                                    ? colors.darkTextTertiary
                                    : colors.lightTextTertiary,
                              ),
                            ),
                          )
                        : ListView(
                            padding: const EdgeInsets.fromLTRB(20, 0, 20, 100),
                            children: [
                              if (today.isNotEmpty) ...[
                                _GroupTitle(h.today, isDark, colors),
                                ...today.map((e) => _HistoryTile(e, isDark)),
                              ],
                              if (yesterday.isNotEmpty) ...[
                                const SizedBox(height: 8),
                                _GroupTitle(h.yesterday, isDark, colors),
                                ...yesterday
                                    .map((e) => _HistoryTile(e, isDark)),
                              ],
                              if (earlier.isNotEmpty) ...[
                                const SizedBox(height: 8),
                                _GroupTitle('Earlier', isDark, colors),
                                ...earlier.map((e) => _HistoryTile(e, isDark)),
                              ],
                            ],
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
}

class _GroupTitle extends StatelessWidget {
  final String text;
  final bool isDark;
  final dynamic colors;
  const _GroupTitle(this.text, this.isDark, this.colors);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8, top: 4),
      child: Text(
        text,
        style: TextStyle(
          fontSize: 13,
          fontWeight: FontWeight.w600,
          color: isDark ? colors.darkTextSecondary : colors.lightTextSecondary,
        ),
      ),
    );
  }
}

class _HistoryTile extends StatelessWidget {
  final DownloadRecord item;
  final bool isDark;
  const _HistoryTile(this.item, this.isDark);

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
                  '${item.size}  •  ${item.platform}  •  ${item.timeLabel}',
                  style: TextStyle(
                    fontSize: 12,
                    color: isDark
                        ? colors.darkTextTertiary
                        : colors.lightTextTertiary,
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
