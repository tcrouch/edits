# frozen_string_literal: true

require "spec_helper"

RSpec.describe Edits::JaroWinkler do
  describe ".similarity" do
    subject { described_class.similarity(a, b).round(3) }

    {
      ["", ""] => 1,
      ["", "a"] => 0,
      ["a", ""] => 0,

      %w[abc abc] => 1,
      %w[abc def] => 0,
      %w[abcvwxyz cabvwxyz] => 0.958,
      %w[dixon dicksonx] => 0.813,
      %w[dwayne duane] => 0.84,
      %w[information informant] => 0.941,
      %w[iota atom] => 0.5,
      %w[jones johnson] => 0.832,
      %w[martha marhta] => 0.961,
      %w[necessary nessecary] => 0.941
    }.each do |(a, b), expected|
      context "with '#{a}', '#{b}'" do
        let(:a) { a }
        let(:b) { b }

        it { is_expected.to eq expected }
      end
    end
  end
end
