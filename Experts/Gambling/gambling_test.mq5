//+------------------------------------------------------------------+
//|                                                gambling_test.mq5 |
//|                                                       chizhijing |
//|                                             https://www.mql5.com |
//+------------------------------------------------------------------+
#property copyright "chizhijing"
#property link      "https://www.mql5.com"
#property version   "1.00"
#include <strategy_czj\Gambling.mqh>
#include <Strategy\StrategiesList.mqh>
//+------------------------------------------------------------------+
//| Expert initialization function                                   |
//+------------------------------------------------------------------+

CStrategyList Manager;

int OnInit()
  {
//---
   AddPositionStrategy *strategy=new AddPositionStrategy();
   strategy.ExpertMagic(2);
   strategy.Timeframe(_Period);
   strategy.ExpertSymbol(_Symbol);
   strategy.ExpertName("Gambling Test");
   strategy.SetEventDetect(_Symbol,_Period);
   Manager.AddStrategy(strategy);
//---
   return(INIT_SUCCEEDED);
  }
//+------------------------------------------------------------------+
//| Expert deinitialization function                                 |
//+------------------------------------------------------------------+
void OnDeinit(const int reason)
  {
//---
   
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
