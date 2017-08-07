#ifndef AI_MINE_CONNECT
#define AI_MINE_CONNECT
#include "../common.hpp"
#include <vector>

std::pair<int, int> mine_connect_solve(int n, const std::vector<PPII> &edges,
				       int pid, int np,
				       const std::vector<int> &mines,
				       int remain, int &eval);
#endif
