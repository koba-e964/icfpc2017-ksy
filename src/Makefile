CPPS = core.cpp tbl_io.cpp ai/exact.cpp
OBJS = $(subst .cpp,.o, $(CPPS))
HEADERS = tbl_io.hpp UnionFind.cpp ai/exact.hpp
core: $(OBJS)
	c++ -o core $(OBJS)
%.o: %.cpp $(HEADERS)
	c++ -Wall -O2 -c $*.cpp -o $*.o
.PHONY: clean
clean:
	-rm $(OBJS) core
