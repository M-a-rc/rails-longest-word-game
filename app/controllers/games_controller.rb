require 'open-uri'

class GamesController < ApplicationController
  def home
  end

  def new
    @letters = []
    2.times { @letters << %w[A E I O U].sample }
    9.times { @letters << ('A'..'Z').to_a.sample }
  end

  def score
    @guess = params[:guess].upcase
    grid = params[:grid].scan(/\w/)
    guess_letters = @guess.split('')
    ok_letters = 0

    guess_letters.each do |guess_letter|
      grid.each_with_index do |grid_letter, grid_index|
        if grid_letter == guess_letter
          grid.delete_at(grid_index)
          ok_letters += 1
          break
        else
          next
        end
      end
    end

    if @guess.length == ok_letters
      filepath = "https://wagon-dictionary.herokuapp.com/#{@guess}"
      serialized_dictionary = URI.open(filepath).read
      dictionary_response = JSON.parse(serialized_dictionary)
      if dictionary_response['found'] == true
        score = dictionary_response['length'] * 4
        @message = "Congrats ! Le mot #{@guess} existe dans la grid ! ✅  Votre score est de #{score} points!"
      else
        @message = "Le mot #{@guess} n'est pas anglais!"
      end
    else
      @message = "Dommage ! Le mot n'existe pas dans la grid ❌"
    end
  end
end
