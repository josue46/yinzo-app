import 'package:flutter/material.dart';
import 'package:yinzo/screens/logement_detail_screen.dart';
import 'package:flutter_carousel_widget/flutter_carousel_widget.dart';

class AllLogementWidget extends StatefulWidget {
  const AllLogementWidget({super.key});

  @override
  State<AllLogementWidget> createState() => _AllLogementWidgetState();
}

class _AllLogementWidgetState extends State<AllLogementWidget> {
  bool _isFavorite = false;
  final List<String> imageUrls = [
    "assets/images/unnamed.jpg",
    "assets/images/project_991124655c6f6da43bf_pic_1.webp",
    "assets/images/Villa-moderne-1-scaled.jpg",
    "assets/images/myimg.jpg",
  ];

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      physics: ClampingScrollPhysics(),
      itemCount: 10,
      itemBuilder: (context, index) {
        return Padding(
          padding: const EdgeInsets.only(top: 8.0),
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: ListTile(
                  title: const Text("Luis Martin's"),
                  subtitle: const Text(
                    "Propriétaire",
                    style: TextStyle(fontSize: 14, color: Colors.black54),
                  ),
                  contentPadding: const EdgeInsets.only(right: 0.8),
                  leading: CircleAvatar(
                    radius: 20,
                    backgroundColor: Colors.transparent,
                    backgroundImage: AssetImage("assets/images/profil.jpg"),
                  ),
                ),
              ),
              Stack(
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 50),
                    child: GestureDetector(
                      onTap: () {
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (context) => LogementDetailsScreen(),
                          ),
                        );
                      },
                      child: FlutterCarousel.builder(
                        options: FlutterCarouselOptions(
                          enableInfiniteScroll: true,
                          autoPlay: true,
                          autoPlayCurve: Curves.easeInOut,
                          viewportFraction: 1.0,
                          autoPlayAnimationDuration: const Duration(
                            milliseconds: 1500,
                          ),
                        ),
                        itemCount: imageUrls.length,
                        itemBuilder: (context, index, _) {
                          return ClipRRect(
                            borderRadius: BorderRadius.circular(15),
                            child: Image.asset(
                              imageUrls[index],
                              fit: BoxFit.cover,
                              width: MediaQuery.of(context).size.width - 40,
                            ),
                          );
                        },
                      ),
                    ),
                  ),
                  Positioned(
                    top: 10,
                    right: 60,
                    child: IconButton(
                      alignment: Alignment.center,
                      style: ButtonStyle(
                        fixedSize: WidgetStatePropertyAll(Size(5, 5)),
                        backgroundColor: WidgetStatePropertyAll<Color>(
                          Colors.white.withValues(alpha: 0.8),
                        ),
                      ),
                      onPressed: () {
                        setState(() {
                          _isFavorite = !_isFavorite;
                        });
                      },
                      icon: Icon(
                        _isFavorite
                            ? Icons.favorite_outlined
                            : Icons.favorite_outline,
                        color: Theme.of(context).primaryColor,
                        size: 25,
                      ),
                    ),
                  ),
                ],
              ),
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 52,
                  vertical: 5,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "Maison à louer",
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: Colors.black,
                          ),
                        ),
                        Text.rich(
                          TextSpan(
                            children: [
                              WidgetSpan(
                                child: Icon(
                                  Icons.star,
                                  color: Theme.of(context).primaryColor,
                                  size: 20,
                                ),
                              ),
                              TextSpan(
                                text: "4.5",
                                style: TextStyle(
                                  fontSize: 16,
                                  color: Colors.black.withValues(alpha: 0.9),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    Text(
                      "Kinshasa, Lingwala",
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.black.withValues(alpha: 0.9),
                      ),
                    ),
                    Text(
                      "2 chambres",
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.black.withValues(alpha: 0.9),
                      ),
                    ),
                    Row(
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(right: 10),
                          child: Text(
                            "80\$",
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: Colors.black.withValues(alpha: 0.9),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
