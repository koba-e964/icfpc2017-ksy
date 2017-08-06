#include "./greedy.hpp"

std::pair<int, int> greedy_solve(int n, const std::vector<PPII> &edges,
				int pid, int np,
			        const std::vector<int> &mines,
				int remain, int &eval) {
  eval = 0;
  int m = edges.size();
  REP(i, 0, m) {
    if (edges[i].second == -1) {
      return edges[i].first;
    }
  }
  return PI(-1, -1);
}
