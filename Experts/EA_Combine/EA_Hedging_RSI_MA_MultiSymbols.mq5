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
#include <strategy_czj\strategyma\SimpleDoubleMA.mqh>

CStrategyList Manager;
//string symbols[]={"EURUSD","USDJPY","GBPUSD","USDCAD","AUDUSD","AUDUSD","NZDUSD"};
string symbols[]={"CADCHF","GBPNZD","AUDCAD","GBPUSD","EURGBP","AUDNZD","CHFJPY","GBPJPY","EURCAD","EURJPY"};

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
      rsi_s[i].ExpertMagic(201801161351+i*100);
      rsi_s[i].Timeframe(_Period);
      rsi_s[i].ExpertSymbol(symbols[i]);
      rsi_s[i].SetEventDetect(symbols[i],_Period);
      rsi_s[i].InitStrategy();
      Manager.AddStrategy(rsi_s[i]);
     }
   CSimpleDoubleMA *ma_s[];
   ArrayResize(ma_s,ArraySize(ma_s));
   for(int i=0;i<ArraySize(symbols);i++)
     {
      ma_s[i]=new CSimpleDoubleMA();
      ma_s[i].ExpertName("Simple Double MA Strategy"+string(i));
      ma_s[i].ExpertMagic(201801161351+i*1000);
      ma_s[i].ExpertSymbol(symbols[i]);
      ma_s[i].SetEventDetect(symbols[i],_Period);
      ma_s[i].InitStrategy(200,24);
      Manager.AddStrategy(ma_s[i]);
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
