import 'package:flutter/material.dart';
import '../services/api_service.dart';
import '../models/spread.dart';
import 'spread_detail_screen.dart';


class SpreadsScreen extends StatefulWidget {
  final String categoryId;
  final String categoryTitle;

  SpreadsScreen({required this.categoryId, required this.categoryTitle});

  @override
  _SpreadsScreenState createState() => _SpreadsScreenState();
}

class _SpreadsScreenState extends State<SpreadsScreen> {
  late Future<List<Spread>> _spreadsFuture;

  @override
  void initState() {
    super.initState();
    _spreadsFuture = ApiService.getSpreadsByCategory(widget.categoryId);
    _testApi();
  }

  void _testApi() async {
    try {
      print('🎯 ТЕСТ: Запуск принудительной загрузки');
      print('🔍 ТЕСТ: categoryId = ${widget.categoryId}');

      final testSpreads = await ApiService.getSpreadsByCategory(widget.categoryId);
      print('✅ ТЕСТ: Найдено раскладов: ${testSpreads.length}');

      for (var spread in testSpreads) {
        print('📄 ТЕСТ Расклад: ${spread.id}');
        print('   Данные: ${spread.title}');
        print('   categoryId: ${spread.categoryId}');
      }
    } catch (e) {
      print('❌ ТЕСТ Ошибка: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Center(child: Text(widget.categoryTitle, style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold))),
        backgroundColor: Color(0xFF387FAD),
        foregroundColor: Colors.white,
        elevation: 2,
        centerTitle: true,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(
            bottom: Radius.circular(16),
          ),
        ),
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context)
        ),
      ),
      body: FutureBuilder<List<Spread>>(
        future: _spreadsFuture,
        builder: (context, snapshot) {
          print('🔴 FUTURE BUILDER:');
          print('   ConnectionState: ${snapshot.connectionState}');
          print('   HasError: ${snapshot.hasError}');
          print('   HasData: ${snapshot.hasData}');
          if (snapshot.hasData) {
            print('   Data length: ${snapshot.data!.length}');
          }
          if (snapshot.hasError) {
            print('❌ FUTURE ERROR: ${snapshot.error}');
          }

          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CircularProgressIndicator(valueColor: AlwaysStoppedAnimation<Color>(Color(0xFFAFA376))),
                  SizedBox(height: 16),
                  Text('Загрузка раскладов...', style: TextStyle(color: Color(0xFF387FAD))),
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
                  Text('Ошибка загрузки раскладов', style: TextStyle(fontSize: 18, color: Color(0xFF387FAD))),
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
            final spreads = snapshot.data!;
            return ListView.builder(
              padding: EdgeInsets.all(16),
              itemCount: spreads.length,
              itemBuilder: (context, index) {
                final spread = spreads[index];
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
                      child: Center(child: Icon(Icons.psychology, color: Color(0xFFAFA376), size: 24)),
                    ),
                    title: Text(spread.title, style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Color(0xFF387FAD))),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(height: 4),
                        Text(
                          spread.description.length > 100 ? '${spread.description.substring(0, 100)}...' : spread.description,
                          style: TextStyle(color: Color(0xFF96B9D3), fontSize: 12),
                        ),
                        SizedBox(height: 4),
                        Text('${spread.positions.length} позиций', style: TextStyle(color: Color(0xFFAFA376), fontSize: 12, fontWeight: FontWeight.w500)),
                      ],
                    ),
                    trailing: Container(
                      padding: EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: Color(0xFFAFA376).withOpacity(0.1),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Icon(Icons.arrow_forward_ios, size: 16, color: Color(0xFFAFA376)),
                    ),
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
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.psychology_outlined, size: 64, color: Color(0xFF96B9D3)),
                SizedBox(height: 16),
                Text('Нет раскладов в этой категории', style: TextStyle(fontSize: 18, color: Color(0xFF387FAD))),
              ],
            ),
          );
        },
      ),
    );
  }
}
