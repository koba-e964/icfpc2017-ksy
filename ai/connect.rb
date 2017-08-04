require 'json'
require 'socket'

class GameSocket
  def initialize(port)
    host = 'punter.inf.ed.ac.uk'

    addrinfo = Addrinfo.getaddrinfo(host, port, nil, :STREAM)[0]
    @sock = addrinfo.connect()
  end
  def send(obj)
    json_str = obj.to_json
    sent_str = json_str.size.to_s + ':' + json_str
    @sock.send(sent_str, 0)
  end
  
  def recv()
    len_str = ''
    while true
      c = @sock.recv(1)
      if c == ':'
        break
      end
      len_str += c
    end
    len = len_str.to_i
    msg = @sock.recv(len)
    JSON.parse(msg)
  end
end



#handshake
name = 'memento_mori'
puts 'port = ' + ARGV[0]
port = ARGV[0].to_i
game_sock = GameSocket::new(port)
game_sock.send({"me" => name})
msg = game_sock.recv()
p msg

# Wait for setup
config = game_sock.recv()
pid = config['punter']
game_sock.send({"ready" => pid})

# Gameplay
scores = nil
while true
  prev = game_sock.recv()
  if prev['stop']
    scores = prev
    break
  end
  # TODO stub: always passes
  game_sock.send({'pass' => {'punter' => pid}})
end

p scores
