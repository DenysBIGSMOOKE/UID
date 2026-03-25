import { Link } from "react-router-dom";

function Home() {
  return (
    <div className="card">
      <h1>Лабораторна робота 6</h1>
      <h2>Single Page Application</h2>
      <p>
        Це односторінковий web-застосунок для проходження опитування.
        Навігація між розділами відбувається без перезавантаження сторінки.
      </p>

      <Link to="/survey" className="link-button">
        Почати опитування
      </Link>
    </div>
  );
}

export default Home;