#ifndef AI_EXACT_HPP
#define AI_EXACT_HPP
#include "../common.hpp"
int eval_board(int n, const std::vector<PPII> &edges, int s1, int s2, int mbits, std::vector<VI> &dist);
PI exact_solve(int n, const std::vector<PPII> &edges, const VI &dp, int pid, int np,
	       int mbits, int remain, int &eval);
std::vector<VI> exact_solve_setup(int n, const std::vector<PPII> &edges,
			     int mbits);

#endif
