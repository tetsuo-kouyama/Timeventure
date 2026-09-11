import { Link } from "react-router-dom"
import { PublicLayout } from "@/shared/components/PublicLayout"
import { LoginForm } from "../components/LoginForm"

export function LoginPage() {
  return (
    <PublicLayout>
      <div className="w-full max-w-md space-y-8">
        <div className="text-center">
          <h1 className="text-3xl font-bold">
            Timeventure
          </h1>

          <p className="mt-2 text-sm text-gray-500">
            ログインして冒険に戻ろう
          </p>
        </div>


        <LoginForm />

        <div className="text-center">
          <Link
		    to="/signup"
	        className="text-sm text-blue-600 hover:underline"
          >
  		  新規登録はこちら
          </Link>
	    	</div>
      </div>
    </PublicLayout>
  )
}
