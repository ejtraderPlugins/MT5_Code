//+------------------------------------------------------------------+
//|                                              TradeAlgorithms.mqh |
//|                               Copyright ?2013, Nikolay Kositsin |
//|                              Khabarovsk,   farria@mail.redcom.ru | 
//+------------------------------------------------------------------+ 
//| 翌疸钼 嚯泐痂蜢?潆 狃铌屦钼 镳邃豚汔桴 礤 眢脲忸?耧疱?   |
//+------------------------------------------------------------------+ 
#property copyright "2013,   Nikolay Kositsin"
#property link      "farria@mail.redcom.ru"
#property version   "1.21"
//+------------------------------------------------------------------+
//|  襄疱麒耠屙桢 潆 忄痂囗蝾?疣聍蛤?腩蜞                         |
//+------------------------------------------------------------------+
enum MarginMode //诣?觐眈蜞眚?潆 镥疱戾眄铋 Margin_Mode 蝾疸钼 趔黻鲨?
  {
   FREEMARGIN=0,     //MM 铗 疋钺钿睇?耩邃耱?磬 聍蛤?
   BALANCE,          //MM 铗 徉豚眈?耩邃耱?磬 聍蛤?
   LOSSFREEMARGIN,   //MM 镱 筢赅?铗 疋钺钿睇?耩邃耱?磬 聍蛤?
   LOSSBALANCE,      //MM 镱 筢赅?铗 徉豚眈?耩邃耱?磬 聍蛤?
   LOT               //祟?徨?桤戾礤龛
  };
//+------------------------------------------------------------------+
//|  离泐痂蜢 铒疱溴脲龛 祛戾眚?镱怆屙? 眍忸泐 徉疣              |
//+------------------------------------------------------------------+  
class CIsNewBar
  {
   //----
public:
   //---- 趔黻鲨 铒疱溴脲龛 祛戾眚?镱怆屙? 眍忸泐 徉疣
   bool IsNewBar(string symbol,ENUM_TIMEFRAMES timeframe)
     {
      //---- 镱塍麒?怵屐 镱怆屙? 蝈牦泐 徉疣
      datetime TNew=datetime(SeriesInfoInteger(symbol,timeframe,SERIES_LASTBAR_DATE));

      if(TNew!=m_TOld && TNew) // 镳钼屦赅 磬 镱怆屙桢 眍忸泐 徉疣
        {
         m_TOld=TNew;
         return(true); // 镱忤腭 眍恹?徉?
        }
      //----
      return(false); // 眍恹?徉痤?镱赅 礤?
     };

   //---- 觐眈蝠箨蝾?觌囫襦    
                     CIsNewBar(){m_TOld=-1;};

protected: datetime m_TOld;
   //---- 
  };
//+==================================================================+
//| 离泐痂蜢?潆 蝾疸钼 铒屦圉栝                                  |
//+==================================================================+

//+------------------------------------------------------------------+
//| 悟牮噱?潆桧眢?镱玷鲨?                                       |
//+------------------------------------------------------------------+
bool BuyPositionOpen
(
 bool &BUY_Signal,           // 綦嚆 疣琊屮屙? 磬 皲咫牦
 const string symbol,        // 蝾疸钼? 镟疣 皲咫觇
 const datetime &TimeLevel,  // 怵屐, 镱耠?觐蝾痤泐 狍溴?铖簌羼蜮脲磬 耠邃簌? 皲咫赅 镱耠?蝈牦?
 double Money_Management,    // MM
 int Margin_Mode,            // 耧铖钺 疣聍蛤?忮腓麒睇 腩蜞
 uint deviation,             // 耠栾镟?
 int StopLoss,               // 耱铒腩耨 ?矬黻蜞?
 int Takeprofit              // 蝈殛镳铘栩 ?矬黻蜞?
 )
//BuyPositionOpen(BUY_Signal,symbol,TimeLevel,Money_Management,deviation,Margin_Mode,StopLoss,Takeprofit);
  {
//----
   if(!BUY_Signal) return(true);

   ENUM_POSITION_TYPE PosType=POSITION_TYPE_BUY;
//---- 橡钼屦赅 磬 桉蝈麇龛?怵屐屙眍泐 腓扈蜞 潆 镳邃簌彘 皲咫觇 ?镱腠铗?钺爨
   if(!TradeTimeLevelCheck(symbol,PosType,TimeLevel)) return(true);

//---- 橡钼屦赅 磬 磬 磬腓麒?铗牮铋 镱玷鲨?
   if(PositionSelect(symbol)) return(true);

//----
   double volume=BuyLotCount(symbol,Money_Management,Margin_Mode,StopLoss,deviation);
   if(volume<=0)
     {
      //Print(__FUNCTION__,"(): 湾忮痦 钺?潆 耱痼牝箴?蝾疸钼钽?玎镳铖?);
      return(false);
     }

//---- 吾?怆屙桢 耱痼牝箴 蝾疸钼钽?玎镳铖??疱珞朦蜞蜞 蝾疸钼钽?玎镳铖?
   MqlTradeRequest request;
   MqlTradeResult result;
//---- 吾?怆屙桢 耱痼牝箴?疱珞朦蜞蜞 镳钼屦觇 蝾疸钼钽?玎镳铖?
   MqlTradeCheckResult check;

//---- 钺眢脲龛?耱痼牝箴
   ZeroMemory(request);
   ZeroMemory(result);
   ZeroMemory(check);

   long digit;
   double point,Ask;
//----   
   if(!SymbolInfoInteger(symbol,SYMBOL_DIGITS,digit)) return(true);
   if(!SymbolInfoDouble(symbol,SYMBOL_POINT,point)) return(true);
   if(!SymbolInfoDouble(symbol,SYMBOL_ASK,Ask)) return(true);

//---- 软桷栲腓玎鲨 耱痼牝箴?蝾疸钼钽?玎镳铖?MqlTradeRequest 潆 铗牮囗? BUY 镱玷鲨?
   request.type   = ORDER_TYPE_BUY;
   request.price  = Ask;
   request.action = TRADE_ACTION_DEAL;
   request.symbol = symbol;
   request.volume = volume;

//---- 物疱溴脲龛?疣耨蝾龛 漕 耱铒腩耨??邃桧桷圊 鲥眍忸泐 沭圄桕?
   if(StopLoss)
     {
      if(!StopCorrect(symbol,StopLoss))return(false);
      double dStopLoss=StopLoss*point;
      request.sl=NormalizeDouble(request.price-dStopLoss,int(digit));
     }
   else request.sl=0.0;

//---- 物疱溴脲龛?疣耨蝾龛 漕 蝈殛镳铘栩?邃桧桷圊 鲥眍忸泐 沭圄桕?
   if(Takeprofit)
     {
      if(!StopCorrect(symbol,Takeprofit))return(false);
      double dTakeprofit=Takeprofit*point;
      request.tp=NormalizeDouble(request.price+dTakeprofit,int(digit));
     }
   else request.tp=0.0;

//----
   request.deviation=deviation;
   request.type_filling=ORDER_FILLING_FOK;

//---- 橡钼屦赅 蝾疸钼钽?玎镳铖?磬 觐痧尻蝽铖螯
   if(!OrderCheck(request,check))
     {
      Print(__FUNCTION__,"(): 湾忮痦 溧眄 潆 耱痼牝箴?蝾疸钼钽?玎镳铖?");
      Print(__FUNCTION__,"(): OrderCheck(): ",ResultRetcodeDescription(check.retcode));
      return(false);
     }

   string comment="";
   StringConcatenate(comment,"<<< ============ ",__FUNCTION__,"(): 悟牮噱?Buy 镱玷鲨?镱 ",symbol," ============ >>>");
   Print(comment);

//---- 悟牮噱?BUY 镱玷鲨??溴豚屐 镳钼屦牦 疱珞朦蜞蜞 蝾疸钼钽?玎镳铖?
   if(!OrderSend(request,result) || result.retcode!=TRADE_RETCODE_DONE)
     {
      Print(__FUNCTION__,"(): 湾忸珈铈眍 耦忮瘌栩?皲咫牦!");
      Print(__FUNCTION__,"(): OrderSend(): ",ResultRetcodeDescription(result.retcode));
      return(false);
     }
   else
   if(result.retcode==TRADE_RETCODE_DONE)
     {
      TradeTimeLevelSet(symbol,PosType,TimeLevel);
      BUY_Signal=false;
      comment="";
      StringConcatenate(comment,"<<< ============ ",__FUNCTION__,"(): Buy 镱玷鲨 镱 ",symbol," 铗牮?============ >>>");
      Print(comment);
      PlaySound("ok.wav");
     }
   else
     {
      Print(__FUNCTION__,"(): 湾忸珈铈眍 耦忮瘌栩?皲咫牦!");
      Print(__FUNCTION__,"(): OrderSend(): ",ResultRetcodeDescription(result.retcode));
     }
//----
   return(true);
  }
//+------------------------------------------------------------------+
//| 悟牮噱?觐痤蜿簋 镱玷鲨?                                      |
//+------------------------------------------------------------------+
bool SellPositionOpen
(
 bool &SELL_Signal,          // 綦嚆 疣琊屮屙? 磬 皲咫牦
 const string symbol,        // 蝾疸钼? 镟疣 皲咫觇
 const datetime &TimeLevel,  // 怵屐, 镱耠?觐蝾痤泐 狍溴?铖簌羼蜮脲磬 耠邃簌? 皲咫赅 镱耠?蝈牦?
 double Money_Management,    // MM
 int Margin_Mode,            // 耧铖钺 疣聍蛤?忮腓麒睇 腩蜞
 uint deviation,             // 耠栾镟?
 int StopLoss,               // 耱铒腩耨 ?矬黻蜞?
 int Takeprofit              // 蝈殛镳铘栩 ?矬黻蜞?
 )
