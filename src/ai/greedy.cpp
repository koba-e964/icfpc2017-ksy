#include <set>
#include "./greedy.hpp"
#include "../UnionFind.cpp"

using namespace std;

int eval_board(int n, const vector<PPII> &edges, int pid, int np, set<int> mines, vector<VI> &dist) {
  int m = edges.size();
  UnionFind uf(n);
  REP(i, 0, m) {
    PI uv = edges[i].first;
    int u = uv.first;
    int v = uv.second;
    if (edges[i].second == pid) {
      uf.unite(u, v);
    }
  }
  int sc = 0;
  REP(i, 0, n) {
    if (mines.count(i) == 0) {
      continue;
    }
    REP(j, 0, n) {
      if (uf.is_same_set(i, j)) {
	sc += dist[i][j] * dist[i][j];
      }
    }
  }
  return sc;
}


std::pair<int, int> greedy_solve(int n, const std::vector<PPII> &edges,
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
  int ma = -inf;
  int maxi = -1;
  REP(i, 0, m) {
    if (edges[i].second != -1) {
      continue;
    }
    edges_cp[i].second = pid;
    int val = eval_board(n, edges_cp, pid, np, mines_set, dist);
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
