# frozen_string_literal: true

require "benchmark"
require "edits"

desc "Compare metrics"
task :benchmark do
  words = File.read("/usr/share/dict/words")
    .split(/\n/).compact.shuffle(random: Random.new(1))

  Benchmark.bm(20) do |x|
    x.report("Hamming") do
      words.each_cons(2) do |a, b|
        Edits::Hamming.distance a, b
      end
    end

    x.report("Levenshtein") do
      words.each_cons(2) do |a, b|
        Edits::Levenshtein.distance a, b
      end
    end

    x.report("RestrictedEdit") do
      words.each_cons(2) do |a, b|
        Edits::RestrictedEdit.distance a, b
      end
    end

    x.report("DamerauLevenshtein") do
      words.each_cons(2) do |a, b|
        Edits::DamerauLevenshtein.distance a, b
      end
    end

    x.report("Jaro") do
      words.each_cons(2) do |a, b|
        Edits::Jaro.distance a, b
      end
    end

    x.report("JaroWinkler") do
      words.each_cons(2) do |a, b|
        Edits::JaroWinkler.distance a, b
      end
    end
  end
end
