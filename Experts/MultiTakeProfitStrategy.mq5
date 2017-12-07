//+------------------------------------------------------------------+
//|                                      MultiTakeProfitStrategy.mq5 |
//|                                                      Daixiaorong |
//|                                             https://www.mql5.com |
//+------------------------------------------------------------------+
#property copyright "Daixiaorong"
#property link      "https://www.mql5.com"
#property version   "1.00"
#include <Strategy\StrategiesList.mqh>
#include <Strategy\Samples\TakeProfitStrategy.mqh>
input double level_gap     =150.0;
input double object_profit =230.0;
input string symbol_1      ="XAUUSD";
input string symbol_2      ="USDJPY";

CStrategyList Manager;
double Lots[]= {0.01,0.01,0.01,0.02,0.03,0.04,0.05,0.08,0.11,0.15,0.21,0.29,0.40,0.57,0.79,1.11,1.56,2.18,3.05,4.27};
//+------------------------------------------------------------------+
//| Expert initialization function                                   |
//+------------------------------------------------------------------+
int OnInit()
  {
//---
   MultiLayerTakeProfit *m_xau=new MultiLayerTakeProfit();
   m_xau.ExpertMagic(8111);
   m_xau.Timeframe(Period());
   m_xau.ExpertSymbol(symbol_1);
   m_xau.ExpertName("TakeProfit Strategy");
   m_xau.LevelGap(level_gap);
   m_xau.ObjectProfit(object_profit);
   m_xau.LevelLot(Lots);
   if(!Manager.AddStrategy(m_xau))
      delete m_xau;
      
   MultiLayerTakeProfit *m_jpy=new MultiLayerTakeProfit();
   m_jpy.ExpertMagic(8112);
   m_jpy.Timeframe(Period());
   m_jpy.ExpertSymbol(symbol_2);
   m_jpy.ExpertName("TakeProfit Strategy");
   m_jpy.LevelGap(level_gap);
   m_jpy.ObjectProfit(object_profit);
   m_jpy.LevelLot(Lots);
   if(!Manager.AddStrategy(m_jpy))
      delete m_jpy;
//---
   return(INIT_SUCCEEDED);
  }
//+------------------------------------------------------------------+
//| Expert deinitialization function                                 |
//+------------------------------------------------------------------+
void OnDeinit(const int reason)
  {
//---
   EventKillTimer();
  }
//+------------------------------------------------------------------+
//| Expert tick function                                             |
//+------------------------------------------------------------------+
void OnTick()
  {
//---
   Manager.OnTick();
  }
//+------------------------------------------------------------------+
