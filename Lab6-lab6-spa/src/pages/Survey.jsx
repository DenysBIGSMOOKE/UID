import { useState, useEffect } from "react";
import { useNavigate } from "react-router-dom";

function Survey() {
  const questions = [
    "Як вас звати?",
    "Скільки вам років?",
    "Яка ваша улюблена мова програмування?",
    "Який ваш улюблений предмет?",
    "Яку технологію ви хотіли б вивчити?"
  ];

  const navigate = useNavigate();

  const [currentQuestionIndex, setCurrentQuestionIndex] = useState(0);
  const [currentAnswer, setCurrentAnswer] = useState("");
  const [answers, setAnswers] = useState(Array(questions.length).fill(""));

  useEffect(() => {
    const savedAnswers = JSON.parse(localStorage.getItem("surveyAnswers"));
    if (savedAnswers && Array.isArray(savedAnswers) && savedAnswers.length === questions.length) {
      setAnswers(savedAnswers);
    }
  }, []);

  useEffect(() => {
    setCurrentAnswer(answers[currentQuestionIndex] || "");
  }, [currentQuestionIndex, answers]);

  const progress = ((currentQuestionIndex + 1) / questions.length) * 100;

  const saveCurrentAnswer = () => {
    const updated = [...answers];
    updated[currentQuestionIndex] = currentAnswer.trim();
    setAnswers(updated);
    localStorage.setItem("surveyAnswers", JSON.stringify(updated));
    return updated;
  };

  const handleNext = () => {
    if (!currentAnswer.trim()) {
      alert("Будь ласка, введіть відповідь.");
      return;
    }

    saveCurrentAnswer();

    if (currentQuestionIndex < questions.length - 1) {
      setCurrentQuestionIndex(currentQuestionIndex + 1);
    } else {
      navigate("/results");
    }
  };

  const handleBack = () => {
    saveCurrentAnswer();
    if (currentQuestionIndex > 0) {
      setCurrentQuestionIndex(currentQuestionIndex - 1);
    }
  };

  return (
    <div className="card">
      <h1>Форма опитування</h1>

      <div className="progress-info">
        Питання {currentQuestionIndex + 1} з {questions.length}
      </div>

      <div className="progress-bar">
        <div className="progress-fill" style={{ width: `${progress}%` }}></div>
      </div>

      <p className="question">{questions[currentQuestionIndex]}</p>

      <input
        type="text"
        placeholder="Введіть вашу відповідь"
        value={currentAnswer}
        onChange={(e) => setCurrentAnswer(e.target.value)}
      />

      <div className="button-row">
        <button onClick={handleBack} disabled={currentQuestionIndex === 0}>
          Назад
        </button>

        <button onClick={handleNext}>
          {currentQuestionIndex === questions.length - 1 ? "Завершити" : "Далі"}
        </button>
      </div>
    </div>
  );
}

export default Survey;