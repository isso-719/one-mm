require 'bundler/setup'
Bundler.require
require 'sinatra/reloader' if development?
require 'faye/websocket'
require 'json'
# TODO: SpreadSheets API の使用
# require 'google/apis/sheets_v4'

# .env ファイルから環境変数を読み込む
Dotenv.load

set :server, 'puma'
set :bind, '0.0.0.0'
set :port, ENV['PORT'] || 8080
set :sockets, []

# 投票数
$bravo = 0      # ブラボーボタンの投票数
$not_bravo = 0  # Not ブラボーボタンの投票数

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
def send_counts
  settings.sockets.each do |s|
    s.send(
      {
        bravo: $bravo,
        not_bravo: $not_bravo
      }.to_json
    )
  end
end


# ブラボーボタン送信先
post '/api/bravo' do
  $bravo += 1
  send_counts

  status 200
end

# Not ブラボーボタン送信先
post '/api/not-bravo' do
  $not_bravo += 1
  send_counts

  status 200
end

# 運営リセットボタン送信先
post '/api/reset' do
  $bravo = 0
  $not_bravo = 0
  send_counts

  status 200
end

# ブラボーボタンの投票数を取得する WebSocket エンドポイント
get '/websocket/counts' do
  if Faye::WebSocket.websocket?(request.env)
    ws = Faye::WebSocket.new(request.env)

    ws.on :open do |event|
      settings.sockets << ws
      send_counts
    end

    ws.on :close do |event|
      settings.sockets.delete(ws)
    end

    ws.rack_response
  else
    status 400
  end
end