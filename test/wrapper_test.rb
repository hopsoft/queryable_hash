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

    test "find_all" do
      query = "glossary.gloss_div.gloss_list.gloss_entry.id"
      assert @queryable.find_all(query) == ["SGML"]
    end

    test "find_all with multiple queries" do
      title, term, para = @queryable.find_all(
        "glossary.title",
        "glossary.gloss_div.gloss_list.gloss_entry.gloss_term",
        "glossary.gloss_div.gloss_list.gloss_entry.gloss_def.para"
      )
      assert title == "example glossary"
      assert term == "Standard Generalized Markup Language"
      assert para == "A meta-markup language, used to create markup languages such as DocBook."
    end

    test "find_first" do
      query = "glossary.gloss_div.gloss_list.gloss_entry.id"
      assert @queryable.find_first(query) == "SGML"
    end

    test "find_first with multiple queries" do
      result = @queryable.find_first(
        "glossary.title",
        "glossary.gloss_div.gloss_list.gloss_entry.gloss_term",
        "glossary.gloss_div.gloss_list.gloss_entry.gloss_def.para"
      )
      assert result == "example glossary"
    end

    test "find_first with missing key" do
      query = "this.key.does.not.exist"
      assert @queryable.find_first(query).nil?
    end

    test "find_first with missing key and nil value" do
      query = "nate.this.key.does.not.exist"
      assert @queryable.find_first(query, nil_value: "missing") == "missing"
    end

    test "find_first with multiple queries" do
      term = @queryable.find_first(
        "glossary.div.list.entry.term",
        "glossary.gloss_div.list.entry.term",
        "glossary.gloss_div.gloss_list.entry.term",
        "glossary.gloss_div.gloss_list.gloss_entry.term",
        "glossary.gloss_div.gloss_list.gloss_entry.gloss_term"
      )
      assert term == "Standard Generalized Markup Language"
    end

    test "to_hash" do
      assert @queryable.to_hash == @data
    end
  end
end
