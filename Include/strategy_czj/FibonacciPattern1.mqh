//+------------------------------------------------------------------+
//|                                            FibonacciPattern1.mqh |
//|                                                       chizhijing |
//|                                             https://www.mql5.com |
//+------------------------------------------------------------------+
#property copyright "chizhijing"
#property link      "https://www.mql5.com"
#include <strategy_czj\FibonacciBase.mqh>
//--- 早期版本
class CFibonacciPattern1:public CFibonacciBaseStrategy
  {
private:
   int               search_tau;
   int               max_mode_bar;
   int               min_point_range;
   double            position_lots;
protected:
   virtual void      PatternRecognize(void);
public:
   void              InitStrategy(const int tau_search,const int bar_max,const int point_range_min,const double pos_lots,const double ratio_open,const double ratio_tp, const double ratio_sl);
   virtual void      OnEvent(const MarketEvent &event);

  };
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void CFibonacciPattern1::InitStrategy(const int tau_search,const int bar_max,const int point_range_min,const double pos_lots,const double ratio_open,const double ratio_tp, const double ratio_sl)
  {
   search_tau=tau_search;
   max_mode_bar=bar_max;
   min_point_range=point_range_min;
   position_lots=pos_lots;
   open_ratio=ratio_open;
   tp_ratio=ratio_tp;
   sl_ratio=ratio_sl;
   
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void CFibonacciPattern1::PatternRecognize(void)
  {
   double high[],low[];
   int max_loc,min_loc;

   ArrayResize(high,search_tau);
   ArrayResize(low,search_tau);
   CopyHigh(ExpertSymbol(),Timeframe(),0,search_tau,high);
   CopyLow(ExpertSymbol(),Timeframe(),0,search_tau,low);

   max_loc=ArrayMaximum(high);
   min_loc=ArrayMinimum(low);

   signal=max_loc>min_loc?up:down;

   max_price=high[max_loc];
   min_price=low[min_loc];

   if(MathAbs(max_loc-min_loc)<max_mode_bar && max_price-min_price>min_point_range*SymbolInfoDouble(ExpertSymbol(),SYMBOL_POINT)&&max_price-min_price<5*min_point_range*SymbolInfoDouble(ExpertSymbol(),SYMBOL_POINT))
      pattern_valid=true;
   else
      pattern_valid=false;
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void CFibonacciPattern1::OnEvent(const MarketEvent &event)
  {
//监控品种的BAR事件发生时的相关处理
   if(event.symbol==ExpertSymbol() && event.type==MARKET_EVENT_BAR_OPEN)
     {
      PatternRecognize();//进行模式识别
     }
//监控品种tick事件发生时的相关处理
   if(event.symbol==ExpertSymbol() && event.type==MARKET_EVENT_TICK)
     {
      SymbolInfoTick(ExpertSymbol(),latest_price);
      GetPositionStates();//刷新仓位信息
      bool basic_buy_open_condition=pattern_valid &&p_state.open_buy==0 && signal==up;
      bool basic_sell_open_condition=pattern_valid &&p_state.open_sell==0 && signal==down;
      if(basic_buy_open_condition || basic_sell_open_condition)
         OpenPosition(position_lots);//进行开仓操作
     }
  }
//+------------------------------------------------------------------+
