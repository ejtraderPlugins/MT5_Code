//+------------------------------------------------------------------+
//|                                                     EA_trend.mq5 |
//|                                                       chizhijing |
//|                                             https://www.mql5.com |
//+------------------------------------------------------------------+
#property copyright "chizhijing"
#property link      "https://www.mql5.com"
#property version   "1.00"
#include <Trade\Trade.mqh>
input double k=0.7;
input int win_points=200;
input int loss_points=100;
input double position_lots=0.1;

double open_today[1];
double high_yestoday[1];
double low_yestoday[1];
MqlTick latest_price;
CTrade ExtTrade;
//+------------------------------------------------------------------+
//| Expert initialization function                                   |
//+------------------------------------------------------------------+
int OnInit()
  {
//--- create timer
   EventSetTimer(60);

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
   SymbolInfoTick(_Symbol,latest_price);
   //CopyOpen(_Symbol,PERIOD_D1,0,1,open_today);
   //CopyHigh(_Symbol,PERIOD_D1,1,1,high_yestoday);
   //CopyLow(_Symbol,PERIOD_D1,1,1,low_yestoday);

   CopyOpen(_Symbol,_Period,0,1,open_today);
   CopyHigh(_Symbol,_Period,1,1,high_yestoday);
   CopyLow(_Symbol,_Period,1,1,low_yestoday);
   
   for(int i=0;i<PositionsTotal();i++)
     {
      long ticket;
      datetime position_open_time;
      MqlDateTime p_time,now_time;
      TimeCurrent(now_time);
      position_open_time=PositionGetInteger(POSITION_TIME);
      TimeToStruct(position_open_time,p_time);
      PositionGetInteger(POSITION_TICKET,ticket);
      //if(now_time.day>p_time.day)
      //   ExtTrade.PositionClose(ticket);
     }
   int num_position=PositionsTotal();
   if(num_position>0) return;
   if(latest_price.ask<open_today[0]-k*(high_yestoday[0]-low_yestoday[0]))
      ExtTrade.PositionOpen(_Symbol,ORDER_TYPE_SELL,position_lots,latest_price.bid,latest_price.bid+loss_points*_Point,latest_price.bid-win_points*_Point,"sell");
   if(latest_price.bid>open_today[0]+k*(high_yestoday[0]-low_yestoday[0]))
      ExtTrade.PositionOpen(_Symbol,ORDER_TYPE_BUY,position_lots,latest_price.ask,latest_price.ask-loss_points*_Point,latest_price.ask+win_points*_Point,"buy");

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
