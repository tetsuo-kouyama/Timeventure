// 冒険に関するRails APIとの通信処理をまとめるファイル

import { apiFetch } from "@/lib/api"

import type {
  CreateAdventureResponse,
  AdventureResultResponse,
  CurrentAdventureResponse,
} from "../types/adventure"

// 冒険開始時の処理
export async function createAdventure(): Promise<CreateAdventureResponse> {
  const response = await apiFetch("/api/v1/adventures", {
    method: "POST",
  })

  if (!response.ok) {
    throw new Error("冒険の開始に失敗しました")
  }

  return response.json()
}

// 冒険完了時の処理
export async function completeAdventure(
  adventureId: number
): Promise<AdventureResultResponse> {
  const response = await apiFetch(
    `/api/v1/adventures/${adventureId}/complete`,
    {
      method: "PATCH",
    }
  )

  if (!response.ok) {
    throw new Error("冒険の完了に失敗しました")
  }

  return response.json()
}

// 冒険中断時の処理
export async function interruptAdventure(
  adventureId: number
): Promise<AdventureResultResponse> {
  const response = await apiFetch(
    `/api/v1/adventures/${adventureId}/interrupt`,
    {
      method: "PATCH",
    }
  )

  if (!response.ok) {
    throw new Error("冒険の中断に失敗しました")
  }

  return response.json()
}

// current Adventure を取得する関数
export async function getCurrentAdventure(): 
  Promise<CurrentAdventureResponse | null> {
    const response = await apiFetch("/api/v1/adventures/current", {
    credentials: "include",
  })

  if (response.status === 204) {
    return null
  }

  if (!response.ok) {
    throw new Error("進行中の冒険の取得に失敗しました")
  }

  return response.json()
}
