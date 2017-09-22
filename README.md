# Edits

A collection of edit distance algorithms in Ruby.

Includes Levenshtein, Restricted Edit (Optimal Alignment) and Damerau-Levenshtein distances, and Jaro and Jaro-Winkler similarity.

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'edits'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install edits

## Usage

### Levenshtein

Edit distance, accounting for deletion, addition and substitution.

```ruby
Edits::Levenshtein.distance "raked", "bakers"
# => 3
Edits::Levenshtein.distance "iota", "atom"
# => 4
Edits::Levenshtein.distance "acer", "earn"
# => 4

# Max distance
Edits::Levenshtein.distance_with_max "iota", "atom", 2
# => 2
Edits::Levenshtein.most_similar "atom", %w[tram atlas rota racer]
# => "atlas"
```

### Restricted Edit (Optimal Alignment)

Edit distance, accounting for deletion, addition, substitution and swapped
characters.

```ruby
Edits::RestrictedEdit.distance "raked", "bakers"
# => 3
Edits::RestrictedEdit.distance "iota", "atom"
# => 3
Edits::RestrictedEdit.distance "acer", "earn"
# => 4
```

### Damerau-Levenshtein

Edit distance, accounting for deletions, additions, substitution and
transposition.

```ruby
Edits::DamerauLevenshtein.distance "raked", "bakers"
# => 3
Edits::DamerauLevenshtein.distance "iota", "atom"
# => 3
Edits::DamerauLevenshtein.distance "acer", "earn"
# => 3
```

### Jaro & Jaro-Winkler

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

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake spec` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/tcrouch/edits.

## License

The gem is available as open source under the terms of the [MIT License](http://opensource.org/licenses/MIT).
