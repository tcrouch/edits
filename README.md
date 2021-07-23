# Edits

[![Gem](https://img.shields.io/gem/v/edits)](https://rubygems.org/gems/edits)
[![Travis (.com)](https://img.shields.io/travis/com/tcrouch/edits)](https://travis-ci.com/github/tcrouch/edits)
[![Inline docs](http://inch-ci.org/github/tcrouch/edits.svg?branch=master)](https://inch-ci.org/github/tcrouch/edits)
[![Yard Docs](https://img.shields.io/badge/yard-docs-informational)](https://rubydoc.info/github/tcrouch/edits)

A collection of edit distance algorithms in Ruby.

Includes Levenshtein, Restricted Edit (Optimal Alignment) and
Damerau-Levenshtein distances, and Jaro and Jaro-Winkler similarity.

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'edits'
```

And then execute:

```console
$ bundle
```

Or install it yourself as:

```console
$ gem install edits
```

## Usage

### Levenshtein variants

Calculate the edit distance between two sequences with variants of the
Levenshtein distance algorithm.

```ruby
Edits::Levenshtein.distance "raked", "bakers"
# => 3
Edits::RestrictedEdit.distance "iota", "atom"
# => 3
Edits::DamerauLevenshtein.distance "acer", "earn"
# => 3
```

- **Levenshtein** edit distance, counting insertion, deletion and
  substitution.
- **Restricted Damerau-Levenshtein** edit distance (aka **Optimal Alignment**),
  counting insertion, deletion, substitution and transposition
  (adjacent symbols swapped). Restricted by the condition that no substring is
  edited more than once.
- **Damerau-Levenshtein** edit distance, counting insertion, deletion,
  substitution and transposition (adjacent symbols swapped).

|                      | Levenshtein | Restricted Damerau-Levenshtein | Damerau-Levenshtein |
|----------------------|-------------|--------------------------------|---------------------|
| "raked" vs. "bakers" | 3           | 3                              | 3                   |
| "iota" vs. "atom"    | 4           | 3                              | 3                   |
| "acer" vs. "earn"    | 4           | 4                              | 3                   |

Levenshtein and Restricted Edit distances also have a bounded version.


```ruby
# Max distance
Edits::Levenshtein.distance_with_max "fghijk", "abcde", 3
# => 3
```

The convenience method `most_similar` searches for the best match to a
given sequence from a collection. It is similar to using `min_by`, but leverages
a maximum bound.

```ruby
Edits::RestrictedEdit.most_similar "atom", ["iota", "tome", "mown", "tame"]
# => "tome"
```

### Jaro & Jaro-Winkler

Calculate the Jaro and Jaro-Winkler similarity/distance of two sequences.

```ruby
Edits::Jaro.similarity "information", "informant"
# => 0.90235690235690236
Edits::Jaro.distance "information", "informant"
# => 0.097643097643097643

Edits::JaroWinkler.similarity "information", "informant"
# => 0.94141414141414137
Edits::JaroWinkler.distance "information", "informant"
# => 0.05858585858585863
```

### Hamming

Calculate the hamming distance between two sequences.

```ruby
Edits::Hamming.distance("explorer", "exploded")
# => 2
```

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake spec` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/tcrouch/edits.

## License

The gem is available as open source under the terms of the [MIT License](http://opensource.org/licenses/MIT).
