//+------------------------------------------------------------------+
//|                                                 MultiSymbols.mq5 |
//|                                                       chizhijing |
//|                                             https://www.mql5.com |
//+------------------------------------------------------------------+
#property copyright "chizhijing"
#property link      "https://www.mql5.com"
#property version   "1.00"
#property indicator_separate_window
#property indicator_buffers 9
#property indicator_plots 9
#property indicator_type1 DRAW_LINE
#property indicator_type2 DRAW_LINE
#property indicator_type3 DRAW_LINE
#property indicator_type4 DRAW_LINE
#property indicator_type5 DRAW_LINE
#property indicator_type6 DRAW_LINE
#property indicator_type7 DRAW_LINE
#property indicator_type8 DRAW_LINE
#property indicator_type9 DRAW_LINE
#property indicator_color1 LightSeaGreen
#property indicator_color2 LightSeaGreen
#property indicator_color3 LightSeaGreen
#property indicator_color4 LightSeaGreen
#property indicator_color5 LightSeaGreen
#property indicator_color6 LightSeaGreen
#property indicator_color7 LightSeaGreen
#property indicator_color8 LightSeaGreen
#property indicator_color9 LightSeaGreen
#property indicator_label1 "XAUUSD"
#property indicator_label2 "XTIUSD"
#property indicator_label3 "EURUSD"
#property indicator_label4 "GBPUSD"
#property indicator_label5 "AUDUSD"
#property indicator_label6 "NZDUSD"
#property indicator_label7 "USDJPY"
#property indicator_label8 "USDCHF"
#property indicator_label9 "USDCAD"


//+------------------------------------------------------------------+
//| Custom indicator initialization function                         |
//+------------------------------------------------------------------+
int OnInit()
  {
//--- indicator buffers mapping
   
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
   int limit=prev_calculated;
   
//--- return value of prev_calculated for next call
   return(rates_total);
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
