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
    STDERR.puts(msg)

    income = self.recv()
    STDERR.puts(income)
    if income['punter']
      # Setup
      pid = income['punter'].to_i
      self.send({"ready" => pid, 'state' => income})
      STDERR.puts('setup done')
      return
    end
    if income['move']
      # Gameplay
      STDERR.puts('moving')
      state = income['state']
      prev = income
      pid = state['punter'].to_i
      # TODO stub: always passes
      self.send({'pass' => {'punter' => pid}, 'state' => state})
      STDERR.puts('move claimed')
      return
    end
    if income['stop']
      STDERR.puts(income['stop'])
      return
    end
    raise Exception
  end
end
