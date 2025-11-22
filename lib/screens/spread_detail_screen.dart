import 'package:flutter/material.dart';
import '../models/spread.dart';

class SpreadDetailScreen extends StatelessWidget {
  final Spread spread;

  const SpreadDetailScreen({super.key, required this.spread});

  @override
  Widget build(BuildContext context) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      print('🔍 DEBUG SpreadDetailScreen:');
      print('   📝 Название: ${spread.title}');
      print('   🖼️ imageUrl: ${spread.imageUrl}');
      print('   ❓ imageUrl is null: ${spread.imageUrl == null}');
      print('   ❓ imageUrl is empty: ${spread.imageUrl?.isEmpty}');
    });

    return Scaffold(
      appBar: AppBar(
        title: Center(
          child: Text(
            spread.title,
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
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
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Описание
            Container(
              padding: EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Color(0xFF387FAD).withOpacity(0.05),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Color(0xFF387FAD).withOpacity(0.1)),
              ),
              child: Text(
                spread.description,
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.black87,
                  height: 1.5,
                ),
              ),
            ),

            // Дивайдер после описания
            Divider(color: Color(0xFF96B9D3).withOpacity(0.3)),
            SizedBox(height: 16),

            // Заголовок позиций
            Row(
              children: [
                Text(
                  'Позиции расклада',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFFAFA376),
                  ),
                ),
                SizedBox(width: 8),
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: Color(0xFFAFA376).withOpacity(0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    '${spread.positions.length}',
                    style: TextStyle(
                      color: Color(0xFFAFA376),
                      fontWeight: FontWeight.bold,
                      fontSize: 14,
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: 16),

            // Список позиций
            ListView.builder(
              shrinkWrap: true,
              physics: NeverScrollableScrollPhysics(),
              itemCount: spread.positions.length,
              itemBuilder: (context, index) {
                return Container(
                  margin: EdgeInsets.only(bottom: 12),
                  child: Material(
                    elevation: 2,
                    borderRadius: BorderRadius.circular(16),
                    child: Container(
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                          colors: [
                            Colors.white,
                            Color(0xFFAFA376).withOpacity(0.05),
                          ],
                        ),
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(
                          color: Color(0xFFAFA376).withOpacity(0.2),
                          width: 1,
                        ),
                      ),
                      child: ListTile(
                        contentPadding: EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 12,
                        ),
                        leading: Container(
                          width: 44,
                          height: 44,
                          decoration: BoxDecoration(
                            color: Color(0xFFAFA376).withOpacity(0.1),
                            borderRadius: BorderRadius.circular(22),
                          ),
                          child: Center(
                            child: Text(
                              '${index + 1}',
                              style: TextStyle(
                                color: Color(0xFFAFA376),
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                              ),
                            ),
                          ),
                        ),
                        title: Text(
                          spread.positions[index],
                          style: TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.w600,
                            color: Color(0xFF387FAD),
                            height: 1.3,
                          ),
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),

            // Дивайдер перед изображением
            Divider(color: Color(0xFF96B9D3).withOpacity(0.3)),
            SizedBox(height: 16),

            // Заголовок изображения
            Row(
              children: [
                Text(
                  'Изображение расклада',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFFAFA376),
                  ),
                ),
              ],
            ),
            SizedBox(height: 16),

            // Изображение расклада
            if (spread.imageUrl != null && spread.imageUrl!.isNotEmpty)
              Container(
                width: double.infinity,
                margin: EdgeInsets.only(bottom: 20),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.1),
                      blurRadius: 8,
                      offset: Offset(0, 4),
                    ),
                  ],
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(16),
                  child: Image.network(
                    // ЗАМЕНИТЕ
                  //'https://tarot.magiclife.su${spread.imageUrl}',
                    // НА
                    'https://45.130.41.31${spread.imageUrl}',
                    fit: BoxFit.contain, // ← ПОКАЗЫВАЕТ ВСЮ КАРТИНКУ
                    loadingBuilder: (context, child, loadingProgress) {
                      if (loadingProgress == null) {
                        print('✅ ИЗОБРАЖЕНИЕ УСПЕШНО ЗАГРУЖЕНО: ${spread.imageUrl}');
                        return child;
                      }
                      print('🔄 ЗАГРУЗКА ИЗОБРАЖЕНИЯ... Прогресс: $loadingProgress');
                      return Container(
                        color: Color(0xFFAFA376).withOpacity(0.1),
                        child: Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              CircularProgressIndicator(
                                valueColor: AlwaysStoppedAnimation<Color>(Color(0xFFAFA376)),
                              ),
                              SizedBox(height: 12),
                              Text(
                                'Загрузка изображения...',
                                style: TextStyle(
                                  color: Color(0xFFAFA376),
                                  fontSize: 14,
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                    errorBuilder: (context, error, stackTrace) {
                      print('❌ ОШИБКА ЗАГРУЗКИ ИЗОБРАЖЕНИЯ:');
                      print('   🔗 URL: ${spread.imageUrl}');
                      print('   💥 Ошибка: $error');
                      print('   📍 StackTrace: $stackTrace');
                      return Container(
                        color: Colors.red.withOpacity(0.1),
                        child: Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(Icons.error, color: Colors.red, size: 48),
                              SizedBox(height: 12),
                              Text(
                                'Ошибка загрузки',
                                style: TextStyle(
                                  color: Colors.red,
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              SizedBox(height: 8),
                              Padding(
                                padding: EdgeInsets.symmetric(horizontal: 16),
                                child: Text(
                                  'URL: ${spread.imageUrl}',
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    color: Colors.red,
                                    fontSize: 12,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ),
              )
            else
              // Заглушка если нет изображения
              Container(
                height: 200,
                width: double.infinity,
                margin: EdgeInsets.only(bottom: 20),
                decoration: BoxDecoration(
                  color: Color(0xFFAFA376).withOpacity(0.1),
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(
                    color: Color(0xFFAFA376).withOpacity(0.3),
                    width: 1,
                  ),
                ),
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.auto_awesome,
                        size: 64,
                        color: Color(0xFFAFA376).withOpacity(0.5),
                      ),
                      SizedBox(height: 12),
                      Text(
                        'Изображение расклада',
                        style: TextStyle(
                          color: Color(0xFFAFA376),
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      SizedBox(height: 8),
                      Text(
                        'будет добавлено позже',
                        style: TextStyle(
                          color: Color(0xFFAFA376).withOpacity(0.7),
                          fontSize: 14,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
