# Random Count Generator

##### Tech and Reasoning
I've opted to use Ruby (version: 2.3.1p112) for this project. I did so, because I have more experience with Ruby compared to Python and I ruled Javascript out (even though the bulk of my experience is in JS) because in order to utilize the new features of ES6, you would have to precompile using Babel and I didn't think it was worth the effort or time.

If you would like to see my logic in another language such as I python I am more than happy to port it over.

## Setup
Make sure you have ruby >= 2.0 installed

## Running
Call on the command line with two optional arguments
- history_limit:integer (default: 100)
- iterations:integer (default: history_limit value)

Iterations is the number of times the program will call the generator method. Setting this value as greater than `history_limit` will validate whether `history_limit` is working.

Ex:
`$ ruby random_count_generator.rb 200 300`
