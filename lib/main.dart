import 'dart:io';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';

void main() {
  runApp(const SurveyApp());
}

class SurveyApp extends StatelessWidget {
  const SurveyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Форма опитування',
      theme: ThemeData(
        useMaterial3: true,
        fontFamily: 'Roboto',
        scaffoldBackgroundColor: const Color(0xFFF0EBF8),
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF673AB7),
          brightness: Brightness.light,
        ),
      ),
      home: const SurveyPage(),
    );
  }
}

class SurveyPage extends StatefulWidget {
  const SurveyPage({super.key});

  @override
  State<SurveyPage> createState() => _SurveyPageState();
}

class _SurveyPageState extends State<SurveyPage> {
  final List<String> questions = [
    'Як вас звати?',
    'Скільки вам років?',
    'Яка ваша улюблена мова програмування?',
    'Що вам найбільше сподобалося у Flutter?',
    'Чи подобається вам програмувати?'
  ];

  final TextEditingController controller = TextEditingController();
  final List<String> answers = [];

  int currentIndex = 0;

  Future<File> _getFile() async {
    final dir = await getApplicationDocumentsDirectory();
    return File('${dir.path}/answers.txt');
  }

  Future<void> saveAnswer() async {
    final text = controller.text.trim();

    if (text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Будь ласка, введіть відповідь')),
      );
      return;
    }

    if (answers.length > currentIndex) {
      answers[currentIndex] = '${questions[currentIndex]}\nВідповідь: $text\n';
    } else {
      answers.add('${questions[currentIndex]}\nВідповідь: $text\n');
    }

    final file = await _getFile();
    await file.writeAsString(answers.join('\n'));

    if (currentIndex < questions.length - 1) {
      setState(() {
        currentIndex++;
        controller.text =
            currentIndex < answers.length
                ? _extractAnswerText(answers[currentIndex])
                : '';
      });
    } else {
      if (!mounted) return;
      showDialog(
        context: context,
        builder:
            (context) => AlertDialog(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              title: const Text('Опитування завершено'),
              content: const Text('Дякуємо за ваші відповіді!'),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text('OK'),
                ),
              ],
            ),
      );
    }
  }

  String _extractAnswerText(String record) {
    final parts = record.split('Відповідь: ');
    if (parts.length > 1) {
      return parts[1].trim();
    }
    return '';
  }

  void goBack() {
    if (currentIndex > 0) {
      setState(() {
        currentIndex--;
        controller.text =
            currentIndex < answers.length
                ? _extractAnswerText(answers[currentIndex])
                : '';
      });
    }
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final progress = (currentIndex + 1) / questions.length;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Форма опитування'),
        centerTitle: true,
        backgroundColor: const Color(0xFFF0EBF8),
        foregroundColor: Colors.black87,
        elevation: 0,
      ),
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 700),
              child: Column(
                children: [
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12),
                      boxShadow: const [
                        BoxShadow(
                          color: Color(0x14000000),
                          blurRadius: 10,
                          offset: Offset(0, 2),
                        ),
                      ],
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          height: 10,
                          decoration: const BoxDecoration(
                            color: Color(0xFF673AB7),
                            borderRadius: BorderRadius.vertical(
                              top: Radius.circular(12),
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.fromLTRB(20, 20, 20, 12),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                'Опитування користувача',
                                style: TextStyle(
                                  fontSize: 28,
                                  fontWeight: FontWeight.w600,
                                  color: Colors.black87,
                                ),
                              ),
                              const SizedBox(height: 8),
                              const Text(
                                'Будь ласка, дайте відповідь на запитання нижче.',
                                style: TextStyle(
                                  fontSize: 15,
                                  color: Colors.black54,
                                ),
                              ),
                              const SizedBox(height: 16),
                              LinearProgressIndicator(
                                value: progress,
                                minHeight: 8,
                                borderRadius: BorderRadius.circular(20),
                                backgroundColor: const Color(0xFFE9E1F8),
                                valueColor: const AlwaysStoppedAnimation(
                                  Color(0xFF673AB7),
                                ),
                              ),
                              const SizedBox(height: 8),
                              Text(
                                'Питання ${currentIndex + 1} з ${questions.length}',
                                style: const TextStyle(
                                  fontSize: 14,
                                  color: Colors.black54,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 16),

                  Container(
                    width: double.infinity,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12),
                      boxShadow: const [
                        BoxShadow(
                          color: Color(0x14000000),
                          blurRadius: 10,
                          offset: Offset(0, 2),
                        ),
                      ],
                    ),
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(20, 24, 20, 24),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            questions[currentIndex],
                            style: const TextStyle(
                              fontSize: 22,
                              fontWeight: FontWeight.w500,
                              color: Colors.black87,
                            ),
                          ),
                          const SizedBox(height: 8),
                          const Text(
                            '* Обов’язкове поле',
                            style: TextStyle(
                              fontSize: 13,
                              color: Colors.redAccent,
                            ),
                          ),
                          const SizedBox(height: 20),
                          TextField(
                            controller: controller,
                            maxLines: 1,
                            decoration: InputDecoration(
                              hintText: 'Ваша відповідь',
                              filled: true,
                              fillColor: Colors.white,
                              contentPadding: const EdgeInsets.symmetric(
                                horizontal: 0,
                                vertical: 12,
                              ),
                              enabledBorder: const UnderlineInputBorder(
                                borderSide: BorderSide(
                                  color: Color(0xFFBDBDBD),
                                  width: 1.2,
                                ),
                              ),
                              focusedBorder: const UnderlineInputBorder(
                                borderSide: BorderSide(
                                  color: Color(0xFF673AB7),
                                  width: 2,
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(height: 28),
                          Row(
                            children: [
                              if (currentIndex > 0)
                                OutlinedButton(
                                  onPressed: goBack,
                                  style: OutlinedButton.styleFrom(
                                    foregroundColor: const Color(0xFF673AB7),
                                    side: const BorderSide(
                                      color: Color(0xFF673AB7),
                                    ),
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 20,
                                      vertical: 14,
                                    ),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                  ),
                                  child: const Text('Назад'),
                                ),
                              if (currentIndex > 0) const SizedBox(width: 12),
                              ElevatedButton(
                                onPressed: saveAnswer,
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: const Color(0xFF673AB7),
                                  foregroundColor: Colors.white,
                                  elevation: 0,
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 22,
                                    vertical: 14,
                                  ),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                ),
                                child: Text(
                                  currentIndex == questions.length - 1
                                      ? 'Завершити'
                                      : 'Далі',
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),

                  const SizedBox(height: 14),

                  const Align(
                    alignment: Alignment.centerLeft,
                    child: Padding(
                      padding: EdgeInsets.symmetric(horizontal: 4),
                      child: Text(
                        'Форма автоматично зберігає відповіді у файл на пристрої.',
                        style: TextStyle(
                          fontSize: 12.5,
                          color: Colors.black54,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}