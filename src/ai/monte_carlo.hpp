#ifndef AI_MONTE_CARLO_HPP
#define AI_MONTE_CARLO_HPP

#include "../common.hpp"
#include <vector>
std::pair<int, int> monte_carlo_solve(int n, const std::vector<PPII> &edges,
				      int pid, int np,
				      const std::vector<int> &mines,
				      int remain, int &eval);

#endif
