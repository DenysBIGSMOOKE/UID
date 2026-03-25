import { Routes, Route, NavLink } from "react-router-dom";
import Home from "./pages/Home";
import Survey from "./pages/Survey";
import Results from "./pages/Results";
import About from "./pages/About";

function App() {
  return (
    <div className="app-shell">
      <nav className="navbar">
        <h2>Survey SPA</h2>
        <div className="nav-links">
          <NavLink to="/">Головна</NavLink>
          <NavLink to="/survey">Опитування</NavLink>
          <NavLink to="/results">Результати</NavLink>
          <NavLink to="/about">Про застосунок</NavLink>
        </div>
      </nav>

      <main className="page-container">
        <Routes>
          <Route path="/" element={<Home />} />
          <Route path="/survey" element={<Survey />} />
          <Route path="/results" element={<Results />} />
          <Route path="/about" element={<About />} />
        </Routes>
      </main>
    </div>
  );
}

export default App;