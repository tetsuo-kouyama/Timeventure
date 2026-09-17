import { Link } from "react-router-dom"
import { SignupForm } from "../components/SignupForm";
import { PublicLayout } from "@/shared/components/PublicLayout";

export function SignupPage() {
  return (
    <PublicLayout>
      <div className="w-full max-w-md space-y-8">
        <div className="text-center">
          <h1 className="text-3xl font-bold">
            Timeventure
          </h1>

          <p className="mt-2 text-sm text-gray-500">
            アカウントを作成して冒険を始めよう
          </p>
        </div>

        <SignupForm />

        <div className="text-center">
          <Link
            to="/login"
            className="text-sm text-blue-600 hover:underline"
          >
            ログインはこちら
          </Link>
        </div>
      </div>
    </PublicLayout>
  )
}
