#include <iostream>
#include <string>
#include <vector>
#include <iomanip>
#include <sstream>
#include <algorithm>

static std::uint8_t to3bit(std::uint32_t color){
  return static_cast<std::uint8_t>( color >> 5 );
}


int main(int argc, char *argv[])
{
  std::vector<std::string> result;
  static const std::uint32_t colorList[15] = {0x000000,0x3EB849,0x74D07D,0x5955E0,0x8076F1,0xB95E51,0x65DBEF,0xDB6559,0xFF897D,0xCCC35E,0xDED087,0x3AA241,0xB766B5,0xCCCCCC,0xFFFFFF};//MSX COLOR
  for(const std::uint32_t color:colorList ){
    std::stringstream ss;
    const std::uint32_t r {to3bit(( color & 0xff0000 ) >> 16)};
    const std::uint32_t g {to3bit(( color & 0x00ff00 ) >> 8)};
    const std::uint32_t b {to3bit(( color & 0x0000ff ))};
    ss << "\tDEFB 0x"
       << std::setfill('0') << std::setw(1) << std::hex << r
       << std::setfill('0') << std::setw(1) << std::hex << b
       << ", 0x00"
       << std::setfill('0') << std::setw(1) << std::hex << g
       << "; 0x" << std::setfill('0') << std::setw(6) << std::hex << color << std::endl;
    result.emplace_back(ss.str());
  }
  std::reverse(result.begin(), result.end());
  for(const auto &r:result ){
    std::cout << r;
  }
  return 0;

}
