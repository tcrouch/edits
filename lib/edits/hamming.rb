# frozen_string_literal: true

module Edits
  # @see https://en.wikipedia.org/wiki/Hamming_distance
  module Hamming
    # Calculate the Hamming distance between two sequences.
    #
    # @note A true distance metric, satisfies triangle inequality.
    #
    # @param seq1 [String, Array]
    # @param seq2 [String, Array]
    # @return [Integer] Hamming distance
    def self.distance(seq1, seq2)
      # if seq1.is_a?(Integer) && seq2.is_a?(Integer)
      #   return (seq1 ^ seq2).to_s(2).count("1")
      # end

      length = seq1.length < seq2.length ? seq1.length : seq2.length
      diff = (seq1.length - seq2.length).abs

      length.times.reduce(diff) do |distance, i|
        seq1[i] == seq2[i] ? distance : distance + 1
      end
    end
  end
end
