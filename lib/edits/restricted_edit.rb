# frozen_string_literal: true

module Edits
  # Implements Restricted Damerau-Levenshtein distance (Optimal Alignment)
  # algorithm.
  #
  # Determines distance between two strings by counting edits, identifying:
  # * Insertion
  # * Deletion
  # * Substitution
  # * Adjacent transposition
  #
  # This variant is restricted by the condition that no sub-string is edited
  # more than once.
  module RestrictedEdit
    extend Compare

    # Calculate the Restricted Damerau-Levenshtein distance (Optimal Alignment)
    # of two sequences.
    #
    # @note Not a true distance metric, fails to satisfy triangle inequality.
    # @example
    #   RestrictedEdit.distance("iota", "atom")
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
      return cols if rows == 0
      return rows if cols == 0

      # retain previous two rows of cost matrix
      lastlast_row = []
      last_row = []

      # Initialize first row of cost matrix.
      # The full initial state where cols=3, rows=2 would be:
      #   [[0, 1, 2, 3],
      #    [1, 0, 0, 0],
      #    [2, 0, 0, 0]]
      curr_row = 0.upto(cols).to_a

      rows.times do |row|
        # rotate row arrays
        curr_row, last_row, lastlast_row = lastlast_row, curr_row, last_row

        curr_row[0] = row + 1
        seq1_item = seq1[row]

        cols.times do |col|
          sub_cost = seq1_item == seq2[col] ? 0 : 1
          is_swap = sub_cost > 0 &&
            row > 0 && col > 0 &&
            seq1_item == seq2[col - 1] &&
            seq1[row - 1] == seq2[col]

          # | Xt |    |    |
          # |    | Xs | Xd |
          # |    | Xi | ?  |
          # step cost is min of operation costs
          # substitution, deletion, insertion, transposition
          cost = [
            last_row[col] + sub_cost,
            last_row[col + 1] + 1,
            curr_row[col] + 1
          ].min

          if is_swap
            swap = lastlast_row[col - 1] + 1
            cost = swap if swap < cost
          end

          curr_row[col + 1] = cost
        end
      end

      curr_row[cols]
    end

    # Calculate the Restricted Damerau-Levenshtein distance (Optimal Alignment)
    # of two sequences, bounded by a maximum value.
    #
    # @example
    #   Edits::RestrictedEdit.distance("cloud", "crayon")
    #   # => 5
    #   Edits::RestrictedEdit.distance_with_max("cloud", "crayon", 2)
    #   # => 2
    # @param seq1 [String, Array]
    # @param seq2 [String, Array]
    # @param max [Integer] maximum distance
    # @return [Integer] distance, from 0 (identical) to max (more distant)
    def self.distance_with_max(seq1, seq2, max)
      seq1, seq2 = seq2, seq1 if seq1.length > seq2.length

      rows = seq1.length
      cols = seq2.length
      return cols > max ? max : cols if rows == 0
      return rows > max ? max : rows if cols == 0
      return max if (cols - rows) >= max

      # array of codepoints outperforms String
      seq1 = seq1.codepoints if seq1.is_a? String
      seq2 = seq2.codepoints if seq2.is_a? String

      # 'infinite' edit distance for padding cost matrix.
      # Can be any value > max[rows, cols]
      inf = cols + 1

      # retain previous two rows of cost matrix,
      # padded with "inf" as matrix is not fully evaluated
      lastlast_row = Array.new(inf, inf)
      last_row = Array.new(inf, inf)
      curr_row = 0.upto(cols).to_a

      rows.times do |row|
        # rotate row arrays
        curr_row, last_row, lastlast_row = lastlast_row, curr_row, last_row

        # Ukkonen cut-off
        min_col = row > max ? row - max : 0
        max_col = row + max
        max_col = cols - 1 if max_col > cols - 1

        curr_row[min_col] = min_col == 0 ? row + 1 : inf
        seq1_item = seq1[row]
        diagonal = cols - rows + row

        min_col.upto(max_col) do |col|
          return max if diagonal == col && last_row[col] >= max

          sub_cost = seq1_item == seq2[col] ? 0 : 1
          is_swap = sub_cost > 0 &&
            row > 0 && col > 0 &&
            seq1_item == seq2[col - 1] &&
            seq1[row - 1] == seq2[col]

          # | Xt |    |    |
          # |    | Xs | Xd |
          # |    | Xi | ?  |
          # substitution, deletion, insertion, transposition
          cost = [
            last_row[col] + sub_cost,
            last_row[col + 1] + 1,
            curr_row[col] + 1
          ].min

          if is_swap
            swap = lastlast_row[col - 1] + 1
            cost = swap if swap < cost
          end

          curr_row[col + 1] = cost
        end
      end

      curr_row[cols] > max ? max : curr_row[cols]
    end
  end
end
