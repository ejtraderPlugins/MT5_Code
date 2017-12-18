//+------------------------------------------------------------------+
//|                                            ArbitrageStrategy.mqh |
//|                                                       chizhijing |
//|                                             https://www.mql5.com |
//+------------------------------------------------------------------+
#property copyright "chizhijing"
#property link      "https://www.mql5.com"
#include <Strategy\Strategy.mqh>
#include <Trade\Trade.mqh>
#include "Cointergration.mqh"
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
struct ArbitragePosition
  {
   int               pair_open_buy;
   int               pair_open_sell;
   int               pair_open_total;
   double            pair_buy_profit;
   double            pair_sell_profit;
   void              Init();
  };
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void ArbitragePosition::Init(void)
  {
   pair_open_buy=0;
   pair_open_sell=0;
   pair_open_total=0;
   pair_buy_profit=0.0;
   pair_sell_profit=0.0;
  }
//+------------------------------------------------------------------+
//|               套利策略类                                         |
//+------------------------------------------------------------------+
class CArbitrageStrategy:public CStrategy
  {
private:
   MqlTick           latest_price_x;
   MqlTick           latest_price_y;
   double            p_cdf;
   ArbitragePosition arb_position_states;
   double            tp;
protected:
   string            symbol_x;
   string            symbol_y;
   ENUM_TIMEFRAMES   period;
   int               num;
   double            lots_x;
   double            lots_y;
   double            p_up;
   double            p_down;

   CCointergration   cointergration_xy;
   double            point_x;
   double            point_y;
protected:
   void              UpdateCointergrationOnBar(void);//bar事件发生时候更新协整序列
   void              CloseArbitrageBuyPosition();//套利对买仓平仓
   void              CloseArbitrageSellPosition();//套利对卖仓平仓
public:
                     CArbitrageStrategy(void);
                    ~CArbitrageStrategy(void){};
                    void SetSymbolsInfor(string symbol_1, string symbol_2, ENUM_TIMEFRAMES tf, int num_max, double lots_1, double lots_2);//设置品种基本信息
                    void SetCointergrationInfor(CointergrationCalType coin_type, PValueType p_type);//设置协整关系的计算方式
                    void SetOpenCloseParameter(double cdf_down, double cdf_up, double tp_value);//设置开平仓条件的参数值
   virtual void      ArbitrageOpen(void);//套利开仓操作
   virtual void      ArbitrageClose(void);//套利平仓操作
   virtual void      OnEvent(const MarketEvent &event);//事件处理
   void              RefreshPosition(void);//刷新仓位信息
   void              SetEventDetect(string symbol,ENUM_TIMEFRAMES time_frame);
  };
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
CArbitrageStrategy::CArbitrageStrategy(void)
  {
   //symbol_x="XAUUSD";
   //symbol_y="USDJPY";
   //period=PERIOD_M1;
   //num=1500;
   //lots_x=0.1;
   //lots_y=0.1;
   //cointergration_xy.SetParameters(num,ENUM_COINTERGRATION_TYPE_MULTIPLY,ENUM_PVALUE_TYPE_ORIGIN);
   //point_x=SymbolInfoDouble(symbol_x,SYMBOL_POINT);
   //point_y=SymbolInfoDouble(symbol_y,SYMBOL_POINT);
   //p_up=0.8;
   //p_down=0.2;
   //tp=40;
  }
void CArbitrageStrategy::SetSymbolsInfor(string symbol_1,string symbol_2,ENUM_TIMEFRAMES tf,int num_max,double lots_1,double lots_2)
   {
    symbol_x=symbol_1;
      symbol_y=symbol_2;
      period=tf;
      num=num_max;
      lots_x=lots_1;
      lots_y=lots_2;
      point_x=SymbolInfoDouble(symbol_1,SYMBOL_POINT);
   point_y=SymbolInfoDouble(symbol_2,SYMBOL_POINT);
   }
void CArbitrageStrategy::SetCointergrationInfor(CointergrationCalType coin_type,PValueType p_type)
   {
    cointergration_xy.SetParameters(num,coin_type,p_type);
   }
