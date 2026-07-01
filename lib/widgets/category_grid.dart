import 'package:flutter/material.dart';
import '../config/app_theme.dart';

class CategoryGrid extends StatelessWidget {
  final List<_CatItemData> categories;
  final String? selectedId;
  final ValueChanged<String> onSelected;

  const CategoryGrid({
    super.key,
    required this.categories,
    required this.selectedId,
    required this.onSelected,
  });

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 4,
        childAspectRatio: 0.9,
        crossAxisSpacing: 8,
        mainAxisSpacing: 8,
      ),
      itemCount: categories.length,
      itemBuilder: (context, index) {
        final cat = categories[index];
        final isSelected = cat.id == selectedId;
        return GestureDetector(
          onTap: () => onSelected(cat.id),
          child: Container(
            padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 4),
            decoration: BoxDecoration(
              color: isSelected
                  ? const Color(0xFFF0E8FA)
                  : Colors.transparent,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: 44,
                  height: 44,
                  decoration: BoxDecoration(
                    color: cat.bgColor,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Center(
                    child: Text(cat.icon,
                        style: const TextStyle(fontSize: 20)),
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  cat.name,
                  style: const TextStyle(
                    fontSize: 11,
                    color: AppTheme.textMain,
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

class _CatItemData {
  final String id;
  final String name;
  final String icon;
  final Color bgColor;
  _CatItemData({
    required this.id,
    required this.name,
    required this.icon,
    required this.bgColor,
  });
}