//SellPositionOpen(SELL_Signal,symbol,TimeLevel,Money_Management,deviation,Margin_Mode,StopLoss,Takeprofit);
  {
//----
   if(!SELL_Signal) return(true);

   ENUM_POSITION_TYPE PosType=POSITION_TYPE_SELL;
//---- 橡钼屦赅 磬 桉蝈麇龛?怵屐屙眍泐 腓扈蜞 潆 镳邃簌彘 皲咫觇 ?镱腠铗?钺爨
   if(!TradeTimeLevelCheck(symbol,PosType,TimeLevel)) return(true);

//---- 橡钼屦赅 磬 磬 磬腓麒?铗牮铋 镱玷鲨?
   if(PositionSelect(symbol)) return(true);

//----
   double volume=SellLotCount(symbol,Money_Management,Margin_Mode,StopLoss,deviation);
   if(volume<=0)
     {
      //Print(__FUNCTION__,"(): 湾忮痦 钺?潆 耱痼牝箴?蝾疸钼钽?玎镳铖?);
      return(false);
     }

//---- 吾?怆屙桢 耱痼牝箴 蝾疸钼钽?玎镳铖??疱珞朦蜞蜞 蝾疸钼钽?玎镳铖?
   MqlTradeRequest request;
   MqlTradeResult result;
//---- 吾?怆屙桢 耱痼牝箴?疱珞朦蜞蜞 镳钼屦觇 蝾疸钼钽?玎镳铖?
   MqlTradeCheckResult check;

//---- 钺眢脲龛?耱痼牝箴
   ZeroMemory(request);
   ZeroMemory(result);
   ZeroMemory(check);

   long digit;
   double point,Bid;
//----
   if(!SymbolInfoInteger(symbol,SYMBOL_DIGITS,digit)) return(true);
   if(!SymbolInfoDouble(symbol,SYMBOL_POINT,point)) return(true);
   if(!SymbolInfoDouble(symbol,SYMBOL_BID,Bid)) return(true);

//---- 软桷栲腓玎鲨 耱痼牝箴?蝾疸钼钽?玎镳铖?MqlTradeRequest 潆 铗牮囗? SELL 镱玷鲨?
   request.type   = ORDER_TYPE_SELL;
   request.price  = Bid;
   request.action = TRADE_ACTION_DEAL;
   request.symbol = symbol;
   request.volume = volume;

//---- 物疱溴脲龛?疣耨蝾龛 漕 耱铒腩耨??邃桧桷圊 鲥眍忸泐 沭圄桕?
   if(StopLoss!=0)
     {
      if(!StopCorrect(symbol,StopLoss))return(false);
      double dStopLoss=StopLoss*point;
      request.sl=NormalizeDouble(request.price+dStopLoss,int(digit));
     }
   else request.sl=0.0;

//---- 物疱溴脲龛?疣耨蝾龛 漕 蝈殛镳铘栩?邃桧桷圊 鲥眍忸泐 沭圄桕?
   if(Takeprofit!=0)
     {
      if(!StopCorrect(symbol,Takeprofit))return(false);
      double dTakeprofit=Takeprofit*point;
      request.tp=NormalizeDouble(request.price-dTakeprofit,int(digit));
     }
   else request.tp=0.0;
//----
   request.deviation=deviation;
   request.type_filling=ORDER_FILLING_FOK;

//---- 橡钼屦赅 蝾疸钼钽?玎镳铖?磬 觐痧尻蝽铖螯
   if(!OrderCheck(request,check))
     {
      //Print(__FUNCTION__,"(): 湾忮痦 溧眄 潆 耱痼牝箴?蝾疸钼钽?玎镳铖?");
      //Print(__FUNCTION__,"(): OrderCheck(): ",ResultRetcodeDescription(check.retcode));
      return(false);
     }

   string comment="";
   StringConcatenate(comment,"<<< ============ ",__FUNCTION__,"(): 悟牮噱?Sell 镱玷鲨?镱 ",symbol," ============ >>>");
   Print(comment);

//---- 悟牮噱?SELL 镱玷鲨??溴豚屐 镳钼屦牦 疱珞朦蜞蜞 蝾疸钼钽?玎镳铖?
   if(!OrderSend(request,result) || result.retcode!=TRADE_RETCODE_DONE)
     {
      Print(__FUNCTION__,"(): 湾忸珈铈眍 耦忮瘌栩?皲咫牦!");
      Print(__FUNCTION__,"(): OrderSend(): ",ResultRetcodeDescription(result.retcode));
      return(false);
     }
   else
   if(result.retcode==TRADE_RETCODE_DONE)
     {
      TradeTimeLevelSet(symbol,PosType,TimeLevel);
      SELL_Signal=false;
      comment="";
      StringConcatenate(comment,"<<< ============ ",__FUNCTION__,"(): Sell 镱玷鲨 镱 ",symbol," 铗牮?============ >>>");
      Print(comment);
      PlaySound("ok.wav");
     }
   else
     {
      Print(__FUNCTION__,"(): 湾忸珈铈眍 耦忮瘌栩?皲咫牦!");
      Print(__FUNCTION__,"(): OrderSend(): ",ResultRetcodeDescription(result.retcode));
     }
//----
   return(true);
  }
//+------------------------------------------------------------------+
//| 悟牮噱?潆桧眢?镱玷鲨?                                       |
//+------------------------------------------------------------------+
bool BuyPositionOpen
(
 bool &BUY_Signal,           // 綦嚆 疣琊屮屙? 磬 皲咫牦
 const string symbol,        // 蝾疸钼? 镟疣 皲咫觇
 const datetime &TimeLevel,  // 怵屐, 镱耠?觐蝾痤泐 狍溴?铖簌羼蜮脲磬 耠邃簌? 皲咫赅 镱耠?蝈牦?
 double Money_Management,    // MM
 int Margin_Mode,            // 耧铖钺 疣聍蛤?忮腓麒睇 腩蜞
 uint deviation,             // 耠栾镟?
 double dStopLoss,           // 耱铒腩耨 ?邃桧桷圊 鲥眍忸泐 沭圄桕?
 double dTakeprofit          // 蝈殛镳铘栩 ?邃桧桷圊 鲥眍忸泐 沭圄桕?
 )
//BuyPositionOpen(BUY_Signal,symbol,TimeLevel,Money_Management,deviation,Margin_Mode,StopLoss,Takeprofit);
  {
//----
   if(!BUY_Signal) return(true);

   ENUM_POSITION_TYPE PosType=POSITION_TYPE_BUY;
//---- 橡钼屦赅 磬 桉蝈麇龛?怵屐屙眍泐 腓扈蜞 潆 镳邃簌彘 皲咫觇 ?镱腠铗?钺爨
   if(!TradeTimeLevelCheck(symbol,PosType,TimeLevel)) return(true);

//---- 橡钼屦赅 磬 磬 磬腓麒?铗牮铋 镱玷鲨?
   if(PositionSelect(symbol)) return(true);

//---- 吾?怆屙桢 耱痼牝箴 蝾疸钼钽?玎镳铖??疱珞朦蜞蜞 蝾疸钼钽?玎镳铖?
   MqlTradeRequest request;
   MqlTradeResult result;
//---- 吾?怆屙桢 耱痼牝箴?疱珞朦蜞蜞 镳钼屦觇 蝾疸钼钽?玎镳铖?
   MqlTradeCheckResult check;

//---- 钺眢脲龛?耱痼牝箴
   ZeroMemory(request);
   ZeroMemory(result);
   ZeroMemory(check);

   long digit;
   double point,Ask;
//----
   if(!SymbolInfoInteger(symbol,SYMBOL_DIGITS,digit)) return(true);
   if(!SymbolInfoDouble(symbol,SYMBOL_POINT,point)) return(true);
   if(!SymbolInfoDouble(symbol,SYMBOL_ASK,Ask)) return(true);

//---- 觐痧尻鲨 疣耨蝾龛?漕 耱铒腩耨??蝈殛镳铘栩??邃桧桷圊 鲥眍忸泐 沭圄桕?
   if(!dStopCorrect(symbol,dStopLoss,dTakeprofit,PosType)) return(false);
   int StopLoss=int((Ask-dStopLoss)/point);
//----
   double volume=BuyLotCount(symbol,Money_Management,Margin_Mode,StopLoss,deviation);
   if(volume<=0)
     {
      //Print(__FUNCTION__,"(): 湾忮痦 钺?潆 耱痼牝箴?蝾疸钼钽?玎镳铖?);
      return(false);
     }

//---- 软桷栲腓玎鲨 耱痼牝箴?蝾疸钼钽?玎镳铖?MqlTradeRequest 潆 铗牮囗? BUY 镱玷鲨?
   request.type   = ORDER_TYPE_BUY;
   request.price  = Ask;
   request.action = TRADE_ACTION_DEAL;
   request.symbol = symbol;
   request.volume = volume;
   request.sl=dStopLoss;
   request.tp=dTakeprofit;
   request.deviation=deviation;
   request.type_filling=ORDER_FILLING_FOK;

//---- 橡钼屦赅 蝾疸钼钽?玎镳铖?磬 觐痧尻蝽铖螯
   if(!OrderCheck(request,check))
     {
      Print(__FUNCTION__,"(): 湾忮痦 溧眄 潆 耱痼牝箴?蝾疸钼钽?玎镳铖?");
      Print(__FUNCTION__,"(): OrderCheck(): ",ResultRetcodeDescription(check.retcode));
      return(false);
     }

   string comment="";
   StringConcatenate(comment,"<<< ============ ",__FUNCTION__,"(): 悟牮噱?Buy 镱玷鲨?镱 ",symbol," ============ >>>");
   Print(comment);

//---- 悟牮噱?BUY 镱玷鲨??溴豚屐 镳钼屦牦 疱珞朦蜞蜞 蝾疸钼钽?玎镳铖?
   if(!OrderSend(request,result) || result.retcode!=TRADE_RETCODE_DONE)
     {
      Print(__FUNCTION__,"(): 湾忸珈铈眍 耦忮瘌栩?皲咫牦!");
      Print(__FUNCTION__,"(): OrderSend(): ",ResultRetcodeDescription(result.retcode));
      return(false);
     }
   else
   if(result.retcode==TRADE_RETCODE_DONE)
     {
      TradeTimeLevelSet(symbol,PosType,TimeLevel);
      BUY_Signal=false;
      comment="";
      StringConcatenate(comment,"<<< ============ ",__FUNCTION__,"(): Buy 镱玷鲨 镱 ",symbol," 铗牮?============ >>>");
      Print(comment);
      PlaySound("ok.wav");
     }
   else
     {
      Print(__FUNCTION__,"(): 湾忸珈铈眍 耦忮瘌栩?皲咫牦!");
      Print(__FUNCTION__,"(): OrderSend(): ",ResultRetcodeDescription(result.retcode));
     }
//----
   return(true);
  }
