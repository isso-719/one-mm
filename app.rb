require 'bundler/setup'
Bundler.require
Dotenv.load
require 'sinatra/reloader' if development?
require 'json'
require 'uri'
require 'net/http'
require './src/datastore'

set :bind, '0.0.0.0'
set :port, ENV['PORT'] || 8080

datastore = DatastoreClient.new

# もし Datastore に Counts という名前のエンティティがなければ作成
if datastore.get_counts.nil?
  datastore.init_counts
end

# Basic 認証
helpers do
  def protect!
    unless authorized?
      response['WWW-Authenticate'] = %(Basic realm="Restricted Area")
      throw(:halt, [401, "Not authorized\n"])
    end
  end
  def authorized?
    @auth ||=  Rack::Auth::Basic::Request.new(request.env)
    # 本来であれば環境変数で管理だが、遊び用なのでベタ書きで良い
    username = "admin"
    password = "password"
    @auth.provided? && @auth.basic? && @auth.credentials && @auth.credentials == [username, password]
  end
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

# 運営用画面
get '/admin' do
  protect!
  erb :admin
end

# ブラボー数を Fetch するためのエンドポイント
get '/api/fetch' do
  content_type :json
  bravo_count, not_bravo_count = datastore.get_bravo_count_not_bravo_count
  { bravo: bravo_count, not_bravo: not_bravo_count }.to_json
end

# カウントを有効化するためのエンドポイント
post '/api/count-enable' do
  datastore.set_enabled(true)
  status 200
end

# カウントを無効化するためのエンドポイント
post '/api/count-disable' do
  datastore.set_enabled(false)
  status 200
end

# ブラボーボタン送信先
post '/api/bravo' do
  if datastore.get_enabled
    datastore.increment_count("bravo")
  end
  status 200
end

# Not ブラボーボタン送信先
post '/api/not-bravo' do
  if datastore.get_enabled
    datastore.increment_count("not_bravo")
  end
  status 200
end

# 運営リセットボタン送信先
post '/api/reset' do
  datastore.reset_counts
  status 200
end

# スプレッドシートに記録
post '/api/save' do
  mentor_name = params[:mentor_name]
  bravo_count, not_bravo_count = datastore.get_bravo_count_not_bravo_count
  count = bravo_count + not_bravo_count
  if count == 0
    count = 1
  end
  bravo_rate = bravo_count.to_f / count.to_f
  not_bravo_rate = not_bravo_count.to_f / count.to_f

  uri = URI(ENV['GOOGLE_APP_SCRIPT_DEPLOY_URL'])
  res = Net::HTTP.post_form(
    uri,
    {
      'service' => 'one-mm-save',
      'mentor_name' => mentor_name,
      'bravo_rate' => bravo_rate,
      'not_bravo_rate' => not_bravo_rate,
      'bravo_counts' => bravo_count,
      'not_bravo_counts' => not_bravo_count,
    },
  )

  if res.code != "200"
    status 500
  end

  status 200
end