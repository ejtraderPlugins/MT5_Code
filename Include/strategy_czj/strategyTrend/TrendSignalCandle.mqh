//+------------------------------------------------------------------+
//|                                            TrendSignalCandle.mqh |
//|                        Copyright 2018, MetaQuotes Software Corp. |
//|                                             https://www.mql5.com |
//+------------------------------------------------------------------+
#property copyright "Copyright 2018, MetaQuotes Software Corp."
#property link      "https://www.mql5.com"

class CTrendSignalCandel
   {
private:
   MqlRates rates[];
   int handle_ma_long;
   int handle_ma_short;
   int handle_macd;
   double ma_long[];
   double ma_short[];
public:
   CTrendSignalCandel(void){};
   void InitSignal(string symbol,ENUM_TIMEFRAMES tf);
   bool LongCondition(void);
   bool ShortCondition(void);
   };
void CTrendSignalCandel::InitSignal(string symbol,ENUM_TIMEFRAMES tf)
   {
    CopyRates(symbol,tf,0,4,rates);
    handle_ma_long=iMA(symbol,tf,200,0,MODE_SMA,PRICE_CLOSE);
    handle_ma_short=iMA(symbol,tf,24,0,MODE_SMA,PRICE_CLOSE);
    handle_macd=iMACD(symbol,tf,24,200,12,PRICE_CLOSE);
    CopyBuffer(handle_ma_long,0,0,2,ma_long);
    CopyBuffer(handle_ma_short,0,0,2,ma_short);
   }
bool CTrendSignalCandel::LongCondition(void)
   {
    bool condition1=rates[0].close<rates[1].close&&rates[1].close<rates[2].close;
    bool condition2=ma_long[0]<ma_short[0];
    if(condition1&&condition2) return true;
    return false;
   }
bool CTrendSignalCandel::ShortCondition(void)
   {
    bool condition1=rates[0].close>rates[1].close&&rates[1].close>rates[2].close;
    bool condition2=ma_long[0]>ma_short[0];
    if(condition1&&condition2) return true;
    return false;
   }