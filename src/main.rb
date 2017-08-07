#!/usr/bin/ruby
require_relative './game_io.rb'

class AI
  # ai_kind = 'greedy' or 'monte_carlo'
  def initialize(ai_kind)
    available_ais = ['greedy', 'monte_carlo']
    if !available_ais.include?(ai_kind)
      raise Exception::new('AI type ' + ai_kind + 'not available')
    end
    @ai_kind = ai_kind
  end

  # if setup returns tbl
  # else returns [move, new_state]
  def move(pid, num_punters, map, claimed, rem, setup=false, tbl=nil)
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
mode
extra

0 <= s_i, t_i < m
-1 <= c_i < np (-1: not claimed)
0 <= a_i < n


if mode == 'state'
  extra == ''
  The C++ program should return
  'tbl (state)'
  where state is a string representing a state (without spaces)
if mode == 'run'
  extra looks like:
tbl
ai_kind
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
    io = IO.popen(File.expand_path(File.dirname($0)) + '/core', 'r+')
    io.puts("#{n} #{m} #{k} #{pid} #{np} #{rem}")
    for i in 0 ... m
      io.puts(edges[i].join(' '))
    end
    mine_ids = []
    for i in 0 ... k
      mine_ids << (mines[i]).to_s
    end
    io.puts(mine_ids.join(' '))
    if setup
      io.puts('setup')
    else
      io.puts('run')
      io.puts(tbl)
      io.puts(@ai_kind)
    end
    io.close_write
    eval = 0
    STDERR.puts("playing as punter #{pid} (total = #{num_punters})")
    while answer = io.gets.chomp.split
      if answer[0] != 'info'
        break
      end
      # info eval (turns) (value)
      if answer[1] == 'eval'
        turns = answer[2].to_i
        eval = answer[3].to_i
        if turns >= 0
          STDERR.puts("evaluation: turns=#{turns}, value=#{eval}")
        else
          STDERR.puts("full evaluation: value=#{eval}")
        end
      end
    end
    if answer[0] == 'pass'
      return {'pass' => {'punter' => pid}}, eval
    end
    if answer[0] == 'claim'
      s = answer[1].to_i
      t = answer[2].to_i
      return {'claim' => {'punter' => pid, 'source' => s, 'target' => t}}, eval
    end
    if answer[0] == 'tbl'
      STDERR.puts("Got tbl (tbl size = #{answer[1].size})")
      return answer[1]
    end
  end
end


ai_kind = ARGV[0] ? ARGV[0] : 'greedy'
game_io = GameIO::new(AI::new(ai_kind))
game_io.run()
