//+------------------------------------------------------------------+
//|                               EA_FibonacciZigZag_MultiSymbol.mq5 |
//|                                                       chizhijing |
//|                                             https://www.mql5.com |
//+------------------------------------------------------------------+
#property copyright "chizhijing"
#property link      "https://www.mql5.com"
#property version   "1.00"
#include  <strategy_czj\FibonacciZigZag.mqh>
#include <Strategy\StrategiesList.mqh>
input int zz_depth=12;
input int zz_deviation=5;
input int zz_backstep=3;

//input int period_choose=1;
input int point_range_min=500;
input double open_ratio=0.618;
input double tp_ratio=0.882;
input double sl_ratio=-0.618;
input double position_lots=0.1;
input int num_zigzag=5;

CStrategyList Manager;
string symbols[]={"XAUUSD","XTIUSD","GBPUSD","EURUSD","USDJPY","USDCHF","AUDUSD","USDCAD","NZDUSD"};
//+------------------------------------------------------------------+
//| Expert initialization function                                   |
//+------------------------------------------------------------------+
int OnInit()
  {
//--- create timer
   EventSetTimer(60);
   for(int i=0;i<ArraySize(symbols);i++)
     {
      int handle=iCustom(symbols[i],_Period,"Examples\\ZigZag",zz_depth,zz_deviation,zz_backstep);
      FibonacciZigZagStrategy *strategy=new FibonacciZigZagStrategy();
      strategy.ExpertMagic(i+10);
      strategy.Timeframe(_Period);
      strategy.ExpertSymbol(symbols[i]);
      strategy.ExpertName("FibonacciZigZag Ratio Strategy"+symbols[i]);
      strategy.SetEventDetect(symbols[i],_Period);
      strategy.InitStrategy(handle,num_zigzag,point_range_min,open_ratio,tp_ratio,sl_ratio,position_lots);
      Manager.AddStrategy(strategy);
     }
   
      
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
