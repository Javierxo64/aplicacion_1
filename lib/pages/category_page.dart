import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:app/services/auth_service.dart';
import 'package:app/services/menu_service.dart';
import 'package:app/models/dish.dart';
import 'package:app/constants/colors.dart';
import 'package:app/pages/rating_dialog.dart';

class CategoryPage extends StatefulWidget {
  final String categoryToken;
  final String categoryName;

  const CategoryPage({
    super.key,
    required this.categoryToken,
    required this.categoryName,
  });

  @override
  State<CategoryPage> createState() => _CategoryPageState();
}

class _CategoryPageState extends State<CategoryPage> {
  late final MenuService _menuService;
  Map<String, dynamic>? _menuData;
  bool _isLoading = true;
  String? _error;

  @override
  void initState() {
    super.initState();
    _menuService = MenuService();
    _loadCategoryMenu();
  }

  Future<void> _loadCategoryMenu() async {
    final token = Provider.of<AuthService>(context, listen: false).token;
    if (token == null) return;

    try {
      final menu = await _menuService.getCategoryMenu(token, widget.categoryToken);
      setState(() {
        _menuData = menu;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
        _error = 'Error al cargar el menú: $e';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.categoryName),
        backgroundColor: AppColors.vintagePrimary,
      ),
      body: _buildBody(),
    );
  }

  Widget _buildBody() {
    if (_isLoading) {
      return Center(
        child: CircularProgressIndicator(
          valueColor: AlwaysStoppedAnimation<Color>(AppColors.vintagePrimary),
        ),
      );
    }

    if (_error != null) {
      return Center(
        child: Text(
          _error!,
          style: const TextStyle(color: AppColors.vintageText),
        ),
      );
    }

    if (_menuData == null) {
      return const Center(
        child: Text(
          'No hay menú disponible para esta categoría',
          style: TextStyle(color: AppColors.vintageText),
        ),
      );
    }

    return Container(
      decoration: const BoxDecoration(
        color: AppColors.vintageBackground,
      ),
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (_menuData!['category']?['description'] != null)
              Padding(
                padding: const EdgeInsets.only(bottom: 16),
                child: Text(
                  _menuData!['category']['description'],
                  style: const TextStyle(
                    color: AppColors.vintageText,
                    fontSize: 16,
                  ),
                ),
              ),
            if (_menuData!['dishes'] != null)
              ..._buildDishesSection(),
            if (_menuData!['drinks'] != null)
              ..._buildDrinksSection(),
          ],
        ),
      ),
    );
  }

  List<Widget> _buildDishesSection() {
    final dishes = (_menuData!['dishes'] as List)
        .map((d) => Dish.fromJson(d))
        .toList();

    return [
      const Text(
        'Platos Principales',
        style: TextStyle(
          color: AppColors.vintagePrimary,
          fontSize: 20,
          fontWeight: FontWeight.bold,
        ),
      ),
      const SizedBox(height: 8),
      ...dishes.map((dish) => _buildDishCard(dish)),
    ];
  }

  Widget _buildDishCard(Dish dish) {
    return Card(
      color: AppColors.vintageCream,
      margin: const EdgeInsets.only(bottom: 16),
      child: InkWell(
        borderRadius: BorderRadius.circular(8),
        onTap: () => _showRatingDialog(dish),
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: CachedNetworkImage(
                  imageUrl: dish.imageUrl,
                  width: 80,
                  height: 80,
                  fit: BoxFit.cover,
                  placeholder: (context, url) => Container(
                    width: 80,
                    height: 80,
                    color: Colors.grey[200],
                    child: Icon(Icons.fastfood, size: 40, color: AppColors.vintagePrimary),
                  ),
                  errorWidget: (context, url, error) => Container(
                    width: 80,
                    height: 80,
                    color: Colors.grey[200],
                    child: Icon(Icons.image_not_supported, size: 40, color: AppColors.vintagePrimary),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      dish.name,
                      style: const TextStyle(
                        color: AppColors.vintageText,
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      dish.description,
                      style: TextStyle(color: AppColors.vintageText.withOpacity(0.8)),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      '\$${dish.price.toStringAsFixed(2)}',
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: AppColors.vintagePrimary,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  List<Widget> _buildDrinksSection() {
    final drinks = (_menuData!['drinks'] as List)
        .map((d) => Dish.fromJson(d))
        .toList();

    return [
      const SizedBox(height: 24),
      const Text(
        'Bebidas',
        style: TextStyle(
          color: AppColors.vintagePrimary,
          fontSize: 20,
          fontWeight: FontWeight.bold,
        ),
      ),
      const SizedBox(height: 8),
      ...drinks.map((drink) => _buildDrinkCard(drink)),
    ];
  }

  Widget _buildDrinkCard(Dish drink) {
    return Card(
      color: AppColors.vintageCream,
      margin: const EdgeInsets.only(bottom: 16),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: CachedNetworkImage(
                imageUrl: drink.imageUrl,
                width: 80,
                height: 80,
                fit: BoxFit.cover,
                placeholder: (context, url) => Container(
                  width: 80,
                  height: 80,
                  color: Colors.grey[200],
                  child: Icon(Icons.local_drink, size: 40, color: AppColors.vintagePrimary),
                ),
                errorWidget: (context, url, error) => Container(
                  width: 80,
                  height: 80,
                  color: Colors.grey[200],
                  child: Icon(Icons.image_not_supported, size: 40, color: AppColors.vintagePrimary),
                ),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    drink.name,
                    style: const TextStyle(
                      color: AppColors.vintageText,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    '\$${drink.price.toStringAsFixed(2)}',
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: AppColors.vintagePrimary,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showRatingDialog(Dish dish) {
    showDialog(
      context: context,
      builder: (context) => RatingDialog(dish: dish),
    );
  }
}