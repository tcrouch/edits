# frozen_string_literal: true

require "spec_helper"

RSpec.describe Edits::Jaro do
  describe ".jaro_matches" do
    {
      ["", ""] => [0, 0],
      ["", "a"] => [0, 0],
      ["a", ""] => [0, 0],

      %w[abc abc] => [3, 0],
      %w[abc def] => [0, 0],
      %w[abcvwxyz cabvwxyz] => [8, 1],
      %w[dixon dicksonx] => [4, 0],
      %w[dwayne duane] => [4, 0],
      %w[information informant] => [9, 1],
      %w[iota atom] => [2, 1],
      %w[jones johnson] => [4, 0],
      %w[martha marhta] => [6, 1],
      %w[necessary nessecary] => [9, 2]
    }.each do |(a, b), result|
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

    {
      ["", ""] => 1,
      ["", "a"] => 0,
      ["a", ""] => 0,

      %w[abc abc] => 1,
      %w[abc def] => 0,
      %w[abcvwxyz cabvwxyz] => 0.958,
      %w[dixon dicksonx] => 0.767,
      %w[dwayne duane] => 0.822,
      %w[information informant] => 0.902,
      %w[iota atom] => 0.5,
      %w[jones johnson] => 0.790,
      %w[martha marhta] => 0.944,
      %w[necessary nessecary] => 0.926
    }.each do |(a, b), expected|
      context "with '#{a}', '#{b}'" do
        let(:a) { a }
        let(:b) { b }

        it { is_expected.to eq expected }
      end
    end
  end
end
