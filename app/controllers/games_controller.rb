require 'open-uri'
require 'json'

class GamesController < ApplicationController
  def new
    @letters = []
    10.times do
      @letters << ('A'..'Z').to_a.sample
    end
  end

  def score
    @letters = params[:letters].delete('[').delete(']').delete('"').split(',')
    @results = params[:score]
    @grid = not_in_the_grid?(@letters, @results)
    @english_word = not_english_word?(@results)
  end

  private

  def not_english_word?(attempt)
    url = "https://wagon-dictionary.herokuapp.com/#{attempt}"
    word_serialized = open(url).read
    word = JSON.parse(word_serialized)
    return word['found'] == false
  end

  def not_in_the_grid?(grid, attempt)
    grid_hash = Hash.new(0)
    attempt_hash = Hash.new(0)

    grid.each { |letter| grid_hash[letter] += 1 }
    attempt.upcase.chars.each { |letter| attempt_hash[letter] += 1 }

    attempt_hash.map do |letter, frequency|
      return true if grid_hash.key?(letter) == false || grid_hash[letter] < frequency
    end
    return false
  end
end
