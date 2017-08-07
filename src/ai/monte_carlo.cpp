#include <set>
#include "./eval.hpp"
#include "./monte_carlo.hpp"
#include "../UnionFind.cpp"
#include <cstdlib>

using namespace std;

ll eval_board_playout(int n, std::vector<PPII> &edges, int pid, int np,
		       const set<int> &mines, const vector<VI> &dist, int turns) {
  ll sum = 0;
  vector<int> vac;
  int m = edges.size();
  REP(i, 0, m) {
    if (edges[i].second == -1) {
      vac.push_back(i);
    }
  }
  turns = min((int) vac.size(), turns)  ;
  REP(i, 0, 1000) {
    // random-shuffle
    REP(j, 1, vac.size()) {
      int tac = rand() % (j + 1);
      if (tac != j) {
	swap(vac[tac], vac[j]);
      }
    }
    REP(j, 0, turns) {
      edges[vac[j]].second = pid;
    }
    int sc = eval_board_myscore(n, edges, pid, np, mines, dist);
    sum = min((ll) sc, sum);
    REP(j, 0, turns) {
      edges[vac[j]].second = -1;
    }
  }
  return sum;
}



std::pair<int, int> monte_carlo_solve(int n, const std::vector<PPII> &edges,
				int pid, int np,
			        const std::vector<int> &mines,
				int remain, int &eval) {
  set<int> mines_set;
  REP(i, 0, mines.size()) {
    mines_set.insert(mines[i]);
  }
  std::vector<PPII> edges_cp(edges);
  int m = edges.size();
  vector<VI> dist(n, VI(n, inf));
  REP(i, 0, m) {
    PI uv = edges[i].first;
    int u = uv.first;
    int v = uv.second;
    dist[u][v] = 1;
    dist[v][u] = 1;
  }
  REP(k, 0, n) {
    REP(i, 0, n) {
      REP(j, 0, n) {
	dist[i][j] = min(dist[i][j], dist[i][k] + dist[k][j]);
      }
    }
  }
  ll ma = -inf;
  int maxi = -1;
  int turns = min(remain - 1, 10);
  REP(i, 0, m) {
    if (edges[i].second != -1) {
      continue;
    }
    edges_cp[i].second = pid;
    ll val = eval_board_playout(n, edges_cp, pid, np, mines_set, dist, turns);
    if (ma < val) {
      ma = val;
      maxi = i;
    }
    edges_cp[i].second = -1;
  }
  eval = ma;
  if (maxi == -1) {
    return PI(-1, -1);
  } else {
    return edges[maxi].first;
  }
}
