#include <set>
#include <iostream>
#include "./mine_connect.hpp"
#include "./eval.hpp"

using namespace std;


std::pair<int, int> mine_connect_solve(int n, const std::vector<PPII> &edges,
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
  vector<VI> dist_free(n, VI(n, inf));
  REP(i, 0, n) {
    dist_free[i][i] = 0;
  }
  REP(i, 0, m) {
    PI uv = edges[i].first;
    int u = uv.first;
    int v = uv.second;
    dist[u][v] = 1;
    dist[v][u] = 1;
    if (edges[i].second == -1) {
      dist_free[u][v] = 1;
      dist_free[v][u] = 1;
    }
    if (edges[i].second == pid) {
      dist_free[u][v] = 0;
      dist_free[v][u] = 0;
    }
  }
  REP(k, 0, n) {
    REP(i, 0, n) {
      REP(j, 0, n) {
	dist[i][j] = min(dist[i][j], dist[i][k] + dist[k][j]);
	dist_free[i][j] = min(dist_free[i][j], dist_free[i][k] + dist_free[k][j]);
      }
    }
  }
  bool mines_connectable = false;
  REP(i, 0, mines.size()) {
    int m1 = mines[i];
    REP(j, 0, mines.size()) {
      int m2 = mines[j];
      if (dist_free[m1][m2] != 0 && dist_free[m1][m2] != inf) {
        mines_connectable = true;
      }
    }
  }
  vector<double> vweight(n);
  REP(i, 0, mines.size()) {
    int mine = mines[i];
    REP(j, 0, n) {
      ll d = dist_free[mine][j];
      vweight[j] += 1.0 / (d * d);
    }
  }
  double orig_val = eval_board_myscore(n, edges, pid, np, mines_set, dist);
  double ma = -inf;
  int maxi = -1;
  REP(i, 0, m) {
    if (edges[i].second != -1) {
      continue;
    }
    edges_cp[i].second = pid;
    PI uv = edges[i].first;
    int u = uv.first;
    int v = uv.second;
    double val = eval_board_myscore(n, edges_cp, pid, np, mines_set, dist);
    // I want to demand at least one of vweight[u] and vweight[v] is infinity
    if (mines_connectable) {
      double wei = 1 / vweight[u] + 1 / vweight[v];
      val = (val - orig_val) / wei + orig_val;
    }
    if (ma < val) {
      ma = val;
      maxi = i;
    }
    edges_cp[i].second = -1;
  }
  eval = ma * 100;
  // cerr << "maxi = " << maxi << endl;
  if (maxi == -1) {
    return PI(-1, -1);
  } else {
    return edges[maxi].first;
  }
}
