require "delegate"

module QueryableHash
  class Wrapper < SimpleDelegator

    def initialize(hash)
      @original_hash = hash
      super hash
    end

    def find(*queries, nil_value: nil)
      context = nil

      queries.each do |query|
        context = self
        query.split(".").each do |name|
          break if context.nil?
          context = context[name.to_sym] || context[name]
        end

        context = nil_value if context.nil? && query == queries.last
      end

      context
    end

    def to_hash
      @original_hash
    end

  end
end
