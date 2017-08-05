#!/usr/bin/ruby
require_relative './game_io.rb'

class PassAI
  # returns [move, new_state]
  def move(pid, num_punters, map, claimed, rem)
    sites = map['sites']
    rivers = map['rivers']
    mines = map['mines']
    _format = """
Invoke C++ program with the following format:
n m k pid np
s_1 t_1 c_1
...
s_m t_m c_m (edges)
a_1 ... a_k (mines)

0 <= s_i, t_i < m
-1 <= c_i < np (-1: not claimed)
0 <= a_i < n


The C++ program should return
'pass'
or
'claim s t'
in one line.
    """
    n = sites.size
    m = rivers.size
    k = mines.size
    np = num_punters
    edges = []
    cl = {}
    for c in claimed
      cl[[c[1], c[2]]] = c[0]
    end
    for e in rivers
      col = -1
      if cl[[e['source'], e['target']]]
        col = cl[[e['source'], e['target']]]
      end
      edges << [e['source'], e['target'], col]
    end
    io = IO.popen('ai/core', 'r+')
    io.puts("#{n} #{m} #{k} #{pid} #{np} #{rem}")
    for i in 0 ... m
      io.puts(edges[i].join(' '))
    end
    mine_ids = []
    for i in 0 ... k
      mine_ids << (mines[i]).to_s
    end
    io.puts(mine_ids.join(' '))
    io.close_write
    answer = io.gets.chomp.split
    STDERR.puts("answer from core: " + answer.inspect)
    if answer[0] == 'pass'
      {'pass' => {'punter' => pid}}
    else
      s = answer[1].to_i
      t = answer[2].to_i
      STDERR.puts('claiming ' + [s, t] * ' ')
      {'claim' => {'punter' => pid, 'source' => s, 'target' => t}}
    end
  end
end


game_io = GameIO::new(PassAI::new())
game_io.run()
