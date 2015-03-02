[![Lines of Code](http://img.shields.io/badge/lines_of_code-46-brightgreen.svg?style=flat)](http://blog.codinghorror.com/the-best-code-is-no-code-at-all/)
[![Code Status](http://img.shields.io/codeclimate/github/hopsoft/queryable_hash.svg?style=flat)](https://codeclimate.com/github/hopsoft/queryable_hash)
[![Dependency Status](http://img.shields.io/gemnasium/hopsoft/queryable_hash.svg?style=flat)](https://gemnasium.com/hopsoft/queryable_hash)
[![Build Status](http://img.shields.io/travis/hopsoft/queryable_hash.svg?style=flat)](https://travis-ci.org/hopsoft/queryable_hash)
[![Coverage Status](https://img.shields.io/coveralls/hopsoft/queryable_hash.svg?style=flat)](https://coveralls.io/r/hopsoft/queryable_hash?branch=master)

# QueryableHash

Safely & easily find data in Hashes using dot notation queries.
_Works with string & symbol keys._

> We use QueryableHash to parse Ruby Hashes built from JSON API data.

## Examples

### Data to Query

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
queryable.find_first(
  "glossary.gloss_div.gloss_list.gloss_entry.id"
)

# "SGML"
```

### Find first using multiple queries

```ruby
queryable = QueryableHash.wrap(data)
queryable.find_first(
  "this.key.does.not.exist",
  "glossary.gloss_div.gloss_list.gloss_entry.id"
)

# "SGML"
```

### Find all matches

```ruby
queryable = QueryableHash.wrap(data)
queryable.find_all(
  "glossary.title",
  "glossary.gloss_div.gloss_list.gloss_entry.gloss_term",
  "glossary.gloss_div.gloss_list.gloss_entry.gloss_def.para"
)

# ["example glossary",
#  "Standard Generalized Markup Language",
#  "A meta-markup language, used to create markup languages such as DocBook."]
```

### Extract multiple values at once

```ruby
queryable = QueryableHash.wrap(data)
title, term, para = queryable.find_all(
  "glossary.title",
  "glossary.gloss_div.gloss_list.gloss_entry.gloss_term",
  "glossary.gloss_div.gloss_list.gloss_entry.gloss_def.para"
)

title # "example glossary",
term  # "Standard Generalized Markup Language"
param # "A meta-markup language, used to create markup languages such as DocBook."
```

### Find deeply nested missing key

```ruby
queryable = QueryableHash.wrap(data)
queryable.find_first(
  "this.key.does.not.exist"
)

# nil
```

### Assign a custom value to represent nil

```ruby
queryable = QueryableHash.wrap(data)
queryable.find_first(
  "this.key.does.not.exist",
  nil_value: "missing")
)

# "missing"
```
