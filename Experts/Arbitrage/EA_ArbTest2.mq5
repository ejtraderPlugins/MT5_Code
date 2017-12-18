//+------------------------------------------------------------------+
//|                                                  EA_ArbTest2.mq5 |
//|                                                       chizhijing |
//|                                             https://www.mql5.com |
//+------------------------------------------------------------------+
#property copyright "chizhijing"
#property link      "https://www.mql5.com"
#property version   "1.00"
#include <Strategy\StrategiesList.mqh>
#include <Arbitrage\ArbitrageStrategy.mqh>
CStrategyList Manager;
input string symbol_x="XAUUSD";
input string symbol_y="USDJPY";
input int num_ts=1440;
input double lots_x=0.1;
input double lots_y=0.1;
input CointergrationCalType coin_cal_type=ENUM_COINTERGRATION_TYPE_MULTIPLY;
input PValueType p_cal_type=ENUM_PVALUE_TYPE_ORIGIN;
input double p_down=0.05;
input double p_up=0.95;
input double take_profits=50; 

//+------------------------------------------------------------------+
//| Expert initialization function                                   |
//+------------------------------------------------------------------+
int OnInit()
  {
//--- create timer
   CArbitrageStrategy *arb =new CArbitrageStrategy();
   arb.ExpertMagic(9002);
   arb.ExpertSymbol(symbol_x);
   arb.Timeframe(PERIOD_M1);
   arb.ExpertName("Arbitrage-2");
   arb.SetEventDetect(symbol_x,PERIOD_M1);
   arb.SetEventDetect(symbol_y,PERIOD_M1);
   arb.SetSymbolsInfor(symbol_x,symbol_y,PERIOD_M1,num_ts,lots_x,lots_y);
   arb.SetCointergrationInfor(coin_cal_type,p_cal_type);
   arb.SetOpenCloseParameter(p_down,p_up,take_profits);
   
   Manager.AddStrategy(arb);
   
      
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
