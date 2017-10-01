# frozen_string_literal: true

module Edits
  # Implements Restricted Damerau-Levenshtein distance (Optimal Alignment)
  # algorithm.
  #
  # Determines distance between two strings by counting edits, identifying:
  # * Insertion
  # * Deletion
  # * Substitution
  # * Swapped items
  module RestrictedEdit
    # Calculate the Restricted Damerau-Levenshtein distance (Optimal Alignment)
    # of two sequences.
    #
    # @note Not a true distance metric, fails to satisfy triangle inequality.
    # @example
    #   RestrictedEdit.distance("iota", "atom")
    #   # => 3
    # @param seq1 [String, Array]
    # @param seq2 [String, Array]
    # @return [Integer]
    def self.distance(seq1, seq2)
      seq1, seq2 = seq2, seq1 if seq1.length > seq2.length

      # array of Integer codepoints outperforms String
      seq1 = seq1.codepoints if seq1.is_a? String
      seq2 = seq2.codepoints if seq2.is_a? String

      rows = seq1.length
      cols = seq2.length
      return cols if rows.zero?
      return rows if cols.zero?

      # previous two rows of cost matrix are retained
      lastlast_row = []
      last_row = []

      # Initialize first row of cost matrix.
      # The full initial state where cols=3, rows=2 would be:
      #   [[0, 1, 2, 3],
      #    [1, 0, 0, 0],
      #    [2, 0, 0, 0]]
      curr_row = 0.upto(cols).to_a

      rows.times do |row|
        # rotate rows
        curr_row, last_row, lastlast_row = lastlast_row, curr_row, last_row

        curr_row[0] = row + 1
        curr_item = seq1[row]

        cols.times do |col|
          sub_cost = curr_item == seq2[col] ? 0 : 1
          is_swap = sub_cost == 1 &&
            row.positive? && col.positive? &&
            curr_item == seq2[col - 1] &&
            seq1[row - 1] == seq2[col]

          deletion = last_row[col + 1] + 1
          insertion = curr_row[col] + 1
          substitution = last_row[col] + sub_cost

          # step cost is min of operation costs
          cost = deletion < insertion ? deletion : insertion
          cost = substitution if substitution < cost

          if is_swap
            swap = lastlast_row[col - 1] + 1
            cost = swap if swap < cost
          end

          curr_row[col + 1] = cost
        end
      end

      curr_row[cols]
    end
  end
end
