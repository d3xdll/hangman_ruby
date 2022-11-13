require "json"



class Game
  attr_accessor :secret_word, :pattern, :wrong_words

  def initialize
    puts "Hello playa"
    if load?
      from_json
      puts "#{@secret_word}, #{@loaded_guess}, #{@loaded_array}"
      gaming_process(@secret_word, @pattern, @loaded_array)
    else
      gaming_process(random_word)
    end
  end

  def game_logic(secret, player_guess, wrong_arr, guess_word)
    if secret.split("").include?(guess_word) #check if secret word has guess
      secret.split("").each_with_index do |n, index|
        if n == guess_word
          player_guess[index] = guess_word
        end
      end
    else
      wrong_arr.push(guess_word)
    end
    puts "Heres' the wrong words #{wrong_arr}"
    puts "Heres' secret word #{@pattern}"
  end

  def gaming_process(word=random_word, pattern=get_pattern, wrong=[])
    puts pattern
    loop do
      game_logic(word, pattern, wrong, get_word)
      if check_loose?(wrong)
        puts "Sorry playa you didn't make it"
        break
      elsif check_win?
        puts "Yayyy"
        break
      end
      if save? == true
        p to_json(@secret_word, @pattern, @wrong_words)
        break
      else
        puts "Next round"
      end
    end
  end
  
  def random_word
    p @secret_word=Word.new.word
    
  end

  def get_pattern
    @pattern = "_" * (@secret_word.length)
  end 

  def get_word
    puts "Enter your guess"
    @guess = gets.chomp.downcase
  end

  def check_loose?(word_array)
    word_array.length > 7 ? true : false 
  end

  def check_win?
    @pattern.split("").any?("_") ? false : true
  end

  def to_json(word, user_word, wrong_array)
    data_hash = {secret_word: word,
                 pat: user_word,
                 arr: wrong_array}
    File.write("./data.json", JSON.dump(data_hash))
  end

  def from_json
    file = File.open("data.json")
    data = JSON.load file
    @secret_word = data["secret_word"]
    @pattern = data["pat"]
    @loaded_array = data["arr"]
    if @loaded_array.nil?
      @loaded_array = []
    end
  end

  def save?
    puts "Wanna save the game?"
    @answer = gets.chomp
    @answer == "save" ? true : false
  end

  def load?
    puts "Wanna load last game?"
    @load = gets.chomp
    @load == "load" ? true : false
  end
  
end

class Word
  attr_accessor :word
  def initialize
    loop do
      @word=Array.new(File.readlines('google-10000-english-no-swears.txt')).sample.strip
      if @word.length > 4 && @word.length < 12
        break
      end
    end
  end
end

Game.new