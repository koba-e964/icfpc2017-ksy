make CXXFLAGS="-Wall -O2" ai/core
lamduct --game-port $1 --log-level 3 --client-instance-logfile punt.log ai/main.rb
