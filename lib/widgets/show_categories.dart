import 'package:flutter/material.dart';

// ignore: must_be_immutable
class ShowCategories extends StatefulWidget {
  List<String> categories;
  int selectedContainerIndex;

  ShowCategories({
    super.key,
    required this.categories,
    required this.selectedContainerIndex,
  });

  @override
  State<ShowCategories> createState() => _ShowCategoriesState();
}

class _ShowCategoriesState extends State<ShowCategories> {
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 36,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: widget.categories.length,
        itemBuilder: (context, index) {
          return GestureDetector(
            onTap: () {
              setState(() {
                widget.selectedContainerIndex = index;
              });
            },
            child: AnimatedContainer(
              duration: Duration(milliseconds: 250),
              margin: EdgeInsets.only(left: 20),
              width: 120,
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
                  fontSize: 15,
                  color:
                      widget.selectedContainerIndex == index
                          ? Colors.white
                          : Colors.black.withValues(alpha: 0.7),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
