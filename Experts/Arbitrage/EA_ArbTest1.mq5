//+------------------------------------------------------------------+
//|                                                  EA_ArbTest1.mq5 |
//|                                                       chizhijing |
//|                                             https://www.mql5.com |
//+------------------------------------------------------------------+
#property copyright "chizhijing"
#property link      "https://www.mql5.com"
#property version   "1.00"
#include <Strategy\StrategiesList.mqh>
#include <strategy_czj\ArbitrageTwoSymbols.mqh>
input double pcdf_down=0.2;
input double pcdf_up=0.8;
input int num_buffer=1000;
CStrategyList Manager;

//+------------------------------------------------------------------+
//| Expert initialization function                                   |
//+------------------------------------------------------------------+
int OnInit()
  {
//--- create timer
   EventSetTimer(60);
   PairSymbolsArbitrageStrategy *s = new PairSymbolsArbitrageStrategy(num_buffer,pcdf_down,pcdf_up);
   s.ExpertName("Arbitrage");
   s.ExpertMagic(9001);
   s.ExpertSymbol("XAUUSD");
   s.Timeframe(_Period);
   s.SetEventDetect("XAUUSD",PERIOD_M1);
   s.SetEventDetect("USDJPY",PERIOD_M1);
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
