import { useState } from "react";
import "./index.css";

function App() {
  const questions = [
    "Як вас звати?",
    "Скільки вам років?",
    "Яка ваша улюблена мова програмування?",
    "Який ваш улюблений предмет?",
    "Яку технологію ви хотіли б вивчити?"
  ];

  const [currentQuestionIndex, setCurrentQuestionIndex] = useState(0);
  const [currentAnswer, setCurrentAnswer] = useState("");
  const [answers, setAnswers] = useState([]);
  const [isCompleted, setIsCompleted] = useState(false);

  const progress = ((currentQuestionIndex) / questions.length) * 100;

  const handleNext = () => {
    const trimmedAnswer = currentAnswer.trim();

    if (!trimmedAnswer) {
      alert("Будь ласка, введіть відповідь.");
      return;
    }

    const updatedAnswers = [
      ...answers,
      {
        question: questions[currentQuestionIndex],
        answer: trimmedAnswer
      }
    ];

    setAnswers(updatedAnswers);
    setCurrentAnswer("");

    if (currentQuestionIndex < questions.length - 1) {
      setCurrentQuestionIndex(currentQuestionIndex + 1);
    } else {
      localStorage.setItem("surveyAnswers", JSON.stringify(updatedAnswers));
      setIsCompleted(true);
    }
  };

  const handleRestart = () => {
    setCurrentQuestionIndex(0);
    setCurrentAnswer("");
    setAnswers([]);
    setIsCompleted(false);
    localStorage.removeItem("surveyAnswers");
  };

  return (
    <div className="app">
      <div className="card">
        <h1>Форма опитування</h1>

        {!isCompleted ? (
          <>
            <div className="progress-info">
              Питання {currentQuestionIndex + 1} з {questions.length}
            </div>

            <div className="progress-bar">
              <div
                className="progress-fill"
                style={{
                  width: `${((currentQuestionIndex + 1 - 1) / questions.length) * 100}%`
                }}
              ></div>
            </div>

            <p className="question">{questions[currentQuestionIndex]}</p>

            <input
              type="text"
              placeholder="Введіть вашу відповідь"
              value={currentAnswer}
              onChange={(e) => setCurrentAnswer(e.target.value)}
            />

            <button onClick={handleNext}>
              {currentQuestionIndex === questions.length - 1 ? "Завершити" : "Далі"}
            </button>
          </>
        ) : (
          <>
            <div className="success-box">
              <h2>Опитування завершено</h2>
              <p>Ваші відповіді успішно збережено.</p>
            </div>

            <div className="answers-block">
              <h3>Ваші відповіді:</h3>
              <ul className="answers-list">
                {answers.map((item, index) => (
                  <li key={index}>
                    <strong>{item.question}</strong>
                    <br />
                    <span>{item.answer}</span>
                  </li>
                ))}
              </ul>
            </div>

            <button onClick={handleRestart}>Пройти знову</button>
          </>
        )}
      </div>
    </div>
  );
}

export default App;