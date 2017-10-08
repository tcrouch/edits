# frozen_string_literal: true

module Edits
  # Implements Levenshtein distance algorithm.
  #
  # Determines distance between two string by counting edits, identifying:
  # * Insertion
  # * Deletion
  # * Substitution
  module Levenshtein
    extend Compare

    # Calculate the Levenshtein (edit) distance of two sequences.
    #
    # @note A true distance metric, satisfies triangle inequality.
    # @example
    #   Levenshtein.distance('sand', 'hands')
    #   # => 2
    # @param seq1 [String, Array]
    # @param seq2 [String, Array]
    # @return [Integer]
    def self.distance(seq1, seq2)
      seq1, seq2 = seq2, seq1 if seq1.length > seq2.length

      # array of codepoints outperforms String
      seq1 = seq1.codepoints if seq1.is_a? String
      seq2 = seq2.codepoints if seq2.is_a? String

      rows = seq1.length
      cols = seq2.length
      return cols if rows.zero?
      return rows if cols.zero?

      # Initialize first row of cost matrix.
      # The full initial state where cols=3, rows=2 would be:
      #   [[0, 1, 2, 3],
      #    [1, 0, 0, 0],
      #    [2, 0, 0, 0]]
      last_row = 0.upto(cols).to_a

      rows.times do |row|
        prev_col_cost = row + 1
        seq1_item = seq1[row]

        cols.times do |col|
          # | Xs | Xd |
          # | Xi | ?  |
          # step cost is min of operation costs
          # substitution, deletion, insertion
          cost = [
            last_row[col] + (seq1_item == seq2[col] ? 0 : 1),
            last_row[col + 1] + 1,
            prev_col_cost + 1
          ].min

          # overwrite previous row as we progress
          last_row[col] = prev_col_cost
          prev_col_cost = cost
        end
        last_row[cols] = prev_col_cost
      end

      last_row[cols]
    end

    # Calculate the Levenshtein (edit) distance of two sequences, bounded by
    # a maximum value.
    #
    # @example
    #   Edits::Levenshtein.distance("cloud", "crayon")
    #   # => 5
    #   Edits::Levenshtein.distance_with_max("cloud", "crayon", 2)
    #   # => 2
    # @param seq1 [String, Array]
    # @param seq2 [String, Array]
    # @param max [Integer] maximum distance
    # @return [Integer]
    def self.distance_with_max(seq1, seq2, max)
      seq1, seq2 = seq2, seq1 if seq1.length > seq2.length

      rows = seq1.length
      cols = seq2.length
      return cols > max ? max : cols if rows.zero?
      return rows > max ? max : rows if cols.zero?
      return max if (cols - rows) >= max

      # array of codepoints outperforms String
      seq1 = seq1.codepoints if seq1.is_a? String
      seq2 = seq2.codepoints if seq2.is_a? String

      # 'infinite' edit distance for padding cost matrix.
      # Can be any value > max[rows, cols]
      inf = cols + 1

      # retain previous row of cost matrix
      last_row = 0.upto(cols).to_a

      rows.times do |row|
        # Ukkonen cut-off
        min_col = row > max ? row - max : 0
        max_col = row + max
        max_col = cols - 1 if max_col > cols - 1

        prev_col_cost = min_col.zero? ? row + 1 : inf
        seq1_item = seq1[row]
        diagonal = cols - rows + row

        min_col.upto(max_col) do |col|
          return max if diagonal == col && last_row[col] >= max

          # | Xs | Xd |
          # | Xi | ?  |
          # substitution, deletion, insertion
          cost = [
            last_row[col] + (seq1_item == seq2[col] ? 0 : 1),
            last_row[col + 1] + 1,
            prev_col_cost + 1
          ].min

          # overwrite previous row as we progress
          last_row[col] = prev_col_cost
          prev_col_cost = cost
        end

        last_row[cols] = prev_col_cost
      end

      last_row[cols] > max ? max : last_row[cols]
    end
  end
end
