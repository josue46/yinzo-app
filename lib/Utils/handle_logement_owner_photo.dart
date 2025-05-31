String handleThePhotoOfTheLogementOwner(
  Map<String, dynamic> owner,
  String baseUrl,
) {
  // Gestion de l'image du propriétaire
  String photoPath = owner["photo"];
  String photoUrl;

  if (photoPath.isNotEmpty) {
    if (photoPath.startsWith("/")) {
      photoUrl = '$baseUrl$photoPath';
    } else if (photoPath.startsWith("http") || photoPath.startsWith("https")) {
      photoUrl = photoPath;
    } else {
      photoUrl = '$baseUrl/$photoPath';
    }
  } else {
    // Si l'utilisateur n'a pas de photo de profile
    photoUrl = "";
  }
  return photoUrl;
}
