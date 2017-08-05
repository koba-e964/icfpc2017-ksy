require 'json'

class GameIO
  def initialize(ai)
    @ai = ai
    STDOUT.sync = true
    STDIN.sync = true
    STDERR.sync = true
  end
  def send(obj)
    json_str = obj.to_json
    sent_str = json_str.size.to_s + ':' + json_str
    STDOUT.write(sent_str)
  end
  
  def recv()
    len_str = ''
    while true
      c = ''
      $stdin.read(1, c)
      if c == ':'
        break
      end
      len_str += c
    end
    len = len_str.to_i
    msg = STDIN.read(len)
    JSON.parse(msg)
  end

  def run()
    #handshake
    name = 'master_thesis'
    self.send({"me" => name})
    msg = self.recv()

    income = self.recv()
    if income['punter']
      # Setup
      pid = income['punter'].to_i
      income['claimed'] = []
      income['rem'] = income['map']['rivers'].size - pid
      self.send({"ready" => pid, 'state' => income})
      return
    end
    if income['move']
      # Gameplay
      state = income['state']
      prev = income
      pid = state['punter']
      n = state['punters']
      map = state['map']
      rem = state['rem']
      claimed = state['claimed']
      for mv in income['move']['moves']
        if mv['claim']
          cl = mv['claim']
          claimed << [cl['punter'], cl['source'], cl['target']]
        end
      end
      move = @ai.move(pid, n, map, claimed, rem)
      state['rem'] = rem - n
      move['state'] = state
      self.send(move)
      return
    end
    if income['stop']
      STDERR.puts(income['stop'])
      return
    end
    raise Exception
  end
end
