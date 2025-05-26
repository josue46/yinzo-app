import 'dart:io';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:file_picker/file_picker.dart';
import 'package:yinzo/Logements/Providers/category_provider.dart';
import 'package:yinzo/Logements/Providers/logement_provider.dart';

class PublishLogementScreen extends StatefulWidget {
  const PublishLogementScreen({super.key});

  @override
  State<PublishLogementScreen> createState() => _PublishLogementScreenState();
}

class _PublishLogementScreenState extends State<PublishLogementScreen> {
  final _formKey = GlobalKey<FormState>();
  String? token;

  final TextEditingController rentPriceController = TextEditingController();
  final TextEditingController warrantyController = TextEditingController();
  final TextEditingController ownerNumberController = TextEditingController();
  final TextEditingController cityController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();
  final TextEditingController visiteFeeController = TextEditingController();
  final TextEditingController commissionMonthController =
      TextEditingController();
  final TextEditingController addressController = TextEditingController();
  final TextEditingController numberOfRoomsController = TextEditingController();

  List<File> selectedImages = [];
  bool isForRent = true;
  String? selectedCategory;
  int maxImages = 5;

  /* GridView.builder(
  shrinkWrap: true,
  itemCount: selectedImages.length,
  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 3),
  itemBuilder: (context, index) {
    return Image.file(selectedImages[index], fit: BoxFit.cover);
  },
  ) */

  Future<List<File>> pickMultipleImages() async {
    /// This function allows the user to pick multiple images from their device.
    // bool granted = await requestPermission();
    // if (!granted) {
    //   ScaffoldMessenger.of(
    //     context,
    //   ).showSnackBar(const SnackBar(content: Text("Permission refusée")));
    //   return [];
    // }

    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.image,
      allowMultiple: true,
    );

