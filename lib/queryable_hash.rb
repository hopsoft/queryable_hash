require_relative "queryable_hash/version"
require_relative "queryable_hash/not_found_error"
require_relative "queryable_hash/wrapper"

module QueryableHash
  def self.wrap(hash, **args)
    Wrapper.new hash, **args
  end
end
