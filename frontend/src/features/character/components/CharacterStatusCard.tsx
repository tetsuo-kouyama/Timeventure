import {
  Card,
  CardContent,
  CardHeader,
  CardTitle,
} from "@/components/ui/card"
import type { Character } from "../types/character"

type Props = {
  character: Character
}

export function CharacterStatusCard({ character }: Props) {
  return (
    <Card>
      <CardHeader>
        <CardTitle>キャラクター</CardTitle>
      </CardHeader>

      <CardContent>
        <p>名前: {character.name}</p>
        <p>レベル: {character.level}</p>
        <p>経験値: {character.experience_points}</p>
        <p>ゴールド: {character.gold}G</p>
        <p>HP: {character.hp}</p>
        <p>攻撃力: {character.attack}</p>
        <p>防御力: {character.defense}</p>
        <p>素早さ: {character.speed}</p>
        <p>運: {character.luck}</p>
      </CardContent>
    </Card>
  )
}