    if (result != null && result.files.isNotEmpty) {
      if (result.count > maxImages) {
        // L'utilisateur a selectionné plus de 5 images.
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              "Selectionnez au maximun $maxImages images.\nNombre d'images selectionées: ${result.count}",
            ),
          ),
        );
        return [];
      }
      return result.paths.map((path) => File(path!)).toList();
    } else {
      // L'utilisateur a annulé la sélection
      return [];
    }
  }

  void handlePublish(String token) async {
    if (_formKey.currentState!.validate()) {
      if (selectedImages.isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Veuillez ajouter des images")),
        );
        return;
      } else if (selectedImages.length > maxImages) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text("Vous avez depassé la limite des images autorisées."),
          ),
        );
        return;
      }

      if (selectedCategory == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text(
              "Choisissez une catégorie pour votre logement pour permettre aux autres utilisateurs de le retrouver facilement.",
            ),
          ),
        );
        return;
      }

      // Publication of logement
      final message = await Provider.of<LogementProvider>(
        context,
      ).publishLogement(
        token,
        description: descriptionController.text,
        price: rentPriceController.text,
        warranty: warrantyController.text,
        category: selectedCategory!,
        location: addressController.text,
        ownerNumber: ownerNumberController.text,
        city: cityController.text,
        images: selectedImages,
        forRent: isForRent,
        numberOfRooms: int.tryParse(numberOfRoomsController.text) ?? 0,
        commissionMonth: int.tryParse(commissionMonthController.text) ?? 0,
        visiteFee: int.tryParse(visiteFeeController.text) ?? 0,
      );
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(message!)));
    }
  }

  @override
  void dispose() {
    rentPriceController.dispose();
    warrantyController.dispose();
    ownerNumberController.dispose();
    cityController.dispose();
    descriptionController.dispose();
    visiteFeeController.dispose();
    commissionMonthController.dispose();
    addressController.dispose();
    numberOfRoomsController.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Publier un logement"),
        scrolledUnderElevation: 0,
        backgroundColor: Colors.white,
        centerTitle: true,
        leading: IconButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          icon: Icon(Icons.arrow_back_ios_sharp),
          tooltip: "Back",
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(16, 5, 16, 16),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              Row(
                children: [
                  Expanded(
                    child: _buildTextField(
                      rentPriceController,
                      "Prix du loyer",
                      keyboardType: TextInputType.number,
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: _buildTextField(
                      warrantyController,
                      "Garantie",
                      keyboardType: TextInputType.number,
                    ),
                  ),
                ],
              ),
              _buildTextField(
                ownerNumberController,
                "Numéro du propriétaire",
                keyboardType: TextInputType.phone,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return "Champ requis";
                  } else if (!RegExp(r'^[0-9]{9,15}$').hasMatch(value)) {
                    return "Numéro invalide";
                  }
                  return null;
                },
              ),
              _buildTextField(cityController, "Ville"),
              _buildTextField(addressController, "Adresse"),
              _buildTextField(
                descriptionController,
                "Description",
                maxLines: 3,
              ),
              const SizedBox(height: 10),
              Container(
                width: double.infinity,
                height: 150,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                  color: Colors.white,
                  border: Border.all(color: Colors.black12, width: 1),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    GestureDetector(
                      onTap: () async {
                        final images = await pickMultipleImages();
                        if (images.isNotEmpty) {
                          setState(() {
                            selectedImages = images;
                          });
                        }
                      },
                      child: Container(
                        width: 40,
                        height: 40,
                        decoration: BoxDecoration(
                          color: Colors.grey.shade200,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Center(
                          child: Icon(
                            Icons.add_photo_alternate_sharp,
                            size: 30,
                          ),
                        ),
                      ),
                    ),
                    const Text(
                      "Ajouter des images",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontFamily: 'Inter',
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 10),
              Row(
                children: [
                  Expanded(
                    child: _buildTextField(
                      visiteFeeController,
                      "Frais de visite",
                      keyboardType: TextInputType.number,
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: _buildTextField(
                      commissionMonthController,
                      "Commission (mois)",
                      keyboardType: TextInputType.number,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 10),
              MediaQuery.of(context).size.width >= 344 &&
                      MediaQuery.of(context).size.width <= 430
                  ? Column(
                    children: [
                      _buildTextField(
                        numberOfRoomsController,
                        "Nombre de chambres",
                        keyboardType: TextInputType.number,
                      ),
                      const SizedBox(height: 8),
                      DropdownButtonFormField<String>(
                        value: selectedCategory,
                        decoration: const InputDecoration(
                          filled: true,
                          fillColor: Colors.white,
                          focusColor: Colors.white,
                          hoverColor: Colors.white,
                          border: UnderlineInputBorder(
                            borderRadius: BorderRadius.all(Radius.circular(10)),
                          ),
                        ),
                        items:
                            CategoryProvider.of(context).categories.map((cat) {
                              return DropdownMenuItem(
                                value:
                                    cat.name == 'Tous'
                                        ? null
                                        : cat.name.toLowerCase(),
                                child:
                                    cat.name == 'Tous'
                                        ? const Text('Choisir une catégorie')
                                        : Text(cat.name),
                              );
                            }).toList(),
                        onChanged: (value) {
                          setState(() => selectedCategory = value);
                        },
                        validator:
                            (value) =>
                                value == null
                                    ? "Veuillez sélectionner une catégorie"
                                    : null,
                      ),
                    ],
                  )
                  : Row(
                    children: [
                      Expanded(
                        child: _buildTextField(
                          numberOfRoomsController,
                          "Nombre de chambres",
                          keyboardType: TextInputType.number,
                        ),
                      ),

                      const SizedBox(width: 10),
                      Expanded(
                        child: DropdownButtonFormField<String>(
                          value: selectedCategory,
                          decoration: const InputDecoration(
                            filled: true,
                            fillColor: Colors.white,
                            focusColor: Colors.white,
                            hoverColor: Colors.white,
                            border: UnderlineInputBorder(
                              borderRadius: BorderRadius.all(
                                Radius.circular(10),
                              ),
                            ),
                          ),
                          items:
                              CategoryProvider.of(context).categories.map((
                                cat,
                              ) {
                                return DropdownMenuItem(
                                  value:
                                      cat.name == 'Tous'
                                          ? null
                                          : cat.name.toLowerCase(),
                                  child:
                                      cat.name == 'Tous'
                                          ? const Text('Choisir une catégorie')
                                          : Text(cat.name),
                                );
                              }).toList(),
                          onChanged: (value) {
                            setState(() => selectedCategory = value);
                          },
                          validator:
                              (value) =>
                                  value == null
                                      ? "Veuillez sélectionner une catégorie"
                                      : null,
                        ),
                      ),
                    ],
                  ),
              CheckboxListTile(
                controlAffinity: ListTileControlAffinity.trailing,
                title: const Text(
                  "Ce logement est-il à louer ?",
                  style: TextStyle(fontSize: 14),
                ),
                activeColor: Theme.of(context).primaryColor,
                contentPadding: EdgeInsets.zero,
                value: isForRent,
                onChanged: (bool? val) => setState(() => isForRent = val!),
              ),

              const SizedBox(height: 40),

              if (selectedImages.isNotEmpty)
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children:
                      selectedImages
                          .map(
                            (img) => Image.file(
                              File(img.path),
                              width: 100,
                              height: 100,
                              fit: BoxFit.cover,
                            ),
                          )
                          .toList(),
                ),
              ElevatedButton(
                onPressed: () => handlePublish(token!),
                style: ElevatedButton.styleFrom(
                  minimumSize: const Size(double.infinity, 50),
                  backgroundColor: Theme.of(context).primaryColor,
                ),
                child: const Text(
                  "Publier le logement",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontFamily: 'Poppins',
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTextField(
    TextEditingController controller,
    String label, {
    TextInputType keyboardType = TextInputType.text,
    int maxLines = 1,
    String? Function(String?)? validator,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: TextFormField(
        controller: controller,
        keyboardType: keyboardType,
        maxLines: maxLines,
        validator:
            validator ??
            (value) => value == null || value.isEmpty ? "Champ requis" : null,
        decoration: InputDecoration(
          filled: true,
          fillColor: Colors.white,
          hoverColor: Colors.white,
          focusColor: Colors.white,
          labelText: label,
          labelStyle: const TextStyle(fontFamily: "Inter"),
          border: UnderlineInputBorder(
            borderRadius: BorderRadius.all(Radius.circular(10)),
          ),
        ),
      ),
    );
  }
}
