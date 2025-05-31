import 'dart:io';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:file_picker/file_picker.dart';
import 'package:yinzo/Logements/Providers/category_provider.dart';
import 'package:yinzo/Logements/Providers/logement_provider.dart';

class PublishLogementScreen extends StatefulWidget {
  final String? token;
  const PublishLogementScreen({super.key, required this.token});

  @override
  State<PublishLogementScreen> createState() => _PublishLogementScreenState();
}

class _PublishLogementScreenState extends State<PublishLogementScreen> {
  final _formKey = GlobalKey<FormState>();
  final _scrollController = ScrollController();
  // liste des villes officielles de la RDC
  final List<String> cities = [
    "Kinshasa",
    "Matadi",
    "Goma",
    "Lubumbashi",
    "Butembo",
    "Mbuji-Mayi",
    "Kananga",
    "Bukavu",
    "Kisangani",
    "Kolwezi",
    "Tshikapa",
    "Likasi",
    "Kolwezi",
    "Beni",
    "Uvira",
    "Kikwit",
    "Mbanza-Ngungu",
    "Likasi",
    "Kalemie",
    "Boma",
    "Bunia",
  ];

  // Controllers for form fields
  final TextEditingController rentPriceController = TextEditingController();
  final TextEditingController warrantyController = TextEditingController();
  final TextEditingController ownerNumberController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();
  final TextEditingController visiteFeeController = TextEditingController();
  final TextEditingController commissionMonthController =
      TextEditingController();
  final TextEditingController addressController = TextEditingController();
  final TextEditingController numberOfRoomsController = TextEditingController();

  List<File> selectedImages = [];
  bool isForRent = true;
  String? selectedCategory;
  String? selectedCity;
  int maxImages = 5;

