def generate_random_number(probabilities = [[1, 0.5], [2, 0.25], [3, 0.15], [4, 0.05], [5, 0.05]])
  # Make sure probabilities add up to 100%
  raise 'Sum of probabilities must be 1' if probabilities.inject(0) { |sum, x| sum + x[1] } != 1
  # Given a list of acceptable numbers and their probabilities, create an array 100
  # values that correspond to the given probability per number
  value_list = probabilities.map { |x| Array.new(x[1] * 100).fill(x[0]) }.flatten
  # Pick a random value from the array and print to stdout
  puts value_list.sample
end