//+------------------------------------------------------------------+
//| 悟牮噱?觐痤蜿簋 镱玷鲨?                                      |
//+------------------------------------------------------------------+
bool SellPositionOpen
(
 bool &SELL_Signal,          // 綦嚆 疣琊屮屙? 磬 皲咫牦
 const string symbol,        // 蝾疸钼? 镟疣 皲咫觇
 const datetime &TimeLevel,  // 怵屐, 镱耠?觐蝾痤泐 狍溴?铖簌羼蜮脲磬 耠邃簌? 皲咫赅 镱耠?蝈牦?
 double Money_Management,    // MM
 int Margin_Mode,            // 耧铖钺 疣聍蛤?忮腓麒睇 腩蜞
 uint deviation,             // 耠栾镟?
 double dStopLoss,           // 耱铒腩耨 ?邃桧桷圊 鲥眍忸泐 沭圄桕?
 double dTakeprofit          // 蝈殛镳铘栩 ?邃桧桷圊 鲥眍忸泐 沭圄桕?
 )
//SellPositionOpen(SELL_Signal,symbol,TimeLevel,Money_Management,deviation,Margin_Mode,StopLoss,Takeprofit);
  {
//----
   if(!SELL_Signal) return(true);

   ENUM_POSITION_TYPE PosType=POSITION_TYPE_SELL;
//---- 橡钼屦赅 磬 桉蝈麇龛?怵屐屙眍泐 腓扈蜞 潆 镳邃簌彘 皲咫觇 ?镱腠铗?钺爨
   if(!TradeTimeLevelCheck(symbol,PosType,TimeLevel)) return(true);

//---- 橡钼屦赅 磬 磬 磬腓麒?铗牮铋 镱玷鲨?
   if(PositionSelect(symbol)) return(true);

//---- 吾?怆屙桢 耱痼牝箴 蝾疸钼钽?玎镳铖??疱珞朦蜞蜞 蝾疸钼钽?玎镳铖?
   MqlTradeRequest request;
   MqlTradeResult result;
//---- 吾?怆屙桢 耱痼牝箴?疱珞朦蜞蜞 镳钼屦觇 蝾疸钼钽?玎镳铖?
   MqlTradeCheckResult check;

//---- 钺眢脲龛?耱痼牝箴
   ZeroMemory(request);
   ZeroMemory(result);
   ZeroMemory(check);

   long digit;
   double point,Bid;
//----
   if(!SymbolInfoInteger(symbol,SYMBOL_DIGITS,digit)) return(true);
   if(!SymbolInfoDouble(symbol,SYMBOL_POINT,point)) return(true);
   if(!SymbolInfoDouble(symbol,SYMBOL_BID,Bid)) return(true);

//---- 觐痧尻鲨 疣耨蝾龛?漕 耱铒腩耨??蝈殛镳铘栩??邃桧桷圊 鲥眍忸泐 沭圄桕?
   if(!dStopCorrect(symbol,dStopLoss,dTakeprofit,PosType)) return(false);
   int StopLoss=int((dStopLoss-Bid)/point);
//----
   double volume=SellLotCount(symbol,Money_Management,Margin_Mode,StopLoss,deviation);
   if(volume<=0)
     {
      //Print(__FUNCTION__,"(): 湾忮痦 钺?潆 耱痼牝箴?蝾疸钼钽?玎镳铖?);
      return(false);
     }

//---- 软桷栲腓玎鲨 耱痼牝箴?蝾疸钼钽?玎镳铖?MqlTradeRequest 潆 铗牮囗? SELL 镱玷鲨?
   request.type   = ORDER_TYPE_SELL;
   request.price  = Bid;
   request.action = TRADE_ACTION_DEAL;
   request.symbol = symbol;
   request.volume = volume;
   request.deviation=deviation;
   request.type_filling=ORDER_FILLING_FOK;

//---- 橡钼屦赅 蝾疸钼钽?玎镳铖?磬 觐痧尻蝽铖螯
   if(!OrderCheck(request,check))
     {
      Print(__FUNCTION__,"(): OrderCheck(): 湾忮痦 溧眄 潆 耱痼牝箴?蝾疸钼钽?玎镳铖?");
      Print(__FUNCTION__,"(): OrderCheck(): ",ResultRetcodeDescription(check.retcode));
      return(false);
     }

   string comment="";
   StringConcatenate(comment,"<<< ============ ",__FUNCTION__,"(): 悟牮噱?Sell 镱玷鲨?镱 ",symbol," ============ >>>");
   Print(comment);

//---- 悟牮噱?SELL 镱玷鲨??溴豚屐 镳钼屦牦 疱珞朦蜞蜞 蝾疸钼钽?玎镳铖?
   if(!OrderSend(request,result) || result.retcode!=TRADE_RETCODE_DONE)
     {
      Print(__FUNCTION__,"(): OrderSend(): 湾忸珈铈眍 耦忮瘌栩?皲咫牦!");
      Print(__FUNCTION__,"(): OrderSend(): ",ResultRetcodeDescription(result.retcode));
      return(false);
     }
   else
   if(result.retcode==TRADE_RETCODE_DONE)
     {
      TradeTimeLevelSet(symbol,PosType,TimeLevel);
      SELL_Signal=false;
      comment="";
      StringConcatenate(comment,"<<< ============ ",__FUNCTION__,"(): Sell 镱玷鲨 镱 ",symbol," 铗牮?============ >>>");
      Print(comment);
      PlaySound("ok.wav");
     }
   else
     {
      Print(__FUNCTION__,"(): OrderSend(): 湾忸珈铈眍 耦忮瘌栩?皲咫牦!");
      Print(__FUNCTION__,"(): OrderSend(): ",ResultRetcodeDescription(result.retcode));
     }
//----
   return(true);
  }
//+------------------------------------------------------------------+
//| 青牮噱?潆桧眢?镱玷鲨?                                       |
//+------------------------------------------------------------------+
bool BuyPositionClose
(
 bool &Signal,         // 綦嚆 疣琊屮屙? 磬 皲咫牦
 const string symbol,  // 蝾疸钼? 镟疣 皲咫觇
 uint deviation        // 耠栾镟?
 )
  {
//----
   if(!Signal) return(true);

//---- 吾?怆屙桢 耱痼牝箴 蝾疸钼钽?玎镳铖??疱珞朦蜞蜞 蝾疸钼钽?玎镳铖?
   MqlTradeRequest request;
   MqlTradeResult result;
//---- 吾?怆屙桢 耱痼牝箴?疱珞朦蜞蜞 镳钼屦觇 蝾疸钼钽?玎镳铖?
   MqlTradeCheckResult check;

//---- 钺眢脲龛?耱痼牝箴
   ZeroMemory(request);
   ZeroMemory(result);
   ZeroMemory(check);

//---- 橡钼屦赅 磬 磬腓麒?铗牮铋 BUY 镱玷鲨?
   if(PositionSelect(symbol))
     {
      if(PositionGetInteger(POSITION_TYPE)!=POSITION_TYPE_BUY) return(false);
     }
   else return(false);

   double MaxLot,volume,Bid;
//---- 镱塍麇龛?溧眄 潆 疣聍蛤?   
   if(!PositionGetDouble(POSITION_VOLUME,volume)) return(true);
   if(!SymbolInfoDouble(symbol,SYMBOL_VOLUME_MAX,MaxLot)) return(true);
   if(!SymbolInfoDouble(symbol,SYMBOL_BID,Bid)) return(true);

//---- 镳钼屦赅 腩蜞 磬 爨犟桁嚯铄 漕矬耱桁铄 珥圜屙桢       
   if(volume>MaxLot) volume=MaxLot;

//---- 软桷栲腓玎鲨 耱痼牝箴?蝾疸钼钽?玎镳铖?MqlTradeRequest 潆 玎牮囗? BUY 镱玷鲨?
   request.type   = ORDER_TYPE_SELL;
   request.price  = Bid;
   request.action = TRADE_ACTION_DEAL;
   request.symbol = symbol;
   request.volume = volume;
   request.sl = 0.0;
   request.tp = 0.0;
   request.deviation=deviation;
   request.type_filling=ORDER_FILLING_FOK;

//---- 橡钼屦赅 蝾疸钼钽?玎镳铖?磬 觐痧尻蝽铖螯
   if(!OrderCheck(request,check))
     {
      Print(__FUNCTION__,"(): 湾忮痦 溧眄 潆 耱痼牝箴?蝾疸钼钽?玎镳铖?");
      Print(__FUNCTION__,"(): OrderCheck(): ",ResultRetcodeDescription(check.retcode));
      return(false);
     }
//----     
   string comment="";
   StringConcatenate(comment,"<<< ============ ",__FUNCTION__,"(): 青牮噱?Buy 镱玷鲨?镱 ",symbol," ============ >>>");
   Print(comment);

//---- 悟镳噔赅 镳桕噻?磬 玎牮囗桢 镱玷鲨?磬 蝾疸钼 皴疴屦
   if(!OrderSend(request,result) || result.retcode!=TRADE_RETCODE_DONE)
     {
      Print(__FUNCTION__,"(): 湾忸珈铈眍 玎牮?镱玷鲨?");
      Print(__FUNCTION__,"(): OrderSend(): ",ResultRetcodeDescription(result.retcode));
      return(false);
     }
   else
   if(result.retcode==TRADE_RETCODE_DONE)
     {
      Signal=false;
      comment="";
      StringConcatenate(comment,"<<< ============ ",__FUNCTION__,"(): Buy 镱玷鲨 镱 ",symbol," 玎牮?============ >>>");
      Print(comment);
      PlaySound("ok.wav");
     }
   else
     {
      Print(__FUNCTION__,"(): 湾忸珈铈眍 玎牮?镱玷鲨?");
      Print(__FUNCTION__,"(): OrderSend(): ",ResultRetcodeDescription(result.retcode));
     }
//----
   return(true);
  }
