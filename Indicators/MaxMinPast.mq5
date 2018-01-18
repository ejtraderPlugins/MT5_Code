//+------------------------------------------------------------------+
//|                                                   MaxMinPast.mq5 |
//|                        Copyright 2017, MetaQuotes Software Corp. |
//|                                             https://www.mql5.com |
//+------------------------------------------------------------------+
#property copyright "Copyright 2017, MetaQuotes Software Corp."
#property link      "https://www.mql5.com"
#property version   "1.00"
#property indicator_chart_window

#property  indicator_buffers 2
#property  indicator_plots 2

#property   indicator_label1 "Max"
#property   indicator_color1 clrYellow
#property   indicator_type1   DRAW_LINE

#property   indicator_label2 "Min"
#property   indicator_color2 clrRed
#property   indicator_type2   DRAW_LINE

double max_price_buffer[];
double min_price_buffer[];

//+------------------------------------------------------------------+
//| Custom indicator initialization function                         |
//+------------------------------------------------------------------+
int OnInit()
  {
//--- indicator buffers mapping
   
//---
   SetIndexBuffer(0,max_price_buffer,INDICATOR_DATA);
   SetIndexBuffer(1,min_price_buffer,INDICATOR_DATA);
   
   return(INIT_SUCCEEDED);
  }
//+------------------------------------------------------------------+
//| Custom indicator iteration function                              |
//+------------------------------------------------------------------+
int OnCalculate(const int rates_total,
                const int prev_calculated,
                const datetime &time[],
                const double &open[],
                const double &high[],
                const double &low[],
                const double &close[],
                const long &tick_volume[],
                const long &volume[],
                const int &spread[])
  {
//---
   
   for(int i=prev_calculated;i<rates_total;i++)
      {
       double high[], low[];
       CopyHigh(_Symbol,_Period,rates_total-i,720,high);
       CopyLow(_Symbol,_Period,rates_total-i,720,low);
       max_price_buffer[i]=high[ArrayMaximum(high)];
       min_price_buffer[i]=low[ArrayMinimum(low)];
      }
//--- return value of prev_calculated for next call
   return(rates_total);
  }
//+------------------------------------------------------------------+
