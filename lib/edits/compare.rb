# frozen_string_literal: true

module Edits
  # Comparison helpers
  module Compare
    # Given a prototype string and an array of strings, determines which
    # string is most similar to the prototype.
    #
    # `most_similar("foo", strings)` is functionally equivalent to
    # `strings.min_by { |s| distance("foo", s) }`, leveraging
    # {.distance_with_max}.
    #
    # @example
    #   most_similar("atom", %w[tram atlas rota racer])
    #   # => "atlas"
    # @param prototype [String]
    # @param strings [<String>]
    # @return [String, nil] most similar string, or nil for empty array
    def most_similar(prototype, strings)
      return nil if strings.empty?

      min_s = strings[0]
      min_d = distance(prototype, min_s)

      strings[1..].each do |s|
        return min_s if min_d.zero?

        d = distance_with_max(prototype, s, min_d)
        if d < min_d
          min_d = d
          min_s = s
        end
      end

      min_s
    end
  end
end
