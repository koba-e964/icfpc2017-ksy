#ifndef AI_EVAL_HPP
#define AI_EVAL_HPP

#include "../common.hpp"
#include <vector>
#include <set>

int eval_board_myscore(int n, const std::vector<PPII> &edges, int pid, int np,
		       std::set<int> mines, std::vector<VI> &dist);
#endif
