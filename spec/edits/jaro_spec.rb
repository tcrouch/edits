# frozen_string_literal: true

require "spec_helper"

RSpec.describe Edits::Jaro do
  describe ".jaro_matches" do
    [
      ["", "", [0, 0]],
      ["", "a", [0, 0]],
      ["a", "", [0, 0]],

      ["abc", "abc", [3, 0]],
      ["abc", "def", [0, 0]],
      ["abcvwxyz", "cabvwxyz", [8, 1]],
      ["dixon", "dicksonx", [4, 0]],
      ["dwayne", "duane", [4, 0]],
      ["information", "informant", [9, 1]],
      ["iota", "atom", [2, 1]],
      ["jones", "johnson", [4, 0]],
      ["martha", "marhta", [6, 1]],
      ["necessary", "nessecary", [9, 2]]
    ].each do |(a, b, result)|
      context "with '#{a}', '#{b}'" do
        it "returns #{result.first} matches" do
          matches = Edits::Jaro.send(:jaro_matches, a, b).first
          expect(matches).to eq result.first
        end

        it "returns #{result.last} transposes" do
          transposes = Edits::Jaro.send(:jaro_matches, a, b).last
          expect(transposes).to eq result.last
        end
      end
    end
  end

  describe ".similarity" do
    subject { described_class.similarity(a, b).round(3) }

    [
      ["", "", 1],
      ["", "a", 0],
      ["a", "", 0],

      ["abc", "abc", 1],
      ["abc", "def", 0],
      ["abcvwxyz", "cabvwxyz", 0.958],
      ["dixon", "dicksonx", 0.767],
      ["dwayne", "duane", 0.822],
      ["information", "informant", 0.902],
      ["iota", "atom", 0.5],
      ["jones", "johnson", 0.790],
      ["martha", "marhta", 0.944],
      ["necessary", "nessecary", 0.926]
    ].each do |(a, b, expected)|
      context "with '#{a}', '#{b}'" do
        let(:a) { a }
        let(:b) { b }

        it { is_expected.to eq expected }
      end
    end
  end

  describe ".distance" do
    subject { described_class.distance(a, b).round(3) }

    describe "calculation" do
      subject { described_class.distance("foo", "bar").round(3) }

      before do
        allow(described_class).to receive(:similarity)
          .and_return(0.45)
      end

      it "returns 1 - similarity" do
        expect(subject).to eq(0.55)
      end
    end

    context "with 'information', 'informant'" do
      let(:a) { "information" }
      let(:b) { "informant" }

      it { is_expected.to eq(0.098) }
    end
  end
end
