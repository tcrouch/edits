# frozen_string_literal: true

require "spec_helper"

RSpec.describe Edits::Hamming do
  describe ".distance" do
    subject { described_class.distance a, b }

    [
      ["", "", 0],
      ["a", "a", 0],

      ["1011101", "1001001", 2],
      ["2173896", "2233796", 3],
      ["foo", "bar", 3],
      ["toned", "roses", 3],
      ["explorer", "exploded", 2],

      ["", "abc", 3],
      ["abc", "", 3],
      ["foo", "barbaz", 6]
    ].each do |a, b, distance|
      context "with '#{a}', '#{b}'" do
        let(:a) { a }
        let(:b) { b }

        it { is_expected.to eq distance }
      end
    end
  end
end
