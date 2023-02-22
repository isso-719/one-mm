require "digest/sha2"
require 'json'

BASE_URI = ENV["REALTIME_DATABASE_URI"]
PRIVATE_KEY = ENV["GOOGLE_APPLICATION_CREDENTIALS"] || "./credentials.json"
PRIVARE_KEY_JSON_STRING = File.open(PRIVATE_KEY).read

def init_counts(firebase)
  firebase.set("Counts", {
    bravo: 0,
    not_bravo: 0,
  })
end

def get_body(firebase)
  return firebase.get("Counts").body
end

def get_counts(firebase)
  body = get_body(firebase)
  return body.nil? ? nil : body.to_hash
end

def get_bravo_count_not_bravo_count(firebase)
  counts = get_counts(firebase)
  return counts["bravo"], counts["not_bravo"]
end

def increment_count(firebase, key)
  counts = get_counts(firebase)
  counts[key] += 1
  firebase.set("Counts", counts)
end