require "delegate"

module QueryableHash
  class Wrapper < SimpleDelegator
    attr_reader :nil_value, :raise_when_nil

    def initialize(hash, nil_value: nil, raise_when_nil: false)
      @original_hash = hash
      @nil_value = nil_value
      @raise_when_nil = raise_when_nil
      super hash
    end

    def get_all(*queries, nil_value: nil)
      queries.reduce([]) do |memo, query|
        context = self
        query.split(".").each do |name|
          break if context.nil?
          context = context[name.to_sym] || context[name]
        end
        memo << (context || nil_value)
      end
    end

    def get(*queries, nil_value: nil, raise_when_nil: nil)
      nil_value = @nil_value if nil_value.nil?
      raise_when_nil = @raise_when_nil if raise_when_nil.nil?

      first = get_all(*queries, nil_value: nil_value).find do |result|
        result != nil_value
      end
      first ||= nil_value

      raise NotFoundError.new("#{queries.join(", ")} not found") if raise_when_nil && first == nil_value
      first
    end

    def to_hash
      @original_hash
    end

  end
end
