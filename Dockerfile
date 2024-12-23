FROM ruby:3.2.2

# 必要なパッケージをインストール
RUN apt-get update && apt-get install -y \
    build-essential \
    libpq-dev \
    nodejs \
    postgresql-client \
    yarn

# 作業ディレクトリを指定
WORKDIR /app

# アプリケーションコードをコンテナにコピー
COPY . .

# Bundler をインストール
RUN bundle install

# サーバーを起動
CMD ["rails", "server", "-b", "0.0.0.0"]