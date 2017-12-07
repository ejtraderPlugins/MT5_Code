//+------------------------------------------------------------------+
//|                                                 TestPattern1.mq5 |
//|                                                       chizhijing |
//|                                             https://www.mql5.com |
//+------------------------------------------------------------------+
#property copyright "chizhijing"
#property link      "https://www.mql5.com"
#property version   "1.00"
#include  <strategy_czj\FibonacciPattern1.mqh>
#include <Strategy\StrategiesList.mqh>
input int search_tau_max=500;
input int bar_num_max=50;
input int points_range_min=300;

input double open_ratio=0.618;
input double tp_ratio=0.882;
input double sl_ratio=-0.618;
input double my_lots=0.1;


CStrategyList Manager;
//+------------------------------------------------------------------+
//| Expert initialization function                                   |
//+------------------------------------------------------------------+
int OnInit()
  {
//--- create timer
   EventSetTimer(60);
   CFibonacciPattern1 *s = new CFibonacciPattern1();
   s.ExpertMagic(1);
   s.ExpertSymbol(_Symbol);
   s.ExpertName("Fibonacci Pattern1");
   s.Timeframe(_Period);
   s.SetEventDetect(_Symbol,_Period);
   s.InitStrategy(search_tau_max,bar_num_max,points_range_min,my_lots,open_ratio,tp_ratio,sl_ratio); 
   Manager.AddStrategy(s);
//---
   return(INIT_SUCCEEDED);
  }
//+------------------------------------------------------------------+
//| Expert deinitialization function                                 |
//+------------------------------------------------------------------+
void OnDeinit(const int reason)
  {
//--- destroy timer
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
//| Timer function                                                   |
//+------------------------------------------------------------------+
void OnTimer()
  {
//---
   
  }
//+------------------------------------------------------------------+
//| ChartEvent function                                              |
//+------------------------------------------------------------------+
void OnChartEvent(const int id,
                  const long &lparam,
                  const double &dparam,
                  const string &sparam)
  {
//---
   
  }
//+------------------------------------------------------------------+
