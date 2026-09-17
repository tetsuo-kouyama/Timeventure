// character 型の定義
export type Character = {
  name: string
  level: number
  gold: number
  experience_points: number
  hp: number
  attack: number
  defense: number
  speed: number
  luck: number
}

export type CharacterResponse = {
  character: Character
}
