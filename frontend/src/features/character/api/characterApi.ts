import { apiFetch } from "@/lib/api";
import type { CharacterResponse } from "../types/character";

export async function getCharacter(): Promise<CharacterResponse> {
  const response = await apiFetch("/api/v1/character")

  if(!response.ok) {
    throw new Error("キャラクター情報の取得に失敗しました")
  }

  return response.json()
}
