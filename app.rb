require 'bundler/setup'
Bundler.require
Dotenv.load
require 'sinatra/reloader' if development?
require 'faye/websocket'
require 'json'
require './src/datastore'
# TODO: SpreadSheets API の使用
# require 'google/apis/sheets_v4'

set :server, 'puma'
set :bind, '0.0.0.0'
set :port, ENV['PORT'] || 8080
set :sockets, []

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

# WebSocket でメッセージを送信するためのメソッド
def send_counts(datastore)
  bravo_count, not_bravo_count = datastore.get_bravo_count_not_bravo_count
  settings.sockets.each do |s|
    s.send(
      {
        bravo: bravo_count,
        not_bravo: not_bravo_count,
      }.to_json
    )
  end
end


# ブラボーボタン送信先
post '/api/bravo' do
  datastore.increment_count("bravo")
  send_counts(datastore)
  status 200
end

# Not ブラボーボタン送信先
post '/api/not-bravo' do
  datastore.increment_count("not_bravo")
  send_counts(datastore)

  status 200
end

# 運営リセットボタン送信先
post '/api/reset' do
  datastore.reset_counts
  send_counts(datastore)

  status 200
end

# ブラボーボタンの投票数を取得する WebSocket エンドポイント
get '/websocket/counts' do
  if Faye::WebSocket.websocket?(request.env)
    ws = Faye::WebSocket.new(request.env)

    ws.on :open do |event|
      settings.sockets << ws
      send_counts(datastore)
    end

    ws.on :close do |event|
      settings.sockets.delete(ws)
    end

    ws.rack_response
  else
    status 400
  end
end