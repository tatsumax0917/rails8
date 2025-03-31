
# selenium を使うための設定を追加します。
# url の host は docker-compose.yml の service 名です。# （http://service名:4444)
# Capybara.server_host はデフォルトだと 127.0.0.1 ですが、それだと接続が上手くいきません。
# 環境変数 HOSTNAME の値を指定してあげると上手く接続できるようになります。
# docker で hostname とコマンドを打つと出力される

require "test_helper"

class ApplicationSystemTestCase < ActionDispatch::SystemTestCase
  driven_by :selenium, using: :headless_chrome, screen_size: [1400, 1400], options: {
    browser: :remote,
    url: 'http://selenium:4444',
  }

  Capybara.server_host = ENV.fetch('HOSTNAME')
end

