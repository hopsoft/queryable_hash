[![Lines of Code](http://img.shields.io/badge/lines_of_code-50-brightgreen.svg?style=flat)](http://blog.codinghorror.com/the-best-code-is-no-code-at-all/)
[![Code Status](http://img.shields.io/codeclimate/github/hopsoft/queryable_hash.svg?style=flat)](https://codeclimate.com/github/hopsoft/queryable_hash)
[![Dependency Status](http://img.shields.io/gemnasium/hopsoft/queryable_hash.svg?style=flat)](https://gemnasium.com/hopsoft/queryable_hash)
[![Build Status](http://img.shields.io/travis/hopsoft/queryable_hash.svg?style=flat)](https://travis-ci.org/hopsoft/queryable_hash)
[![Coverage Status](https://img.shields.io/coveralls/hopsoft/queryable_hash.svg?style=flat)](https://coveralls.io/r/hopsoft/queryable_hash?branch=master)

# QueryableHash

Find data in Hashes using dot notation queries.

> We use QueryableHash to parse Ruby Hashes built from JSON API data.
> It works especially well when the target data is erratic.

## Examples

### Data to query

```ruby
data = {
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
```

### Find first match

```ruby
queryable = QueryableHash.wrap(data)
queryable.get("glossary.gloss_div.gloss_list.gloss_entry.id") #=> "SGML"
```

### Find first match using multiple queries

```ruby
queryable = QueryableHash.wrap(data)
queryable.get("this.key.does.not.exist", "glossary.gloss_div.gloss_list.gloss_entry.id") #=> "SGML"
```

### Find all matches

```ruby
queryable = QueryableHash.wrap(data)
queryable.get_all(
  "glossary.title",
  "glossary.gloss_div.gloss_list.gloss_entry.gloss_term",
  "glossary.gloss_div.gloss_list.gloss_entry.gloss_def.para"
)
#=> [ "example glossary",
#     "Standard Generalized Markup Language",
#     "A meta-markup language, used to create markup languages such as DocBook." ]

# or assign the results

title, term, para = queryable.get_all(
  "glossary.title",
  "glossary.gloss_div.gloss_list.gloss_entry.gloss_term",
  "glossary.gloss_div.gloss_list.gloss_entry.gloss_def.para"
)
title #=> "example glossary",
term  #=> "Standard Generalized Markup Language"
param #=> "A meta-markup language, used to create markup languages such as DocBook."
```

### Find deeply nested missing key

```ruby
queryable = QueryableHash.wrap(data)
queryable.get("this.key.does.not.exist") #=> nil
```

### Assign a custom value to represent nil

```ruby
queryable = QueryableHash.wrap(data)
queryable.get("this.key.does.not.exist", nil_value: "missing") #=> "missing"
```

### Raise an error when not found

```ruby
queryable = QueryableHash.wrap(data)
queryable.get("this.key.does.not.exist", raise_when_nil: true) #=> raises QueryableHash::NotFoundError
```

### Set query options on the instance

```ruby
queryable = QueryableHash.wrap(data, nil_value: "missing")
queryable.get("this.key.does.not.exist")      #=> "missing"
queryable.get("neither.does.this.one")        #=> "missing"
queryable.get("nor.this.one", nil_value: nil) #=> nil
```

```ruby
queryable = QueryableHash.wrap(data, raise_when_nil: true)
queryable.get("this.key.does.not.exist")             #=> raises QueryableHash::NotFoundError
queryable.get("neither.does.this.one")               #=> raises QueryableHash::NotFoundError
queryable.get("nor.this.one", raise_when_nil: false) #=> nil
```

---

Also check out: [https://github.com/joshbuddy/jsonpath](https://github.com/joshbuddy/jsonpath)
