#!/bin/bash

# エラーが発生した場合にスクリプトを即座に停止
set -e

# ================================
#     サーバーPIDファイルの調整
# ================================
# 既存のサーバーPIDファイルがあれば削除します。
echo "既存のサーバーPIDファイルを削除します..."
rm -f /app/tmp/pids/server.pid


# ================================
#     実行環境によって設定を分岐
# ================================
if [ "$RAILS_ENV" = "development" ]; then
    echo "Development環境で起動中..."
elif [ "$RAILS_ENV" = "production" ]; then
    echo "Production環境で起動中..."
    # 古いアセットをクリーンアップする
    # echo "古いアセットをクリーンアップ中..."
    # bundle exec rake assets:clobber
    # 本番環境用にアセットをプリコンパイル
    echo "アセットをプリコンパイル中..."
    bundle exec rake assets:precompile
    # 古いアセットをクリーンアップする
    # echo "古いアセットクリーンアップ中..."
    # bundle exec rake assets:clean
else
    echo "未知の環境: $RAILS_ENV"
    exit 1
fi

# ================================
#     データベースの生成
# ================================
# データベースがなければ作成、既に存在してたらなにもしない
if ! bundle exec rake db:version >/dev/null 2>&1; then
    echo "データベースが存在しなかったので作成中..."
    bundle exec rake db:create
fi

# ================================
#     マイグレーション実行 
# ================================
echo "マイグレーション中..."
bundle exec rake db:migrate

# Dockerfileで指定されたCMDコマンドを実行します。
exec "$@"