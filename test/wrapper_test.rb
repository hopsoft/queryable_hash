require_relative "test_helper"

module QueryableHash
  class QueryableHashTest < PryTest::Test
    before do
      @data = {
        glossary: {
          title: "example glossary",
          gloss_div: {
            title: "S",
            gloss_list: {
              gloss_entry: {
                id: "SGML",
                sort_as: "SGML",
                gloss_term: "Standard Generalized Markup Language",
                acronym: "SGML",
                abbrev: "ISO 8879:1986",
                gloss_def: {
                  para: "A meta-markup language, used to create markup languages such as DocBook.",
                  gloss_see_also: ["GML", "XML"]
                },
                gloss_see: "markup"
              }
            }
          }
        }
      }
      @queryable = QueryableHash.wrap(@data)
    end

    test "get_all" do
      query = "glossary.gloss_div.gloss_list.gloss_entry.id"
      assert @queryable.get_all(query) == ["SGML"]
    end

    test "get_all with multiple queries" do
      title, term, para = @queryable.get_all(
        "glossary.title",
        "glossary.gloss_div.gloss_list.gloss_entry.gloss_term",
        "glossary.gloss_div.gloss_list.gloss_entry.gloss_def.para"
      )
      assert title == "example glossary"
      assert term == "Standard Generalized Markup Language"
      assert para == "A meta-markup language, used to create markup languages such as DocBook."
    end

    test "get" do
      query = "glossary.gloss_div.gloss_list.gloss_entry.id"
      assert @queryable.get(query) == "SGML"
    end

    test "get with multiple queries" do
      result = @queryable.get(
        "glossary.title",
        "glossary.gloss_div.gloss_list.gloss_entry.gloss_term",
        "glossary.gloss_div.gloss_list.gloss_entry.gloss_def.para"
      )
      assert result == "example glossary"
    end

    test "get with missing key" do
      query = "this.key.does.not.exist"
      assert @queryable.get(query).nil?
    end

    test "get with missing key and nil_value" do
      query = "nate.this.key.does.not.exist"
      assert @queryable.get(query, nil_value: "missing") == "missing"
    end

    test "get with missing key and nil_value set by instance" do
      query = "nate.this.key.does.not.exist"
      queryable = QueryableHash.wrap(@data, nil_value: "missing")
      assert queryable.get(query) == "missing"
    end

    test "get with multiple queries some invalid" do
      term = @queryable.get(
        "glossary.div.list.entry.term",
        "glossary.gloss_div.list.entry.term",
        "glossary.gloss_div.gloss_list.entry.term",
        "glossary.gloss_div.gloss_list.gloss_entry.term",
        "glossary.gloss_div.gloss_list.gloss_entry.gloss_term"
      )
      assert term == "Standard Generalized Markup Language"
    end

    test "get with raise_when_nil" do
      query = "nate.this.key.does.not.exist"
      begin
        @queryable.get(query, raise_when_nil: true)
      rescue NotFoundError => e
      end

      assert e
    end

    test "get with raise_when_nil set by instance" do
      query = "nate.this.key.does.not.exist"
      begin
        queryable = QueryableHash.wrap(@data, raise_when_nil: true)
        queryable.get(query)
      rescue NotFoundError => e
      end
      assert e
    end

    test "to_hash" do
      assert @queryable.to_hash == @data
    end
  end
end
