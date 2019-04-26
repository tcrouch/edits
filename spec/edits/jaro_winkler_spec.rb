# frozen_string_literal: true

require "spec_helper"

RSpec.describe Edits::JaroWinkler do
  describe ".similarity" do
    subject { described_class.similarity(a, b).round(3) }

    [
      ["", "", 1],
      ["", "a", 0],
      ["a", "", 0],

      ["abc", "abc", 1],
      ["abc", "def", 0],
      ["abcvwxyz", "cabvwxyz", 0.958],
      ["dixon", "dicksonx", 0.813],
      ["dwayne", "duane", 0.84],
      ["information", "informant", 0.941],
      ["iota", "atom", 0.5],
      ["jones", "johnson", 0.832],
      ["martha", "marhta", 0.961],
      ["necessary", "nessecary", 0.941]
    ].each do |(a, b, expected)|
      context "with '#{a}', '#{b}'" do
        let(:a) { a }
        let(:b) { b }

        it { is_expected.to eq expected }
      end
    end

    context "with threshold 0.8" do
      subject { described_class.similarity(a, b, threshold: 0.8).round(3) }

      context "with 'dixon', 'dicksonx'" do
        let(:a) { "dixon" }
        let(:b) { "dicksonx" }

        it { is_expected.to eq 0.767 }
      end
    end

    context "with weight 0.2" do
      subject { described_class.similarity(a, b, weight: 0.2).round(3) }

      context "with 'dixon', 'dicksonx'" do
        let(:a) { "dixon" }
        let(:b) { "dicksonx" }

        it { is_expected.to eq 0.86 }
      end
    end
  end
end