void CArbitrageStrategy::SetOpenCloseParameter(double cdf_down,double cdf_up,double tp_value)
   {
    p_up=cdf_up;
    p_down=cdf_down;
    tp=tp_value;
   }
void CArbitrageStrategy::UpdateCointergrationOnBar(void)
   {
    double x_price[];
    double y_price[];
    if(MathAbs(int(latest_price_x.time)-int(latest_price_y.time))<60*5)
      cointergration_xy.AddValue((latest_price_x.ask+latest_price_x.bid)/2,(latest_price_y.ask+latest_price_y.bid)/2);
   }
//+------------------------------------------------------------------+
//|               事件处理                                           |
//+------------------------------------------------------------------+
void CArbitrageStrategy::OnEvent(const MarketEvent &event)
  {
//挂载品种bar事件发生时候更新协整序列
   if(event.symbol==symbol_x && event.type==MARKET_EVENT_BAR_OPEN)
      UpdateCointergrationOnBar();
//Tick事件发生时，进行平仓操作（如果能平），进行开仓操作（如果能开）
   if((event.symbol==symbol_x || event.symbol==symbol_y) && event.type==MARKET_EVENT_TICK)
     {
      SymbolInfoTick(symbol_x,latest_price_x);
      SymbolInfoTick(symbol_y,latest_price_y);
      if(!cointergration_xy.Valid()) return;
      p_cdf=cointergration_xy.CDF(latest_price_x.bid,latest_price_y.bid);
      RefreshPosition();
      //Print("position num:",p_cdf, arb_position_states.pair_open_total);
      ArbitrageClose();
      ArbitrageOpen();
     }
  }
//+------------------------------------------------------------------+
//|         刷新套利仓位信息                                         |
//+------------------------------------------------------------------+
void CArbitrageStrategy::RefreshPosition(void)
  {
   arb_position_states.Init();
   for(int i=0;i<ActivePositions.Total();i++)
     {
      CPosition *cpos=ActivePositions.At(i);
      if(cpos.ExpertMagic()!=ExpertMagic())continue;
      if(cpos.Symbol()==symbol_x)
        {
         arb_position_states.pair_open_total++;
         if(cpos.Direction()==POSITION_TYPE_BUY)
           {
            arb_position_states.pair_open_buy++;
            arb_position_states.pair_buy_profit+=cpos.Profit();
           }
         else
           {
            arb_position_states.pair_open_sell++;
            arb_position_states.pair_sell_profit+=cpos.Profit();
           }

        }
      if(cpos.Symbol()==symbol_y)
        {
         switch(cointergration_xy.GetRelation())
           {
            case ENUM_RELATION_TYPE_NEGATIVE:
               if(cpos.Direction()==POSITION_TYPE_BUY) arb_position_states.pair_buy_profit+=cpos.Profit();
               else arb_position_states.pair_sell_profit+=cpos.Profit();
               break;
            case ENUM_RELATION_TYPE_POSITIVE:
               if(cpos.Direction()==POSITION_TYPE_SELL) arb_position_states.pair_buy_profit+=cpos.Profit();
               else arb_position_states.pair_sell_profit+=cpos.Profit();
               break;
            default:
               Print("Relation not definde!");
               break;
           }
        }
     }
  }
