function Results() {
  const questions = [
    "Як вас звати?",
    "Скільки вам років?",
    "Яка ваша улюблена мова програмування?",
    "Який ваш улюблений предмет?",
    "Яку технологію ви хотіли б вивчити?"
  ];

  const answers = JSON.parse(localStorage.getItem("surveyAnswers")) || [];

  const clearResults = () => {
    localStorage.removeItem("surveyAnswers");
    window.location.reload();
  };

  return (
    <div className="card">
      <h1>Результати опитування</h1>

      {answers.length === 0 ? (
        <p>Ще немає збережених відповідей.</p>
      ) : (
        <ul className="answers-list">
          {questions.map((question, index) => (
            <li key={index}>
              <strong>{question}</strong>
              <br />
              <span>{answers[index] || "Немає відповіді"}</span>
            </li>
          ))}
        </ul>
      )}

      <button onClick={clearResults}>Очистити результати</button>
    </div>
  );
}

export default Results;