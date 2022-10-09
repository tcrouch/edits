# frozen_string_literal: true

require "benchmark"
require "benchmark/ips"
require "edits"

namespace :benchmark do
  desc "levenshtein distance vs distance_with_max (x100)"
  task :lev_max do
    words = File.read("/usr/share/dict/words")
      .split(/\n/).compact.shuffle(random: Random.new(1))
      .take(101)

    Benchmark.ips do |x|
      x.report("distance") do
        words.each_cons(2) do |a, b|
          Edits::Levenshtein.distance a, b
        end
      end

      x.report("with max 1") do
        words.each_cons(2) do |a, b|
          Edits::Levenshtein.distance_with_max a, b, 1
        end
      end

      x.report("with max 2") do
        words.each_cons(2) do |a, b|
          Edits::Levenshtein.distance_with_max a, b, 2
        end
      end

      x.report("with max 3") do
        words.each_cons(2) do |a, b|
          Edits::Levenshtein.distance_with_max a, b, 3
        end
      end

      x.report("with max 4") do
        words.each_cons(2) do |a, b|
          Edits::Levenshtein.distance_with_max a, b, 4
        end
      end

      x.report("with max 6") do
        words.each_cons(2) do |a, b|
          Edits::Levenshtein.distance_with_max a, b, 6
        end
      end

      x.report("with max 8") do
        words.each_cons(2) do |a, b|
          Edits::Levenshtein.distance_with_max a, b, 8
        end
      end

      x.report("with max 50") do
        words.each_cons(2) do |a, b|
          Edits::Levenshtein.distance_with_max a, b, 100
        end
      end

      x.compare!
    end
  end

  desc "restricted distance vs distance_with_max (x100)"
  task :restricted_max do
    words = File.read("/usr/share/dict/words")
      .split(/\n/).compact.shuffle(random: Random.new(1))
      .take(101)

    Benchmark.ips do |x|
      x.report("distance") do
        words.each_cons(2) do |a, b|
          Edits::RestrictedEdit.distance a, b
        end
      end

      x.report("with max 1") do
        words.each_cons(2) do |a, b|
          Edits::RestrictedEdit.distance_with_max a, b, 1
        end
      end

      x.report("with max 2") do
        words.each_cons(2) do |a, b|
          Edits::RestrictedEdit.distance_with_max a, b, 2
        end
      end

      x.report("with max 3") do
        words.each_cons(2) do |a, b|
          Edits::RestrictedEdit.distance_with_max a, b, 3
        end
      end

      x.report("with max 4") do
        words.each_cons(2) do |a, b|
          Edits::RestrictedEdit.distance_with_max a, b, 4
        end
      end

      x.report("with max 6") do
        words.each_cons(2) do |a, b|
          Edits::RestrictedEdit.distance_with_max a, b, 6
        end
      end

      x.report("with max 8") do
        words.each_cons(2) do |a, b|
          Edits::RestrictedEdit.distance_with_max a, b, 8
        end
      end

      x.report("with max 50") do
        words.each_cons(2) do |a, b|
          Edits::RestrictedEdit.distance_with_max a, b, 100
        end
      end

      x.compare!
    end
  end

  desc "most_similar vs min_by (100 words)"
  task :lev_similar do
    words = File.read("/usr/share/dict/words")
      .split(/\n/).compact.shuffle(random: Random.new(1))
      .take(100)

    Benchmark.ips do |x|
      x.report("most_similar") do
        Edits::Levenshtein.most_similar("wxyz", words)
      end

      x.report("min_by") do
        words.min_by { |s| Edits::Levenshtein.distance("wxyz", s) }
      end

      x.compare!
    end
  end

  task :rowgen1 do
    cols = 5
    rows = 3

    Benchmark.ips do |x|
      x.report "new, unshift" do
        Array.new(cols, 0).unshift(rows)
      end

      x.report "new, []=" do
        curr_row = Array.new(cols + 1, 0)
        curr_row[0] = rows
      end

      x.report "literal, concat" do
        [rows].concat(Array.new(cols, 0))
      end

      x.report "literal, +" do
        m = []
        m << ([rows] + Array.new(cols, 0))
      end

      x.compare!
    end
  end

  task :rowgen2 do
    cols = 5
    rows = 3
    inf = cols + rows

    Benchmark.ips do |x|
      x.report "new, unshift" do
        m = []
        m << Array.new(cols, 0).unshift(rows, inf)
      end

      x.report "new, []=" do
        m = []
        curr_row = Array.new(cols + 2, 0)
        curr_row[0] = rows
        curr_row[1] = inf
        m << curr_row
      end

      x.report "literal, concat" do
        m = []
        m << [rows, inf].concat(Array.new(cols, 0))
      end

      x.report "literal, +" do
        m = []
        m << ([rows, inf] + Array.new(cols, 0))
      end

      x.compare!
    end
  end
end
