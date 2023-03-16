# one-mm

Life is Tech! の卒業イベント 2023 で仕様するブラボーな Web アプリ。

## 動かし方

Docker-compose で動かす。インストールしてない場合は[ここ](https://qiita.com/isso_719/items/8b4dfc6f441cf52a88b2)を参照。

- 起動前準備

まず、本 Web アプリケーションは [Datastore モードの Cloud Firestore](https://console.cloud.google.com/datastore) を使用するため、有効にする。

次に `./credentials` に Google Cloud サービスアカウントの Credentials JSON を配置する。

```bash
proj=google-cloud-project-id

gcloud auth login
gcloud config set project $proj

# gcloud コマンドでサービスアカウントを作成
gcloud iam service-accounts create one-mm --project $proj

# サービスアカウントに Datastore の権限を付与
gcloud projects add-iam-policy-binding $proj --member serviceAccount:one-mm@$proj.iam.gserviceaccount.com --role roles/datastore.user

# サービスアカウントの Credentials JSON を ./credentials.json ダウンロード
gcloud iam service-accounts keys create ./credentials.json --iam-account one-mm@$proj.iam.gserviceaccount.com
```

`.env` ファイルを作成し、以下のように環境変数を設定する。

```bash
GOOGLE_APPLICATION_CREDENTIALS=./credentials.json
```

また、スプレッドシートに記録する機能は SpreadSheet および Google Apps Script を使用しているため、以下の手順を行う必要がある。

1. スプレッドシートを作成する
2. スプレッドシートのシート名を `1mm結果` にする
3. スプレッドシートのスクリプトエディタを開く
4. スクリプトエディタに `gas/one-mm.gs` の内容をコピペする
5. デプロイを行う
   1. [デプロイ] > [新しいデプロイ]を選択
   2. 種類を [ウェブアプリ] に設定
   3. 次のユーザーとしてアプリを実行: [自分] を選択
   4. アクセスできるユーザー: [全員] を選択
   5. [デプロイ] を選択
   6. 初回のみ、許可のためのポップアップが表示されます
   7. ウェブアプリの URL が表示されるので、コピーしておく
6. `.env` ファイルに以下のように環境変数を設定する
```bash
GOOGLE_APP_SCRIPT_DEPLOY_URL=https://script.google.com/macros/s/xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx/exec
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

- 本番環境は Cloud Run を想定し、gcloud コマンドを使用してデプロイする。

```bash
proj=google-cloud-project-id

gcloud auth login
gcloud config set project $proj

# Cloud Run と Cloud Build を有効化
gcloud services enable run.googleapis.com cloudbuild.googleapis.com

# Cloud Run にスプレッドシート記録用の URL を設定
google_app_script_deploy_url=https://script.google.com/macros/s/xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx/exec

make deploy GOOGLE_APP_SCRIPT_DEPLOY_URL=$google_app_script_deploy_url 
```