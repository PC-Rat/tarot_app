import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import '../services/api_service.dart';
import '../models/category.dart';
import '../models/spread.dart';
import 'spreads_screen.dart';
import 'spread_detail_screen.dart';

class CategoriesScreen extends StatefulWidget {
  @override
  _CategoriesScreenState createState() => _CategoriesScreenState();
}

class _CategoriesScreenState extends State<CategoriesScreen> {
  late Future<List<Category>> _categoriesFuture;
  Map<String, dynamic> _appInfo = {
    'subtitle': '',
    'announcement': ''
  };

  final TextEditingController _searchController = TextEditingController();
  List<Spread> _allSpreads = [];
  List<Spread> _searchResults = [];
  bool _isSearching = false;

  @override
  void initState() {
    super.initState();
    _categoriesFuture = ApiService.getCategories();
    _loadAppInfo();
    _loadAllSpreads();
    _searchController.addListener(_onSearchChanged);
  }

  void _loadAppInfo() async {
    final info = await ApiService.getAppInfo();
    if (info != null && mounted) {
      setState(() {
        _appInfo = info;
      });
    }
  }

  void _loadAllSpreads() async {
    try {
     final response = await http.get(Uri.parse('${ApiService.baseUrl}/spreads.php'));
      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);
        setState(() {
          _allSpreads = data.map((json) => Spread.fromJson(json)).toList();
        });
      }
    } catch (e) {
      print('Ошибка загрузки раскладов: $e');
    }
  }

  void _onSearchChanged() {
  final query = _searchController.text.trim().toLowerCase();
  setState(() {
    _isSearching = query.isNotEmpty;
    if (_isSearching) {
      _searchResults = _allSpreads.where((spread) =>
        spread.title.toLowerCase().contains(query) ||
        spread.description.toLowerCase().contains(query) ||
        spread.categoryId.toLowerCase().contains(query) ||
        spread.positions.any((position) => position.toLowerCase().contains(query))
      ).toList();
    }
  });
}

  Widget _buildSearchResults() {
    if (_searchController.text.isNotEmpty && _searchResults.isEmpty) {
      return Center(
        child: Text(
          'Ничего не найдено',
          style: TextStyle(color: Color(0xFF387FAD)),
        ),
      );
    }

    return ListView.builder(
      padding: EdgeInsets.all(16),
      itemCount: _searchResults.length,
      itemBuilder: (context, index) {
        final spread = _searchResults[index];
        return Card(
          elevation: 2,
          margin: EdgeInsets.symmetric(vertical: 8),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          child: ListTile(
            contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            leading: Container(
              width: 50, height: 50,
              decoration: BoxDecoration(
                color: Color(0xFFAFA376).withOpacity(0.1),
                borderRadius: BorderRadius.circular(10),
              ),
              child: spread.imageUrl != null
                  ? Image.network(
                      '${ApiService.baseUrl}${spread.imageUrl}',
                      width: 50,
                      height: 50,
                      fit: BoxFit.cover,
                    )
                  : Center(child: Text('🔮', style: TextStyle(fontSize: 20))),
            ),
            title: Text(
              spread.title,
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Color(0xFF387FAD)),
            ),
            subtitle: Text(spread.description, style: TextStyle(color: Color(0xFF96B9D3))),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => SpreadDetailScreen(spread: spread),
                ),
              );
            },
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Center(
          child: Text(
            'Расклады Таро Insolate',
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        backgroundColor: Color(0xFF387FAD),
        foregroundColor: Colors.white,
        elevation: 2,
        centerTitle: true,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(
            bottom: Radius.circular(16),
          ),
        ),
        leading: Builder(
          builder: (context) => IconButton(
            icon: Icon(Icons.menu, color: Colors.white),
            onPressed: () => Scaffold.of(context).openDrawer(),
          ),
        ),
      ),
      drawer: _buildAppDrawer(),
      body: Column(
        children: [
          // Верхняя часть с subtitle и announcement
          Container(
            width: double.infinity,
            padding: EdgeInsets.all(20),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [Color(0xFF387FAD), Color(0xFF96B9D3)],
              ),
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(16),
                topRight: Radius.circular(16),
                bottomLeft: Radius.circular(16),
                bottomRight: Radius.circular(16),
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  _appInfo['subtitle'] ?? '',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                SizedBox(height: 12),
                Text(
                  _appInfo['announcement'] ?? '',
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.white,
                    height: 1.4,
                  ),
                ),
                // 🔍 ПОИСК
                SizedBox(height: 16),
                Container(
                  width: double.infinity,
                  child: TextField(
                    controller: _searchController,
                    decoration: InputDecoration(
                      hintText: 'Поиск...',
                      hintStyle: TextStyle(color: Colors.white70),
                      prefixIcon: Icon(Icons.search, color: Colors.white70),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide(color: Colors.white),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide(color: Colors.white),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide(color: Colors.white),
                      ),
                      filled: true,
                      fillColor: Colors.white.withOpacity(0.2),
                      contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                    ),
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              ],
            ),
          ),

          // КОНТЕНТ С УСЛОВИЕМ ПОИСКА
          Expanded(
            child: _isSearching ? _buildSearchResults() : FutureBuilder<List<Category>>(
              future: _categoriesFuture,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        CircularProgressIndicator(
                          valueColor: AlwaysStoppedAnimation<Color>(Color(0xFFAFA376)),
                        ),
                        SizedBox(height: 16),
                        Text(
                          'Загрузка категорий...',
                          style: TextStyle(color: Color(0xFF387FAD)),
                        ),
                      ],
                    ),
                  );
                }
                if (snapshot.hasError) {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.error, color: Color(0xFF387FAD), size: 64),
                        SizedBox(height: 16),
                        Text(
                          'Ошибка загрузки категорий',
                          style: TextStyle(fontSize: 18, color: Color(0xFF387FAD)),
                        ),
                        SizedBox(height: 8),
                        Text(
                          '${snapshot.error}',
                          textAlign: TextAlign.center,
                          style: TextStyle(color: Color(0xFF96B9D3)),
                        ),
                      ],
                    ),
                  );
                }
             if (snapshot.hasData && snapshot.data!.isNotEmpty) {
  final categories = snapshot.data!;
  return ListView.builder(
    padding: EdgeInsets.all(16),
    itemCount: categories.length,
    itemBuilder: (context, index) {
      final category = categories[index];
      return Card(
        elevation: 2,
        margin: EdgeInsets.symmetric(vertical: 8),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        child: ExpansionTile(
          leading: Container(
            width: 50, height: 50,
            decoration: BoxDecoration(
              color: Color(0xFFAFA376).withOpacity(0.1),
              borderRadius: BorderRadius.circular(10),
            ),
            //child: Center(
              //child: Text('🔮', style: TextStyle(fontSize: 24)),
            //),
            child: Image.network(
  '${ApiService.baseUrl}/images/categories_icon.png',
  width: 100,
  height: 100,
)
          ),
          title: Text(
            category.title,
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Color(0xFF387FAD)),
          ),
          subtitle: Text('${category.count} раскладов', style: TextStyle(color: Color(0xFF96B9D3))),
          trailing: Icon(Icons.arrow_drop_down, color: Color(0xFFAFA376)),
          children: _buildCategorySpreads(category.id),
          onExpansionChanged: (expanded) {
            // Дополнительная логика при раскрытии/закрытии
          },
        ),
      );
    },
  );
}
                return Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.inbox, size: 64, color: Color(0xFF96B9D3)),
                      SizedBox(height: 16),
                      Text('Нет категорий', style: TextStyle(fontSize: 18, color: Color(0xFF387FAD))),
                    ],
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  List<Widget> _buildCategorySpreads(String categoryId) {
  final categorySpreads = _allSpreads
      .where((spread) => spread.categoryId == categoryId)
      .toList();

  if (categorySpreads.isEmpty) {
    return [
      Padding(
        padding: EdgeInsets.all(16),
        child: Text(
          'Нет раскладов в этой категории',
          style: TextStyle(color: Color(0xFF96B9D3), fontStyle: FontStyle.italic),
        ),
      ),
    ];
  }

  return categorySpreads.map((spread) =>
    Container(
      margin: EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Color(0xFFAFA376).withOpacity(0.2)),
      ),
      child: ListTile(
        contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        leading: Container(
          width: 40, height: 40,
          decoration: BoxDecoration(
            color: Color(0xFFAFA376).withOpacity(0.1),
            borderRadius: BorderRadius.circular(8),
          ),
          child: spread.imageUrl != null
              ? ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: Image.network(
                    '${ApiService.baseUrl}${spread.imageUrl}',
                    width: 40,
                    height: 40,
                    fit: BoxFit.cover,
                  ),
                )
              : Center(
                  child: Icon(Icons.psychology, size: 20, color: Color(0xFFAFA376)),
                ),
        ),
        title: Text(
          spread.title,
          style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500, color: Color(0xFF387FAD)),
        ),
        trailing: Icon(Icons.arrow_forward_ios, size: 14, color: Color(0xFFAFA376)),
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => SpreadDetailScreen(spread: spread),
            ),
          );
        },
      ),
    )
  ).toList();
}

  Widget _buildAppDrawer() {
    return Drawer(
      child: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Color(0xFF387FAD), Color(0xFF96B9D3)],
          ),
        ),
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            DrawerHeader(
              decoration: BoxDecoration(
                color: Color(0xFF387FAD),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  CircleAvatar(
                    backgroundColor: Colors.white,
                    radius: 30,
                    child: Icon(Icons.psychology, color: Color(0xFF387FAD), size: 32),
                  ),
                  SizedBox(height: 12),
                  Text(
                    'Таро Insolate',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 4),
                  Text(
                    'Авторские расклады',
                    style: TextStyle(
                      color: Colors.white70,
                      fontSize: 14,
                    ),
                  ),
                ],
              ),
            ),
            _buildDrawerItem(
              icon: Icons.search,
              title: 'Поиск',
              onTap: () => Navigator.pop(context),
            ),
            _buildDrawerItem(
              icon: Icons.category,
              title: 'Категории',
              onTap: () => Navigator.pop(context),
            ),
            Divider(color: Colors.white.withOpacity(0.3), height: 20),
            _buildDrawerItem(
              icon: Icons.favorite_border,
              title: 'Избранное',
              onTap: () => _openFavoritesScreen(context),
            ),
            _buildDrawerItem(
              icon: Icons.info_outline,
              title: 'О приложении',
              onTap: () => _openAboutScreen(context),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDrawerItem({
    required IconData icon,
    required String title,
    required VoidCallback onTap,
  }) {
    return ListTile(
      leading: Icon(icon, color: Colors.white, size: 24),
      title: Text(
        title,
        style: TextStyle(
          color: Colors.white,
          fontSize: 16,
          fontWeight: FontWeight.w500,
        ),
      ),
      onTap: onTap,
    );
  }

  void _openFavoritesScreen(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Избранное'),
        content: Text('Скоро здесь будут ваши избранные расклады! ⭐'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Жду!'),
          ),
        ],
      ),
    );
  }

  void _openAboutScreen(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('О приложении'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Таро Insolate'),
            SizedBox(height: 8),
            Text('Авторские расклады'),
            SizedBox(height: 8),
            Text('Версия 1.0.0'),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('OK'),
          ),
        ],
      ),
    );
  }
}
