#ifndef TBL_IO_HPP
#define TBL_IO_HPP

#include <vector>
#include <string>

void set_hex(int x, std::string &s, int idx, int len = 8);
int read_hex(const std::string &s, int idx, int len);
std::string encode_tbl(const std::vector<int> &tbl);
std::vector<int> decode_tbl(const std::string &s);

#endif
