//+------------------------------------------------------------------+
//|                                           Strategy_MACD_BOLL.mq5 |
//|                                                      Daixiaorong |
//|                                             https://www.mql5.com |
//+------------------------------------------------------------------+
#property copyright "Daixiaorong"
#property link      "https://www.mql5.com"
#property version   "1.00"
#include <Strategy\StrategiesList.mqh>
#include <Strategy\Samples\Signal_MACD_BOLL.mqh>

CStrategyList Manager;
//+------------------------------------------------------------------+
//| Expert initialization function                                   |
//+------------------------------------------------------------------+
int OnInit()
  {
//---
   COnSignal_MACD_BOLL* signal = new COnSignal_MACD_BOLL();
   signal.ExpertMagic(2918);
   signal.ExpertName("MQL Signal Samples");
   signal.Timeframe(Period());
   if(!Manager.AddStrategy(signal))
      delete signal;
//---
   return(INIT_SUCCEEDED);
  }
//+------------------------------------------------------------------+
//| Expert tick function                                             |
//+------------------------------------------------------------------+
void OnTick()
{
  Manager.OnTick();
}
//+------------------------------------------------------------------+
