# frozen_string_literal: true

require "spec_helper"
require "edits/levenshtein_shared"

RSpec.describe Edits::Levenshtein do
  cases = [
    # simple transpositions
    ["a cat", "an act", 3],
    ["abc", "acb", 2],
    ["abc", "bac", 2],
    ["abcdef", "abcdfe", 2],
    ["abcdefghij", "acbdegfhji", 6],
    ["acre", "acer", 2],
    ["art", "ran", 3],
    ["caned", "acned", 2],
    ["iota", "atom", 4],
    ["minion", "noir", 5],

    # complex transpositions
    ["a cat", "a tc", 3],
    ["a cat", "an abct", 4],
    ["acer", "earn", 4],
    ["craned", "read", 4],
    ["information", "informant", 4],
    ["raced", "dear", 5],
    ["roam", "art", 4],
    ["tram", "rota", 4]
  ]

  describe ".distance" do
    subject { described_class.distance a, b }

    include_examples "levenshtein"

    cases.each do |(a, b, distance)|
      context "with '#{a}', '#{b}'" do
        let(:a) { a }
        let(:b) { b }

        it { is_expected.to eq distance }
      end
    end
  end

  describe ".distance_with_max" do
    subject { described_class.distance_with_max a, b, max }

    context "when max is 100" do
      let(:max) { 100 }

      include_examples "levenshtein"

      cases.each do |(a, b, distance)|
        context "with '#{a}', '#{b}'" do
          let(:a) { a }
          let(:b) { b }

          it { is_expected.to eq distance }
        end
      end
    end

    context "when max is 4" do
      let(:max) { 4 }

      cases.each do |(a, b, distance)|
        context "with '#{a}', '#{b}'" do
          let(:a) { a }
          let(:b) { b }

          it { is_expected.to eq(distance > max ? max : distance) }
        end
      end

      context "with '', 'abcdfe'" do
        let(:a) { "" }
        let(:b) { "abcdfe" }

        it { is_expected.to eq max }
      end

      context "with 'abcdfe', ''" do
        let(:a) { "abcdfe" }
        let(:b) { "" }

        it { is_expected.to eq max }
      end
    end
  end

  describe ".most_similar" do
    let(:prototype) { "atom" }

    subject { described_class.most_similar prototype, words }

    context "with empty array" do
      let(:words) { [] }

      it { is_expected.to be_nil }
    end

    context "when a single word has the lowest distance" do
      let(:words) { %w[light at atlas beer iota train] }

      it "returns the word with lowest distance from prototype" do
        expect(subject).to eq "at"
      end
    end

    context "when two words share the lowest distance" do
      let(:words) { %w[light beer iota train] }

      it "returns the first with lowest distance from prototype" do
        expect(subject).to eq "beer"
      end
    end
  end
end
