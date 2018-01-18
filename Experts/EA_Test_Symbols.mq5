//+------------------------------------------------------------------+
//|                                              EA_Test_Symbols.mq5 |
//|                        Copyright 2018, MetaQuotes Software Corp. |
//|                                             https://www.mql5.com |
//+------------------------------------------------------------------+
#property copyright "Copyright 2018, MetaQuotes Software Corp."
#property link      "https://www.mql5.com"
#property version   "1.00"
#include <Trade\Trade.mqh>
   CTrade         my_trade;                      // trading object
   bool first=true;

//+------------------------------------------------------------------+
//| Expert initialization function                                   |
//+------------------------------------------------------------------+
int OnInit()
  {
//---
   

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
   if(!first) return;
   for(int i=0;i<SymbolsTotal(false);i++)
     {
      MqlTick latest_price;
      SymbolInfoTick(SymbolName(i,false),latest_price);
      my_trade.PositionOpen(SymbolName(i,false),ORDER_TYPE_BUY,0.02,latest_price.ask,0,0);
     }
   for(int i=0;i<SymbolsTotal(false);i++)
     {
      my_trade.PositionClose(SymbolName(i,false));
     }
   first=false;
   
  }
//+------------------------------------------------------------------+
