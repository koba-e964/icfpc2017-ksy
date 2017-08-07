CPPS = core.cpp tbl_io.cpp ai/exact.cpp ai/greedy.cpp ai/eval.cpp ai/monte_carlo.cpp ai/mine_connect.cpp ai/two_player_minmax.cpp
OBJS = $(subst .cpp,.o, $(CPPS))
HEADERS = tbl_io.hpp UnionFind.cpp ai/exact.hpp ai/greedy.hpp ai/eval.hpp ai/monte_carlo.hpp ai/mine_connect.hpp ai/two_player_minmax.hpp
core: $(OBJS)
	c++ -o core $(OBJS)
%.o: %.cpp $(HEADERS)
	c++ -Wall -O2 -c $*.cpp -o $*.o
.PHONY: clean
clean:
	-rm $(OBJS) core
