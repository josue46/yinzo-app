import 'package:flutter/material.dart';

// ignore: must_be_immutable
class ShowCategories extends StatefulWidget {
  final List<String> categories;
  final Function(String slug) onCategorySelected;
  int selectedContainerIndex;

  ShowCategories({
    super.key,
    required this.categories,
    required this.onCategorySelected,
    this.selectedContainerIndex = 0,
  });

  @override
  State<ShowCategories> createState() => _ShowCategoriesState();
}

class _ShowCategoriesState extends State<ShowCategories> {
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: List.generate(widget.categories.length, (index) {
          final isSelected = widget.selectedContainerIndex == index;

          return GestureDetector(
            onTap: () {
              setState(() {
                widget.selectedContainerIndex = index;
              });

              final slug = widget.categories[index].toLowerCase();
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
                    isSelected == true
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
                widget.categories[index],
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
