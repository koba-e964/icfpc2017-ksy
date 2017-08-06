#include "tbl_io.hpp"
using namespace std;

#define REP(i,s,n) for(int i=(int)(s);i<(int)(n);i++)

void set_hex(int x, string &s, int idx, int len) {
  char c[17] = "0123456789abcdef";
  REP(i, 0, len) {
    int b = x & 15;
    s[idx + i] = c[b];
    x >>= 4;
  }
}

int read_hex(const string &s, int idx, int len) {
  int v = 0;
  REP(i, 0, len) {
    char c = s[idx + i];
    int d = 0;
    if (c >= '0' && c <= '9') {
      d = c - '0';
    } else {
      d = c - 'a' + 10;
    }
    v |= d << (4 * i);
  }
  return v;
}

string encode_tbl(const vector<int> &tbl) {
  int n = tbl.size();
  string ss(9 * n + 8, '-');
  set_hex(n, ss, 0);
  int pos = 8;
  REP(j, 0, n) {
    int v = tbl[j];
    if (v >= -64 && v <= 63) {
      set_hex(v, ss, pos, 1);
      pos += 1;
    } else {
      set_hex(0x80, ss, pos, 1);
      set_hex(v, ss, pos + 1, 8);
      pos += 9;
    }
  }
  return ss.substr(0, pos);
}

vector<int> decode_tbl(const string &s) {
  int len = read_hex(s, 0, 8);
  vector<int> ret(len);
  int pos = 8;
  REP(i, 0, len) {
    int val = read_hex(s, pos, 1);
    if ((val & 0xff) == 0x80) {
      val = read_hex(s, pos + 1, 8);
      pos += 9;
    } else {
      pos += 1;
    }
    ret[i] = val;
  }
  return ret;
}

