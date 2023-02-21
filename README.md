# one-mm

Life is Tech! の卒業イベント 2023 で仕様するブラボーな Web アプリ。

## 動かし方

Docker-compose で動かす。インストールしてない場合は[ここ](https://qiita.com/isso_719/items/8b4dfc6f441cf52a88b2)を参照。

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

make deploy
```