import { SignupForm } from "../components/SignupForm";

export function SignupPage() {
  return (
    <main className="flex min-h-screen items-center justify-center px-4">
      <div className="w-full max-w-md space-y-8">
        <div className="text-center">
          <h1 className="text-3xl font-bold">Timeventure</h1>

          <p className="mt-2 text-sm text-gray-500">
            アカウントを作成して冒険を始めよう
          </p>
        </div>

        <SignupForm />
      </div>
    </main>
  )
}
