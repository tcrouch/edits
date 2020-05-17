# frozen_string_literal: true

module Edits
  # Implements the Damerau/Levenshtein distance algorithm.
  #
  # Determines distance between two strings by counting edits, identifying:
  # * Insertion
  # * Deletion
  # * Substitution
  # * Adjacent transposition
  module DamerauLevenshtein
    # Calculate the Damerau/Levenshtein distance of two sequences.
    #
    # @example
    #   DamerauLevenshtein.distance("acer", "earn")
    #   # => 3
    # @param seq1 [String, Array]
    # @param seq2 [String, Array]
    # @return [Integer] distance, 0 (identical) or greater (more distant)
    def self.distance(seq1, seq2)
      seq1, seq2 = seq2, seq1 if seq1.length > seq2.length

      # array of codepoints outperforms String
      if seq1.is_a?(String) && seq2.is_a?(String)
        seq1 = seq1.codepoints
        seq2 = seq2.codepoints
      end

      rows = seq1.length
      cols = seq2.length
      return cols if rows == 0
      return rows if cols == 0

      # 'infinite' edit distance to pad cost matrix.
      # Any value > max[rows, cols]
      inf = cols + 1

      # element => last row seen
      row_history = Hash.new(0)

      # initialize alphabet-keyed cost matrix
      matrix = {}
      curr_row = 0.upto(cols).to_a

      rows.times do |row|
        seq1_item = seq1[row]
        match_col = 0

        # rotate row arrays & generate next
        matrix[seq1_item] = last_row = curr_row
        curr_row = Array.new(cols + 1, inf)
        curr_row[0] = row + 1

        cols.times do |col|
          seq2_item = seq2[col]
          sub_cost = seq1_item == seq2_item ? 0 : 1

          # | Xs | Xd |
          # | Xi | ?  |
          # substitution, deletion, insertion
          cost = [
            last_row[col] + sub_cost,
            last_row[col + 1] + 1,
            curr_row[col] + 1
          ].min

          # transposition cost
          # skip missed matrix lookup (inf cost)
          if sub_cost > 0 && row > 0 && (m = matrix[seq2_item])
            transpose = 1 + m[match_col] \
              + (row - row_history[seq2_item] - 1) \
              + (col - match_col - 1)
            cost = transpose if transpose < cost
          end

          match_col = col if sub_cost == 0
          curr_row[col + 1] = cost
        end

        row_history[seq1_item] = row
      end

      curr_row[cols]
    end
  end
end
