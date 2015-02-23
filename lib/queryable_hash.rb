require_relative "queryable_hash/version"
require_relative "queryable_hash/wrapper"

module QueryableHash
  def self.wrap(hash)
    Wrapper.new hash
  end
end
