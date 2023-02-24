require "digest/sha2"
require 'google/cloud/datastore'

class DatastoreClient
  def initialize
    @datastore = Google::Cloud::Datastore.new(
      credentials: ENV["GOOGLE_APPLICATION_CREDENTIALS"],
    )
  end

  def init_counts
    entity = @datastore.entity "Counts" do |t|
      t["is_enabled"] = false
      t["bravo"] = 0
      t["not_bravo"] = 0
    end
    @datastore.save entity
  end

  def get_enabled
    query = @datastore.query("Counts")
    return @datastore.run(query).first["is_enabled"]
  end

  def set_enabled(enabled)
    counts = get_counts
    counts["is_enabled"] = enabled
    @datastore.save counts
  end

  def get_counts
    query = @datastore.query("Counts")
    return @datastore.run(query).first
  end

  def get_bravo_count_not_bravo_count
    counts = get_counts
    return counts["bravo"], counts["not_bravo"]
  end

  def get_count(key)
    counts = get_counts
    return counts[key]
  end

  def increment_count(key)
    counts = get_counts
    counts[key] += 1
    @datastore.save counts
  end

  def reset_counts
    counts = get_counts
    counts["bravo"] = 0
    counts["not_bravo"] = 0
    @datastore.save counts
  end
end