//+------------------------------------------------------------------+
//| 青牮噱?觐痤蜿簋 镱玷鲨?                                      |
//+------------------------------------------------------------------+
bool SellPositionClose
(
 bool &Signal,         // 綦嚆 疣琊屮屙? 磬 皲咫牦
 const string symbol,  // 蝾疸钼? 镟疣 皲咫觇
 uint deviation        // 耠栾镟?
 )
  {
//----
   if(!Signal) return(true);

//---- 吾?怆屙桢 耱痼牝箴 蝾疸钼钽?玎镳铖??疱珞朦蜞蜞 蝾疸钼钽?玎镳铖?
   MqlTradeRequest request;
   MqlTradeResult result;
//---- 吾?怆屙桢 耱痼牝箴?疱珞朦蜞蜞 镳钼屦觇 蝾疸钼钽?玎镳铖?
   MqlTradeCheckResult check;

//---- 钺眢脲龛?耱痼牝箴
   ZeroMemory(request);
   ZeroMemory(result);
   ZeroMemory(check);

//---- 橡钼屦赅 磬 磬腓麒?铗牮铋 SELL 镱玷鲨?
   if(PositionSelect(symbol))
     {
      if(PositionGetInteger(POSITION_TYPE)!=POSITION_TYPE_SELL)return(false);
     }
   else return(false);

   double MaxLot,volume,Ask;
//---- 镱塍麇龛?溧眄 潆 疣聍蛤?   
   if(!PositionGetDouble(POSITION_VOLUME,volume)) return(true);
   if(!SymbolInfoDouble(symbol,SYMBOL_VOLUME_MAX,MaxLot)) return(true);
   if(!SymbolInfoDouble(symbol,SYMBOL_ASK,Ask)) return(true);

//---- 镳钼屦赅 腩蜞 磬 爨犟桁嚯铄 漕矬耱桁铄 珥圜屙桢       
   if(volume>MaxLot) volume=MaxLot;

//---- 软桷栲腓玎鲨 耱痼牝箴?蝾疸钼钽?玎镳铖?MqlTradeRequest 潆 玎牮囗? SELL 镱玷鲨?
   request.type   = ORDER_TYPE_BUY;
   request.price  = Ask;
   request.action = TRADE_ACTION_DEAL;
   request.symbol = symbol;
   request.volume = volume;
   request.sl = 0.0;
   request.tp = 0.0;
   request.deviation=deviation;
   request.type_filling=ORDER_FILLING_FOK;

//---- 橡钼屦赅 蝾疸钼钽?玎镳铖?磬 觐痧尻蝽铖螯
   if(!OrderCheck(request,check))
     {
      Print(__FUNCTION__,"(): 湾忮痦 溧眄 潆 耱痼牝箴?蝾疸钼钽?玎镳铖?");
      Print(__FUNCTION__,"(): OrderCheck(): ",ResultRetcodeDescription(check.retcode));
      return(false);
     }
//----    
   string comment="";
   StringConcatenate(comment,"<<< ============ ",__FUNCTION__,"(): 青牮噱?Sell 镱玷鲨?镱 ",symbol," ============ >>>");
   Print(comment);

//---- 悟镳噔赅 镳桕噻?磬 玎牮囗桢 镱玷鲨?磬 蝾疸钼 皴疴屦
   if(!OrderSend(request,result) || result.retcode!=TRADE_RETCODE_DONE)
     {
      Print(__FUNCTION__,"(): 湾忸珈铈眍 玎牮?镱玷鲨?");
      Print(__FUNCTION__,"(): OrderSend(): ",ResultRetcodeDescription(result.retcode));
      return(false);
     }
   else
   if(result.retcode==TRADE_RETCODE_DONE)
     {
      Signal=false;
     }
   else
     {
      Print(__FUNCTION__,"(): 湾忸珈铈眍 玎牮?镱玷鲨?");
      Print(__FUNCTION__,"(): OrderSend(): ",ResultRetcodeDescription(result.retcode));
      comment="";
      StringConcatenate(comment,"<<< ============ ",__FUNCTION__,"(): Sell 镱玷鲨 镱 ",symbol," 玎牮?============ >>>");
      Print(comment);
      PlaySound("ok.wav");
     }
//----
   return(true);
  }
//+------------------------------------------------------------------+
//| 填滂翳鲨痼屐 潆桧眢?镱玷鲨?                                    |
//+------------------------------------------------------------------+
bool BuyPositionModify
(
 bool &Modify_Signal,        // 綦嚆 疣琊屮屙? 祛滂翳赅鲨?
 const string symbol,        // 蝾疸钼? 镟疣 皲咫觇
 uint deviation,             // 耠栾镟?
 int StopLoss,               // 耱铒腩耨 ?矬黻蜞?
 int Takeprofit              // 蝈殛镳铘栩 ?矬黻蜞?
 )
//BuyPositionModify(Modify_Signal,symbol,deviation,StopLoss,Takeprofit);
  {
//----
   if(!Modify_Signal) return(true);

   ENUM_POSITION_TYPE PosType=POSITION_TYPE_BUY;

//---- 橡钼屦赅 磬 磬 磬腓麒?铗牮铋 镱玷鲨?
   if(!PositionSelect(symbol)) return(true);

//---- 吾?怆屙桢 耱痼牝箴 蝾疸钼钽?玎镳铖??疱珞朦蜞蜞 蝾疸钼钽?玎镳铖?
   MqlTradeRequest request;
   MqlTradeResult result;

//---- 吾?怆屙桢 耱痼牝箴?疱珞朦蜞蜞 镳钼屦觇 蝾疸钼钽?玎镳铖?
   MqlTradeCheckResult check;

//---- 钺眢脲龛?耱痼牝箴
   ZeroMemory(request);
   ZeroMemory(result);
   ZeroMemory(check);

   long digit;
   double point,Ask;
//----
   if(!SymbolInfoInteger(symbol,SYMBOL_DIGITS,digit)) return(true);
   if(!SymbolInfoDouble(symbol,SYMBOL_POINT,point)) return(true);
   if(!SymbolInfoDouble(symbol,SYMBOL_ASK,Ask)) return(true);

//---- 软桷栲腓玎鲨 耱痼牝箴?蝾疸钼钽?玎镳铖?MqlTradeRequest 潆 铗牮囗? BUY 镱玷鲨?
   request.type   = ORDER_TYPE_BUY;
   request.price  = Ask;
   request.action = TRADE_ACTION_SLTP;
   request.symbol = symbol;

//---- 物疱溴脲龛?疣耨蝾龛 漕 耱铒腩耨??邃桧桷圊 鲥眍忸泐 沭圄桕?
   if(StopLoss)
     {
      if(!StopCorrect(symbol,StopLoss))return(false);
      double dStopLoss=StopLoss*point;
      request.sl=NormalizeDouble(request.price-dStopLoss,int(digit));
      if(request.sl<PositionGetDouble(POSITION_SL)) request.sl=PositionGetDouble(POSITION_SL);
     }
   else request.sl=PositionGetDouble(POSITION_SL);

//---- 物疱溴脲龛?疣耨蝾龛 漕 蝈殛镳铘栩?邃桧桷圊 鲥眍忸泐 沭圄桕?
   if(Takeprofit)
     {
      if(!StopCorrect(symbol,Takeprofit))return(false);
      double dTakeprofit=Takeprofit*point;
      request.tp=NormalizeDouble(request.price+dTakeprofit,int(digit));
      if(request.tp<PositionGetDouble(POSITION_TP)) request.tp=PositionGetDouble(POSITION_TP);
     }
   else request.tp=PositionGetDouble(POSITION_TP);

//----   
   if(request.tp==PositionGetDouble(POSITION_TP) && request.sl==PositionGetDouble(POSITION_SL)) return(true);
   request.deviation=deviation;
   request.type_filling=ORDER_FILLING_FOK;

//---- 橡钼屦赅 蝾疸钼钽?玎镳铖?磬 觐痧尻蝽铖螯
   if(!OrderCheck(request,check))
     {
      Print(__FUNCTION__,"(): 湾忮痦 溧眄 潆 耱痼牝箴?蝾疸钼钽?玎镳铖?");
      Print(__FUNCTION__,"(): OrderCheck(): ",ResultRetcodeDescription(check.retcode));
      return(false);
     }

   string comment="";
   StringConcatenate(comment,"<<< ============ ",__FUNCTION__,"(): 填滂翳鲨痼屐 Buy 镱玷鲨?镱 ",symbol," ============ >>>");
   Print(comment);

//---- 填滂翳鲨痼屐 BUY 镱玷鲨??溴豚屐 镳钼屦牦 疱珞朦蜞蜞 蝾疸钼钽?玎镳铖?
   if(!OrderSend(request,result) || result.retcode!=TRADE_RETCODE_DONE)
     {
      Print(__FUNCTION__,"(): 湾忸珈铈眍 祛滂翳鲨痤忄螯 镱玷鲨?");
      Print(__FUNCTION__,"(): OrderSend(): ",ResultRetcodeDescription(result.retcode));
      return(false);
     }
   else
   if(result.retcode==TRADE_RETCODE_DONE)
     {
      Modify_Signal=false;
      comment="";
      StringConcatenate(comment,"<<< ============ ",__FUNCTION__,"(): Buy 镱玷鲨 镱 ",symbol," 祛滂翳鲨痤忄磬 ============ >>>");
      Print(comment);
      PlaySound("ok.wav");
     }
   else
     {
      Print(__FUNCTION__,"(): 湾忸珈铈眍 祛滂翳鲨痤忄螯 镱玷鲨?");
      Print(__FUNCTION__,"(): OrderSend(): ",ResultRetcodeDescription(result.retcode));
     }
//----
   return(true);
  }
//+------------------------------------------------------------------+
//| 填滂翳鲨痼屐 觐痤蜿簋 镱玷鲨?                                   |
//+------------------------------------------------------------------+
bool SellPositionModify
(
 bool &Modify_Signal,        // 綦嚆 疣琊屮屙? 祛滂翳赅鲨?
 const string symbol,        // 蝾疸钼? 镟疣 皲咫觇
 uint deviation,             // 耠栾镟?
 int StopLoss,               // 耱铒腩耨 ?矬黻蜞?
 int Takeprofit              // 蝈殛镳铘栩 ?矬黻蜞?
 )
