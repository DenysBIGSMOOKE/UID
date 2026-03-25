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
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
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
  final TextEditingController _controller = TextEditingController();

  final List<String> questions = [
    'Як вас звати?',
    'Скільки вам років?',
    'Звідки ви?',
    'Що вам найбільше сподобалося у Flutter?',
    'Які функції ви хотіли б додати у застосунок?',
  ];

  int currentQuestionIndex = 0;
  bool surveyCompleted = false;

  Future<String> _getFilePath() async {
    final directory = await getApplicationDocumentsDirectory();
    return '${directory.path}/answers.txt';
  }

  Future<void> _saveAnswer() async {
    final answer = _controller.text.trim();

    if (answer.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Помилка: введіть відповідь перед збереженням.'),
        ),
      );
      return;
    }

    final filePath = await _getFilePath();
    final file = File(filePath);

    final textToWrite =
        'Питання ${currentQuestionIndex + 1}: ${questions[currentQuestionIndex]}\n'
        'Відповідь: $answer\n'
        '-----------------------------\n';

    await file.writeAsString(
      textToWrite,
      mode: FileMode.append,
    );

    if (currentQuestionIndex < questions.length - 1) {
      setState(() {
        currentQuestionIndex++;
        _controller.clear();
      });
    } else {
      setState(() {
        surveyCompleted = true;
        _controller.clear();
      });

      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Опитування завершено! Усі відповіді збережено.'),
        ),
      );
    }
  }

  void _exitApp() {
    exit(0);
  }

  @override
  void initState() {
    super.initState();
    _clearOldAnswersFile();
  }

  Future<void> _clearOldAnswersFile() async {
    final filePath = await _getFilePath();
    final file = File(filePath);

    if (await file.exists()) {
      await file.writeAsString('');
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final String progressText = surveyCompleted
        ? 'Опитування завершено'
        : 'Питання ${currentQuestionIndex + 1} з ${questions.length}';

    return Scaffold(
      appBar: AppBar(
        title: const Text('Форма опитування'),
        centerTitle: true,
      ),
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 500),
            child: Card(
              elevation: 4,
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      'Опитування користувача',
                      style: Theme.of(context).textTheme.headlineSmall,
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 12),
                    Text(
                      progressText,
                      style: const TextStyle(
                        fontSize: 16,
                        color: Colors.deepPurple,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 20),
                    Text(
                      surveyCompleted
                          ? 'Дякуємо за проходження опитування.'
                          : questions[currentQuestionIndex],
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 20),
                    TextField(
                      controller: _controller,
                      enabled: !surveyCompleted,
                      maxLines: 4,
                      decoration: const InputDecoration(
                        labelText: 'Ваша відповідь',
                        border: OutlineInputBorder(),
                        hintText: 'Введіть відповідь тут...',
                      ),
                    ),
                    const SizedBox(height: 20),
                    if (!surveyCompleted)
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: _saveAnswer,
                          child: const Text('Зберегти'),
                        ),
                      ),
                    if (surveyCompleted)
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: _exitApp,
                          child: const Text('Вийти'),
                        ),
                      ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}