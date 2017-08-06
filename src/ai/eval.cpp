#include "./eval.hpp"
#include "../UnionFind.cpp"

using namespace std;

int eval_board_myscore(int n, const vector<PPII> &edges, int pid, int np, set<int> mines, vector<VI> &dist) {
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

