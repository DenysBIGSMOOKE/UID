using System;
using System.IO;
using System.Windows;

namespace Lab1_2
{
    public partial class MainWindow : Window
    {
        string[] questions =
        {
            "Як вас звати?",
            "Скільки вам років?",
            "З якого ви міста?",
            "Яка ваша улюблена мова програмування?",
            "Який ваш улюблений предмет?"
        };

        int currentIndex = 0;

        public MainWindow()
        {
            InitializeComponent();
            ShowQuestion();
        }

        private void ShowQuestion()
        {
            questionText.Text = questions[currentIndex];
            progressText.Text = $"Питання {currentIndex + 1} з {questions.Length}";
        }

        private void saveButton_Click(object sender, RoutedEventArgs e)
        {
            string answer = answerTextBox.Text.Trim();
            if (string.IsNullOrWhiteSpace(answer))
            {
                MessageBox.Show("Будь ласка, введіть відповідь!", "Помилка", MessageBoxButton.OK, MessageBoxImage.Warning);
                return;
            }

            string result = questions[currentIndex] + " - " + answer;
            string filePath = Path.Combine(AppDomain.CurrentDomain.BaseDirectory, "answers.txt");
            File.AppendAllText(filePath, result + Environment.NewLine);

            answerTextBox.Clear();
            currentIndex++;

            if (currentIndex >= questions.Length)
            {
                MessageBox.Show("Опитування завершено!\nДякуємо за участь 😊", "Завершено", MessageBoxButton.OK, MessageBoxImage.Information);
                questionText.Text = "Опитування завершено.";
                progressText.Text = "";
                answerTextBox.IsEnabled = false;
                saveButton.IsEnabled = false;
                exitButton.Visibility = Visibility.Visible;
            }
            else
            {
                ShowQuestion();
            }
        }

        private void exitButton_Click(object sender, RoutedEventArgs e)
        {
            this.Close(); 
        }
    }
}
