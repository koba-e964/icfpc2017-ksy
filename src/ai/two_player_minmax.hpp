#ifndef AI_TWO_PLAYER_MINMAX_HPP
#define AI_TWO_PLAYER_MINMAX_HPP

#include "../common.hpp"
#include <vector>
std::pair<int, int>
two_player_minmax_solve(int n, const std::vector<PPII> &edges,
			int pid, int np,
			const std::vector<int> &mines,
			int remain, int &turns, int &eval);

#endif
