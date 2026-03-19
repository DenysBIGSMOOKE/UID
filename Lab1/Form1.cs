using System;
using System.IO;
using System.Windows.Forms;
using static System.Windows.Forms.VisualStyles.VisualStyleElement;

namespace Lab1
{
    public partial class Form1 : Form
    {
        // Масив питань
        string[] questions =
        {
            "Як вас звати?",
            "Скільки вам років?",
            "З якого ви міста?",
            "Яка ваша улюблена мова програмування?",
            "Який ваш улюблений предмет?"
        };

        // Індекс поточного питання
        int currentIndex = 0;

        public Form1()
        {
            InitializeComponent();
            ShowQuestion();

            // Кнопка виходу прихована до завершення
            exitButton.Visible = false;
            exitButton.Click += ExitButton_Click;
        }

        // Метод відображення питання
        private void ShowQuestion()
        {
            questionLabel.Text = questions[currentIndex];
            progressLabel.Text = $"Питання {currentIndex + 1} з {questions.Length}";
        }

        // Обробник кнопки "Зберегти"
        private void saveButton_Click(object sender, EventArgs e)
        {
            string answer = answerTextBox.Text;

            // Перевірка на пусте поле
            if (string.IsNullOrWhiteSpace(answer))
            {
                MessageBox.Show("Будь ласка, введіть відповідь!", "Помилка",
                    MessageBoxButtons.OK, MessageBoxIcon.Warning);
                return;
            }

            // Формування рядка для запису
            string result = questions[currentIndex] + " - " + answer;

            // Шлях до файлу
            string filePath = Path.Combine(
                AppDomain.CurrentDomain.BaseDirectory,
                "answers.txt");

            // Запис у файл
            File.AppendAllText(filePath, result + Environment.NewLine);

            answerTextBox.Clear();
            currentIndex++;

            // Перевірка завершення
            if (currentIndex >= questions.Length)
            {
                MessageBox.Show("Опитування завершено!\nДякуємо за участь 😊",
                    "Завершено",
                    MessageBoxButtons.OK,
                    MessageBoxIcon.Information);

                questionLabel.Text = "Опитування завершено.";
                progressLabel.Text = "";
                answerTextBox.Enabled = false;
                saveButton.Enabled = false;
                exitButton.Visible = true;
            }
            else
            {
                ShowQuestion();
            }
        }

        // Кнопка виходу
        private void ExitButton_Click(object sender, EventArgs e)
        {
            Application.Exit();
        }

       
    }
}

