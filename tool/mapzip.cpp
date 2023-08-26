#include <iostream>
#include <fstream>
#include <string>
#include <vector>
#include <algorithm>
#include <memory>
#include <string>
#include <utility>
#include <bitset>
#include <regex>
#include <sstream>

namespace {

constexpr std::size_t MAP_WIDTH=32;
constexpr std::size_t MAP_HEIGHT=22;

static std::string trim(const std::string& str){
  std::regex r{"(^[\\s]+)|([\\s]+$)"};
  return std::regex_replace(str, r, "");
}
/**
 * 1マップのデータ
 */
struct MapData{
  std::string title; //コメント出力
  std::vector<unsigned char> map;
  struct EnemyData{
    unsigned char x;
    unsigned char y;
    unsigned char colorCode;
    std::array<unsigned char,4> sprite; //元データでは4つあるが使うのは1つ
    int move; //敵移動量 9の場合、JUMP
    unsigned char xMax;
    unsigned char yMax;
    unsigned char hp;
    unsigned char str;
    unsigned char exp;
  };
  std::vector<EnemyData> enemyDataList;
  enum class Mode{
    INVISIBLE_WALL, //見えない壁がある
    LAST_BOSS, //ラスボス
    SIZE
  };
  std::bitset<(static_cast<std::size_t>(MapData::Mode::SIZE))> mode = 0;
  struct EventData{
    unsigned char x=0;
    unsigned char y=0;
    enum class ViewType{
      none,//表示なし
      chest,//宝箱
      door,//扉
      fairy,//妖精
    };
    MapData::EventData::ViewType viewType=MapData::EventData::ViewType::none;
    static constexpr unsigned char ITEM_NO_ITEM=0;
    static constexpr unsigned char ITEM_SHIELD=0x80;
    static constexpr unsigned char ITEM_SWORD=0x40;
    static constexpr unsigned char ITEM_KEY=0x20;
    static constexpr unsigned char ITEM_LAMP=0x10;
    static constexpr unsigned char ITEM_HAMMER=0x08;
    static constexpr unsigned char ITEM_MAGICLAMP=0x04;
    static constexpr unsigned char ITEM_FAIRY=0x02;
    unsigned char item=ITEM_NO_ITEM;
    enum class ActionType{
      NoAction,//アクションなし
      GetItem,//アイテム取得
      GetItemNoEnemy,//敵がいない場合アイテム取得
      Password,//パスワード
      Warp,//ワープ
    };
    MapData::EventData::ActionType actionType=MapData::EventData::ActionType::NoAction;
    struct WarpData{//ワープ先
      unsigned char mapId=0;
      unsigned char x=0;
      unsigned char y=0;
      std::string message;
    };
    MapData::EventData::WarpData warpData;
  };
  std::vector<EventData> eventDataList;
};

/**
 * マップデータの書き込み
 */
struct MapWriter{
  virtual void writeMapData(const std::vector<unsigned char>& map,std::ofstream& ofs)=0;
};


/**
 * マップデータの管理
 */
class MapManager{
  std::vector<MapData> mapDataList_;
  unsigned char toByte(const std::string& str,std::size_t index) const;
  unsigned char toInt(const std::string& str,std::size_t index) const;
  unsigned char toMSXChar(std::int64_t a) const;
public:
  MapManager() : mapDataList_{} {}
  void read(const char *filename );
  void write(const char *mapTblFileName,const char *mapDataFileName,MapWriter& mapWriter) const;
};

unsigned char MapManager::toByte(const std::string& str,std::size_t index) const{
  return static_cast<unsigned char>(std::stoi(str.substr(index,2) , nullptr, 16));
}
unsigned char MapManager::toInt(const std::string& str,std::size_t index) const{
  return std::stoi(str.substr(index,2));
}

/**
 * ユニコードをMSXのキャラクターコードに変換
 */
unsigned char MapManager::toMSXChar(std::int64_t a) const{
  static std::int64_t toMSXCharList[256] = {
    0x00,0x01,0x02,0x03, 0x04,0x05,0x06,0x07, 0x08,0x09,0x0a,0x0b, 0x0c,0x0d,0x0e,0x0f,
    0x10,0x11,0x12,0x13, 0x14,0x15,0x16,0x17, 0x18,0x19,0x1a,0x1b, 0x1c,0x1d,0x1e,0x1f,
    0x20,0x21,0x22,0x23, 0x24,0x25,0x26,0x27, 0x28,0x29,0x2a,0x2b, 0x2c,0x2d,0x2e,0x2f,
    0x30,0x31,0x32,0x33, 0x34,0x35,0x36,0x37, 0x38,0x39,0x3a,0x3b, 0x3c,0x3d,0x3e,0x3f,
    0x40,0x41,0x42,0x43, 0x44,0x45,0x46,0x47, 0x48,0x49,0x4a,0x4b, 0x4c,0x4d,0x4e,0x4f,
    0x50,0x51,0x52,0x53, 0x54,0x55,0x56,0x57, 0x58,0x59,0x5a,0x5b, 0x5c,0x5d,0x5e,0x5f,
    0x60,0x61,0x62,0x63, 0x64,0x65,0x66,0x67, 0x68,0x69,0x6a,0x6b, 0x6c,0x6d,0x6e,0x6f,
    0x70,0x71,0x72,0x73, 0x74,0x75,0x76,0x77, 0x78,0x79,0x7a,0x7b, 0x7c,0x7d,0x7e,0x7f,
    0x2660,0x2665,0x2663,0x2666, 0x25CB,0x25CF,0x3092,0x3041, 0x3043,0x3045,0x3047,0x3049, 0x3083,0x3085,0x3087,0x3063,
    0x0000,0x3042,0x3044,0x3046, 0x3048,0x304A,0x304B,0x304D, 0x304F,0x3051,0x3053,0x3055, 0x3057,0x3059,0x305B,0x305D,

    0x0000,0x3002,0x300c,0x300d, 0x3001,0x30fb,0x30F2,0x30A1, 0x30A3,0x30A5,0x30A7,0x30A9, 0x30E3,0x30E5,0x30E7,0x30C3,
    0x30FC,0x30A2,0x30A4,0x30A6, 0x30A8,0x30AA,0x30AB,0x30AD, 0x30AF,0x30B1,0x30B3,0x30B5, 0x30B5,0x30B9,0x30BB,0x30BD,

    0x30BF,0x30C1,0x30C4,0x30C6, 0x30C8,0x30CA,0x30CB,0x30CC, 0x30CD,0x30CD,0x30CD,0x30CD, 0x30D5,0x30D5,0x30DB,0x30DE,
    0x30DE,0x30E0,0x30E0,0x30E0, 0x30E0,0x30E6,0x30E6,0x30E9, 0x30EA,0x30EA,0x30EA,0x30EA, 0x30EA,0x30F3,0x309B,0x309C,
    0x305F,0x3061,0x3064,0x3066, 0x3068,0x306A,0x306B,0x306C, 0x306D,0x306E,0x306F,0x3072, 0x3075,0x3078,0x307B,0x307E,
    0x307F,0x3080,0x3081,0x3082, 0x3084,0x3086,0x3088,0x3089, 0x308A,0x308B,0x308C,0x308D, 0x308F,0x308F,0x0000,0x0000,
  };
  auto it = std::find(std::begin(toMSXCharList), std::end(toMSXCharList), a);
  if( it==std::end(toMSXCharList) ){
    return 0;
  }
  return std::distance(std::begin(toMSXCharList), it);
}

void MapManager::read(const char *filename ){
  std::ifstream ifs{ filename ,std::ios_base::in | std::ios_base::binary };
  std::string line;
  enum class ReadMode{ None,Title,Map,Enemy,Mode,Event };
  ReadMode readMode{ ReadMode::None };
  MapData mapData;
  while (std::getline(ifs, line)){
    line = trim(line);
    if( line.empty() ){
      continue;
    }
    if( line[0]==';' ){
      if (line.find(";title") != std::string::npos) {
        readMode=ReadMode::Title;
        if( !mapData.map.empty() ){
          mapDataList_.emplace_back(mapData);
        }
        mapData.title = line.substr(6);
        mapData.map.clear();
        mapData.enemyDataList.clear();
        mapData.mode = 0;
        mapData.eventDataList.clear();
      }else
      if (line == ";map") {
        readMode=ReadMode::Map;
      }else
      if (line == ";enemy") {
        readMode=ReadMode::Enemy;
      }else
      if (line == ";mode") {
        readMode=ReadMode::Mode;
      }else
      if (line == ";event") {
        readMode=ReadMode::Event;
      }
      continue;
    }
    if( readMode==ReadMode::Map ){
      //mapデータをmapData.mapに入れる
      std::int64_t a{ 0 };
      int restByte{0}; //マルチバイトの2バイト目以降(残りバイト数)
      for( auto it=std::begin(line);it<std::end(line);++it ){
        unsigned char c{ static_cast<unsigned char>(*it) };
        if( 0<restByte ){
          //マルチバイトの2バイト目以降
          a=( a << 6 ) + (c & 0x3f);
          --restByte;
          if( restByte==0 ){
            mapData.map.emplace_back(toMSXChar(a));
            a=0;
          }
        }else
        if( c<=0x7f ){
          //1バイト
          if( 32<=c ){
            mapData.map.emplace_back(c);
          }
          a=0;
          restByte=0;
        }else{
          //マルチバイトの1バイト目
          a=0;
          restByte=0;
          unsigned char check{ 0x80 };
          while( (c & check)!=0 ){
            check = check >> 1;
            restByte++;
          }
          --check;
          a=(c & check);
          --restByte;
        }
      }
    }else
    if( readMode==ReadMode::Enemy ){
      if('0'<=line[0]){
        //敵データを設定する
        std::vector<MapData::EnemyData> e;
        const std::size_t enemyCount{ static_cast<std::size_t>(line[0]-'0') };
        for(std::size_t i=0;i<enemyCount;++i){
          mapData.enemyDataList.emplace_back(MapData::EnemyData{
            toInt(line,i*27+1),//x
            toInt(line,i*27+3),//y
            toInt(line,i*27+5),//colorCode
            { toInt(line,i*27+7),toInt(line,i*27+9),toInt(line,i*27+11),toInt(line,i*27+13), },//sprite
            toInt(line,i*27+15),//move
            toInt(line,i*27+17),//xMax
            toInt(line,i*27+19),//yMax
            toByte(line,i*27+21),//hp
            toByte(line,i*27+23),//str
            toByte(line,i*27+25),//exp
          });
        }
      }
    }else
    if( readMode==ReadMode::Mode ){
      if (line == "invisible_wall") {
        mapData.mode.set(static_cast<std::size_t>(MapData::Mode::INVISIBLE_WALL));
      }
      if (line == "last_boss") {
        mapData.mode.set(static_cast<std::size_t>(MapData::Mode::LAST_BOSS));
      }
    }else
    if( readMode==ReadMode::Event ){
      MapData::EventData eventData;
      const std::regex r{
        R"(([0-9]+)\s*,\s*([0-9]+))" //x,y 
        R"(\s*,\s*((none)|(chest)|(door)|(fairy)))" //ViewType
        R"(\s*,\s*((NO_ITEM)|(SHIELD)|(SWORD)|(KEY)|(LAMP)|(HAMMER)|(MAGICLAMP)|(FAIRY)))" //item
        R"(\s*,\s*((NoAction)|(GetItem)|(GetItemNoEnemy)|(Password)|(Warp\s+([0-9]+)\s+([0-9]+)\s+([0-9]+)\s+([0-9]+))))" //ActionType
      };
      std::smatch m;
      if(!std::regex_match(line, m, r)) {
        throw std::runtime_error(std::string("EventData Error:")+line);
      }
      {
        int v{ std::stoi(m.str(1)) };
        if( v<0 || 255<v ){
          throw std::runtime_error(std::string("EventData Error:")+line);
        }
        eventData.x = static_cast<unsigned char>(v);
      }
      {
        int v{ std::stoi(m.str(2)) };
        if( v<0 || 255<v ){
          throw std::runtime_error(std::string("EventData Error:")+line);
        }
        eventData.y = static_cast<unsigned char>(v);
      }
      {
        for(std::size_t i=0;i<4;++i){
          if( m.length(4+i) ){
            eventData.viewType = static_cast<MapData::EventData::ViewType>(i);
            break;
          }
        }
      }
      {
        static constexpr unsigned char ITEM_LIST[] = {
          MapData::EventData::ITEM_NO_ITEM,
          MapData::EventData::ITEM_SHIELD,
          MapData::EventData::ITEM_SWORD,
          MapData::EventData::ITEM_KEY,
          MapData::EventData::ITEM_LAMP,
          MapData::EventData::ITEM_HAMMER,
          MapData::EventData::ITEM_MAGICLAMP,
          MapData::EventData::ITEM_FAIRY,
        };
        for(std::size_t i=0;i<sizeof(ITEM_LIST)/sizeof(ITEM_LIST[0]);++i){
          if( m.length(9+i) ){
            eventData.item = ITEM_LIST[i];
            break;
          }
        }
      }
      {
        for(std::size_t i=0;i<5;++i){
          if( m.length(18+i) ){
            eventData.actionType = static_cast<MapData::EventData::ActionType>(i);
            if( i==4 ){ //ワープ
              eventData.warpData.mapId = std::stoi(m.str(23))+std::stoi(m.str(24))*4;
              eventData.warpData.x = std::stoi(m.str(25));
              eventData.warpData.y = std::stoi(m.str(26));
              {
                std::stringstream  ss;
                ss << '(' << mapDataList_.size() << ',' << static_cast<int>(eventData.x) << ',' << static_cast<int>(eventData.y) << ") -> ";
                ss << '(' << static_cast<int>(eventData.warpData.mapId) << ',' << static_cast<int>(eventData.warpData.x) << ',' << static_cast<int>(eventData.warpData.y) << ')';
                eventData.warpData.message = ss.str();
              }
              if( eventData.warpData.mapId<0 || 12<eventData.warpData.mapId
                || eventData.warpData.x<0 || 255<eventData.warpData.x
                || eventData.warpData.y<0 || 255<eventData.warpData.y ){
                throw std::runtime_error(std::string("EventData Error:")+line);
              }
            }
            break;
          }
        }
      }
      if( eventData.viewType==MapData::EventData::ViewType::none && eventData.actionType==MapData::EventData::ActionType::NoAction ){
        throw std::runtime_error(std::string("EventData Error:")+line);
      }
      mapData.eventDataList.emplace_back(eventData);
    }
  }
  mapDataList_.emplace_back(mapData);
}

void MapManager::write(const char *mapTblFileName,const char *mapDataFileName,MapWriter& mapWriter) const{
  std::vector<MapData::EventData::WarpData> warpData;
  {
    //
    std::ofstream ofs{ mapDataFileName, std::ios_base::out };
    for(std::size_t i=0;i<mapDataList_.size();++i){
      const MapData& mapData{ mapDataList_[i] };
      ofs << ";;;;;;;;;;;; MAP DATA " << i << " ;;;;;;;;;" << std::endl;
      ofs << ";" << mapData.title << std::endl;

      {
        // enemyData
        ofs << std::endl;
        constexpr std::size_t ENEMY_SIZE = 14;
        ofs << "\tDEFB " << mapData.enemyDataList.size() << " ;ENEMY_COUNT" << std::endl;
        for(const auto &enemyData: mapData.enemyDataList){
          ofs << "\tDEFB " << static_cast<int>(enemyData.str) << " ;str" << std::endl;
          ofs << "\tDEFB " << static_cast<int>(enemyData.exp) << " ;exp" << std::endl;
          ofs << "\tDEFB " << static_cast<int>(enemyData.hp) << " ;hp" << std::endl;
          ofs << "\tDEFB " << 0 << " ;無敵カウント" << std::endl;
          ofs << "\tDEFB " << static_cast<int>(enemyData.y)*8-1 << " ;y" << std::endl;
          ofs << "\tDEFB " << static_cast<int>(enemyData.x)*8+8 << " ;x" << std::endl;
          ofs << "\tDEFB " << (static_cast<int>(enemyData.sprite[0]) & 0xfc )*4 << " ;sprite" << std::endl; //元プラグラムとスプライトパターンの番号が異なる
          ofs << "\tDEFB " << static_cast<int>(enemyData.colorCode) << " ;colorCode" << std::endl;
          int move{0};
          if( enemyData.move==9 ){
            //Jump
            move=4;
          }else
          if( enemyData.move!=0 ){
            move = 2+(127<enemyData.move ? 1 : 0);
          }
          ofs << "\tDEFB " << move << " ;Move" << std::endl;
          ofs << "\tDEFB " << 0 << " ;JumpCount" << std::endl;
          ofs << "\tDEFB " << static_cast<int>(enemyData.yMax)*8-1 << " ;yMax" << std::endl;
          ofs << "\tDEFB " << static_cast<int>(enemyData.xMax)*8 << " ;xMax" << std::endl;
          ofs << "\tDEFB " << static_cast<int>(enemyData.y)*8-1 << " ;yMin" << std::endl;
          ofs << "\tDEFB " << static_cast<int>(enemyData.x)*8 << " ;xMin" << std::endl;
        }
        ofs << "\tDEFB " << (mapData.enemyDataList.size()*ENEMY_SIZE+1)+1 << " ;enemy data size" << std::endl; //コピーするサイズ+1
        ofs << std::endl;
      }
      ofs << "MAP_" << i << "::" << std::endl;
      {
        //mode
        ofs << "\tDEFB " << static_cast<int>(mapData.mode.to_ulong()) << " ;mode" << std::endl;
      }
      {
        //eventData
        ofs << std::endl;
        for(const auto &eventData: mapData.eventDataList){
          int v{ static_cast<int>(eventData.viewType)*0x40 + static_cast<int>(eventData.actionType) };
          if( eventData.actionType==MapData::EventData::ActionType::Warp ){
            v += warpData.size();
            warpData.emplace_back(eventData.warpData);
          }
          ofs << "\tDEFB " << v << " ;event" << std::endl;
          ofs << "\tDEFB " << static_cast<int>(eventData.item) << " ;item" << std::endl;
          ofs << "\tDEFB " << static_cast<int>(eventData.x)*8 << " ;x" << std::endl;
          ofs << "\tDEFB " << static_cast<int>(eventData.y)*8-1 << " ;y" << std::endl;
        }
        ofs << "\tDEFB " << 0 << " ;end of eventData" << std::endl;
      }
      {
        //map
        ofs << std::endl;
        mapWriter.writeMapData(mapData.map,ofs);
      }
      ofs << std::endl;
    }
  }
  {
    //dest.map.tblに出力
    std::ofstream ofstbl{ mapTblFileName, std::ios_base::out };
    ofstbl << "MAP_LIST::" << std::endl << "\tDEFW";
    for(std::size_t i=0;i<mapDataList_.size();++i){
      if( i!=0 ){
        ofstbl << ',';
      }
      ofstbl << " MAP_" << i;
    }
    ofstbl << std::endl;

    ofstbl << "WARP_LIST::" << std::endl;
    ofstbl << " ;mapId,y,x" << std::endl;
    for(const auto &d:warpData){
      ofstbl << " DEFB " << static_cast<int>(d.mapId) << ',' << static_cast<int>(d.y)*8-1 << ',' << static_cast<int>(d.x)*8 <<" ;" << d.message << std::endl;
    }
  }
}

/**
 * マップ未圧縮
 */
class MapWriterRaw : public MapWriter{
private:
public:
  MapWriterRaw() {}
  void writeMapData(const std::vector<unsigned char>& map,std::ofstream& ofs) override;
};

void MapWriterRaw::writeMapData(const std::vector<unsigned char>& map,std::ofstream& ofs) {
  ofs << "\tDEFB ";
  bool is1st{true};
  for( const unsigned char c:map){
    if( !is1st ){
      ofs << ',';
    }
    ofs << static_cast<int>(c);
    is1st=false;
  }
  ofs << std::endl;
}


/**
 * マップ ランレングス圧縮
 */
class MapWriterZipRunLength : public MapWriter{
private:
  void out_(std::ofstream& ofs,bool is1st,int nowMsxChar,std::size_t sameCount);
public:
  MapWriterZipRunLength() {}
  void writeMapData(const std::vector<unsigned char>& map,std::ofstream& ofs) override;
};

void MapWriterZipRunLength::out_(std::ofstream& ofs,bool is1st,int nowMsxChar,std::size_t sameCount) {
  if( sameCount==0){
    return;
  }
  if( is1st ){
    ofs << "\tDEFB ";
  }else{
    ofs << " ,";
  }
  if( sameCount<=2){
    ofs << nowMsxChar;
    out_(ofs,false,nowMsxChar,sameCount-1);
  }else
  if( sameCount<=90+2 ){
    ofs << (sameCount-2) <<',' << nowMsxChar;
  }else{
    ofs << 90 <<',' << nowMsxChar;
    out_(ofs,false,nowMsxChar,sameCount-92);
  }
}

void MapWriterZipRunLength::writeMapData(const std::vector<unsigned char>& map,std::ofstream& ofs) {
  int nowMsxChar=static_cast<int>(map[0]);
  std::size_t sameCount{1};
  bool is1st{true};
  for(std::size_t j=1;j<map.size();++j){
    int nextMsxChar=static_cast<int>(map[j]);
    if( nowMsxChar==nextMsxChar ){
      ++sameCount;
    }else{
      out_(ofs,is1st,nowMsxChar,sameCount);
      sameCount=1;
      is1st=false;
    }
    nowMsxChar=nextMsxChar;
  }
  out_(ofs,is1st,nowMsxChar,sameCount);
  ofs << std::endl;
}

}

int main(int argc, char *argv[])
{
  bool isHelp{false};
  try {
    if( argc!=5 ){
      isHelp=true;
    }else{
      std::unique_ptr<MapWriter> mapWriter{nullptr};
      if( std::string("raw")==argv[4] ){
        //マップ未圧縮
        mapWriter=std::make_unique<MapWriterRaw>();
      }else
      if( std::string("run-length")==argv[4] ){
        //マップランレングス圧縮
        mapWriter=std::make_unique<MapWriterZipRunLength>();
      }
      if( mapWriter==nullptr ){
        throw std::runtime_error("mode Error");
      }
      MapManager mapManager;
      mapManager.read(argv[1]);
      mapManager.write( argv[2], argv[3],*mapWriter ); //dest.map.tbl,dest.map.dataに出力
    }
  } catch ( std::runtime_error &e){
    std::cerr << e.what() << std::endl;
    isHelp=true;
  } catch (...) {
    std::cerr << "例外が発生しました" << std::endl;
    isHelp=true;
  }
  if(isHelp){
    std::cerr << argv[0] << " <src.map> <dest.map.tbl> <dest.map.data> <mode>" << std::endl;
    return 1;
  }
  return 0;

}
