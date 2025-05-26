import 'package:flutter/material.dart';

class ShowCategories extends StatefulWidget {
  final List<Map<String, String>> categories;
  final Function(String slug) onCategorySelected;

  const ShowCategories({
    super.key,
    required this.categories,
    required this.onCategorySelected,
  });

  @override
  State<ShowCategories> createState() => _ShowCategoriesState();
}

class _ShowCategoriesState extends State<ShowCategories> {
  int selectedContainerIndex = 0;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: List.generate(widget.categories.length, (index) {
          final isSelected = selectedContainerIndex == index;

          return GestureDetector(
            onTap: () {
              setState(() {
                selectedContainerIndex = index;
              });

              final String slug = widget.categories[index]["slug"]!;
              widget.onCategorySelected(slug);
            },
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 250),
              margin: const EdgeInsets.only(left: 20),
              width: 102,
              height: 32,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color:
                    isSelected
                        ? Theme.of(context).primaryColor
                        : Theme.of(context).cardColor,
                borderRadius: BorderRadius.circular(20),
                boxShadow: const [
                  BoxShadow(
                    color: Colors.black12,
                    blurRadius: 5,
                    offset: Offset(0, 2),
                  ),
                ],
              ),
              child: Text(
                widget.categories[index]["name"]!,
                style: TextStyle(
                  fontSize: 14,
                  color:
                      isSelected
                          ? Colors.white
                          : Colors.black.withValues(alpha: 0.7),
                ),
              ),
            ),
          );
        }),
      ),
    );
  }
}