//SellPositionModify(Modify_Signal,symbol,deviation,StopLoss,Takeprofit);
  {
//----
   if(!Modify_Signal) return(true);

   ENUM_POSITION_TYPE PosType=POSITION_TYPE_SELL;

//---- 橡钼屦赅 磬 磬 磬腓麒?铗牮铋 镱玷鲨?
   if(!PositionSelect(symbol)) return(true);

//---- 吾?怆屙桢 耱痼牝箴 蝾疸钼钽?玎镳铖??疱珞朦蜞蜞 蝾疸钼钽?玎镳铖?
   MqlTradeRequest request;
   MqlTradeResult result;

//---- 吾?怆屙桢 耱痼牝箴?疱珞朦蜞蜞 镳钼屦觇 蝾疸钼钽?玎镳铖?
   MqlTradeCheckResult check;

//---- 钺眢脲龛?耱痼牝箴
   ZeroMemory(request);
   ZeroMemory(result);
   ZeroMemory(check);
//----
   long digit;
   double point,Bid;
//----
   if(!SymbolInfoInteger(symbol,SYMBOL_DIGITS,digit)) return(true);
   if(!SymbolInfoDouble(symbol,SYMBOL_POINT,point)) return(true);
   if(!SymbolInfoDouble(symbol,SYMBOL_BID,Bid)) return(true);

//---- 软桷栲腓玎鲨 耱痼牝箴?蝾疸钼钽?玎镳铖?MqlTradeRequest 潆 铗牮囗? BUY 镱玷鲨?
   request.type   = ORDER_TYPE_SELL;
   request.price  = Bid;
   request.action = TRADE_ACTION_SLTP;
   request.symbol = symbol;

//---- 物疱溴脲龛?疣耨蝾龛 漕 耱铒腩耨??邃桧桷圊 鲥眍忸泐 沭圄桕?
   if(StopLoss!=0)
     {
      if(!StopCorrect(symbol,StopLoss))return(false);
      double dStopLoss=StopLoss*point;
      request.sl=NormalizeDouble(request.price+dStopLoss,int(digit));
      double laststop=PositionGetDouble(POSITION_SL);
      if(request.sl>laststop && laststop) request.sl=PositionGetDouble(POSITION_SL);
     }
   else request.sl=PositionGetDouble(POSITION_SL);

//---- 物疱溴脲龛?疣耨蝾龛 漕 蝈殛镳铘栩?邃桧桷圊 鲥眍忸泐 沭圄桕?
   if(Takeprofit!=0)
     {
      if(!StopCorrect(symbol,Takeprofit))return(false);
      double dTakeprofit=Takeprofit*point;
      request.tp=NormalizeDouble(request.price-dTakeprofit,int(digit));
      double lasttake=PositionGetDouble(POSITION_TP);
      if(request.tp>lasttake && lasttake) request.tp=PositionGetDouble(POSITION_TP);
     }
   else request.tp=PositionGetDouble(POSITION_TP);

//----   
   if(request.tp==PositionGetDouble(POSITION_TP) && request.sl==PositionGetDouble(POSITION_SL)) return(true);
   request.deviation=deviation;
   request.type_filling=ORDER_FILLING_FOK;

//---- 橡钼屦赅 蝾疸钼钽?玎镳铖?磬 觐痧尻蝽铖螯
   if(!OrderCheck(request,check))
     {
      Print(__FUNCTION__,"(): 湾忮痦 溧眄 潆 耱痼牝箴?蝾疸钼钽?玎镳铖?");
      Print(__FUNCTION__,"(): OrderCheck(): ",ResultRetcodeDescription(check.retcode));
      return(false);
     }

   string comment="";
   StringConcatenate(comment,"<<< ============ ",__FUNCTION__,"(): 填滂翳鲨痼屐 Sell 镱玷鲨?镱 ",symbol," ============ >>>");
   Print(comment);

//---- 填滂翳鲨痼屐 SELL 镱玷鲨??溴豚屐 镳钼屦牦 疱珞朦蜞蜞 蝾疸钼钽?玎镳铖?
   if(!OrderSend(request,result) || result.retcode!=TRADE_RETCODE_DONE)
     {
      Print(__FUNCTION__,"(): 湾忸珈铈眍 祛滂翳鲨痤忄螯 镱玷鲨?");
      Print(__FUNCTION__,"(): OrderSend(): ",ResultRetcodeDescription(result.retcode));
      return(false);
     }
   else
   if(result.retcode==TRADE_RETCODE_DONE)
     {
      Modify_Signal=false;
      comment="";
      StringConcatenate(comment,"<<< ============ ",__FUNCTION__,"(): Sell 镱玷鲨 镱 ",symbol," 祛滂翳鲨痤忄磬 ============ >>>");
      Print(comment);
      PlaySound("ok.wav");
     }
   else
     {
      Print(__FUNCTION__,"(): 湾忸珈铈眍 祛滂翳鲨痤忄螯 镱玷鲨?");
      Print(__FUNCTION__,"(): OrderSend(): ",ResultRetcodeDescription(result.retcode));
     }
//----
   return(true);
  }
//+------------------------------------------------------------------+
//| GetTimeLevelName() function                                      |
//+------------------------------------------------------------------+
string GetTimeLevelName(string symbol,ENUM_POSITION_TYPE trade_operation)
  {
//----
   string G_Name_;
//----  
   if(MQL5InfoInteger(MQL5_TESTING)
      || MQL5InfoInteger(MQL5_OPTIMIZATION)
      || MQL5InfoInteger(MQL5_DEBUGGING))
      StringConcatenate(G_Name_,"TimeLevel_",AccountInfoInteger(ACCOUNT_LOGIN),"_",symbol,"_",trade_operation,"_Test_");
   else StringConcatenate(G_Name_,"TimeLevel_",AccountInfoInteger(ACCOUNT_LOGIN),"_",symbol,"_",trade_operation);
//----
   return(G_Name_);
  }
//+------------------------------------------------------------------+
//| TradeTimeLevelCheck() function                                   |
//+------------------------------------------------------------------+
bool TradeTimeLevelCheck
(
 string symbol,
 ENUM_POSITION_TYPE trade_operation,
 datetime TradeTimeLevel
 )
  {
//----
   if(TradeTimeLevel>0)
     {
      //---- 橡钼屦赅 磬 桉蝈麇龛?怵屐屙眍泐 腓扈蜞 潆 镳邃簌彘 皲咫觇 
      if(TimeCurrent()<GlobalVariableGet(GetTimeLevelName(symbol,trade_operation))) return(false);
     }
//----
   return(true);
  }
//+------------------------------------------------------------------+
//| TradeTimeLevelSet() function                                     |
//+------------------------------------------------------------------+
void TradeTimeLevelSet
(
 string symbol,
 ENUM_POSITION_TYPE trade_operation,
 datetime TradeTimeLevel
 )
  {
//----
   GlobalVariableSet(GetTimeLevelName(symbol,trade_operation),TradeTimeLevel);
  }
//+------------------------------------------------------------------+
//| TradeTimeLevelSet() function                                     |
//+------------------------------------------------------------------+
datetime TradeTimeLevelGet
(
 string symbol,
 ENUM_POSITION_TYPE trade_operation
 )
  {
//----
   return(datetime(GlobalVariableGet(GetTimeLevelName(symbol,trade_operation))));
  }
//+------------------------------------------------------------------+
//| TimeLevelGlobalVariableDel() function                            |
//+------------------------------------------------------------------+
void TimeLevelGlobalVariableDel
(
 string symbol,
 ENUM_POSITION_TYPE trade_operation
 )
  {
//----
   if(MQL5InfoInteger(MQL5_TESTING)
      || MQL5InfoInteger(MQL5_OPTIMIZATION)
      || MQL5InfoInteger(MQL5_DEBUGGING))
      GlobalVariableDel(GetTimeLevelName(symbol,trade_operation));
//----
  }
//+------------------------------------------------------------------+
//| GlobalVariableDel_() function                                    |
//+------------------------------------------------------------------+
void GlobalVariableDel_(string symbol)
  {
//----
   TimeLevelGlobalVariableDel(symbol,POSITION_TYPE_BUY);
   TimeLevelGlobalVariableDel(symbol,POSITION_TYPE_SELL);
//----
  }
//+------------------------------------------------------------------+
//| 朽聍蛤 疣珈屦?腩蜞 潆 铗牮囗? 腩磴?                        |  
//+------------------------------------------------------------------+
/*                                                                   |
 马屮?  镥疱戾眄? Margin_Mode 铒疱溴?弪 耧铖钺 疣聍蛤? 忮腓麒睇 | 
 腩蜞                                                                |
 0 - MM 镱 疋钺钿睇?耩邃耱忄?磬 聍蛤?                             |
 1 - MM 镱 徉豚眈?耩邃耱?磬 聍蛤?                                 |
 2 - MM 镱 筢赅?铗 疋钺钿睇?耩邃耱?磬 聍蛤?                    |
 3 - MM 镱 筢赅?铗 徉豚眈?耩邃耱?磬 聍蛤?                      |
 镱 箪铍鬣龛?- MM 镱 疋钺钿睇?耩邃耱忄?磬 聍蛤?                  |
//+ - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -+
 羼腓 Money_Management 戾睃 眢?,  蝾 蝾疸钼?  趔黻鲨 ?赅麇耱忮 | 
 忮腓麒睇  腩蜞  桉镱朦珞弪  铌痼汶疙眢? 漕 犭桄嚅泐 耱囗溧痱眍泐 |
 珥圜屙? 噌耦膻蝽簋 忮腓麒眢 Money_Management.                      |
*///                                                                 |
//+------------------------------------------------------------------+
double BuyLotCount
(
 string symbol,
 double Money_Management,
 int Margin_Mode,
 int STOPLOSS,
 uint Slippage_
 )
