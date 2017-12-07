//+------------------------------------------------------------------+
//|                                                EA_DailyTrend.mq5 |
//|                                                       chizhijing |
//|                                             https://www.mql5.com |
//+------------------------------------------------------------------+
#property copyright "chizhijing"
#property link      "https://www.mql5.com"
#property version   "1.00"
#include <strategy_czj\DailyTrend.mqh>
#include <Strategy\StrategiesList.mqh>
input double delta=3.0;
input double lots_value=0.1;
input int sl_points=450;
input int tp_points=850;

CStrategyList Manager;
//string SymbolList[]={"XAUUSD","XAGUSD","XTIUSD","EURUSD","GBPUSD","USDJPY","USDCAD","USDCHF","AUDUSD","NZDUSD"};
//string SymbolList[]={"XAUUSD","XTIUSD","GBPUSD","USDJPY"};
//string SymbolList[]={"XAUUSD","XAGUSD","XTIUSD","XBRUSD","USDJPY","USDCHF","AUDUSD","EURJPY"};
string SymbolList[]={"XAUUSD","XTIUSD","USDJPY","USDCHF","AUDUSD"};
//+------------------------------------------------------------------+
//| Expert initialization function                                   |
//+------------------------------------------------------------------+
int OnInit()
  {
//--- create timer
   DailyTrendStrategy *s[];
   //string SymbolList[1];
   //SymbolList[0]=_Symbol;
   int num_symbol=ArraySize(SymbolList);
   ArrayResize(s,num_symbol);
   
   for(int i=0;i<num_symbol;i++)
     {
      s[i]=new DailyTrendStrategy(delta,lots_value, sl_points, tp_points);
      s[i].ExpertMagic(i*10+1);
      s[i].Timeframe(_Period);
      s[i].ExpertSymbol(SymbolList[i]);
      s[i].ExpertName("DailyTrend Strategy");
      s[i].SetEventDetect(SymbolList[i],PERIOD_D1); 
      Manager.AddStrategy(s[i]);
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
