#ifndef AI_GREEDY
#define AI_GREEDY
#include "../common.hpp"
#include <vector>

std::pair<int, int> greedy_solve(int n, const std::vector<PPII> &edges,
				int pid, int np,
			        const std::vector<int> &mines,
				int remain, int &eval);
#endif
