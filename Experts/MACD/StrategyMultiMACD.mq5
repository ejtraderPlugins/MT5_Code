//+------------------------------------------------------------------+
//|                                            StrategyMultiMACD.mq5 |
//|                                                      Daixiaorong |
//|                                             https://www.mql5.com |
//+------------------------------------------------------------------+
#property copyright "Daixiaorong"
#property link      "https://www.mql5.com"
#property version   "1.00"
#include <Strategy\StrategiesList.mqh>
#include <Strategy\Samples\SignalMultiMACD.mqh>

CStrategyList Manager;
//+------------------------------------------------------------------+
//| Expert initialization function                                   |
//+------------------------------------------------------------------+
int OnInit()
  {
//---
   COnSignal_M_MACD *signal=new COnSignal_M_MACD();
   signal.ExpertMagic(2918);
   signal.ExpertName("Multi_MACD Signal ");
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
//| OnChartEvent function                                               |
//+------------------------------------------------------------------+
void OnChartEvent(const int id,const long &lparam,const double &dparam,const string &sparam)
{
   Manager.OnChartEvent(id, lparam, dparam, sparam);
}
//+------------------------------------------------------------------+
