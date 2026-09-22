require 'rails_helper'

RSpec.describe TimerSession, type: :model do
  describe "バリデーション" do
    describe "phase" do
      context "異常系" do
        it "定義されていない値を設定できない" do
          timer_session = build(:timer_session, phase: :undefined)

          expect(timer_session).to be_invalid
          expect(timer_session.errors[:phase]).to be_present
        end

        it "nil を設定できない" do
          timer_session = build(:timer_session, phase: nil)

          expect(timer_session).to be_invalid
          expect(timer_session.errors[:phase]).to be_present
        end
      end
    end

    describe "status" do
      context "異常系" do
        it "定義されていない値を設定できない" do
          timer_session = build(:timer_session, status: :undefined)

          expect(timer_session).to be_invalid
          expect(timer_session.errors[:status]).to be_present
        end

        it "nil を設定できない" do
          timer_session = build(:timer_session, status: nil)

          expect(timer_session).to be_invalid
          expect(timer_session.errors[:status]).to be_present
        end
      end
    end

    describe "focus_minutes" do
      context "正常系" do
        it "最小値の5分を設定できる" do
          timer_session = build(:timer_session, focus_minutes: 5)

          expect(timer_session).to be_valid
        end

        it "最大値の180分を設定できる" do
          timer_session = build(:timer_session, focus_minutes: 180)

          expect(timer_session).to be_valid
        end
      end

      context "異常系" do
        it "最小値未満は設定できない" do
          timer_session = build(:timer_session, focus_minutes: 0)

          expect(timer_session).to be_invalid
          expect(timer_session.errors[:focus_minutes]).to be_present
        end

        it "最大値を超える値は設定できない" do
          timer_session = build(:timer_session, focus_minutes: 185)

          expect(timer_session).to be_invalid
          expect(timer_session.errors[:focus_minutes]).to be_present
        end

        it "5分単位以外は設定できない" do
          timer_session = build(:timer_session, focus_minutes: 6)

          expect(timer_session).to be_invalid
          expect(timer_session.errors[:focus_minutes]).to be_present
        end

        it "少数は設定出来ない" do
          timer_session = build(:timer_session, focus_minutes: 25.5)

          expect(timer_session).to be_invalid
          expect(timer_session.errors[:focus_minutes]).to be_present
        end

        it "未入力で設定できない" do
          timer_session = build(
            :timer_session,
            focus_minutes: nil,
            # factory 内で nil に対して minutes を呼び出さないようにテスト側で指定する
            phase_ends_at: Time.current + 25.minutes
          )

          expect(timer_session).to be_invalid
          expect(timer_session.errors[:focus_minutes]).to be_present
        end
      end
    end

    describe "break_minutes" do
      context "正常系" do
        it "最小値の0を設定できる" do
          timer_session = build(:timer_session, break_minutes: 0)

          expect(timer_session).to be_valid
        end

        it "最大値の180を設定できる" do
          timer_session = build(:timer_session, break_minutes: 180)

          expect(timer_session).to be_valid
        end
      end

      context "異常系" do
        it "最小値未満は設定できない" do
          timer_session = build(:timer_session, break_minutes: -5)

          expect(timer_session).to be_invalid
          expect(timer_session.errors[:break_minutes]).to be_present
        end

        it "最大値を超える値は設定できない" do
          timer_session = build(:timer_session, break_minutes: 185)

          expect(timer_session).to be_invalid
          expect(timer_session.errors[:break_minutes]).to be_present
        end

        it "5分単位以外は設定できない" do
          timer_session = build(:timer_session, break_minutes: 6)

          expect(timer_session).to be_invalid
          expect(timer_session.errors[:break_minutes]).to be_present
        end

        it "少数は設定出来ない" do
          timer_session = build(:timer_session, break_minutes: 5.5)

          expect(timer_session).to be_invalid
          expect(timer_session.errors[:break_minutes]).to be_present
        end

        it "未入力で設定できない" do
          timer_session = build(:timer_session, break_minutes: nil)

          expect(timer_session).to be_invalid
          expect(timer_session.errors[:break_minutes]).to be_present
        end
      end
    end

    describe "phase_started_at" do
      context "正常系" do
        it "開始時刻を設定できる" do
          timer_session = build(:timer_session, phase_started_at: Time.current)

          expect(timer_session).to be_valid
        end
      end

      context "異常系" do
        it "未入力で設定できない" do
          timer_session = build(
            :timer_session,
            phase_started_at: nil,
            # factory 内で nil に対して + を呼び出さないようにテスト側で指定する
            phase_ends_at: Time.current + 25.minutes
          )

          expect(timer_session).to be_invalid
          expect(timer_session.errors[:phase_started_at]).to be_present
        end
      end
    end

    describe "phase_ends_at" do
      context "正常系" do
        it "終了予定時刻を設定できる" do
          started_at = Time.current
          timer_session = build(
            :timer_session,
            phase_started_at: started_at,
            phase_ends_at: started_at + 25.minutes
          )

          expect(timer_session).to be_valid
        end
      end

      context "異常系" do
        it "未入力で設定できない" do
          timer_session = build(:timer_session, phase_ends_at: nil)

          expect(timer_session).to be_invalid
          expect(timer_session.errors[:phase_ends_at]).to be_present
        end

        it "終了予定時刻は開始時刻より前に設定できない" do
          started_at = Time.current
          timer_session = build(
            :timer_session,
            phase_started_at: started_at,
            phase_ends_at: started_at - 1.second
          )

          expect(timer_session).to be_invalid
          expect(timer_session.errors[:phase_ends_at]).to be_present
        end

        it "終了予定時刻は開始時刻と同じ時刻に設定できない" do
          started_at = Time.current
          timer_session = build(
            :timer_session,
            phase_started_at: started_at,
            phase_ends_at: started_at
          )

          expect(timer_session).to be_invalid
          expect(timer_session.errors[:phase_ends_at]).to be_present
        end
      end
    end
  end
end
