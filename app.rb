require 'bundler/setup'
Bundler.require
Dotenv.load
require 'sinatra/reloader' if development?
require 'json'
require './src/datastore'
# TODO: SpreadSheets API の使用
# require 'google/apis/sheets_v4'

set :bind, '0.0.0.0'
set :port, ENV['PORT'] || 8080

datastore = DatastoreClient.new

# もし Datastore に Counts という名前のエンティティがなければ作成
if datastore.get_counts.nil?
  datastore.init_counts
end

# 全てのルートに CORS 対応
before do
  response.headers['Access-Control-Allow-Origin'] = '*'
end

# 投票画面
get '/' do
  erb :index
end

# リアルタイムに投票結果を表示する画面
get '/result' do
  erb :result
end

# ブラボー数を Fetch するためのエンドポイント
get '/api/fetch' do
  content_type :json
  bravo_count, not_bravo_count = datastore.get_bravo_count_not_bravo_count
  { bravo: bravo_count, not_bravo: not_bravo_count }.to_json
end

# ブラボーボタン送信先
post '/api/bravo' do
  datastore.increment_count("bravo")
  status 200
end

# Not ブラボーボタン送信先
post '/api/not-bravo' do
  datastore.increment_count("not_bravo")
  status 200
end

# 運営リセットボタン送信先
post '/api/reset' do
  datastore.reset_counts
  status 200
end