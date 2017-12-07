//+------------------------------------------------------------------+
//|                                                 StrategyMACD.mq5 |
//|                                      Copyright 2017,Daixiaorong. |
//|                                             https://www.mql5.com |
//+------------------------------------------------------------------+
#property copyright "Copyright 2017,Daixiaorong."
#property link      "https://www.mql5.com"
#property version   "1.00"
#include <Strategy\StrategiesList.mqh>
#include <Strategy\Samples\SignalWithAdapter.mqh>
CStrategyList Manager;
//+------------------------------------------------------------------+
//| Expert initialization function                                   |
//+------------------------------------------------------------------+
int OnInit()
  {
   CAdapterMACD* signal = new CAdapterMACD();
   signal.ExpertMagic(20170908);
   signal.ExpertName("MQL Signal Samples");
   signal.Timeframe(Period());
   if(!Manager.AddStrategy(signal))
      delete signal;
   return(INIT_SUCCEEDED);
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
