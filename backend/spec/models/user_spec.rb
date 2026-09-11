require "rails_helper"

RSpec.describe User, type: :model do
  describe "validations" do
    context "必須項目が入力されている場合" do
      it "ユーザーを保存できる" do
        user = build(:user)

        expect(user.save).to be true
        expect(user).to be_persisted
      end
    end

    context "メールアドレスが空の場合" do
      it "バリデーションエラーになる" do
        user = build(:user, email_address: nil)

        expect(user).to be_invalid
        expect(user.errors[:email_address]).to be_present
      end
    end

        context "メールアドレスのフォーマットが正しい場合" do
      it "有効になる" do
        user = build(:user, email_address: "user@example.com")

        expect(user).to be_valid
      end
    end

    context "メールアドレスのフォーマットが不正な場合" do
      it "バリデーションエラーになる" do
        user = build(:user, email_address: "invalid-email")

        expect(user).to be_invalid
        expect(user.errors[:email_address]).to be_present
      end
    end

    context "メールアドレスが重複している場合" do
      it "バリデーションエラーになる" do
        existing_user = create(:user)
        user = build(:user, email_address: existing_user.email_address)

        expect(user).to be_invalid
        expect(user.errors[:email_address]).to be_present
      end
    end

    context "パスワードが空の場合" do
      it "バリデーションエラーになる" do
        user = build(:user, password: nil, password_confirmation: nil)

        expect(user).to be_invalid
        expect(user.errors[:password]).to be_present
      end
    end

    context "パスワードが5文字の場合" do
      it "バリデーションエラーになる" do
        user = build(:user, password: "a" * 5, password_confirmation: "a" * 5)

        expect(user).to be_invalid
        expect(user.errors[:password]).to be_present
      end
    end

    context "パスワードが6文字の場合" do
      it "有効になる" do
        user = build(:user, password: "a" * 6, password_confirmation: "a" * 6)

        expect(user).to be_valid
      end
    end
  end
end