// BuyLotCount_(string symbol, double Money_Management, int Margin_Mode, int STOPLOSS,Slippage_)
  {
//----
   double margin,Lot;

//---1+ 欣炎ㄒ 屡巳兹哇 宋依 乃?我市勐劳冗 衔侨秩?
   if(Money_Management<0) Lot=MathAbs(Money_Management);
   else
   switch(Margin_Mode)
     {
      //---- 朽聍蛤 腩蜞 铗 疋钺钿睇?耩邃耱?磬 聍蛤?
      case  0:
         margin=AccountInfoDouble(ACCOUNT_FREEMARGIN)*Money_Management;
         Lot=GetLotForOpeningPos(symbol,POSITION_TYPE_BUY,margin);
         break;

         //---- 朽聍蛤 腩蜞 铗 徉豚眈?耩邃耱?磬 聍蛤?
      case  1:
         margin=AccountInfoDouble(ACCOUNT_BALANCE)*Money_Management;
         Lot=GetLotForOpeningPos(symbol,POSITION_TYPE_BUY,margin);
         break;

         //---- 朽聍蛤 腩蜞 镱 筢赅?铗 疋钺钿睇?耩邃耱?磬 聍蛤?            
      case  2:
        {
         if(STOPLOSS<=0)
           {
            Print(__FUNCTION__,": 湾忮痦 耱铒腩耨!!!");
            STOPLOSS=0;
           }
         //---- 
         long digit;
         double point,price_open;
         //----   
         if(!SymbolInfoInteger(symbol,SYMBOL_DIGITS,digit)) return(-1);
         if(!SymbolInfoDouble(symbol,SYMBOL_POINT,point)) return(-1);
         if(!SymbolInfoDouble(symbol,SYMBOL_ASK,price_open)) return(-1);

         //---- 物疱溴脲龛?疣耨蝾龛 漕 耱铒腩耨??邃桧桷圊 鲥眍忸泐 沭圄桕?
         if(!StopCorrect(symbol,STOPLOSS)) return(TRADE_RETCODE_ERROR);
         double price_close=NormalizeDouble(price_open-STOPLOSS*point,int(digit));

         double profit;
         if(!OrderCalcProfit(ORDER_TYPE_BUY,symbol,1,price_open,price_close,profit)) return(-1);
         if(!profit) return(-1);

         //---- 朽聍蛤 镱蝈瘘 铗 疋钺钿睇?耩邃耱?磬 聍蛤?
         double Loss=AccountInfoDouble(ACCOUNT_FREEMARGIN)*Money_Management;
         if(!Loss) return(-1);

         Lot=Loss/MathAbs(profit);
         break;
        }

      //---- 朽聍蛤 腩蜞 镱 筢赅?铗 徉豚眈?耩邃耱?磬 聍蛤?
      case  3:
        {
         if(STOPLOSS<=0)
           {
            Print(__FUNCTION__,": 湾忮痦 耱铒腩耨!!!");
            STOPLOSS=0;
           }
         //---- 
         long digit;
         double point,price_open;
         //----   
         if(!SymbolInfoInteger(symbol,SYMBOL_DIGITS,digit)) return(-1);
         if(!SymbolInfoDouble(symbol,SYMBOL_POINT,point)) return(-1);
         if(!SymbolInfoDouble(symbol,SYMBOL_ASK,price_open)) return(-1);

         //---- 物疱溴脲龛?疣耨蝾龛 漕 耱铒腩耨??邃桧桷圊 鲥眍忸泐 沭圄桕?
         if(!StopCorrect(symbol,STOPLOSS)) return(TRADE_RETCODE_ERROR);
         double price_close=NormalizeDouble(price_open-STOPLOSS*point,int(digit));

         double profit;
         if(!OrderCalcProfit(ORDER_TYPE_BUY,symbol,1,price_open,price_close,profit)) return(-1);
         if(!profit) return(-1);

         //---- 朽聍蛤 镱蝈瘘 铗 徉豚眈?耩邃耱?磬 聍蛤?
         double Loss=AccountInfoDouble(ACCOUNT_BALANCE)*Money_Management;
         if(!Loss) return(-1);

         Lot=Loss/MathAbs(profit);
         break;
        }

      //---- 朽聍蛤 腩蜞 徨?桤戾礤龛
      case  4:
        {
         Lot=MathAbs(Money_Management);
         break;
        }

      //---- 朽聍蛤 腩蜞 铗 疋钺钿睇?耩邃耱?磬 聍蛤?镱 箪铍鬣龛?
      default:
        {
         margin=AccountInfoDouble(ACCOUNT_FREEMARGIN)*Money_Management;
         Lot=GetLotForOpeningPos(symbol,POSITION_TYPE_BUY,margin);
        }
     }
//---1+    

//---- 眍痨桊钼囗桢 忮腓麒睇 腩蜞 漕 犭桄嚅泐 耱囗溧痱眍泐 珥圜屙? 
   if(!LotCorrect(symbol,Lot,POSITION_TYPE_BUY)) return(-1);
//----
   return(Lot);
  }
//+------------------------------------------------------------------+
//| 朽聍蛤 疣珈屦?腩蜞 潆 铗牮囗? 痱?                        |  
//+------------------------------------------------------------------+
/*                                                                   |
 马屮?  镥疱戾眄? Margin_Mode 铒疱溴?弪 耧铖钺 疣聍蛤? 忮腓麒睇 | 
 腩蜞                                                                |
 0 - MM 镱 疋钺钿睇?耩邃耱忄?磬 聍蛤?                             |
 1 - MM 镱 徉豚眈?耩邃耱?磬 聍蛤?                                 |
 2 - MM 镱 筢赅?铗 疋钺钿睇?耩邃耱?磬 聍蛤?                    |
 3 - MM 镱 筢赅?铗 徉豚眈?耩邃耱?磬 聍蛤?                      |
 镱 箪铍鬣龛?- MM 镱 疋钺钿睇?耩邃耱忄?磬 聍蛤?                  |
//+ - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -+
 羼腓 Money_Management 戾睃 眢?,  蝾 蝾疸钼?  趔黻鲨 ?赅麇耱忮 | 
 忮腓麒睇  腩蜞  桉镱朦珞弪  铌痼汶疙眢? 漕 犭桄嚅泐 耱囗溧痱眍泐 |
 珥圜屙? 噌耦膻蝽簋 忮腓麒眢 Money_Management.                      |
*///                                                                 |
//+------------------------------------------------------------------+
double SellLotCount
(
 string symbol,
 double Money_Management,
 int Margin_Mode,
 int STOPLOSS,
 uint Slippage_
 )
// (string symbol, double Money_Management, int Margin_Mode, int STOPLOSS)
  {
//----
   double margin,Lot;

//---1+ 欣炎ㄒ 屡巳兹哇 宋依 乃?我市勐劳冗 衔侨秩?
   if(Money_Management<0) Lot=MathAbs(Money_Management);
   else
   switch(Margin_Mode)
     {
      //---- 朽聍蛤 腩蜞 铗 疋钺钿睇?耩邃耱?磬 聍蛤?
      case  0:
         margin=AccountInfoDouble(ACCOUNT_FREEMARGIN)*Money_Management;
         Lot=GetLotForOpeningPos(symbol,POSITION_TYPE_SELL,margin);
         break;

         //---- 朽聍蛤 腩蜞 铗 徉豚眈?耩邃耱?磬 聍蛤?
      case  1:
         margin=AccountInfoDouble(ACCOUNT_BALANCE)*Money_Management;
         Lot=GetLotForOpeningPos(symbol,POSITION_TYPE_SELL,margin);
         break;

         //---- 朽聍蛤 腩蜞 镱 筢赅?铗 疋钺钿睇?耩邃耱?磬 聍蛤?            
      case  2:
        {
         if(STOPLOSS<=0)
           {
            Print(__FUNCTION__,": 湾忮痦 耱铒腩耨!!!");
            STOPLOSS=0;
           }
         //---- 
         long digit;
         double point,price_open;
         //----   
         if(!SymbolInfoInteger(symbol,SYMBOL_DIGITS,digit)) return(-1);
         if(!SymbolInfoDouble(symbol,SYMBOL_POINT,point)) return(-1);
         if(!SymbolInfoDouble(symbol,SYMBOL_BID,price_open)) return(-1);

         //---- 物疱溴脲龛?疣耨蝾龛 漕 耱铒腩耨??邃桧桷圊 鲥眍忸泐 沭圄桕?
         if(!StopCorrect(symbol,STOPLOSS)) return(TRADE_RETCODE_ERROR);
         double price_close=NormalizeDouble(price_open+STOPLOSS*point,int(digit));

         double profit;
         if(!OrderCalcProfit(ORDER_TYPE_SELL,symbol,1,price_open,price_close,profit)) return(-1);
         if(!profit) return(-1);

         //---- 朽聍蛤 镱蝈瘘 铗 疋钺钿睇?耩邃耱?磬 聍蛤?
         double Loss=AccountInfoDouble(ACCOUNT_FREEMARGIN)*Money_Management;
         if(!Loss) return(-1);

         Lot=Loss/MathAbs(profit);
         break;
        }

      //---- 朽聍蛤 腩蜞 镱 筢赅?铗 徉豚眈?耩邃耱?磬 聍蛤?
      case  3:
        {
         if(STOPLOSS<=0)
           {
            Print(__FUNCTION__,": 湾忮痦 耱铒腩耨!!!");
            STOPLOSS=0;
           }
         //---- 
         long digit;
         double point,price_open;
         //----   
         if(!SymbolInfoInteger(symbol,SYMBOL_DIGITS,digit)) return(-1);
         if(!SymbolInfoDouble(symbol,SYMBOL_POINT,point)) return(-1);
         if(!SymbolInfoDouble(symbol,SYMBOL_BID,price_open)) return(-1);

         //---- 物疱溴脲龛?疣耨蝾龛 漕 耱铒腩耨??邃桧桷圊 鲥眍忸泐 沭圄桕?
         if(!StopCorrect(symbol,STOPLOSS)) return(TRADE_RETCODE_ERROR);
         double price_close=NormalizeDouble(price_open+STOPLOSS*point,int(digit));

         double profit;
         if(!OrderCalcProfit(ORDER_TYPE_SELL,symbol,1,price_open,price_close,profit)) return(-1);
         if(!profit) return(-1);

         //---- 朽聍蛤 镱蝈瘘 铗 徉豚眈?耩邃耱?磬 聍蛤?
         double Loss=AccountInfoDouble(ACCOUNT_BALANCE)*Money_Management;
         if(!Loss) return(-1);

         Lot=Loss/MathAbs(profit);
         break;
        }

      //---- 朽聍蛤 腩蜞 徨?桤戾礤龛
      case  4:
        {
         Lot=MathAbs(Money_Management);
         break;
        }

      //---- 朽聍蛤 腩蜞 铗 疋钺钿睇?耩邃耱?磬 聍蛤?镱 箪铍鬣龛?
      default:
        {
         margin=AccountInfoDouble(ACCOUNT_FREEMARGIN)*Money_Management;
         Lot=GetLotForOpeningPos(symbol,POSITION_TYPE_SELL,margin);
        }
     }
//---1+ 

//---- 眍痨桊钼囗桢 忮腓麒睇 腩蜞 漕 犭桄嚅泐 耱囗溧痱眍泐 珥圜屙? 
   if(!LotCorrect(symbol,Lot,POSITION_TYPE_SELL)) return(-1);
//----
   return(Lot);
  }
//+------------------------------------------------------------------+
//| 觐痧尻鲨 疣珈屦?铗腩驽眄钽?铕溴疣 漕 漕矬耱桁钽?珥圜屙?     |
//+------------------------------------------------------------------+
bool StopCorrect(string symbol,int &Stop)
  {
//----
   long Extrem_Stop;
   if(!SymbolInfoInteger(symbol,SYMBOL_TRADE_STOPS_LEVEL,Extrem_Stop)) return(false);
   if(Stop<Extrem_Stop) Stop=int(Extrem_Stop);
//----
   return(true);
  }
//+------------------------------------------------------------------+
//| 觐痧尻鲨 疣珈屦?铗腩驽眄钽?铕溴疣 漕 漕矬耱桁钽?珥圜屙?     |
//+------------------------------------------------------------------+
bool dStopCorrect
(
 string symbol,
 double &dStopLoss,
 double &dTakeprofit,
 ENUM_POSITION_TYPE trade_operation
 )
