import sys
from datetime import datetime
from pathlib import Path

from PyQt6.QtCore import Qt
from PyQt6.QtGui import QFontMetrics
from PyQt6.QtWidgets import (
    QApplication, QWidget, QLabel, QLineEdit, QPushButton,
    QVBoxLayout, QHBoxLayout, QMessageBox, QFileDialog,
    QProgressBar, QFrame
)

QUESTIONS = [
    "1) Як вас звати?",
    "2) Скільки вам років?",
    "3) Яка ваша улюблена мова програмування?",
    "4) Що вам найбільше сподобалось у Qt?",
    "5) Вам подобається грати у танки?"
]


class SurveyApp(QWidget):
    def __init__(self):
        super().__init__()
        self.setWindowTitle("Опитування (PyQt6)")
        self.setMinimumWidth(720)

        self.i = 0
        self.answers = [""] * len(QUESTIONS)
        self.output_file = Path.cwd() / "answers.txt"

        self._build_ui()
        self._apply_style()
        self._load_question()

    def _build_ui(self):
        self.title = QLabel("Опитування користувача")
        self.title.setObjectName("title")

        self.subtitle = QLabel("Введіть відповідь і натисніть “Зберегти і далі”.")
        self.subtitle.setObjectName("subtitle")
        self.subtitle.setWordWrap(True)

        self.progress_text = QLabel()
        self.progress_text.setObjectName("progress")

        self.progress = QProgressBar()
        self.progress.setRange(0, len(QUESTIONS))
        self.progress.setTextVisible(False)

        self.question = QLabel()
        self.question.setObjectName("question")
        self.question.setWordWrap(True)

        self.input = QLineEdit()
        self.input.setPlaceholderText("Введіть відповідь...")
        self.input.returnPressed.connect(self.save_and_next)

       
        self.file_label = QLabel()
        self.file_label.setObjectName("fileLabel")
        self.file_label.setTextInteractionFlags(Qt.TextInteractionFlag.TextSelectableByMouse)

        self.btn_choose_file = QPushButton("Обрати файл…")
        self.btn_choose_file.setObjectName("secondaryBtn")
        self.btn_choose_file.clicked.connect(self.choose_file)

        file_row = QHBoxLayout()
        file_row.setSpacing(10)
        file_row.addWidget(self.file_label, 1)
        file_row.addWidget(self.btn_choose_file, 0)

        # buttons
        self.btn_back = QPushButton("⬅ Назад")
        self.btn_back.setObjectName("secondaryBtn")
        self.btn_back.clicked.connect(self.go_back)

        self.btn_save_next = QPushButton("Зберегти і далі ➜")
        self.btn_save_next.clicked.connect(self.save_and_next)

        self.btn_finish = QPushButton("Завершити")
        self.btn_finish.setObjectName("dangerBtn")
        self.btn_finish.clicked.connect(self.finish)
        self.btn_finish.setEnabled(False)

        btn_row = QHBoxLayout()
        btn_row.setSpacing(10)
        btn_row.addWidget(self.btn_back)
        btn_row.addStretch(1)
        btn_row.addWidget(self.btn_save_next)
        btn_row.addWidget(self.btn_finish)

     
        card = QFrame()
        card.setObjectName("card")
        card_layout = QVBoxLayout(card)
        card_layout.setSpacing(12)

        card_layout.addWidget(self.title)
        card_layout.addWidget(self.subtitle)
        card_layout.addSpacing(4)
        card_layout.addWidget(self.progress_text)
        card_layout.addWidget(self.progress)
        card_layout.addSpacing(6)
        card_layout.addWidget(self.question)
        card_layout.addWidget(self.input)
        card_layout.addLayout(file_row)
        card_layout.addLayout(btn_row)

        root = QVBoxLayout(self)
        root.setContentsMargins(16, 16, 16, 16)
        root.addWidget(card)

    def _apply_style(self):
      
        self.setStyleSheet("""
            QWidget {
                background: #0b1220;
                color: #e5e7eb;
                font-family: Segoe UI, Arial;
                font-size: 14px;
            }
            QFrame#card {
                background: #0f172a;
                border: 1px solid #22304a;
                border-radius: 14px;
                padding: 14px;
            }
            QLabel { background: transparent; }
            QLabel#title { font-size: 22px; font-weight: 800; color: #f8fafc; }
            QLabel#subtitle { color: #a7b0c0; }
            QLabel#progress { color: #94a3b8; font-size: 15px; }
            QLabel#question { font-size: 16px; font-weight: 700; color: #f1f5f9; padding-top: 4px; }
            QLabel#fileLabel { color: #cbd5e1; font-size: 12px; }

            QProgressBar {
                background: #111827;
                border: 1px solid #22304a;
                border-radius: 8px;
                height: 10px;
            }
            QProgressBar::chunk {
                background: #3b82f6;
                border-radius: 8px;
            }
            QLineEdit {
                background: #0b1220;
                border: 1px solid #22304a;
                border-radius: 10px;
                padding: 10px 12px;
                color: #e5e7eb;
            }
            QLineEdit:focus { border: 1px solid #60a5fa; }

            QPushButton {
                background: #2563eb;
                border: none;
                border-radius: 10px;
                padding: 10px 14px;
                font-weight: 700;
                color: #e5e7eb;
            }
            QPushButton:hover { background: #1d4ed8; }
            QPushButton:disabled { background: #24314b; color: #93a4bd; }

            QPushButton#secondaryBtn { background: #24314b; }
            QPushButton#secondaryBtn:hover { background: #2d3b58; }

            QPushButton#dangerBtn { background: #334155; }
            QPushButton#dangerBtn:hover { background: #3f516b; }
        """)

    def _update_file_label(self):
        full = f"Файл: {self.output_file}"
        fm = QFontMetrics(self.file_label.font())
        max_w = max(120, self.file_label.width() - 20)
        self.file_label.setText(fm.elidedText(full, Qt.TextElideMode.ElideMiddle, max_w))

    def resizeEvent(self, event):
        super().resizeEvent(event)
        self._update_file_label()

    def _load_question(self):
        self.question.setText(QUESTIONS[self.i])
        self.progress_text.setText(f"Питання {self.i + 1} з {len(QUESTIONS)}")
        self.progress.setValue(self.i)

        self.input.setText(self.answers[self.i])
        self.input.setFocus()
        self.input.selectAll()

        self.btn_back.setEnabled(self.i > 0)
        is_last = self.i == len(QUESTIONS) - 1
        self.btn_finish.setEnabled(is_last)
        self.btn_save_next.setText("Зберегти" if is_last else "Зберегти і далі ➜")

        self._update_file_label()

    def choose_file(self):
        path, _ = QFileDialog.getSaveFileName(
            self,
            "Оберіть файл для збереження",
            str(self.output_file),
            "Text files (*.txt);;All files (*.*)"
        )
        if path:
            self.output_file = Path(path)
            self._update_file_label()

    def _append_to_file(self, question: str, answer: str):
        self.output_file.parent.mkdir(parents=True, exist_ok=True)
        ts = datetime.now().strftime("%Y-%m-%d %H:%M:%S")
        with open(self.output_file, "a", encoding="utf-8") as f:
            f.write(f"[{ts}] {question}\nВідповідь: {answer}\n\n")

    def _require_answer(self) -> str | None:
        text = self.input.text().strip()
        if not text:
            QMessageBox.warning(self, "Помилка", "Відповідь не може бути порожньою.")
            return None
        return text

    def save_and_next(self):
        ans = self._require_answer()
        if ans is None:
            return

        self.answers[self.i] = ans

        try:
            self._append_to_file(QUESTIONS[self.i], ans)
        except Exception as e:
            QMessageBox.critical(self, "Помилка", f"Не вдалося записати у файл:\n{e}")
            return

        if self.i < len(QUESTIONS) - 1:
            self.i += 1
            self._load_question()
        else:
            # last question saved
            self.progress.setValue(len(QUESTIONS))
            QMessageBox.information(self, "Готово", f"Опитування завершено!\nФайл:\n{self.output_file}")

    def go_back(self):
        if self.i > 0:
            # збережемо введене, навіть якщо ще не натиснули “зберегти”
            self.answers[self.i] = self.input.text().strip()
            self.i -= 1
            self._load_question()

    def finish(self):
        ans = self._require_answer()
        if ans is None:
            return

        self.answers[self.i] = ans

        try:
            self._append_to_file(QUESTIONS[self.i], ans)
        except Exception as e:
            QMessageBox.critical(self, "Помилка", f"Не вдалося записати у файл:\n{e}")
            return

        self.progress.setValue(len(QUESTIONS))
        QMessageBox.information(self, "Завершено", f"Відповіді збережено у:\n{self.output_file}")
        self.close()

    def closeEvent(self, event):
     if self.i < len(QUESTIONS) - 1:

        msg = QMessageBox(self)
        msg.setWindowTitle("Вихід")
        msg.setText("Опитування ще не завершено. Вийти з програми?")

        btn_yes = msg.addButton("Так", QMessageBox.ButtonRole.YesRole)
        btn_no = msg.addButton("Ні", QMessageBox.ButtonRole.NoRole)

        msg.exec()

        if msg.clickedButton() == btn_no:
            event.ignore()
            return

     event.accept()


if __name__ == "__main__":
    app = QApplication(sys.argv)
    w = SurveyApp()
    w.resize(780, 380)
    w.show()
    sys.exit(app.exec())