//+------------------------------------------------------------------+
//|                                                FibonacciBase.mqh |
//|                                                       chizhijing |
//|                                             https://www.mql5.com |
//+------------------------------------------------------------------+
#property copyright "chizhijing"
#property link      "https://www.mql5.com"
#include <Strategy\Strategy.mqh>
#include <Trade\Trade.mqh>
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
enum trend_signal
  {
   up=1,
   down=-1
  };
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
struct PositionStates
  {
   int               open_buy;
   int               open_sell;
   int               open_total;
  };
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
class CFibonacciBaseStrategy:public CStrategy
  {
protected:
   double            max_price;
   double            min_price;
   trend_signal      signal;
   double            open_ratio;
   double            tp_ratio;
   double            sl_ratio;
   bool              pattern_valid;
   PositionStates    p_state;
   MqlTick           latest_price;

   void              GetPositionStates(void);//刷新当前策略的仓位信息
   bool              OpenPosition(const double p_lots);//开仓操作
   virtual void      PatternRecognize(void);//---识别模式：是否有效，模式类型，最大价格和最小价格
public:
    void              SetEventDetect(string symbol,ENUM_TIMEFRAMES time_frame);//设置监控事件

  };
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void CFibonacciBaseStrategy::GetPositionStates(void)
  {
   p_state.open_buy=0;
   p_state.open_sell=0;
   for(int i=0;i<PositionsTotal();i++)
     {
      ulong ticket=PositionGetTicket(i);
      if(!PositionSelectByTicket(ticket)) continue;
      if(PositionGetInteger(POSITION_MAGIC)!=ExpertMagic()) continue;
      if(PositionGetInteger(POSITION_TYPE)==POSITION_TYPE_BUY) p_state.open_buy++;
      else p_state.open_sell++;
      p_state.open_total++;
     }
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
bool CFibonacciBaseStrategy::OpenPosition(const double p_lots)
  {
   double tp_price,sl_price;
   if(signal==up && latest_price.ask<(max_price-min_price)*open_ratio+min_price)
     {
     Print("OPEN BUY CONDITION");
      tp_price=(max_price-min_price)*tp_ratio+min_price;
      sl_price=(max_price-min_price)*sl_ratio+min_price;
      if(Trade.PositionOpen(ExpertSymbol(),ORDER_TYPE_BUY,p_lots,latest_price.ask,sl_price,tp_price))
         return true;
     }
   else if(signal==down && latest_price.bid>max_price-(max_price-min_price)*open_ratio)
     {
     Print("OPEN SELL CONDITION");
      tp_price=max_price-(max_price-min_price)*tp_ratio;
      sl_price=max_price-(max_price-min_price)*sl_ratio;
      if(Trade.PositionOpen(ExpertSymbol(),ORDER_TYPE_SELL,p_lots,latest_price.bid,sl_price,tp_price))
         return true;
     }
   return false;
  }
void CFibonacciBaseStrategy::SetEventDetect(string symbol,ENUM_TIMEFRAMES time_frame)
  {
   AddBarOpenEvent(symbol,time_frame);
   AddTickEvent(symbol);
  }

//+------------------------------------------------------------------+
