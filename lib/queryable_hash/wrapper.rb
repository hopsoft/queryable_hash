require "delegate"

module QueryableHash
  class Wrapper < SimpleDelegator

    def initialize(hash)
      @original_hash = hash
      super hash
    end

    def find_all(*queries, nil_value: nil)
      queries.reduce([]) do |memo, query|
        context = self
        query.split(".").each do |name|
          break if context.nil?
          context = context[name.to_sym] || context[name]
        end
        memo << (context || nil_value)
      end
    end

    def find_first(*queries, nil_value: nil, raise_when_nil: false)
      first = find_all(*queries, nil_value: nil_value).find do |result|
        result != nil_value
      end
      first ||= nil_value

      raise NotFoundError if raise_when_nil && first == nil_value
      first
    end

    alias_method :find, :find_first

    def to_hash
      @original_hash
    end

  end
end
