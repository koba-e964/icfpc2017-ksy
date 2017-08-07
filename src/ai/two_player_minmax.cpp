#include <set>
#include <cassert>
#include "./eval.hpp"
#include "./monte_carlo.hpp"
#include "../UnionFind.cpp"
#include <cstdlib>

using namespace std;

static ll eval_board_minmax(int n, std::vector<PPII> &edges, int pid,
		       const set<int> &mines, const vector<VI> &dist, int turns) {
  int m = edges.size();
  if (turns <= 0) {
    return eval_board_myscore(n, edges, pid, 2, mines, dist)
      - eval_board_myscore(n, edges, 1 - pid, 2, mines, dist);
  }
  ll mi = inf;
  REP(j, 0, m) {
    if (edges[j].second != -1) { continue; }
    edges[j].second = pid;
    ll sc = eval_board_minmax(n, edges, 1 - pid, mines, dist, turns - 1);
    mi = min(mi, sc);
    edges[j].second = -1;
  }
  return -mi;
}



std::pair<int, int>
two_player_minmax_solve(int n, const std::vector<PPII> &edges,
			int pid, int np,
			const std::vector<int> &mines,
			int remain, int &turns, int &eval) {
  assert (np == 2);
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
  ll cplx = 1;
  turns = 0;
  while (cplx <= 80000 && turns <= remain) { // Magic number to achieve <= 1.0 sec
    turns += 1;
    cplx *= remain;
  }
  turns -= 2;
  REP(i, 0, m) {
    if (edges[i].second != -1) {
      continue;
    }
    edges_cp[i].second = pid;
    ll val = -eval_board_minmax(n, edges_cp, 1 - pid, mines_set, dist, turns);
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
