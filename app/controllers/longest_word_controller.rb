require 'open-uri'
require 'json'

class LongestWordController < ApplicationController
  def game
    @grid_length = generate_grid(9)
    @initial_time = Time.now
  end

  def score
    finish_time = Time.now
    @guess = params[:long_word]
    @initial_time = params[:initial_time]
    @result = run_game(@guess, params[:grid_string].split(""), Time.parse(@initial_time), finish_time)
  end

  def generate_grid(grid_size)
    # TODO: generate random grid of letters
    (0...grid_size).map { ('A'..'Z').to_a[rand(26)] }
  end

  def run_game(attempt, grid, start_time, end_time)
  # TODO: runs the game and return detailed hash of result
    word_checker = JSON.parse(open("https://wagon-dictionary.herokuapp.com/#{attempt}").read)
    if word_checker['found'] == true
      if in_grid?(attempt, grid)
        attempt.split("").each { |character| grid.include? character == true }
        return { time: (end_time - start_time).to_i, score: (1.0 / (end_time - start_time)) + (attempt.length * 2),
                 message: "Well done!" }
      else return { time: (end_time - start_time).to_i, score: 0, message: "the given word is not in the grid" }
      end
    else return { time: (end_time - start_time).to_i, score: 0, message: "That is not an English word." }
    end
  end

  def in_grid?(word, grid)
    new_grid = grid.join("").downcase.chars
    check = true
    word.chars.each do |letter|
      if new_grid.include? letter
        new_grid.delete_at(new_grid.find_index(letter))
      else
        check = false
      end
    end
    return check
  end
end
