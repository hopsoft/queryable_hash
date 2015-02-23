require_relative "test_helper"

module QueryableHash
  class QueryableHashTest < PryTest::Test
    test "query" do
      hash = { foo: { "bar" => { baz: true } } }
      queryable = QueryableHash::wrap(hash)
      assert queryable.find("foo.bar.baz") == true
    end

    test "to_hash" do
      hash = { foo: { bar: { baz: true } } }
      queryable = QueryableHash.wrap(hash)
      assert queryable.to_hash == hash
    end
  end
end
