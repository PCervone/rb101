require "yaml"

MESSAGES = YAML.load_file("calculator_messages.yml")
LANGUAGE = "it"

def messages(message, lang="en")
  MESSAGES[lang][message]
end

def prompt(key)
  msg = messages(key, LANGUAGE)
  puts("=> #{msg}")
end

def integer?(num)
  num.to_i().to_s() == num
end

def float?(num)
  num.to_f().to_s() == num
end

def number?(num)
  integer?(num) || float?(num)
end

def operation_to_message(op)
  operation = case op
              when "1"
                messages("adding", LANGUAGE)
              when "2"
                messages("subtracting", LANGUAGE)
              when "3"
                messages("multiplying", LANGUAGE)
              when "4"
                messages("dividing", LANGUAGE)
              end
  operation
end

prompt("welcome")

name = ''
loop do
  name = Kernel.gets().chomp()
  if name.empty?()
    prompt("empty_name")
  else
    break
  end
end

puts format(messages("hi", LANGUAGE), name: name)

loop do
  number1 = ''
  loop do
    prompt("first_number")
    number1 = Kernel.gets().chomp()
    if number?(number1)
      break
    else
      prompt("invalid_number")
    end
  end
  number2 = ''
  loop do
    prompt("second_number")
    number2 = Kernel.gets().chomp()
    if number?(number2)
      break
    else
      prompt("invalid_number")
    end
  end

  prompt("operator_prompt")
  operator = ''
  loop do
    operator = Kernel.gets().chomp()
    if %w(1 2 3 4).include?(operator)
      break
    else
      prompt("invalid_opearator")
    end
  end

  puts format(messages("loading_operation", LANGUAGE), operation:
    operation_to_message(operator))

  result = case operator
           when "1"
             number1.to_i() + number2.to_i()
           when "2"
             number1.to_i() - number2.to_i()
           when "3"
             number1.to_i() * number2.to_i()
           else
             number1.to_f() / number2.to_f()
           end

  puts format(messages("result", LANGUAGE), result: result)

  prompt("again?")
  answer = Kernel.gets.chomp()
  break unless answer.downcase().start_with?("y")
end

prompt("goodbye")
