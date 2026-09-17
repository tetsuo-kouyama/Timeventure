class Api::V1::CharactersController < ApplicationController
  before_action :set_character, only: :show

  def show
    render json: {
      character: {
        name: @character.name,
        level: @character.level,
        gold: @character.gold,
        experience_points: @character.experience_points,
        hp: @character.hp,
        attack: @character.attack,
        defense: @character.defense,
        speed: @character.speed,
        luck: @character.luck
      }
    }, status: :ok
  end

  private

  def set_character
    @character = Current.user.character
  end
end
