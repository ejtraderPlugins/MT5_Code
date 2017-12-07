//+------------------------------------------------------------------+
//|                                           TakeProfitStrategy.mq5 |
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

CStrategyList Manager;
double Lots[]= {0.01,0.01,0.01,0.02,0.03,0.04,0.05,0.08,0.11,0.15,0.21,0.29,0.40,0.57,0.79,1.11,1.56,2.18,3.05,4.27};
//double Lots[]= {0.04,0.08,0.12,0.24,0.36,0.56,1.12,2.12,1.51,1.31,1.21,1.10,1.00,0.90,0.79,0.50,0.40,0.30,0.20,0.10};
//double Lots[]= {0.04,0.04,0.04,0.06,0.08,0.12,0.15,0.20,0.25,0.35,0.45,0.55,0.65,0.75,0.85,1.00,1.10,1.20,1.30,1.40};
//+------------------------------------------------------------------+
//| Expert initialization function                                   |
//+------------------------------------------------------------------+
int OnInit()
  {
//---
   MultiLayerTakeProfit *m_tp=new MultiLayerTakeProfit();
   m_tp.ExpertMagic(8111);
   m_tp.Timeframe(Period());
   m_tp.ExpertSymbol(Symbol());
   m_tp.ExpertName("TakeProfit Strategy");
   m_tp.LevelGap(level_gap);
   m_tp.ObjectProfit(object_profit);
   m_tp.LevelLot(Lots);
   if(!Manager.AddStrategy(m_tp))
      delete m_tp;
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
