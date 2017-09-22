# frozen_string_literal: true

require "spec_helper"
require "edits/levenshtein_shared"

RSpec.describe Edits::RestrictedEdit do
  describe ".distance" do
    subject { described_class.distance a, b }

    include_examples "levenshtein"

    [
      # swaps
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
      ["a cat", "a tc", 3],
      ["a cat", "an abct", 4],
      ["acer", "earn", 4],
      ["craned", "read", 4],
      ["information", "informant", 4],
      ["raced", "dear", 5],
      ["roam", "art", 4],
      ["tram", "rota", 4]
    ].each do |(a, b, distance)|
      context "with '#{a}', '#{b}'" do
        let(:a) { a }
        let(:b) { b }

        it { is_expected.to eq distance }
      end
    end
  end
end