//+------------------------------------------------------------------+
//|               满足套利平仓条件进行平仓                           |
//+------------------------------------------------------------------+
void CArbitrageStrategy::ArbitrageClose(void)
  {
   if(arb_position_states.pair_buy_profit>tp || p_cdf>p_up)
      {
       //Print("close buy:", p_cdf, arb_position_states.pair_buy_profit>tp, p_cdf>p_up);
       CloseArbitrageBuyPosition();
      }
      
   if(arb_position_states.pair_sell_profit>tp || p_cdf<p_down)
      CloseArbitrageSellPosition();
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void CArbitrageStrategy::CloseArbitrageBuyPosition(void)
  {
   for(int i=0;i<ActivePositions.Total();i++)
     {
      CPosition *cpos=ActivePositions.At(i);
      if(cpos.ExpertMagic()!=ExpertMagic()) continue;
      if(cpos.Symbol()==symbol_x && cpos.Direction()==POSITION_TYPE_BUY)
         Trade.PositionClose(cpos.ID());
      if(cpos.Symbol()==symbol_y)
        {
         if(cointergration_xy.GetRelation()==ENUM_RELATION_TYPE_POSITIVE && cpos.Direction()==POSITION_TYPE_SELL)
            Trade.PositionClose(cpos.ID());
         if(cointergration_xy.GetRelation()==ENUM_RELATION_TYPE_NEGATIVE && cpos.Direction()==POSITION_TYPE_BUY)
            Trade.PositionClose(cpos.ID());
        }
     }
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void CArbitrageStrategy::CloseArbitrageSellPosition(void)
  {
   for(int i=0;i<ActivePositions.Total();i++)
     {
      CPosition *cpos=ActivePositions.At(i);
      if(cpos.ExpertMagic()!=ExpertMagic()) continue;
      if(cpos.Symbol()==symbol_x && cpos.Direction()==POSITION_TYPE_SELL)
         Trade.PositionClose(cpos.ID());
      if(cpos.Symbol()==symbol_y)
        {
         if(cointergration_xy.GetRelation()==ENUM_RELATION_TYPE_POSITIVE && cpos.Direction()==POSITION_TYPE_BUY)
            Trade.PositionClose(cpos.ID());
         if(cointergration_xy.GetRelation()==ENUM_RELATION_TYPE_NEGATIVE && cpos.Direction()==POSITION_TYPE_SELL)
            Trade.PositionClose(cpos.ID());
        }
     }
  }
//+------------------------------------------------------------------+
//|               满足套利开仓条件进行开仓                           |
//+------------------------------------------------------------------+
void CArbitrageStrategy::ArbitrageOpen(void)
  {
   if(arb_position_states.pair_open_total>0) return;
   if(p_cdf<p_down)
     {
      switch(cointergration_xy.GetRelation())
        {
         case ENUM_RELATION_TYPE_NEGATIVE:
            Trade.PositionOpen(symbol_x,ORDER_TYPE_BUY,lots_x,latest_price_x.ask,0,0);
            Trade.PositionOpen(symbol_y,ORDER_TYPE_BUY,lots_y,latest_price_y.ask,0,0);
            break;
         case ENUM_RELATION_TYPE_POSITIVE:
            Trade.PositionOpen(symbol_x,ORDER_TYPE_BUY,lots_x,latest_price_x.ask,0,0);
            Trade.PositionOpen(symbol_y,ORDER_TYPE_SELL,lots_y,latest_price_y.bid,0,0);
            break;
         default:
            Print("Relation ship has not defined!");
            break;
        }
      return;
     }
   if(p_cdf>p_up)
     {
      switch(cointergration_xy.GetRelation())
        {
         case ENUM_RELATION_TYPE_NEGATIVE:
            Trade.PositionOpen(symbol_x,ORDER_TYPE_SELL,lots_x,latest_price_x.bid,0,0);
            Trade.PositionOpen(symbol_y,ORDER_TYPE_SELL,lots_y,latest_price_y.bid,0,0);
            break;
         case ENUM_RELATION_TYPE_POSITIVE:
            Trade.PositionOpen(symbol_x,ORDER_TYPE_SELL,lots_x,latest_price_x.bid,0,0);
            Trade.PositionOpen(symbol_y,ORDER_TYPE_BUY,lots_y,latest_price_y.ask,0,0);
            break;
         default:
            Print("Relation ship has not defined!");
            break;
        }
      return;
     }
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void CArbitrageStrategy::SetEventDetect(string symbol,ENUM_TIMEFRAMES time_frame)
  {
   AddBarOpenEvent(symbol,time_frame);
   AddTickEvent(symbol);
  }

//+------------------------------------------------------------------+
