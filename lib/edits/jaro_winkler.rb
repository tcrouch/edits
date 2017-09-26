# frozen_string_literal: true

module Edits
  # Implements Jaro-Winkler similarity algorithm.
  #
  # @see https://en.wikipedia.org/wiki/Jaro-Winkler_distance
  module JaroWinkler
    # Prefix scaling factor for jaro-winkler metric. Default is 0.1
    # Should not exceed 0.25 or metric range will leave 0..1
    WINKLER_PREFIX_WEIGHT = 0.1

    # Threshold for boosting Jaro with winkler prefix multiplier.
    # Default is 0.7
    WINKLER_THRESHOLD = 0.7

    # Calculate Jaro-Winkler similarity of given strings
    #
    # Adds weight to Jaro similarity according to the length of a common prefix
    # of up to 4 letters, where exists. The additional weighting is only
    # applied when the original similarity passes a threshold.
    #
    # `Sw = Sj + (l * p * (1 - Dj))`
    #
    # Where `Sj` is Jaro, `l` is prefix length, and `p` is prefix weight
    #
    # @example
    #   Edits::JaroWinkler.similarity("information", "informant")
    #   # => 0.9414141414141414
    #
    # @param seq1 [String, Array]
    # @param seq2 [String, Array]
    # @param threshold [Float] threshold for applying Winkler prefix weighting
    # @param weight [Float] weighting for common prefix, should not exceed 0.25
    # @return [Float] similarity, between 0.0 (none) and 1.0 (identical)
    def self.similarity(
      seq1, seq2,
      threshold: WINKLER_THRESHOLD,
      weight: WINKLER_PREFIX_WEIGHT
    )

      dj = Jaro.similarity(seq1, seq2)

      if dj > threshold
        # size of common prefix, max 4
        max_bound = seq1.length > seq2.length ? seq2.length : seq1.length
        max_bound = 4 if max_bound > 4

        l = 0
        l += 1 until seq1[l] != seq2[l] || l >= max_bound

        l < 1 ? dj : dj + (l * weight * (1 - dj))
      else
        dj
      end
    end

    # Calculate Jaro-Winkler distance
    #
    # @note Not a true distance metric, fails to satisfy triangle inequality.
    #
    # @example
    #   Edits::JaroWinkler.distance("information", "informant")
    #   # => 0.05858585858585863
    # @param (see #distance)
    # @return [Float] distance, between 0.0 (identical) and 1.0 (distant)
    def self.distance(
      seq1, seq2,
      threshold: WINKLER_THRESHOLD,
      weight: WINKLER_PREFIX_WEIGHT
    )
      1.0 - similarity(seq1, seq2, threshold: threshold, weight: weight)
    end
  end
end
