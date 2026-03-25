function About() {
  return (
    <div className="card">
      <h1>Про застосунок</h1>
      <p>
        Даний застосунок реалізує парадигму Single Page Application.
        Він створений за допомогою React та React Router.
      </p>
      <p>
        Навігація між розділами виконується без повного перезавантаження сторінки,
        а відповіді користувача зберігаються у localStorage браузера.
      </p>
    </div>
  );
}

export default About;