// dStopCorrect(symbol,dStopLoss,dTakeprofit,trade_operation)
  {
//----
   if(!dStopLoss && !dTakeprofit) return(true);

   if(dStopLoss<0)
     {
      Print(__FUNCTION__,"(): 悟痂鲟蝈朦眍?珥圜屙桢 耱铒腩耨?");
      return(false);
     }

   if(dTakeprofit<0)
     {
      Print(__FUNCTION__,"(): 悟痂鲟蝈朦眍?珥圜屙桢 蝈殛镳铘栩?");
      return(false);
     }
//---- 
   int Stop;
   long digit;
   double point,dStop,ExtrStop,ExtrTake;

//---- 镱塍鬣屐 扈龛爨朦眍?疣耨蝾龛?漕 铗腩驽眄钽?铕溴疣 
   Stop=0;
   if(!StopCorrect(symbol,Stop))return(false);
//----   
   if(!SymbolInfoInteger(symbol,SYMBOL_DIGITS,digit)) return(false);
   if(!SymbolInfoDouble(symbol,SYMBOL_POINT,point)) return(false);
   dStop=Stop*point;

//---- 觐痧尻鲨 疣珈屦?铗腩驽眄钽?铕溴疣 潆 腩磴?
   if(trade_operation==POSITION_TYPE_BUY)
     {
      double Ask;
      if(!SymbolInfoDouble(symbol,SYMBOL_ASK,Ask)) return(false);

      ExtrStop=NormalizeDouble(Ask-dStop,int(digit));
      ExtrTake=NormalizeDouble(Ask+dStop,int(digit));

      if(dStopLoss>ExtrStop && dStopLoss) dStopLoss=ExtrStop;
      if(dTakeprofit<ExtrTake && dTakeprofit) dTakeprofit=ExtrTake;
     }

//---- 觐痧尻鲨 疣珈屦?铗腩驽眄钽?铕溴疣 潆 痱?
   if(trade_operation==POSITION_TYPE_SELL)
     {
      double Bid;
      if(!SymbolInfoDouble(symbol,SYMBOL_BID,Bid)) return(false);

      ExtrStop=NormalizeDouble(Bid+dStop,int(digit));
      ExtrTake=NormalizeDouble(Bid-dStop,int(digit));

      if(dStopLoss<ExtrStop && dStopLoss) dStopLoss=ExtrStop;
      if(dTakeprofit>ExtrTake && dTakeprofit) dTakeprofit=ExtrTake;
     }
//----
   return(true);
  }
//+------------------------------------------------------------------+
//| 觐痧尻鲨 疣珈屦?腩蜞 漕 犭桄嚅泐 漕矬耱桁钽?珥圜屙?        |
//+------------------------------------------------------------------+
bool LotCorrect
(
 string symbol,
 double &Lot,
 ENUM_POSITION_TYPE trade_operation
 )
//LotCorrect(string symbol, double& Lot, ENUM_POSITION_TYPE trade_operation)
  {
//---- 镱塍麇龛?溧眄 潆 疣聍蛤?  
   double Step,MaxLot,MinLot;
   if(!SymbolInfoDouble(symbol,SYMBOL_VOLUME_STEP,Step)) return(false);
   if(!SymbolInfoDouble(symbol,SYMBOL_VOLUME_MAX,MaxLot)) return(false);
   if(!SymbolInfoDouble(symbol,SYMBOL_VOLUME_MIN,MinLot)) return(false);

//---- 眍痨桊钼囗桢 忮腓麒睇 腩蜞 漕 犭桄嚅泐 耱囗溧痱眍泐 珥圜屙? 
   Lot=Step*MathFloor(Lot/Step);

//---- 镳钼屦赅 腩蜞 磬 扈龛爨朦眍?漕矬耱桁铄 珥圜屙桢
   if(Lot<MinLot) Lot=MinLot;
//---- 镳钼屦赅 腩蜞 磬 爨犟桁嚯铄 漕矬耱桁铄 珥圜屙桢       
   if(Lot>MaxLot) Lot=MaxLot;

//---- 镳钼屦赅 耩邃耱?磬 漕耱囹铟眍耱?
   if(!LotFreeMarginCorrect(symbol,Lot,trade_operation))return(false);
//----
   return(true);
  }
//+------------------------------------------------------------------+
//| 钽疣龛麇龛?疣珈屦?腩蜞 忸珈铈眍耱扈 溴镱玷蜞                  |
//+------------------------------------------------------------------+
bool LotFreeMarginCorrect
(
 string symbol,
 double &Lot,
 ENUM_POSITION_TYPE trade_operation
 )
//(string symbol, double& Lot, ENUM_POSITION_TYPE trade_operation)
  {
//---- 镳钼屦赅 耩邃耱?磬 漕耱囹铟眍耱?
   double freemargin=AccountInfoDouble(ACCOUNT_FREEMARGIN);
   if(freemargin<=0) return(false);

//---- 镱塍麇龛?溧眄 潆 疣聍蛤?  
   double Step,MaxLot,MinLot;
   if(!SymbolInfoDouble(symbol,SYMBOL_VOLUME_STEP,Step)) return(false);
   if(!SymbolInfoDouble(symbol,SYMBOL_VOLUME_MAX,MaxLot)) return(false);
   if(!SymbolInfoDouble(symbol,SYMBOL_VOLUME_MIN,MinLot)) return(false);

   double ExtremLot=GetLotForOpeningPos(symbol,trade_operation,freemargin);
//---- 眍痨桊钼囗桢 忮腓麒睇 腩蜞 漕 犭桄嚅泐 耱囗溧痱眍泐 珥圜屙? 
   ExtremLot=Step*MathFloor(ExtremLot/Step);

   if(ExtremLot<MinLot) return(false); // 礤漕耱囹铟眍 溴礤?溧驽 磬 扈龛爨朦睇?腩?
   if(Lot>ExtremLot) Lot=ExtremLot; // 箴彗噱?疣珈屦 腩蜞 漕 蝾泐, 黩?羼螯 磬 溴镱玷蝈!
   if(Lot>MaxLot) Lot=MaxLot; // 箴彗噱?疣珈屦 腩蜞 漕 爨耔爨朦眍 漕矬耱桁钽?
//----
   return(true);
  }
//+------------------------------------------------------------------+
//| 疣聍蛤 疣珈屦 腩蜞 潆 铗牮囗? 镱玷鲨??爨疰铋 lot_margin    |
//+------------------------------------------------------------------+
double GetLotForOpeningPos(string symbol,ENUM_POSITION_TYPE direction,double lot_margin)
  {
//----
   double price=0.0,n_margin;
   if(direction==POSITION_TYPE_BUY)  if(!SymbolInfoDouble(symbol,SYMBOL_ASK,price)) return(0);
   if(direction==POSITION_TYPE_SELL) if(!SymbolInfoDouble(symbol,SYMBOL_BID,price)) return(0);
   if(!price) return(NULL);

   if(!OrderCalcMargin(ENUM_ORDER_TYPE(direction),symbol,1,price,n_margin) || !n_margin) return(0);
   double lot=lot_margin/n_margin;

//---- 镱塍麇龛?蝾疸钼 觐眈蜞眚
   double LOTSTEP,MaxLot,MinLot;
   if(!SymbolInfoDouble(symbol,SYMBOL_VOLUME_STEP,LOTSTEP)) return(0);
   if(!SymbolInfoDouble(symbol,SYMBOL_VOLUME_MAX,MaxLot)) return(0);
   if(!SymbolInfoDouble(symbol,SYMBOL_VOLUME_MIN,MinLot)) return(0);

//---- 眍痨桊钼囗桢 忮腓麒睇 腩蜞 漕 犭桄嚅泐 耱囗溧痱眍泐 珥圜屙? 
   lot=LOTSTEP*MathFloor(lot/LOTSTEP);

//---- 镳钼屦赅 腩蜞 磬 扈龛爨朦眍?漕矬耱桁铄 珥圜屙桢
   if(lot<MinLot) lot=0;
//---- 镳钼屦赅 腩蜞 磬 爨犟桁嚯铄 漕矬耱桁铄 珥圜屙桢       
   if(lot>MaxLot) lot=MaxLot;
//----
   return(lot);
  }
//+------------------------------------------------------------------+
//| 忸玮疣?耔焘铍??玎溧眄?忄膻蜞扈 玎腩汔 ?觐蜩痤怅?         |
//+------------------------------------------------------------------+
string GetSymbolByCurrencies(string margin_currency,string profit_currency)
  {
//---- 镥疱徨疱??鲨觌?怦?耔焘铍? 觐蝾瘥?镳邃耱噔脲睇 ?铌礤 "吾珙?瘥黻?
   int total=SymbolsTotal(true);
   for(int numb=0; numb<total; numb++)
     {
      //---- 镱塍麒?桁 耔焘铍?镱 眍戾痼 ?耧桉赍 "吾珙?瘥黻?
      string symbolname=SymbolName(numb,true);

      //---- 镱塍麒?忄膻蝮 玎腩汔
      string m_cur=SymbolInfoString(symbolname,SYMBOL_CURRENCY_MARGIN);

      //---- 镱塍麒?忄膻蝮 觐蜩痤怅?(?麇?桤戾?弪? 镳栳?镳?桤戾礤龛?鲥睇)
      string p_cur=SymbolInfoString(symbolname,SYMBOL_CURRENCY_PROFIT);

      //---- 羼腓 耔焘铍 镱漕?镱 钺彖?玎溧眄 忄膻蜞? 忮痦屐  桁 耔焘铍?
      if(m_cur==margin_currency && p_cur==profit_currency) return(symbolname);
     }
//----    
   return(NULL);
  }