  Future<List<File>> pickMultipleImages() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.image,
      allowMultiple: true,
    );

    if (result != null && result.files.isNotEmpty) {
      if (result.count > maxImages) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text("Sélectionnez maximum $maxImages images"),
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
          ),
        );
        return [];
      }
      return result.paths.map((path) => File(path!)).toList();
    } else {
      return [];
    }
  }

  Future<void> handlePublish(String token) async {
    if (!_formKey.currentState!.validate()) return;

    if (selectedImages.isEmpty) {
      _showErrorSnackbar("Veuillez ajouter des images");
      return;
    }

    if (selectedCategory == null) {
      _showErrorSnackbar("Veuillez sélectionner une catégorie");
      return;
    }

    try {
      final message = await Provider.of<LogementProvider>(
        context,
        listen: false,
      ).publishLogement(
        token,
        description: descriptionController.text,
        price: rentPriceController.text,
        warranty: warrantyController.text,
        category: selectedCategory!,
        location: addressController.text,
        ownerNumber: ownerNumberController.text,
        city: selectedCity!,
        images: selectedImages,
        forRent: isForRent,
        numberOfRooms: int.tryParse(numberOfRoomsController.text) ?? 0,
        commissionMonth: int.tryParse(commissionMonthController.text) ?? 0,
        visiteFee: int.tryParse(visiteFeeController.text) ?? 0,
      );

      _showSuccessSnackbar(message ?? "Logement publié avec succès");

      // Nettoyage du formulaire après une publication réussie.
      if (mounted) {
        _formKey.currentState?.reset();
        setState(() {
          selectedImages = [];
          selectedCategory = null;
          selectedCity = null;
        });
        _scrollController.animateTo(
          0,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    } catch (e) {
      _showErrorSnackbar("Erreur lors de la publication: ${e.toString()}");
    }
  }

  void _showErrorSnackbar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.red[400],
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      ),
    );
  }

  void _showSuccessSnackbar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.green[400],
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      ),
    );
  }

  @override
  void dispose() {
    rentPriceController.dispose();
    warrantyController.dispose();
    ownerNumberController.dispose();
    descriptionController.dispose();
    visiteFeeController.dispose();
    commissionMonthController.dispose();
    addressController.dispose();
    numberOfRoomsController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isSmallScreen = MediaQuery.of(context).size.width < 600;
    final provider = Provider.of<LogementProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text("Publier un logement"),
        elevation: 0,
        backgroundColor: theme.colorScheme.primary,
        foregroundColor: Colors.white,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          controller: _scrollController,
          padding: const EdgeInsets.all(16),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Informations de base",
                  style: theme.textTheme.titleLarge?.copyWith(
                    fontFamily: 'Inter',
                    color: Colors.black87,
                    fontSize: 25,
                  ),
                ),
                const SizedBox(height: 16),
                _buildSectionCard(
                  theme: theme,
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: _buildTextField(
                            rentPriceController,
                            "Prix du loyer*",
                            icon: Icons.attach_money,
                            keyboardType: TextInputType.number,
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: _buildTextField(
                            warrantyController,
                            "Garantie*",
                            icon: Icons.security,
                            keyboardType: TextInputType.number,
                          ),
                        ),
                      ],
                    ),
                    _buildTextField(
                      ownerNumberController,
                      "Numéro du propriétaire*",
                      icon: Icons.phone,
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
                    Row(
                      children: [
                        Expanded(
                          child: DropdownButtonFormField<String>(
                            value: selectedCity,
                            decoration: InputDecoration(
                              labelText: "Ville*",
                              prefixIcon: Icon(Icons.location_city),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                            ),
                            items:
                                cities.map((city) {
                                  return DropdownMenuItem<String>(
                                    value: city,
                                    child: Text(city),
                                  );
                                }).toList(),
                            onChanged: (value) {
                              setState(() {
                                selectedCity = value;
                              });
                            },
                            validator:
                                (value) =>
                                    value == null
                                        ? "Veuillez indiquer la ville où se trouve votre logement"
                                        : null,
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: _buildTextField(
                            numberOfRoomsController,
                            "Nombre de chambres*",
                            icon: Icons.meeting_room,
                            keyboardType: TextInputType.number,
                          ),
                        ),
                      ],
                    ),
                    _buildTextField(
                      addressController,
                      "Adresse complète*",
                      icon: Icons.map,
                    ),
                  ],
                ),
                const SizedBox(height: 24),
                Text(
                  "Description",
                  style: theme.textTheme.titleLarge?.copyWith(
                    fontFamily: 'Inter',
                    color: Colors.black87,
                    fontSize: 25,
                  ),
                ),
                const SizedBox(height: 16),
                _buildSectionCard(
                  theme: theme,
                  children: [
                    _buildTextField(
                      descriptionController,
                      "Décrivez votre logement*",
                      maxLines: 4,
                      icon: Icons.description,
                    ),
                  ],
                ),
                const SizedBox(height: 24),
                Text(
                  "Images",
                  style: theme.textTheme.titleLarge?.copyWith(
                    color: Colors.black87,
                    fontFamily: 'Inter',
                    fontSize: 25,
                  ),
                ),
                const SizedBox(height: 16),
                _buildSectionCard(
                  theme: theme,
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
                        width: double.infinity,
                        padding: const EdgeInsets.all(24),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(
                            color: theme.colorScheme.outline.withValues(
                              alpha: 0.3,
                            ),
                            width: 1.5,
                          ),
                          color: theme.colorScheme.surfaceContainerHigh,
                        ),
                        child: Column(
                          children: [
                            Icon(
                              Icons.cloud_upload,
                              size: 48,
                              color: theme.colorScheme.primary,
                            ),
                            const SizedBox(height: 8),
                            Text(
                              "Ajoutez des photos",
                              style: theme.textTheme.titleMedium,
                            ),
                            const SizedBox(height: 4),
                            Text(
                              "Sélectionnez jusqu'à $maxImages images",
                              style: theme.textTheme.bodySmall,
                            ),
                            if (selectedImages.isNotEmpty) ...[
                              const SizedBox(height: 16),
                              Wrap(
                                spacing: 8,
                                runSpacing: 8,
                                children:
                                    selectedImages
                                        .map(
                                          (img) => Stack(
                                            children: [
                                              ClipRRect(
                                                borderRadius:
                                                    BorderRadius.circular(8),
                                                child: Image.file(
                                                  File(img.path),
                                                  width: 80,
                                                  height: 80,
                                                  fit: BoxFit.cover,
                                                ),
                                              ),
                                              Positioned(
                                                top: 4,
                                                right: 4,
                                                child: GestureDetector(
                                                  onTap:
                                                      () => setState(() {
                                                        selectedImages.remove(
                                                          img,
                                                        );
                                                      }),
                                                  child: Container(
                                                    padding:
                                                        const EdgeInsets.all(2),
                                                    decoration: BoxDecoration(
                                                      color: Colors.black54,
                                                      shape: BoxShape.circle,
                                                    ),
                                                    child: Icon(
                                                      Icons.close,
                                                      size: 16,
                                                      color: Colors.white,
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                        )
                                        .toList(),
                              ),
                            ],
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 24),
                Text(
                  "Détails supplémentaires",
                  style: theme.textTheme.titleLarge?.copyWith(
                    color: Colors.black87,
                    fontFamily: 'Inter',
                    fontSize: 25,
                  ),
                ),
                const SizedBox(height: 16),
                _buildSectionCard(
                  theme: theme,
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: _buildTextField(
                            visiteFeeController,
                            "Frais de visite",
                            icon: Icons.money,
                            keyboardType: TextInputType.number,
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: _buildTextField(
                            commissionMonthController,
                            "Commission (mois)",
                            icon: Icons.calendar_month,
                            keyboardType: TextInputType.number,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    DropdownButtonFormField<String>(
                      value: selectedCategory,
                      decoration: InputDecoration(
                        labelText: "Catégorie*",
                        prefixIcon: Icon(Icons.category),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      items:
                          CategoryProvider.of(context).categories
                              .where((cat) => cat.name != 'Tous')
                              .map((cat) {
                                return DropdownMenuItem(
                                  value: cat.slug,
                                  child: Text(cat.name),
                                );
                              })
                              .toList(),
                      onChanged: (value) {
                        setState(() => selectedCategory = value);
                      },
                      validator:
                          (value) =>
                              value == null
                                  ? "Veuillez sélectionner une catégorie"
                                  : null,
                    ),
                    const SizedBox(height: 8),
                    SwitchListTile(
                      contentPadding: EdgeInsets.zero,
                      title: Text(
                        "Ce logement est à louer",
                        style: theme.textTheme.bodyLarge,
                      ),
                      secondary: Icon(
                        isForRent ? Icons.home_work : Icons.home,
                        color: theme.colorScheme.primary,
                      ),
                      value: isForRent,
                      onChanged:
                          (bool value) => setState(() => isForRent = value),
                    ),
                  ],
                ),
                const SizedBox(height: 32),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed:
                        provider.isLoading
                            ? null
                            : () {
                              if (widget.token != null)
                                handlePublish(widget.token!);
                            },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: theme.primaryColor,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child:
                        provider.isLoading
                            ? const SizedBox(
                              width: 24,
                              height: 24,
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                                valueColor: AlwaysStoppedAnimation(
                                  Colors.white,
                                ),
                              ),
                            )
                            : Text(
                              "PUBLIER LE LOGEMENT",
                              style: theme.textTheme.labelLarge?.copyWith(
                                color: Colors.white,
                                letterSpacing: 1.2,
                              ),
                            ),
                  ),
                ),
                const SizedBox(height: 16),
                Text(
                  "* Champs obligatoires",
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: theme.colorScheme.outline,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildSectionCard({required List<Widget> children, ThemeData? theme}) {
    return Card(
      elevation: 1,
      color: theme?.cardColor,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: BorderSide(
          color: Theme.of(context).colorScheme.outline.withOpacity(0.2),
          width: 1,
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children:
              children
                  .map(
                    (child) => Padding(
                      padding: const EdgeInsets.only(bottom: 16),
                      child: child,
                    ),
                  )
                  .toList(),
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
    IconData? icon,
  }) {
    return TextFormField(
      controller: controller,
      keyboardType: keyboardType,
      maxLines: maxLines,
      validator:
          validator ??
          (value) => value == null || value.isEmpty ? "Champ requis" : null,
      decoration: InputDecoration(
        labelText: label,
        prefixIcon: icon != null ? Icon(icon) : null,
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
      ),
    );
  }
}
