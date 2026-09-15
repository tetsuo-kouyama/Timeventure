require 'rails_helper'

RSpec.describe "Api::V1::Adventures", type: :request do
  describe "POST /create" do
    let!(:user) { create(:user) }
    let!(:character) { user.character }
    let!(:timer_setting) { user.timer_setting }
    let!(:start_area) { create(:area, name: "草原") }

    context "正常系" do
      before { login(user) }

      it "冒険の作成に成功する" do
        expect do
          post api_v1_adventures_path
        end.to change(Adventure, :count).by(1)
        expect(response).to have_http_status(:created)

        adventure = Adventure.last

        expect(adventure.character).to eq(character)
        expect(adventure.start_area).to eq(start_area)
        expect(adventure.planned_focus_minutes).to eq(timer_setting.focus_minutes)
        expect(adventure).to be_ongoing
        expect(adventure.started_at).to be_present
      end
    end

    context "異常系" do
      it "未認証では作成できない" do
        expect do
          post api_v1_adventures_path
        end.not_to change(Adventure, :count)
        expect(response).to have_http_status(:unauthorized)
      end
    end
  end

  describe "PATCH /complete" do
    let!(:user) { create(:user) }
    let!(:character) { user.character }
    let!(:start_area) { create(:area, name: "草原") }
    let!(:enemy) { create(:enemy) }
    let!(:adventure) {
      create(
        :adventure,
        character: character,
        start_area: start_area,
        started_at: 30.minutes.ago
      )
    }
    let!(:area_enemy) {
      create(
        :area_enemy,
        area: start_area,
        enemy: enemy
      )
    }

    context "正常系" do
      before { login(user) }

      it "冒険の完了に成功する" do
        patch complete_api_v1_adventure_path(adventure)

        expect(response).to have_http_status(:ok)

        adventure.reload

        expect(adventure.character).to eq(character)
        expect(adventure.start_area).to eq(start_area)
        expect(adventure).to be_completed
        expect(adventure.ended_at).to be_present
      end
    end

    context "異常系" do
      it "未認証では完了できない" do
        patch complete_api_v1_adventure_path(adventure)
        expect(response).to have_http_status(:unauthorized)

        # リロード後、既存の冒険に変更がないことを確認
        adventure.reload
        expect(adventure).to be_ongoing
        expect(adventure.ended_at).to be_nil
      end

      it "同じ complete で重複生成されない" do
        login(user)

        # 1回目の完了処理が正常に終了することを確認
        patch complete_api_v1_adventure_path(adventure)
        expect(response).to have_http_status(:ok)

        # 同じ冒険に対して2回目の完了処理を行う
        event_count = adventure.adventure_events.count
        patch complete_api_v1_adventure_path(adventure)

        # 完了処理が失敗し、イベント数が変更されていないことを確認
        expect(adventure.adventure_events.count).to eq(event_count)
        expect(response).to have_http_status(:unprocessable_content)
      end

      it "他ユーザーの Adventure を完了できない" do
        other_user = create(:user)
        other_adventure = create(
          :adventure,
          character: other_user.character,
          start_area: start_area,
          started_at: 30.minutes.ago
        )
        login(user)

        # 他ユーザーの冒険が見つからないことを確認
        patch complete_api_v1_adventure_path(other_adventure)
        expect(response).to have_http_status(:not_found)

        # リロード後、他ユーザーの冒険に変更がないことを確認
        other_adventure.reload
        expect(other_adventure).to be_ongoing
        expect(other_adventure.ended_at).to be_nil
      end
    end
  end

  describe "PATCH /interrupt" do
    let!(:user) { create(:user) }
    let!(:character) { user.character }
    let!(:start_area) { create(:area, name: "草原") }
    let!(:enemy) { create(:enemy) }
    let!(:adventure) {
      create(
        :adventure,
        character: character,
        start_area: start_area,
        started_at: 10.minutes.ago # 途中まで進める
      )
    }
    let!(:area_enemy) {
      create(
        :area_enemy,
        area: start_area,
        enemy: enemy
      )
    }

    context "正常系" do
      before { login(user) }

      it "冒険の中断に成功する" do
        patch interrupt_api_v1_adventure_path(adventure)

        expect(response).to have_http_status(:ok)

        adventure.reload

        expect(adventure).to be_interrupted
        expect(adventure.ended_at).to be_present
      end
    end

    context "異常系" do
      it "未認証では中断できない" do
        patch interrupt_api_v1_adventure_path(adventure)
        expect(response).to have_http_status(:unauthorized)

        # リロード後、既存の冒険に変更がないことを確認
        adventure.reload
        expect(adventure).to be_ongoing
        expect(adventure.ended_at).to be_nil
      end

      it "同じ interrupt で重複生成されない" do
        login(user)

        # 1回目の中断処理が正常に終了することを確認
        patch interrupt_api_v1_adventure_path(adventure)
        expect(response).to have_http_status(:ok)

        # 同じ冒険に対して2回目の中断処理を行う
        event_count = adventure.adventure_events.count
        patch interrupt_api_v1_adventure_path(adventure)

        # 中断処理が失敗し、イベント数が変更されていないことを確認
        expect(adventure.adventure_events.count).to eq(event_count)
        expect(response).to have_http_status(:unprocessable_content)
      end

      it "他ユーザーの Adventure を中断できない" do
        other_user = create(:user)
        other_adventure = create(
          :adventure,
          character: other_user.character,
          start_area: start_area,
          started_at: 10.minutes.ago
        )
        login(user)

        # 他ユーザーの冒険が見つからないことを確認
        patch interrupt_api_v1_adventure_path(other_adventure)
        expect(response).to have_http_status(:not_found)

        # リロード後、他ユーザーの冒険に変更がないことを確認
        other_adventure.reload
        expect(other_adventure).to be_ongoing
        expect(other_adventure.ended_at).to be_nil
      end
    end
  end
end
