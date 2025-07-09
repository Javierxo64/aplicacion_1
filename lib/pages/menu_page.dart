import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:app/services/auth_service.dart';
import 'package:app/services/menu_service.dart';
import 'package:app/models/category.dart';
import 'package:app/constants/colors.dart';
import 'package:app/pages/category_page.dart';

class MenuPage extends StatefulWidget {
  const MenuPage({super.key});

  @override
  State<MenuPage> createState() => _MenuPageState();
}

class _MenuPageState extends State<MenuPage> {
  late final MenuService _menuService;
  List<Category> _categories = [];
  bool _isLoading = true;
  String? _error;

  @override
  void initState() {
    super.initState();
    _menuService = MenuService();
    _loadMenus();
  }

  Future<void> _loadMenus() async {
    final token = Provider.of<AuthService>(context, listen: false).token;
    if (token == null) return;

    try {
      final menus = await _menuService.getTodayMenus(token);
      setState(() {
        _categories = menus.map((m) => Category.fromJson(m['category'])).toList();
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
        _error = 'Error al cargar menús: $e';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Menú'),
        backgroundColor: AppColors.vintagePrimary,
      ),
      body: _buildBody(),
    );
  }

  Widget _buildBody() {
    if (_isLoading) {
      return const Center(
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

    return Container(
      decoration: const BoxDecoration(
        color: AppColors.vintageBackground,
      ),
      child: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: _categories.length,
        itemBuilder: (context, index) {
          final category = _categories[index];
          return Card(
            color: AppColors.vintageCream,
            margin: const EdgeInsets.only(bottom: 16),
            child: ListTile(
              title: Text(
                category.name,
                style: const TextStyle(
                  color: AppColors.vintageText,
                  fontWeight: FontWeight.bold,
                ),
              ),
              subtitle: Text(
                category.description,
                style: const TextStyle(color: AppColors.vintageText),
              ),
              trailing: const Icon(
                Icons.chevron_right,
                color: AppColors.vintagePrimary,
              ),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => CategoryPage(
                      categoryToken: category.token,
                      categoryName: category.name,
                    ),
                  ),
                );
              },
            ),
          );
        },
      ),
    );
  }
}