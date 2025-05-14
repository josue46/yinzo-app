class Logement {
  final String id;
  final String address;
  final String description;
  final double rentPrice;
  final int warranty;
  final Map<String, dynamic> owner;
  final String ownerNumber;
  final String city;
  final double? visiteFee;
  final int? commissionMonth;
  final DateTime publishedDate;
  final int numberOfRooms;
  final bool forRent;
  final String category;
  final List<String> images;
  final double averageRating;
  final int numberComments;
  final int reviews;
  final int numberScheduledVisits;

  Logement({
    required this.id,
    required this.rentPrice,
    required this.warranty,
    required this.owner,
    required this.ownerNumber,
    required this.city,
    required this.address,
    required this.description,
    required this.publishedDate,
    required this.numberOfRooms,
    required this.forRent,
    required this.category,
    required this.images,
    required this.averageRating,
    required this.numberComments,
    required this.reviews,
    required this.numberScheduledVisits,
    this.commissionMonth = 0,
    this.visiteFee = 0,
  });

  factory Logement.fromJson(Map<String, dynamic> json) {
    return Logement(
      id: json['id'],
      description: json['description'],
      rentPrice: json['rent_price'],
      address: json['address'],
      averageRating: json['average_rating'],
      category: json['category'],
      city: json['city'],
      forRent: json['for_rent'],
      images: List<String>.from(json['images'] ?? []),
      numberComments: json['number_comments'],
      numberOfRooms: json['number_of_rooms'],
      numberScheduledVisits: json['number_scheduled_visits'],
      owner: json['owner'],
      ownerNumber: json['owner_number'],
      publishedDate: DateTime.parse(json['published_on']),
      reviews: json['reviews'],
      warranty: json['warranty'],
      commissionMonth: json['commission_month'],
      visiteFee: json['visite_fee'],
    );
  }
}
