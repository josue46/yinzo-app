import 'package:flutter/material.dart';

// ignore: must_be_immutable
class ShowCategories extends StatefulWidget {
  List<String> categories;
  int selectedContainerIndex;

  ShowCategories({
    super.key,
    required this.categories,
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
        mainAxisAlignment: MainAxisAlignment.start,
        children: List.generate(widget.categories.length, (int index) {
          return GestureDetector(
            onTap: () {
              setState(() {
                widget.selectedContainerIndex = index;
              });
            },
            child: AnimatedContainer(
              duration: Duration(milliseconds: 250),
              margin: EdgeInsets.only(left: 20),
              width: 102,
              height: 32,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color:
                    widget.selectedContainerIndex == index
                        ? Theme.of(context).primaryColor
                        : Colors.white,
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
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
                      widget.selectedContainerIndex == index
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
