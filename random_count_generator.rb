require 'date'

class WriteQueue
  @@queue = []

  def self.add_to_queue(value)
    @@queue.unshift({ timestamp: DateTime.now.iso8601, value: value })
  end

  def self.next
    @@queue.pop
  end
end

class RandomNumberGenerator

  def initialize(
    probabilities: [[1, 0.5], [2, 0.25], [3, 0.15], [4, 0.05], [5, 0.05]],
    history_limit: 100
  )
    # Make sure history limit is a positive integer
    unless history_limit.is_a?(Integer) && history_limit > 0
      raise 'history_limit must be a positive integer'
    end
    # Make sure probabilities add up to 100%
    raise 'Sum of probabilities must be 1' if probabilities.inject(0) { |sum, x| sum + x[1] } != 1
    @probabilities = probabilities
    # Given a list of acceptable numbers and their probabilities, create an array 100
    # values that correspond to the given probability per number
    @value_list = @probabilities.map { |x| Array.new(x[1] * 100).fill(x[0]) }.flatten
    # Setup history
    @history = []
    @history_limit = history_limit
  end

  def add_to_history(val)
    # Add value to beginning of list with timestamp
    @history.unshift({ timestamp: Time.now, value: val })
    # Remove oldest value if at history limit
    if @history.length > @history_limit
      @history.pop
    end
  end

  def generate_random_number
    # Get value
    val = @value_list.sample
    # Add to history
    add_to_history(val)
    # Return value
    val
  end

  def get_frequencies
    # Group by number
    grouped = @history.group_by { |x| x[:value] }
    # Calculate frequency and print to stdout
    puts grouped.keys.sort.map { |x| { value: x, frequency: grouped[x].length.to_f / @history.length } }
  end

end

# Most of this code is just to log to std out so we know its working.
def start_writer
  Thread.new {
    done = false
    waiting = false
    while !done do
      next_value = WriteQueue.next
      unless next_value.nil?
        waiting = false
        puts "\n"
        puts "Writer: writing #{next_value}"
        # Append value to file
        File.open('out.txt', 'a') { |file| file.write("#{next_value[:timestamp]}: #{next_value[:value]}\n") }
      else
        unless waiting
          puts "\n"
          print "Writer: waiting"
          waiting = true
        else
          print "."
          sleep(1)
        end
      end
    end
  }
end

limit = ARGV[0] && ARGV[0].to_i || 100
iterations = ARGV[1] && ARGV[1].to_i || limit


# Create 5 workers generating numbers
workers = []
(1..5).each do |i|
  t = Thread.new {
    puts "\n"
    puts "Worker #{i}: Running with limit = #{limit} and #{iterations} iterations"
    rng = RandomNumberGenerator.new(history_limit: limit)
    (1..iterations).each do
      # Sleep randomly so that not all values are generated instantaneously
      sleep(rand(0..10))
      val = rng.generate_random_number
      puts "\n"
      puts "Worker #{i}: Generated value #{val}"
      # Add to queue
      WriteQueue.add_to_queue(val)
    end
  }
  workers.push(t)
end

# Start write thread
write_thread = start_writer

# Wait for workers to finish
workers.each { |t| t.join }

# We want the the write thread to continue, ctrl + c to stop
write_thread.join
