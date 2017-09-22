# frozen_string_literal: true

RSpec.shared_examples "levenshtein" do
  [
    ["", "", 0],
    ["", "abc", 3],
    ["abc", "", 3],

    ["a", "a", 0],
    ["one", "one", 0],

    ["abc", "d", 3],
    ["bar", "foo", 3],
    ["d", "abc", 3],
    ["foo", "bar", 3],

    # insertion
    ["fog", "frog", 1],
    ["mitten", "mittens", 1],
    ["mitten", "smitten", 1],
    ["pit", "pint", 1],
    ["tom", "thom", 1],
    ["tom", "thomas", 3],

    # deletion
    ["frog", "fog", 1],
    ["mittens", "mitten", 1],
    ["pint", "pit", 1],
    ["smitten", "mitten", 1],
    ["thom", "tom", 1],
    ["thomas", "tom", 3],

    # substitution
    ["book", "back", 2],
    ["raked", "baker", 2],
    ["ran", "fan", 1],
    ["rat", "ran", 1],
    ["saturday", "caturday", 1],

    # multiple edits
    ["kitten", "sitting", 3],
    ["phish", "fish", 2],
    ["raked", "bakers", 3],
    ["sittings", "kitting", 2],
    ["sunday", "saturday", 3]
  ].each do |(a, b, distance)|
    context "with '#{a}', '#{b}'" do
      let(:a) { a }
      let(:b) { b }

      it { is_expected.to eq distance }
    end
  end
end
