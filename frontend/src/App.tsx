import { Route, Routes } from "react-router-dom"
import { HomePage } from "./features/home/components/HomePage";
import { PublicHeader } from "./shared/components/PublicHeader";
import { SignupPage } from "./features/auth/pages/SignupPage";
import { DashboardPage } from "./features/dashboard/pages/DashboardPage";

function App() {
  return (
    <Routes>
      <Route
        path="/"
        element={
          <div className="flex min-h-screen flex-col">
            <PublicHeader />
            <HomePage />
          </div>
        }
      />

      <Route path="/signup" element={<SignupPage />} />
      <Route path="/dashboard" element={<DashboardPage />} />
    </Routes>
  )
}

export default App
