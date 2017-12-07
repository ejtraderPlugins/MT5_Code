//+------------------------------------------------------------------+
//|                                                          czj.mq5 |
//|                                                       chizhijing |
//|                                             https://www.mql5.com |
//+------------------------------------------------------------------+
#property copyright "chizhijing"
#property link      "https://www.mql5.com"
#property version   "1.00"
#include "Program.mqh"
CProgram program;
//+------------------------------------------------------------------+
//| Expert initialization function                                   |
//+------------------------------------------------------------------+
int OnInit()
  {
   ulong tick_counter=GetTickCount();
   //program.OnInitEvent();
   if(!program.CreateGUI())
      {
       ::Print(__FUNCTION__," > Failed to create graphical interface!");
       return(INIT_FAILED);
      }
      Print(__FUNCTION__," > objects total: ",ObjectsTotal(0),"; total ms: ",GetTickCount()-tick_counter);
//---
   return(INIT_SUCCEEDED);
  }
//+------------------------------------------------------------------+
//| Expert deinitialization function                                 |
//+------------------------------------------------------------------+
void OnDeinit(const int reason)
  {
//--- destroy timer
   
   program.OnDeinitEvent(reason);
      
  }
//+------------------------------------------------------------------+
//| Expert tick function                                             |
//+------------------------------------------------------------------+
void OnTick()
  {
//---
   
  }
//+------------------------------------------------------------------+
//| Timer function                                                   |
//+------------------------------------------------------------------+
void OnTimer()
  {
//---
   program.OnTimerEvent();
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
   program.ChartEvent(id,lparam,dparam,sparam);
  }
//+------------------------------------------------------------------+
