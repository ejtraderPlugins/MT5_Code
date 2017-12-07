//+------------------------------------------------------------------+
//|                                                 TestPattern2.mq5 |
//|                                                       chizhijing |
//|                                             https://www.mql5.com |
//+------------------------------------------------------------------+
#property copyright "chizhijing"
#property link      "https://www.mql5.com"
#property version   "1.00"
#include  <strategy_czj\FibonacciPattern2.mqh>
#include <Strategy\StrategiesList.mqh>

input double open_ratio=0.7;
input double tp_ratio=0.9;
input double sl_ratio=-1.0;
input double my_lots=0.1;
input int position_max=10;
input int num_zigzag=9;
input int point_range=500;
input int tau_zigzag=45;
input int c_mode=2;
input double z_ratio=1.2;

CStrategyList Manager;
//+------------------------------------------------------------------+
//| Expert initialization function                                   |
//+------------------------------------------------------------------+
int OnInit()
  {
//--- create timer
   CFibonacciPattern2 *s = new CFibonacciPattern2();
   s.ExpertMagic(2);
   s.ExpertSymbol(_Symbol);
   s.ExpertName("Fibonacci Pattern2");
   s.Timeframe(_Period);
   s.SetEventDetect(_Symbol,_Period);
   s.InitStrategy(open_ratio,tp_ratio,sl_ratio,my_lots,position_max,point_range,num_zigzag,tau_zigzag,c_mode,z_ratio); 
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

