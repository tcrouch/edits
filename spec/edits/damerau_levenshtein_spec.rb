# frozen_string_literal: true

require "spec_helper"
require "edits/levenshtein_shared"

RSpec.describe Edits::DamerauLevenshtein do
  describe ".distance" do
    subject { described_class.distance a, b }

    include_examples "levenshtein"

    [
      # simple transpositions
      ["a cat", "an act", 2],
      ["abc", "acb", 1],
      ["abc", "bac", 1],
      ["abcdef", "abcdfe", 1],
      ["abcdefghij", "acbdegfhji", 3],
      ["acre", "acer", 1],
      ["art", "ran", 2],
      ["caned", "acned", 1],
      ["iota", "atom", 3],
      ["minion", "noir", 4],

      # complex transpositions
      ["a cat", "a tc", 2],
      ["acer", "earn", 3],
      ["craned", "read", 3],
      ["information", "informant", 3],
      ["raced", "dear", 4],
      ["roam", "art", 3],
      ["tram", "rota", 3]
    ].each do |(a, b, distance)|
      context "with '#{a}', '#{b}'" do
        let(:a) { a }
        let(:b) { b }

        it { is_expected.to eq distance }
      end
    end
  end
end