//+------------------------------------------------------------------+
//| 忸玮疣?耱痂磴钼钽?疱珞朦蜞蜞 蝾疸钼铋 铒屦圉梃 镱 邈?觐潴     |
//+------------------------------------------------------------------+
string ResultRetcodeDescription(int retcode)
  {
   string str="";
//----
   //switch(retcode)
   //  {
   //   case TRADE_RETCODE_REQUOTE: str="绣赈铗?; break;
   //   case TRADE_RETCODE_REJECT: str="青镳铖 铗忮疸眢?; break;
   //   case TRADE_RETCODE_CANCEL: str="青镳铖 铗戾礤?蝠彘溴痤?; break;
   //   case TRADE_RETCODE_PLACED: str="勿溴?疣珈妁屙"; break;
   //   case TRADE_RETCODE_DONE: str="青怅?恹镱腠屙?; break;
   //   case TRADE_RETCODE_DONE_PARTIAL: str="青怅?恹镱腠屙?鬣耱梓眍"; break;
   //   case TRADE_RETCODE_ERROR: str="硒栳赅 钺疣犷蜿?玎镳铖?; break;
   //   case TRADE_RETCODE_TIMEOUT: str="青镳铖 铗戾礤?镱 桉蝈麇龛?怵屐屙?;break;
   //   case TRADE_RETCODE_INVALID: str="湾镳噔桦 玎镳铖"; break;
   //   case TRADE_RETCODE_INVALID_VOLUME: str="湾镳噔桦 钺??玎镳铖?; break;
   //   case TRADE_RETCODE_INVALID_PRICE: str="湾镳噔桦? 鲥磬 ?玎镳铖?; break;
   //   case TRADE_RETCODE_INVALID_STOPS: str="湾镳噔桦 耱铒??玎镳铖?; break;
   //   case TRADE_RETCODE_TRADE_DISABLED: str="翌疸钼? 玎镳妁屙?; break;
   //   case TRADE_RETCODE_MARKET_CLOSED: str="宣眍?玎牮"; break;
   //   case TRADE_RETCODE_NO_MONEY: str="湾?漕耱囹铟睇?溴礤骓 耩邃耱?潆 恹镱腠屙? 玎镳铖?; break;
   //   case TRADE_RETCODE_PRICE_CHANGED: str="皱睇 桤戾龛腓顸"; break;
   //   case TRADE_RETCODE_PRICE_OFF: str="悟耋蝰蜮簋?觐蜩痤怅?潆 钺疣犷蜿?玎镳铖?; break;
   //   case TRADE_RETCODE_INVALID_EXPIRATION: str="湾忮痦? 溧蜞 桉蝈麇龛 铕溴疣 ?玎镳铖?; break;
   //   case TRADE_RETCODE_ORDER_CHANGED: str="杨耱?龛?铕溴疣 桤戾龛腩顸"; break;
   //   case TRADE_RETCODE_TOO_MANY_REQUESTS: str="央桫觐?鬣耱 玎镳铖?; break;
   //   case TRADE_RETCODE_NO_CHANGES: str="?玎镳铖?礤?桤戾礤龛?; break;
   //   case TRADE_RETCODE_SERVER_DISABLES_AT: str="棱蝾蝠彘滂磴 玎镳妁屙 皴疴屦铎"; break;
   //   case TRADE_RETCODE_CLIENT_DISABLES_AT: str="棱蝾蝠彘滂磴 玎镳妁屙 觌桢眚耜桁 蝈痨桧嚯铎"; break;
   //   case TRADE_RETCODE_LOCKED: str="青镳铖 玎犭铌桊钼囗 潆 钺疣犷蜿?; break;
   //   case TRADE_RETCODE_FROZEN: str="勿溴?桦?镱玷鲨 玎祛痤驽睇"; break;
   //   case TRADE_RETCODE_INVALID_FILL: str="雨噻囗 礤镱滗屦骅忄屐 蜩?桉镱腠屙? 铕溴疣 镱 铖蜞蜿?"; break;
   //   case TRADE_RETCODE_CONNECTION: str="湾?耦邃桧屙? ?蝾疸钼 皴疴屦铎"; break;
   //   case TRADE_RETCODE_ONLY_REAL: str="物屦圉? 疣琊屮屙?蝾朦觐 潆 疱嚯 聍弪钼"; break;
   //   case TRADE_RETCODE_LIMIT_ORDERS: str="念耱桡眢?腓扈?磬 觐腓麇耱忸 铗腩驽眄 铕溴痤?; break;
   //   case TRADE_RETCODE_LIMIT_VOLUME: str="念耱桡眢?腓扈?磬 钺?铕溴痤??镱玷鲨?潆 溧眄钽?耔焘铍?; break;
   //   default: str="湾桤忮耱睇?疱珞朦蜞?;
   //  }
//----
   return(str);
  }
//+------------------------------------------------------------------+
//|                                                HistoryLoader.mqh |
//|                      Copyright ?2009, MetaQuotes Software Corp. |
//|                                       http://www.metaquotes.net/ |
//+------------------------------------------------------------------+

//+------------------------------------------------------------------+
//| 青沭箸赅 桉蝾痂?潆 祗朦蜩忄膻蝽钽?耧屦蜞                    |
//+------------------------------------------------------------------+
int LoadHistory(datetime StartDate,           // 耱囵蝾忄 溧蜞 潆 镱溷痼珀?桉蝾痂?
                string LoadedSymbol,          // 耔焘铍 玎镳帏桠噱禧?桉蝾痂麇耜桴 溧眄
                ENUM_TIMEFRAMES LoadedPeriod) // 蜞殪麴彘?玎镳帏桠噱禧?桉蝾痂麇耜桴 溧眄
  {
//----+ 
//Print(__FUNCTION__, ": Start load ", LoadedSymbol+ " , " + EnumToString(LoadedPeriod) + " from ", StartDate);
   int res=CheckLoadHistory(LoadedSymbol,LoadedPeriod,StartDate);
   switch(res)
     {
      case -1 : Print(__FUNCTION__, "(", LoadedSymbol, " ", EnumToString(LoadedPeriod), "): Unknown symbol ", LoadedSymbol);               break;
      case -2 : Print(__FUNCTION__, "(", LoadedSymbol, " ", EnumToString(LoadedPeriod), "): Requested bars more than max bars in chart "); break;
      case -3 : Print(__FUNCTION__, "(", LoadedSymbol, " ", EnumToString(LoadedPeriod), "): Program was stopped ");                        break;
      case -4 : Print(__FUNCTION__, "(", LoadedSymbol, " ", EnumToString(LoadedPeriod), "): Indicator shouldn't load its own data ");      break;
      case -5 : Print(__FUNCTION__, "(", LoadedSymbol, " ", EnumToString(LoadedPeriod), "): Load failed ");                                break;
      case  0 : /* Print(__FUNCTION__, "(", LoadedSymbol, " ", EnumToString(LoadedPeriod), "): Loaded OK ");  */                           break;
      case  1 : /* Print(__FUNCTION__, "(", LoadedSymbol, " ", EnumToString(LoadedPeriod), "): Loaded previously ");  */                   break;
      case  2 : /* Print(__FUNCTION__, "(", LoadedSymbol, " ", EnumToString(LoadedPeriod), "): Loaded previously and built ");  */         break;
      default : { /* Print(__FUNCTION__, "(", LoadedSymbol, " ", EnumToString(LoadedPeriod), "): Unknown result "); */}
     }
/* 
   if (res > 0)
    {   
     bars = Bars(LoadedSymbol, LoadedPeriod);
     Print(__FUNCTION__, "(", LoadedSymbol, " ", GetPeriodName(LoadedPeriod), "): First date ", first_date, " - ", bars, " bars");
    }
   */
//----+
   return(res);
  }
//+------------------------------------------------------------------+
//|  镳钼屦赅 桉蝾痂?潆 镱溷痼珀?                                 |
//+------------------------------------------------------------------+
int CheckLoadHistory(string symbol,ENUM_TIMEFRAMES period,datetime start_date)
  {
//----+
   datetime first_date=0;
   datetime times[100];
//--- check symbol & period
   if(symbol == NULL || symbol == "") symbol = Symbol();
   if(period == PERIOD_CURRENT)     period = Period();
//--- check if symbol is selected in the MarketWatch
   if(!SymbolInfoInteger(symbol,SYMBOL_SELECT))
     {
      if(GetLastError()==ERR_MARKET_UNKNOWN_SYMBOL) return(-1);
      if(!SymbolSelect(symbol,true)) Print(__FUNCTION__,"(): 湾 箐嚯铖?漕徉忤螯 耔焘铍 ",symbol," ?铌眍 MarketWatch!!!");
     }
//--- check if data is present
   SeriesInfoInteger(symbol,period,SERIES_FIRSTDATE,first_date);
   if(first_date>0 && first_date<=start_date) return(1);
//--- don't ask for load of its own data if it is an indicator
   if(MQL5InfoInteger(MQL5_PROGRAM_TYPE)==PROGRAM_INDICATOR && Period()==period && Symbol()==symbol)
      return(-4);
//--- second attempt
   if(SeriesInfoInteger(symbol,PERIOD_M1,SERIES_TERMINAL_FIRSTDATE,first_date))
     {
      //--- there is loaded data to build timeseries
      if(first_date>0)
        {
         //--- force timeseries build
         CopyTime(symbol,period,first_date+PeriodSeconds(period),1,times);
         //--- check date
         if(SeriesInfoInteger(symbol,period,SERIES_FIRSTDATE,first_date))
            if(first_date>0 && first_date<=start_date) return(2);
        }
     }
//--- max bars in chart from terminal options
   int max_bars=TerminalInfoInteger(TERMINAL_MAXBARS);
//--- load symbol history info
   datetime first_server_date=0;
   while(!SeriesInfoInteger(symbol,PERIOD_M1,SERIES_SERVER_FIRSTDATE,first_server_date) && !IsStopped())
      Sleep(5);
//--- fix start date for loading
   if(first_server_date>start_date) start_date=first_server_date;
   if(first_date>0 && first_date<first_server_date)
      Print(__FUNCTION__,"(): Warning: first server date ",first_server_date," for ",symbol,
            " does not match to first series date ",first_date);
//--- load data step by step
   int fail_cnt=0;
   while(!IsStopped())
     {
      //--- wait for timeseries build
      while(!SeriesInfoInteger(symbol,period,SERIES_SYNCHRONIZED) && !IsStopped())
         Sleep(5);
      //--- ask for built bars
      int bars=Bars(symbol,period);
      if(bars>0)
        {
         if(bars>=max_bars) return(-2);
         //--- ask for first date
         if(SeriesInfoInteger(symbol,period,SERIES_FIRSTDATE,first_date))
            if(first_date>0 && first_date<=start_date) return(0);
        }
      //--- copying of next part forces data loading
      int copied=CopyTime(symbol,period,bars,100,times);
      if(copied>0)
        {
         //--- check for data
         if(times[0]<=start_date) return(0);
         if(bars+copied>=max_bars) return(-2);
         fail_cnt=0;
        }
      else
        {
         //--- no more than 100 failed attempts
         fail_cnt++;
         if(fail_cnt>=100) return(-5);
         Sleep(10);
        }
     }
//----+ stopped
   return(-3);
  }
//+------------------------------------------------------------------+
