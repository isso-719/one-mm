# one-mm

Life is Tech! の卒業イベント 2023 で仕様するブラボーな Web アプリ。

## 動かし方

Docker-compose で動かす。インストールしてない場合は[ここ](https://qiita.com/isso_719/items/8b4dfc6f441cf52a88b2)を参照。

- 起動前準備

起動前に `./credentials` に Google サービスアカウントの Credentials JSON を配置する。

```bash
proj=google-cloud-project-id

# gcloud コマンドでサービスアカウントを作成
gcloud iam service-accounts create one-mm --project $proj

# サービスアカウントに Datastore の権限を付与
gcloud projects add-iam-policy-binding $proj --member serviceAccount:one-mm@$proj.iam.gserviceaccount.com --role roles/datastore.user

# サービスアカウントの Credentials JSON を ./credentials.json ダウンロード
gcloud iam service-accounts keys create ./credentials.json --iam-account one-mm@$proj.iam.gserviceaccount.com
```

`.env` ファイルを作成し、以下のように環境変数を設定します。

```bash
GOOGLE_APPLICATION_CREDENTIALS=./credentials.json
```

- 起動
```bash
make run
```

- Web ブラウザで確認
```bash
make open
```

- 停止
```bash
make stop
```

## デプロイ

- 本番環境は Cloud Run を想定し、gcloud コマンドを使用してデプロイします。

```bash
proj=google-cloud-project-id

gcloud auth login
gcloud config set project $proj

# Cloud Run と Cloud Build と Datastore を有効化
gcloud services enable run.googleapis.com cloudbuild.googleapis.com datastore.googleapis.com

make deploy
```