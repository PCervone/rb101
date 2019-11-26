# Rock, Paper, Scissors + Bonus Features
# --------------------------------------

VALID_CHOICES = ["rock", "paper", "scissors", "lizard", "spock"]
VALID_CHARACTERS = ["r", "p", "l", "s"]

# Insert the prompt '=>' in front of 'message'.
def prompt(message)
  puts "=> #{message}"
end

# Clear the screen and display the scoreboard.
def display_score(player_score, computer_score)
  system "clear"
  prompt "************ RPSLS *************"
  prompt "* Score: PLAYER #{player_score} | COMPUTER #{computer_score} *"
  prompt "********************************"
end

# Substitute the given character with a valid choice. If the character is 's'
# keep asking for 'scissors' or 'spock', otherwise return the right choice
# from the 'sub_characters' hash.
def substitute_character(choice)
  sub_characters = {
    "r" => VALID_CHOICES[0],
    "p" => VALID_CHOICES[1],
    "l" => VALID_CHOICES[3]
  }

  if choice == "s"
    until choice == VALID_CHOICES[2] || choice == VALID_CHOICES[4]
      prompt "Select scissors or spock:"
      choice = gets.chomp.downcase
    end
    choice
  else
    sub_characters[choice]
  end
end

# Return 'true' if the first choice beats the second one. Every key in
# 'winning_choices' has an array of choices that they beat as value.
def first_beats_second?(first, second)
  winning_choices = {
    "rock" => ["scissors", "lizard"],
    "paper" => ["rock", "spock"],
    "scissors" => ["paper", "lizard"],
    "spock" => ["scissors", "rock"],
    "lizard" => ["paper", "spock"]
  }

  winning_choices[first].include?(second)
end

# Output who has won this round.
def display_results(player, computer)
  if first_beats_second?(player, computer)
    prompt ".. YOU win!"
  elsif first_beats_second?(computer, player)
    prompt ".. COMPUTER win!"
  else
    prompt "It's a tie!"
  end
end

# Checks if player's or computer's score is five. If so, output who's the
# winner and reset both scores.
def five_points(player_score, computer_score)
  if player_score == 5
    prompt "PLAYER is the Grand Winner!!\n=> Resetting the score.."
    player_score = 0
    computer_score = 0
    yield(player_score, computer_score)
  elsif computer_score == 5
    prompt "COMPUTER is the Grand Winner!!\n=> Resetting the score.."
    player_score = 0
    computer_score = 0
    yield(player_score, computer_score)
  end
end

player_score = 0
computer_score = 0

choice = ""
loop do
  display_score(player_score, computer_score)
  loop do
    prompt "Choose one: #{VALID_CHOICES.join(', ')}" \
      "\n=> (type the word or the first character)"
    choice = gets.chomp.downcase

    # Check if the choice is valid, and call for the 'substitute_character'
    # method if the choice length is 1
    if VALID_CHOICES.include?(choice) || VALID_CHARACTERS.include?(choice)
      choice = substitute_character(choice) if choice.length == 1
      break
    else
      prompt "That's not a valid choice."
    end
  end

  computer_choice = VALID_CHOICES.sample()

  if first_beats_second?(choice, computer_choice)
    player_score += 1
  elsif first_beats_second?(computer_choice, choice)
    computer_score += 1
  end

  display_score(player_score, computer_score)

  prompt "YOU chose: #{choice}. COMPUTER chose: #{computer_choice}."

  display_results(choice, computer_choice)

  five_points(player_score, computer_score) do |player, computer|
    player_score = player
    computer_score = computer
  end

  prompt "Do you want to play again? ('y' = yes, 'n' = no)"
  answer = gets.chomp.downcase
  while answer != "y" && answer != "n"
    prompt "That's not a valid choice. " \
      "Do you want to play again? ('y' = yes, 'n' = no)"
    answer = gets.chomp.downcase
  end
  break unless answer == "y"
end

prompt "Thank you for playing. Have a nice day!"
