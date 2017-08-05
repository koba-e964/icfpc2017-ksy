#!/usr/bin/ruby
require_relative './game_io.rb'

class PassAI
  # returns [move, new_state]
  def move(pid, num_punters, map, claimed)
    sites = map['sites']
    rivers = map['rivers']
    mines = map['mines']
    n = sites.size
    m = rivers.size
    k = mines.size
    l = claimed.size
    remaining_edges = []
    cl = {}
    for c in claimed
      cl[[c[1], c[2]]] = true
    end
    for e in rivers
      if cl[[e['source'], e['target']]]
        next
      end
      remaining_edges << [e['source'], e['target']]
    end
    STDERR.puts('remaining: ' + remaining_edges.to_s)
    if remaining_edges.size >= 1
      rem = remaining_edges[0]
      {'claim' => {'punter' => pid, 'source' => rem[0], 'target' => rem[1]}}
    else
      {'pass' => {'punter' => pid}}
    end
  end
end


game_io = GameIO::new(PassAI::new())
game_io.run()
