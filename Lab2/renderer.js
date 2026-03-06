const questions = [
  "Як вас звати?",
  "Скільки вам років?",
  "З якого ви міста?",
  "Яка ваша улюблена мова програмування?",
  "Який ваш улюблений предмет?"
];

let index = 0;
let answers = [];

const questionDiv = document.getElementById("question");
const answerInput = document.getElementById("answer");
const errorDiv = document.getElementById("error");

const nextBtn = document.getElementById("nextBtn");
const saveBtn = document.getElementById("saveBtn");

function setError(msg) {
  errorDiv.textContent = msg || "";
}

function showQuestion() {
  questionDiv.textContent = questions[index];
  answerInput.value = "";
  answerInput.disabled = false;
  answerInput.style.display = "block";
  setError("");             
  answerInput.focus();
}

function finishSurvey() {
  questionDiv.textContent = "Опитування завершено!";
  answerInput.value = "";
  answerInput.disabled = true;
  answerInput.style.display = "none";
  nextBtn.style.display = "none";
  setError("");
  saveBtn.disabled = false;
}

function nextStep() {
  const text = answerInput.value.trim();

  if (text === "") {
    setError("Введіть відповідь!");
    answerInput.focus();
    return;
  }

  setError("");

  answers.push({
    question: questions[index],
    answer: text
  });

  index++;

  if (index < questions.length) showQuestion();
  else finishSurvey();
}

nextBtn.addEventListener("click", (e) => {
  e.preventDefault();
  nextStep();
});


answerInput.addEventListener("keydown", (e) => {
  if (e.key === "Enter") {
    e.preventDefault();
    nextStep();
  }
});

saveBtn.addEventListener("click", async () => {
  const filePath = await window.api.saveFile(answers);
  alert("Файл збережено на робочому столі:\n" + filePath);
});


answerInput.addEventListener("input", () => {
  if (errorDiv.textContent) setError("");
});

showQuestion();