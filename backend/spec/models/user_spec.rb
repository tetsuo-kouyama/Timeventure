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

    context "パスワードが空の場合" do
      it "バリデーションエラーになる" do
        user = build(:user, password: nil, password_confirmation: nil)

        expect(user).to be_invalid
        expect(user.errors[:password]).to be_present
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
  end
end
