import { BrowserRouter, Routes, Route } from 'react-router-dom'
import Login from './pages/Login'
import AgendaDia from './pages/veterinario/AgendaDia'
import MeusPets from './pages/tutor/MeusPets'
import ProtectedRoute from './components/ProtectedRoute'

export default function App() {
  return (
    <BrowserRouter>
      <Routes>
        <Route path="/" element={<Login />} />
        <Route path="/vet/agenda" element={
          <ProtectedRoute role="VETERINARIO">
            <AgendaDia />
          </ProtectedRoute>
        } />
        <Route path="/tutor/pets" element={
          <ProtectedRoute role="TUTOR">
            <MeusPets />
          </ProtectedRoute>
        } />
      </Routes>
    </BrowserRouter>
  )
}