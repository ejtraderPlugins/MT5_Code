//+------------------------------------------------------------------+
//|                                             EA_BreakPointRSI.mq5 |
//|                        Copyright 2018, MetaQuotes Software Corp. |
//|                                             https://www.mql5.com |
//+------------------------------------------------------------------+
#property copyright "Copyright 2018, MetaQuotes Software Corp."
#property link      "https://www.mql5.com"
#property version   "1.00"
#include <Strategy\StrategiesList.mqh>
#include <strategy_czj\strategyRSI\GridAddRSI.mqh>

CStrategyList Manager;
string symbols[]={"EURUSD","USDJPY","GBPUSD","USDCAD","AUDUSD","AUDUSD","NZDUSD"};

//+------------------------------------------------------------------+
//| Expert initialization function                                   |
//+------------------------------------------------------------------+
int OnInit()
  {
//---
   CGridAddRSIStrategy *rsi_s[];
   ArrayResize(rsi_s,ArraySize(symbols));
   for(int i=0;i<ArraySize(symbols);i++)
     {
      rsi_s[i]=new CGridAddRSIStrategy();
      rsi_s[i].ExpertName("RSI Grid add Strategy"+string(i));
      rsi_s[i].ExpertMagic(2018012204+i*100);
      rsi_s[i].Timeframe(_Period);
      rsi_s[i].ExpertSymbol(symbols[i]);
      rsi_s[i].SetEventDetect(symbols[i],_Period);
      Manager.AddStrategy(rsi_s[i]);
      
     }
   
   
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
