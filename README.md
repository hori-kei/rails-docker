# 環境構築方法

このプロジェクトは、Docker を使用して Ruby on Rails アプリケーションを構築しています。以下の手順を実行して、開発環境をセットアップしてください。

---

## **前提条件**

Ruby,Rails,Postgresql のバージョンは以下とする：

- Ruby 3.2.2
- Rails 7.0.6
- Postgresql 12

---

## **環境構築手順**

### **1. プロジェクトテンプレートをクローン**

以下のコマンドを実行し、プロジェクトのテンプレートをクローンします：

```bash
git 任意のgithub上にあるリポジトリURL
```

---

### **2. 必要なファイルを作成**

クローンしたプロジェクトのディレクトリで、`Dockerfile` と `docker-compose.yml` を作成します：

```bash
cd rails7_docker_template
touch Dockerfile docker-compose.yml
```

---

### **3. `Dockerfile` の記述**

以下の内容を `Dockerfile` に記述します：

```dockerfile
FROM ruby:3.2.2

# 必要なパッケージをインストール
RUN apt-get update && apt-get install -y     build-essential     libpq-dev     nodejs     postgresql-client     yarn

# 作業ディレクトリを指定
WORKDIR /app

# アプリケーションコードをコンテナにコピー
COPY . .

# Bundler をインストール
RUN bundle install

# サーバーを起動
CMD ["rails", "server", "-b", "0.0.0.0"]
```

---

### **4. `docker-compose.yml` の記述**

以下の内容を `docker-compose.yml` に記述します：

```yaml
version: "3"

volumes:
  db-data:

services:
  web:
    build: .
    ports:
      - "3000:3000"
    volumes:
      - ".:/app" # ローカルディレクトリをコンテナの /app にマウント
    environment:
      - "DATABASE_PASSWORD=postgres"
    depends_on:
      - db

  db:
    image: postgres
    volumes:
      - "db-data:/var/lib/postgresql/data"
    environment:
      - "POSTGRES_USER=postgres"
      - "POSTGRES_PASSWORD=postgres"
```

---

### **5. データベースの作成**

#### **(1) コンテナを起動**

以下のコマンドを実行して Docker イメージをビルドし、バックグラウンドでコンテナを起動します：

```bash
docker-compose up -d
```

#### **(2) コンテナに入る**

以下のコマンドを実行して、`web` コンテナ内に入ります：

```bash
docker-compose exec web bash
```

#### **(3) データベースとテーブルを作成**

コンテナ内で以下のコマンドを実行してデータベースを作成します：

```bash
rails db:create
```

次に、マイグレーションを実行してテーブルを作成します：

```bash
rails db:migrate
```

---

### **6. コンテナの再起動とサーバーの確認**

#### **(1) コンテナから退出**

以下のコマンドでコンテナから退出します：

```bash
exit
```

#### **(2) コンテナとイメージを停止・削除**

以下のコマンドを実行してコンテナを停止し、削除します：

```bash
docker-compose down
```

#### **(3) コンテナを再ビルドして起動**

以下のコマンドを実行してコンテナを再度ビルドし、起動します：

```bash
docker-compose up --build
```

---

### **7. アプリケーションにアクセス**

ブラウザで以下の URL にアクセスし、Rails アプリケーションが起動していることを確認します：

```
http://localhost:3000
```

---

## **補足情報**

### **コンテナの操作**

- **コンテナの停止**

  ```bash
  docker-compose down
  ```

- **Rails コマンドの実行**
  コンテナ内で以下のようにコマンドを実行できます：
  ```bash
  docker-compose exec web rails <コマンド>
  ```

---
