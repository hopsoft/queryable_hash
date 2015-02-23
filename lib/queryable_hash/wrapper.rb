require "delegate"

module QueryableHash
  class Wrapper < SimpleDelegator

    def initialize(hash)
      @original_hash = hash
      super hash
    end

    def find(*queries, nil_value: nil)
      results = queries.reduce([]) do |memo, query|
        context = self
        query.split(".").each do |name|
          break if context.nil?
          context = context[name.to_sym] || context[name]
        end
        memo << context
      end

      return results.first if queries.length == 1
      results
    end

    def to_hash
      @original_hash
    end

  end
end
