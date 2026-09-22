require 'rails_helper'

RSpec.describe "Api::V1::TimerSessions", type: :request do
  describe "POST /api/v1/timer_sessions" do
    let!(:user) { create(:user) }

    context "正常系" do
      let!(:start_area) { create(:area, name: "草原") }

      before { login(user) }

      it "集中タイマーの作成に成功する" do
        expect do
          post api_v1_timer_sessions_path
        end.to change(TimerSession, :count).by(1)
        expect(response).to have_http_status(:created)
      end

      it "タイマー開始時の設定が保持される" do
        post api_v1_timer_sessions_path

        timer_session = user.timer_sessions.last

        expect(timer_session.user_id).to eq(user.id)
        expect(timer_session.focus_minutes).to eq(25)
        expect(timer_session.break_minutes).to eq(5)
        expect(timer_session).to be_focus
        expect(timer_session).to be_ongoing
        expect(timer_session.phase_started_at)
          .to be_within(1.second).of(Time.current)
        expect(timer_session.phase_ends_at)
          .to be_within(1.second)
          .of(timer_session.phase_started_at + timer_session.focus_minutes.minutes)
      end

      it "期限切れタイマーが存在する場合は新しいタイマーを作成できる" do
        expired_session = create(:timer_session, :expired, :with_adventure, user: user)
        enemy = create(:enemy)
        create(:area_enemy, area: start_area, enemy: enemy)

        expect do
          post api_v1_timer_sessions_path
        end.to change(TimerSession, :count).by(1)
        expect(response).to have_http_status(:created)

        # 既存のタイマーが終了していること
        expect(expired_session.reload).to be_completed

        # 新しいタイマーが実行中であること
        new_session = user.timer_sessions.order(:id).last

        expect(new_session).to be_ongoing
        expect(new_session).to be_focus
      end
    end

    context "異常系" do
      it "未認証では作成できない" do
        expect do
          post api_v1_timer_sessions_path
        end.not_to change(TimerSession, :count)
        expect(response).to have_http_status(:unauthorized)
      end

      it "集中中に新しいタイマーを作成できない" do
        create(:timer_session, user: user)
        login(user)

        expect do
          post api_v1_timer_sessions_path
        end.not_to change(TimerSession, :count)
        expect(response).to have_http_status(:conflict)
      end

      it "休憩中に新しいタイマーを作成できない" do
        create(:timer_session, :break, user: user)
        login(user)

        expect do
          post api_v1_timer_sessions_path
        end.not_to change(TimerSession, :count)
        expect(response).to have_http_status(:conflict)
      end
    end
  end

  describe "PATCH /api/v1/timer_sessions/:id/complete_focus" do
    let(:user) { create(:user) }

    context "正常系" do
      let!(:start_area) { create(:area, name: "草原") }

      before do
        enemy = create(:enemy)
        create(:area_enemy, area: start_area, enemy: enemy)
        login(user)
      end

      it "集中タイマーの完了に成功する" do
        expired_session = create(:timer_session, :expired, :with_adventure, user: user)

        patch complete_focus_api_v1_timer_session_path(expired_session.id)
        expect(response).to have_http_status(:ok)

        expired_session.reload

        expect(expired_session).to be_break
        expect(expired_session).to be_ongoing
        expect(expired_session.adventure.reload).to be_completed

        # 休憩開始時刻と冒険開始時刻が一致する
        expect(expired_session.phase_started_at)
          .to be_within(1.second)
          .of(expired_session.adventure.ended_at)

        # 休憩終了時刻と休憩開始時刻＋休憩時間が一致する
        expect(expired_session.phase_ends_at)
          .to be_within(1.second)
          .of(expired_session.phase_started_at + expired_session.break_minutes.minutes)
      end

      it "休憩時間が0分の場合はタイマーが完了する" do
        completed_timer_session = create(:timer_session, :expired, :with_adventure, user: user, break_minutes: 0)
        patch complete_focus_api_v1_timer_session_path(completed_timer_session.id)
        expect(response).to have_http_status(:ok)
        expect(completed_timer_session.reload).to be_focus
        expect(completed_timer_session).to be_completed
      end
    end

    context "異常系" do
      it "未認証では完了できない" do
        expired_session = create(:timer_session, :expired, user: user)
        patch complete_focus_api_v1_timer_session_path(expired_session.id)
        expect(response).to have_http_status(:unauthorized)
      end

      it "終了済みの集中タイマーは完了できない" do
        timer_session = create(:timer_session, :completed, user: user)
        login(user)
        patch complete_focus_api_v1_timer_session_path(timer_session.id)
        expect(response).to have_http_status(:unprocessable_content)
      end

      it "終了予定時刻前に完了できない" do
        timer_session = create(:timer_session, phase_started_at: Time.current, user: user)
        login(user)
        patch complete_focus_api_v1_timer_session_path(timer_session.id)
        expect(response).to have_http_status(:unprocessable_content)
      end

      it "他のユーザーの集中タイマーは完了できない" do
        other_user = create(:user)

        timer_session = create(:timer_session, :expired, user: other_user)
        login(user)

        patch complete_focus_api_v1_timer_session_path(timer_session.id)
        expect(response).to have_http_status(:not_found)
        expect(timer_session.reload).to be_ongoing
      end
    end
  end

  describe "PATCH /api/v1/timer_sessions/:id/interrupt" do
    let!(:user) { create(:user) }
    context "正常系" do
      let!(:start_area) { create(:area, name: "草原") }

      before do
        enemy = create(:enemy)
        create(:area_enemy, area: start_area, enemy: enemy)
        login(user)
      end

      it "集中タイマーの中断に成功する" do
        timer_session = create(:timer_session, :with_adventure, user: user)

        before_interrupt = Time.current
        patch interrupt_api_v1_timer_session_path(timer_session.id)
        after_interrupt = Time.current
        expect(response).to have_http_status(:ok)

        timer_session.reload

        expect(timer_session).to be_focus
        expect(timer_session).to be_interrupted
        expect(timer_session.adventure.reload).to be_interrupted

        # APIの呼び出しから終了までの間に冒険が中断されたことを確認
        expect(timer_session.adventure.ended_at).to be_between(before_interrupt, after_interrupt)
      end

      it "終了予定時刻を過ぎている場合は通常終了として扱う" do
        expired_session = create(:timer_session, :expired, :with_adventure, user: user)

        patch interrupt_api_v1_timer_session_path(expired_session.id)
        expect(response).to have_http_status(:ok)

        expired_session.reload

        expect(expired_session).to be_break
        expect(expired_session).to be_ongoing
        expect(expired_session.adventure.reload).to be_completed

        # 冒険終了時刻が休憩開始時刻と一致することを確認
        expect(expired_session.adventure.ended_at).to eq(expired_session.phase_started_at)
      end
    end

    context "異常系" do
      it "未認証では中断できない" do
        timer_session = create(:timer_session, user: user)
        patch interrupt_api_v1_timer_session_path(timer_session.id)
        expect(response).to have_http_status(:unauthorized)
      end

      it "完了済みの集中タイマーは中断できない" do
        completed_timer_session = create(:timer_session, :completed, user: user)
        login(user)
        patch interrupt_api_v1_timer_session_path(completed_timer_session.id)
        expect(response).to have_http_status(:unprocessable_content)
        expect(completed_timer_session.reload).to be_completed
      end

      it "中断済みの集中タイマーは中断できない" do
        interrupted_timer_session = create(:timer_session, :interrupted, user: user)
        login(user)
        patch interrupt_api_v1_timer_session_path(interrupted_timer_session.id)
        expect(response).to have_http_status(:unprocessable_content)
        expect(interrupted_timer_session.reload).to be_interrupted
      end

      it "休憩タイマーは中断できない" do
        break_timer_session = create(:timer_session, :break, user: user)
        login(user)
        patch interrupt_api_v1_timer_session_path(break_timer_session.id)
        expect(response).to have_http_status(:unprocessable_content)

        break_timer_session.reload

        expect(break_timer_session).to be_break
        expect(break_timer_session).to be_ongoing
      end

      it "他のユーザーの集中タイマーは中断できない" do
        other_user = create(:user)
        other_timer_session = create(:timer_session, user: other_user)
        login(user)
        patch interrupt_api_v1_timer_session_path(other_timer_session.id)
        expect(response).to have_http_status(:not_found)
        expect(other_timer_session.reload).to be_ongoing
      end
    end
  end

  describe "PATCH /api/v1/timer_sessions/:id/finish_break" do
    let!(:user) { create(:user) }

    context "正常系" do
      before { login(user) }

      it "休憩タイマーを手動終了できる" do
        break_timer_session = create(:timer_session, :break, user: user)
        patch finish_break_api_v1_timer_session_path(break_timer_session.id)
        expect(response).to have_http_status(:ok)
        expect(break_timer_session.reload).to be_break
        expect(break_timer_session).to be_completed
      end

      it "終了予定時刻を過ぎた休憩タイマーを終了できる" do
        break_expired_timer_session = create(:timer_session, :break_expired, user: user)
        patch finish_break_api_v1_timer_session_path(break_expired_timer_session.id)
        expect(response).to have_http_status(:ok)
        expect(break_expired_timer_session.reload).to be_break
        expect(break_expired_timer_session).to be_completed
      end
    end

    context "異常系" do
      it "未認証では休憩タイマーを終了できない" do
        break_timer_session = create(:timer_session, :break, user: user)
        patch finish_break_api_v1_timer_session_path(break_timer_session.id)
        expect(response).to have_http_status(:unauthorized)
      end

      it "存在しない休憩タイマーは終了できない" do
        login(user)
        patch finish_break_api_v1_timer_session_path(0)
        expect(response).to have_http_status(:not_found)
      end

      it "実行中の集中タイマーは終了できない" do
        focus_timer_session = create(:timer_session, user: user)
        login(user)
        patch finish_break_api_v1_timer_session_path(focus_timer_session.id)
        expect(response).to have_http_status(:unprocessable_content)
        expect(focus_timer_session.reload).to be_focus
        expect(focus_timer_session).to be_ongoing
      end

      it "完了済みの集中タイマーは終了できない" do
        completed_timer_session = create(:timer_session, :completed, user: user)
        login(user)
        patch finish_break_api_v1_timer_session_path(completed_timer_session.id)
        expect(response).to have_http_status(:unprocessable_content)
        expect(completed_timer_session.reload).to be_focus
        expect(completed_timer_session).to be_completed
      end

      it "中断済みの集中タイマーは終了できない" do
        interrupted_timer_session = create(:timer_session, :interrupted, user: user)
        login(user)
        patch finish_break_api_v1_timer_session_path(interrupted_timer_session.id)
        expect(response).to have_http_status(:unprocessable_content)
        expect(interrupted_timer_session.reload).to be_focus
        expect(interrupted_timer_session).to be_interrupted
      end

      it "完了済みの休憩タイマーは再度終了できない" do
        completed_break_timer_session = create(:timer_session, :break, :completed, user: user)
        login(user)
        patch finish_break_api_v1_timer_session_path(completed_break_timer_session.id)
        expect(response).to have_http_status(:unprocessable_content)
        expect(completed_break_timer_session.reload).to be_break
        expect(completed_break_timer_session).to be_completed
      end

      it "他のユーザーの休憩タイマーは終了できない" do
        other_user = create(:user)
        other_break_timer_session = create(:timer_session, :break, user: other_user)
        login(user)
        patch finish_break_api_v1_timer_session_path(other_break_timer_session.id)
        expect(response).to have_http_status(:not_found)
        expect(other_break_timer_session.reload).to be_break
        expect(other_break_timer_session).to be_ongoing
      end
    end
  end

  describe "GET /api/v1/timer_sessions/current" do
    let!(:user) { create(:user) }

    context "正常系" do
      before { login(user) }

      it "実行中のタイマーを取得できる" do
        focus_timer_session = create(:timer_session, user: user)
        get current_api_v1_timer_sessions_path
        expect(response).to have_http_status(:ok)

        json = response.parsed_body["timer_session"]

        expect(json["id"]).to eq(focus_timer_session.id)
        expect(json["phase"]).to eq("focus")
        expect(json["status"]).to eq("ongoing")
        expect(json["focus_minutes"]).to eq(focus_timer_session.focus_minutes)
        expect(json["break_minutes"]).to eq(focus_timer_session.break_minutes)
        expect(Time.iso8601(json["phase_started_at"]))
          .to be_within(0.001.second).of(focus_timer_session.phase_started_at)
        expect(Time.iso8601(json["phase_ends_at"]))
          .to be_within(0.001.second).of(focus_timer_session.phase_ends_at)
      end

      it "実行中の休憩タイマーを取得できる" do
        break_timer_session = create(:timer_session, :break, user: user)
        get current_api_v1_timer_sessions_path
        expect(response).to have_http_status(:ok)

        json = response.parsed_body["timer_session"]

        expect(json["id"]).to eq(break_timer_session.id)
        expect(json["phase"]).to eq("break")
        expect(json["status"]).to eq("ongoing")
        expect(Time.iso8601(json["phase_started_at"]))
          .to be_within(0.001.second).of(break_timer_session.phase_started_at)
        expect(Time.iso8601(json["phase_ends_at"]))
          .to be_within(0.001.second).of(break_timer_session.phase_ends_at)
      end

      it "実行中のタイマーが存在しない場合はnilを返す" do
        get current_api_v1_timer_sessions_path
        expect(response).to have_http_status(:ok)
        expect(response.parsed_body["timer_session"]).to be_nil
      end

      it "集中終了予定時刻を過ぎている場合は休憩へ移行する" do
        start_area = create(:area, name: "草原")
        enemy = create(:enemy)
        create(:area_enemy, area: start_area, enemy: enemy)
        focus_expired_timer_session = create(:timer_session, :focus_expired, :with_adventure, user: user)

        get current_api_v1_timer_sessions_path
        expect(response).to have_http_status(:ok)

        json = response.parsed_body["timer_session"]

        expect(json["id"]).to eq(focus_expired_timer_session.id)
        expect(json["phase"]).to eq("break")
        expect(json["status"]).to eq("ongoing")
      end

      it "休憩終了予定時刻を過ぎている場合はタイマーを完了する" do
        break_expired_timer_session = create(:timer_session, :break_expired, user: user)
        get current_api_v1_timer_sessions_path
        expect(response).to have_http_status(:ok)
        expect(response.parsed_body["timer_session"]).to be_nil
        expect(break_expired_timer_session.reload).to be_completed
      end

      it "休憩を手動終了した場合はnilを返す" do
        finish_timer_session = create(:timer_session, :break, user: user)
        patch finish_break_api_v1_timer_session_path(finish_timer_session.id)
        expect(response).to have_http_status(:ok)

        get current_api_v1_timer_sessions_path
        expect(response).to have_http_status(:ok)
        expect(response.parsed_body["timer_session"]).to be_nil
        expect(finish_timer_session.reload).to be_completed
      end

      it "中断済みのタイマーはnilを返す" do
        interrupted_timer_session = create(:timer_session, :interrupted, user: user)
        get current_api_v1_timer_sessions_path
        expect(response).to have_http_status(:ok)
        expect(response.parsed_body["timer_session"]).to be_nil
        expect(interrupted_timer_session.reload).to be_interrupted
      end

      it "休憩時間が0分の場合は集中終了後にnilを返す" do
        start_area = create(:area, name: "草原")
        enemy = create(:enemy)
        create(:area_enemy, area: start_area, enemy: enemy)
        create(:timer_session, :focus_expired, :with_adventure, user: user, break_minutes: 0)

        get current_api_v1_timer_sessions_path
        expect(response).to have_http_status(:ok)
        expect(response.parsed_body["timer_session"]).to be_nil
      end

      it "タイマー実行中に設定を変更しても開始時点の設定を返す" do
        timer_session = create(:timer_session, user: user, focus_minutes: 25, break_minutes: 5)
        user.timer_setting.update!(focus_minutes: 50, break_minutes: 10)

        get current_api_v1_timer_sessions_path
        expect(response).to have_http_status(:ok)

        json = response.parsed_body["timer_session"]

        expect(json["focus_minutes"]).to eq(25)
        expect(json["break_minutes"]).to eq(5)

        expect(Time.iso8601(json["phase_ends_at"]))
          .to be_within(0.001.second).of(timer_session.phase_ends_at)
      end
    end

    context "異常系" do
      it "未認証では取得できない" do
        unauthorized_timer_session = create(:timer_session, user: user)
        get current_api_v1_timer_sessions_path
        expect(response).to have_http_status(:unauthorized)
      end

      it "他のユーザーのタイマーを取得できない" do
        other_user = create(:user)
        other_timer_session = create(:timer_session, user: other_user)
        login(user)
        get current_api_v1_timer_sessions_path
        expect(response).to have_http_status(:ok)
        expect(response.parsed_body["timer_session"]).to be_nil
        expect(other_timer_session.reload).to be_ongoing
      end
    end
  end
end
