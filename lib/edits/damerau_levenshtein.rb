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
      seq1 = seq1.codepoints if seq1.is_a? String
      seq2 = seq2.codepoints if seq2.is_a? String

      rows = seq1.length
      cols = seq2.length
      return cols if rows.zero?
      return rows if cols.zero?

      # 'infinite' edit distance for padding cost matrix.
      # Can be any value > max[rows, cols]
      inf = rows + cols

      # Initialize first two rows of cost matrix.
      # The full initial state where cols=3, rows=2 (inf=5) would be:
      #   [[5, 5, 5, 5, 5],
      #    [5, 0, 1, 2, 3],
      #    [5, 1, 0, 0, 0],
      #    [5, 2, 0, 0, 0]]
      matrix = [Array.new(cols + 2, inf)]
      matrix << 0.upto(cols).to_a.unshift(inf)

      # element => last row seen
      item_history = Hash.new(0)

      1.upto(rows) do |row|
        # generate next row of cost matrix
        new_row = Array.new(cols + 2, 0)
        new_row[0] = inf
        new_row[1] = row
        matrix << new_row

        last_match_col = 0
        seq1_item = seq1[row - 1]

        1.upto(cols) do |col|
          seq2_item = seq2[col - 1]
          last_match_row = item_history[seq2_item]

          sub_cost = seq1_item == seq2_item ? 0 : 1

          transposition = 1 + matrix[last_match_row][last_match_col]
          transposition += row - last_match_row - 1
          transposition += col - last_match_col - 1

          # TODO: do insertion/deletion need to be considered when
          # seq1_item == seq2_item ?
          #
          # substitution, deletion, insertion, transposition
          cost = [
            matrix[row][col] + sub_cost,
            matrix[row][col + 1] + 1,
            matrix[row + 1][col] + 1,
            transposition
          ].min

          matrix[row + 1][col + 1] = cost

          last_match_col = col if sub_cost.zero?
        end

        item_history[seq1_item] = row
      end

      matrix[rows + 1][cols + 1]
    end
  end
end
