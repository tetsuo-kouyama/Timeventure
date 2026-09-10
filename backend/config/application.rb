require_relative "boot"

require "rails/all"

# Gemfile に記述された Gem を環境（development, test, production）に合わせて読み込み
Bundler.require(*Rails.groups)

module App
  class Application < Rails::Application
    # Rails 8.1 のデフォルト設定を読み込み
    config.load_defaults 8.1

    # lib ディレクトリ配下の自動読み込み設定（assets や tasks は除外）
    config.autoload_lib(ignore: %w[assets tasks])

    # タイムゾーンを日本時間に設定
    config.time_zone = "Tokyo"

    # API モード（View やセッション等の不要なミドルウェアをスキップ）
    config.api_only = true

    # APIモードではCookie middlewareが標準で省かれるため追加
    config.middleware.use ActionDispatch::Cookies

    # ジェネレーター設定
    config.generators do |g|
      g.test_framework :rspec,
        view_specs: false,       # View のスペックを生成しない
        helper_specs: false,     # Helper のスペックを生成しない
        routing_specs: false,    # Routing のスペックを生成しない
        request_specs: true

      # テストデータ作成ツールとして Factory Bot を使用
      g.fixture_replacement :factory_bot, dir: "spec/factories"
    end
  end
end
