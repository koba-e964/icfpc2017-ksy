#include <vector>
#include <cassert>
#include "./exact.hpp"
#include "../UnionFind.cpp"
using namespace std;
#define REP(i,s,n) for(int i=(int)(s);i<(int)(n);i++)

const int inf = 1e8;

int eval_board(int n, const vector<PPII> &edges, int s1, int s2, int mbits, vector<VI> &dist) {
  int m = edges.size();
  UnionFind uf1(n), uf2(n);
  REP(i, 0, m) {
    PI uv = edges[i].first;
    int u = uv.first;
    int v = uv.second;
    if (s1 & 1 << i) {
      uf1.unite(u, v);
    }
    if (s2 & 1 << i) {
      uf2.unite(u, v);
    }
  }
  int sc1 = 0;
  int sc2 = 0;
  REP(i, 0, n) {
    if ((mbits & 1 << i) == 0) {
      continue;
    }
    REP(j, 0, n) {
      if (uf1.is_same_set(i, j)) {
	sc1 += dist[i][j] * dist[i][j];
      }
      if (uf2.is_same_set(i, j)) {
	sc2 += dist[i][j] * dist[i][j];
      }
    }
  }
  return sc1 - sc2;
}

PI exact_solve(int n, const vector<PPII> &edges, const VI &dp, int pid, int np,
	       int mbits, int remain, int &eval) {
  int m = edges.size();
  assert (np == 2);
  assert (remain >= 1);
  assert (remain <= m);
  int s1 = 0, s2 = 0;
  REP(i, 0, m) {
    int c = edges[i].second;
    if (c == 0) {
      s1 |= 1 << i;
    } else if (c == 1) {
      s2 |= 1 << i;
    }
  }
  int ma = -inf;
  int maxi = -1;
  if (pid == 0) {
    REP(i, 0, m) {
      if ((s1 | s2) & 1 << i) { continue; }
      int t = dp[(s1 | 1 << i) << m | s2];
      if (ma < -t) {
	ma = -t;
	maxi = i;
      }
    }
  } else {
    REP(i, 0, m) {
      if ((s1 | s2) & 1 << i) { continue; }
      int t = dp[s1 << m | s2 | 1 << i];
      if (ma < -t) {
	ma = -t;
	maxi = i;
      }
    }
  }
  eval = ma;
  if (maxi == -1) {
    return PI(-1, -1);
  }
  return edges[maxi].first;
}


vector<VI> exact_solve_setup(int n, const vector<PPII> &edges,
	       int mbits) {
  int m = edges.size();
  vector<VI> dp(m + 1, VI(1 << (2 * m), -1));
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
  REP(qqq, 0, m + 1) {
    REP(s1, 0, 1 << m) {
      int rest = (1 << m) - s1;
      for (int s2 = rest; true; s2 = (s2 - 1) & rest) {
	if (s1 & s2) {
	  continue;
	}
	if (__builtin_popcount(s1 | s2) != m - qqq) {
	  if (s2 == 0) {
	    break;
	  } else {
	    continue;
	  }
	}
	int cur_id = (m - qqq) % 2;
	if (qqq == 0) {
	  int val = eval_board(n, edges, s1, s2, mbits, dist);
	  if (cur_id == 1) {
	    val = -val;
	  }
	  dp[qqq][s1 << m | s2] = val;
	} else {
	  int ma = -inf;
	  if (cur_id == 0) {
	    REP(i, 0, m) {
	      if ((s1 | s2) & 1 << i) { continue; }
	      int t = dp[qqq - 1][(s1 | 1 << i) << m | s2];
	      ma = max(ma, -t);
	    }
	  } else {
	    REP(i, 0, m) {
	      if ((s1 | s2) & 1 << i) { continue; }
	      int t = dp[qqq - 1][s1 << m | s2 | 1 << i];
	      ma = max(ma, -t);
	    }
	  }
	  dp[qqq][s1 << m | s2] = ma;
	}
	if (s2 == 0) {
	  break;
	}
      }
    }
  }
  return dp;
}
