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
   int handle_macd;
   double macd[];
   double signal[];
   double fast_ma[];
   double slow_ma[];
public:
   CTrendSignalCandel(void){};
   void InitSignal(string symbol,ENUM_TIMEFRAMES tf);
   bool LongCondition(void);
   bool ShortCondition(void);
   };
void CTrendSignalCandel::InitSignal(string symbol,ENUM_TIMEFRAMES tf)
   {
    CopyRates(symbol,tf,0,4,rates);
    handle_macd=iMACD(symbol,tf,24,200,12,PRICE_CLOSE);
    CopyBuffer(handle_macd,0,0,50,macd);
    CopyBuffer(handle_macd,1,0,50,signal);
    CopyBuffer(handle_macd,2,0,50,fast_ma);
    CopyBuffer(handle_macd,3,0,50,slow_ma);
   }
bool CTrendSignalCandel::LongCondition(void)
   {
    bool condition1=rates[0].close<rates[1].close&&rates[1].close<rates[2].close;
    bool condition2=signal[48]>0;
    bool condition3=rates[0].close-rates[0].open<rates[1].close-rates[1].open&&rates[1].close-rates[1].open<rates[2].close-rates[2].open;
    if(condition1&&condition2&&condition3) return true;
    return false;
   }
bool CTrendSignalCandel::ShortCondition(void)
   {
    bool condition1=rates[0].close>rates[1].close&&rates[1].close>rates[2].close;
    bool condition2=signal[48]<0;
    bool condition3=rates[0].close-rates[0].open>rates[1].close-rates[1].open&&rates[1].close-rates[1].open>rates[2].close-rates[2].open;
    if(condition1&&condition2&&condition3) return true;
    return false;
   }