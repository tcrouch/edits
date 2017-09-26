# frozen_string_literal: true

module Edits
  # Implements Jaro similarity algorithm.
  #
  # @see https://en.wikipedia.org/wiki/Jaro-Winkler_distance
  module Jaro
    # Calculate Jaro similarity
    #
    # `Sj = 1/3 * ((m / |A|) + (m / |B|) + ((m - t) / m))`
    #
    # Where `m` is #matches and `t` is #transposes
    #
    # @example
    #   Edits::Jaro.similarity("information", "informant")
    #   # => 0.9023569023569024
    # @param seq1 [String, Array]
    # @param seq2 [String, Array]
    # @return [Float] similarity, between 0.0 (none) and 1.0 (identical)
    def self.similarity(seq1, seq2)
      return 1.0 if seq1 == seq2
      return 0.0 if seq1.empty? || seq2.empty?

      seq1 = seq1.codepoints if seq1.is_a? String
      seq2 = seq2.codepoints if seq2.is_a? String

      m, t = jaro_matches(seq1, seq2)
      return 0.0 if m.zero?

      m = m.to_f
      ((m / seq1.length) + (m / seq2.length) + ((m - t) / m)) / 3
    end

    # Calculate Jaro distance
    #
    # `Dj = 1 - Sj`
    #
    # @example
    #   Edits::Jaro.distance("information", "informant")
    #   # => 0.09764309764309764
    # @param (see #distance)
    # @return [Float] distance, between 0.0 (identical) and 1.0 (distant)
    def self.distance(str1, str2)
      1.0 - similarity(str1, str2)
    end

    # Calculate number of Jaro matches and transpositions
    #
    # @param (see #distance)
    # @return [(Integer, Integer)] matches and transpositions
    def self.jaro_matches(seq1, seq2)
      seq1, seq2 = seq2, seq1 if seq1.length > seq2.length

      # search range: (max(|A|, |B|) / 2) - 1
      range = (seq2.length / 2) - 1
      range = 0 if range.negative?

      seq1_flags = Array.new(seq1.length, false)
      seq2_flags = Array.new(seq2.length, false)

      matches = 0
      last2 = seq2.length - 1

      # Pass 1:
      # - determine number of matches
      # - initialize transposition flags
      seq1.length.times do |i|
        min_bound = i >= range ? i - range : 0
        max_bound = (i + range) <= last2 ? (i + range) : last2

        min_bound.upto(max_bound) do |j|
          next unless seq2_flags[j] != true && seq2[j] == seq1[i]

          seq2_flags[j] = true
          seq1_flags[i] = true
          matches += 1
          break
        end
      end

      return [0, 0] if matches.zero?

      transposes = 0
      j = 0

      # Pass 2: determine number of half-transpositions
      seq1.length.times do |i|
        # find a match in first string
        next unless seq1_flags[i] == true
        # go to location of next match on second string
        j += 1 until seq2_flags[j]

        # transposition if not the current match
        transposes += 1 if seq1[i] != seq2[j]
        j += 1
      end

      # half-transpositions -> transpositions
      transposes /= 2

      [matches, transposes]
    end
    private_class_method :jaro_matches
  end
end
