//+------------------------------------------------------------------+
//|                                             SymbolsIndicator.mq5 |
//|                                                       chizhijing |
//|                                             https://www.mql5.com |
//+------------------------------------------------------------------+
#property copyright "chizhijing"
#property link      "https://www.mql5.com"
#property version   "1.00"
#property indicator_separate_window

#property indicator_plots 0
#property indicator_buffers 0

#include "SymbolAnalysisDialog.mqh"
#include "FibonacciAnalysizer.mqh"

string symbol_names[]={"XAUUSD","GBPUSD","EURUSD","USDJPY","USDCAD","NZDUSD","XTIUSD"};
string indicator_names[];

CSymbolAnalysisDialog ExtDialog;
CFibonacciAnalysizer ExtFi[7];
double fi_ratio[];
//+------------------------------------------------------------------+
//| Custom indicator initialization function                         |
//+------------------------------------------------------------------+
int OnInit()
  {
//--- indicator buffers mapping
   EventSetTimer(1);
   int indicator_num=ArraySize(period_names);
   int symbol_num =ArraySize(symbol_names);
   ArrayResize(fi_ratio,indicator_num*symbol_num);
   ArrayResize(indicator_names,indicator_num);
   for(int i=0;i<indicator_num;i++)
     {
      indicator_names[i]=period_names[i];
     }
   ExtDialog.CreateTable(symbol_names, indicator_names);
   for(int j=0;j<symbol_num;j++)
     {
      ExtFi[j].Init(symbol_names[j]);
      ExtFi[j].Analysis();
      for(int i=0;i<ArraySize(ExtFi[j].fibonacci_ratio);i++)
        {
         fi_ratio[j*indicator_num+i]=ExtFi[j].fibonacci_ratio[i];
        }
     }
//   
   ExtDialog.SetIndicatorValues(fi_ratio);
//---
   return(INIT_SUCCEEDED);
  }
//+------------------------------------------------------------------+
//| Custom indicator iteration function                              |
//+------------------------------------------------------------------+
int OnCalculate(const int rates_total,
                const int prev_calculated,
                const int begin,
                const double &price[])
  {
//---
   
//--- return value of prev_calculated for next call
   return(rates_total);
  }
//+------------------------------------------------------------------+
//| Timer function                                                   |
//+------------------------------------------------------------------+
void OnTimer()
  {
//---
    int indicator_num=ArraySize(period_names);
   int symbol_num =ArraySize(symbol_names);
  for(int j=0;j<symbol_num;j++)
     {
      ExtFi[j].Analysis();
      for(int i=0;i<ArraySize(ExtFi[j].fibonacci_ratio);i++)
        {
         fi_ratio[j*indicator_num+i]=ExtFi[j].fibonacci_ratio[i];
        }
     }
   
   ExtDialog.SetIndicatorValues(fi_ratio);
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
   ExtDialog.ChartEvent(id,lparam,dparam,sparam);
  }
//+------------------------------------------------------------------+
