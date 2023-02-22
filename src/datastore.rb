require "digest/sha2"
require 'google/cloud/datastore'


# Datastore のクライアントを作成
def datastore
  return Google::Cloud::Datastore.new(
    credentials: ENV["GOOGLE_APPLICATION_CREDENTIALS"] || "./credentials.json",
  )
end

# Datastore に Counts という名前のエンティティで bravo, not_bravo を保存
def init_counts(datastore)
  entity = datastore.entity "Counts" do |t|
    t["bravo"] = 0
    t["not_bravo"] = 0
  end
  datastore.save entity
end

# Datastore から Counts という名前のエンティティを取得
def get_counts(datastore)
  query = datastore.query("Counts")
  return datastore.run(query).first
end

# Datastore から Counts という名前のエンティティを取得して、その中の bravo, not_bravo を取得
def get_bravo_count_not_bravo_count(datastore)
  counts = get_counts(datastore)
  return counts["bravo"], counts["not_bravo"]
end

# Datastore から Counts という名前のエンティティを取得して、その中の key を取得。
def get_count(datastore, key)
  counts = get_counts(datastore)
  return counts[key]
end

# 指定されたキーの値を 1 増やして保存
def increment_count(datastore, key)
  counts = get_count(datastore, key)
  counts[key] += 1
  datastore.save counts
end

# Counts という名前のエンティティの bravo, not_bravo を 0 にする
def reset_counts()
  datastore.run(
    datastore.gql(
      "UPDATE Counts SET bravo = 0, not_bravo = 0"
    ), mode: :non_transactional
  )
end