import { HomePage } from "./features/home/components/HomePage";
import { PublicHeader } from "./shared/components/PublicHeader";

function App() {
  return (
    <div className="flex min-h-screen flex-col">
      <PublicHeader />
      <HomePage />
    </div>
  )
}

export default App
