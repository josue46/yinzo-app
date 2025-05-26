class Logement {
  final String id;
  final String address;
  final String city;
  final Map<String, dynamic> owner;
  final bool forRent;
  final String category;
  final int numberOfRooms;
  final List<String> images;
  final double averageRating;

  // Champs uniquement présents dans lors des (détails)
  final String? description;
  final double? rentPrice;
  final int? warranty;
  final String? ownerNumber;
  final DateTime? publishedDate;
  final int? numberComments;
  final int? reviews;
  final int? numberScheduledVisits;
  final int? commissionMonth;
  final double? visiteFee;

  Logement({
    required this.id,
    required this.address,
    required this.city,
    required this.owner,
    required this.forRent,
    required this.category,
    required this.numberOfRooms,
    required this.images,
    required this.averageRating,
    this.description,
    this.rentPrice,
    this.warranty,
    this.ownerNumber,
    this.publishedDate,
    this.numberComments,
    this.reviews,
    this.numberScheduledVisits,
    this.commissionMonth,
    this.visiteFee,
  });

  factory Logement.fromJson(Map<String, dynamic> json) {
    return Logement(
      id: json['id'],
      address: json['address'],
      city: json['city'],
      owner: json['owner'] ?? {},
      forRent: json['for_rent'],
      category: json['category'],
      numberOfRooms: json['number_of_rooms'],
      images: List<String>.from(json['images'] ?? []),
      averageRating: (json['average_rating'] ?? 0.0).toDouble(),

      // Champs uniquement disponibles dans les détails (nullables)
      description: json['description'],
      rentPrice: (json['rent_price'] as num?)?.toDouble(),
      warranty: json['warranty'],
      ownerNumber: json['owner_number'],
      publishedDate:
          json['published_on'] != null
              ? DateTime.tryParse(json['published_on'])
              : null,
      numberComments: json['number_comments'],
      reviews: json['reviews'],
      numberScheduledVisits: json['number_scheduled_visits'],
      commissionMonth: json['commission_month'],
      visiteFee: (json['visite_fee'] as num?)?.toDouble(),
    );
  }
}
