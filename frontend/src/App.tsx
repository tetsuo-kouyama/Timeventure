import { Route, Routes } from "react-router-dom"
import { AppLayout } from "./shared/layouts/AppLayout";
import { ProtectedRoute } from "./features/auth/components/ProtectedRoute";
import { HomePage } from "./features/home/components/HomePage";
import { PublicHeader } from "./shared/components/PublicHeader";
import { SignupPage } from "./features/auth/pages/SignupPage";
import { LoginPage } from "./features/auth/pages/LoginPage";
import { DashboardPage } from "./features/dashboard/pages/DashboardPage";
import { TimerSettingsPage } from "./features/timer/pages/TimerSettingsPage";

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
      <Route path="/login" element={<LoginPage />} />

      <Route element={<ProtectedRoute />}>
        <Route element={<AppLayout />}>
          <Route path="/dashboard" element={<DashboardPage />} />
          <Route path="/timer-setting" element={<TimerSettingsPage />} />
        </Route>
      </Route>
    </Routes>
  )
}

export default App
