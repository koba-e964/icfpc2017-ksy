#include <algorithm>
#include <cassert>
#include <iostream>
#include <string>
#include <vector>
#include <cstdlib>
#include "./common.hpp"
#include "./tbl_io.hpp"
#include "./ai/exact.hpp"
#include "./ai/greedy.hpp"
#include "./ai/monte_carlo.hpp"
#include "./ai/mine_connect.hpp"
#include "./ai/two_player_minmax.hpp"

using namespace std;


int main(void) {
  ios::sync_with_stdio(false);
  cin.tie(0);
  int n, m, k, pid, np, rem;
  cin >> n >> m >> k >> pid >> np >> rem;
  srand(time(0));
  vector<PPII> edges(m);
  REP(i, 0, m) {
    int s, t, c;
    cin >> s >> t >> c;
    edges[i] = PPII(PI(s, t), c);
  }
  VI mines(k);
  REP(i, 0, k) {
    cin >> mines[i];
  }
  string mode;
  cin >> mode;
  if (np == 2 && m <= 12) {
    int mbits = 0;
    REP(i, 0, k) {
      mbits |= 1 << mines[i];
    }
    if (mode == "setup") {
      cerr << "setup..." << endl;
      vector<VI> tbl = exact_solve_setup(n, edges, mbits);
      cerr << "tbl ready" << endl;
      VI comp;
      REP(i, 0, 1 << (2 * m)) {
	int cc = __builtin_popcount(i);
	int s1 = i >> m;
	int s2 = i & ((1 << m) - 1);
	if (cc <= m && (s1 & s2) == 0) {
	  comp.push_back(tbl[m - cc][i]);
	}
      }
      string encode = encode_tbl(comp);
      cerr << "tbl_len = " << encode.length() << endl;
      cout << "tbl " << encode << endl;
      return 0;
    }
    string tbl;
    cin >> tbl;
    string ai_kind;
    cin >> ai_kind;
    VI pre_dp = decode_tbl(tbl);
    int pos = 0;
    VI dp(1 << (2 * m), -inf);
    REP(i, 0, 1 << (2 * m)) {
	int cc = __builtin_popcount(i);
	int s1 = i >> m;
	int s2 = i & ((1 << m) - 1);
	if (cc <= m && (s1 & s2) == 0) {
	  dp[i] = pre_dp[pos];
	  pos++;
	}
    }
    cerr << "tbl loaded" << endl;
    int value;
    PI res = exact_solve(n, edges, dp, pid, np, mbits, rem, value);
    cout << "info eval -1 " << value << endl;
    if (res.first == -1) {
      cout << "pass\n";
    } else {
      cout << "claim " << res.first << " " << res.second << "\n";
    }
    return 0;
  }
  if (mode == "setup") {
    // Do nothing
    cout << "tbl bigCase" << endl;
    return 0;
  }
  string tbl;
  cin >> tbl;
  string ai_kind;
  cin >> ai_kind;
  int value;
  int turns = 1;
  PI move;
  if (ai_kind == "greedy") {
    move = greedy_solve(n, edges, pid, np, mines, rem, value);
  } else if (ai_kind == "monte_carlo") {
    move = monte_carlo_solve(n, edges, pid, np, mines, rem, value);
  } else if (ai_kind == "mine_connect") {
    move = mine_connect_solve(n, edges, pid, np, mines, rem, value);
  } else if (ai_kind == "two_player_minmax") {
    move = two_player_minmax_solve(n, edges, pid, np, mines, rem, turns, value);
  } else {
    exit(1);
  }
  cout << "info eval " << turns << " " << value << endl;
  if (move.first == -1) {
    cout << "pass" << endl;
  } else {
    cout << "claim " << move.first << " " << move.second << endl;
  }
}
