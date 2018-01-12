//+------------------------------------------------------------------+
//|                                                  StrategyRSI.mq5 |
//|                        Copyright 2018, MetaQuotes Software Corp. |
//|                                             https://www.mql5.com |
//+------------------------------------------------------------------+
#property copyright "Copyright 2018, MetaQuotes Software Corp."
#property link      "https://www.mql5.com"
#property version   "1.00"
#include <Trade\Trade.mqh>

int rsi_handle;
CTrade trade;
//+------------------------------------------------------------------+
//| Expert initialization function                                   |
//+------------------------------------------------------------------+
int OnInit()
  {
//---
   rsi_handle=iRSI(_Symbol,_Period,12,PRICE_CLOSE);
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
   double rsi_value[];
   MqlTick latest_price;
   CopyBuffer(rsi_handle,0,0,1,rsi_value);
   SymbolInfoTick(_Symbol,latest_price);
   
   if(PositionsTotal()>0)
      {
       if(PositionGetInteger(POSITION_TYPE)==POSITION_TYPE_BUY && rsi_value[0]>70)
         trade.PositionClose(_Symbol);
       if(PositionGetInteger(POSITION_TYPE)==POSITION_TYPE_SELL && rsi_value[0]<30)
         trade.PositionClose(_Symbol); 
      }
    if(PositionsTotal()==0)
      {
       if(rsi_value[0]>70)
         trade.PositionOpen(_Symbol,ORDER_TYPE_SELL,0.1,latest_price.bid,0,0,"SELL");
       if(rsi_value[0]<30)
         trade.PositionOpen(_Symbol,ORDER_TYPE_BUY,0.1,latest_price.ask,0,0,"BUY");
      }
  }
//+------------------------------------------------------------------+
