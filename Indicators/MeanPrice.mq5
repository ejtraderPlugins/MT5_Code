//+------------------------------------------------------------------+
//|                                                    MeanPrice.mq5 |
//|                                                       chizhijing |
//|                                             https://www.mql5.com |
//+------------------------------------------------------------------+
#property copyright "chizhijing"
#property link      "https://www.mql5.com"
#property version   "1.00"
#property indicator_chart_window

#property  indicator_buffers 1
#property  indicator_plots 1

#property   indicator_label1 "Mean"
#property   indicator_color1 clrYellow
#property   indicator_type1   DRAW_LINE

double mean_price[];

//+------------------------------------------------------------------+
//| Custom indicator initialization function                         |
//+------------------------------------------------------------------+
int OnInit()
  {
//--- indicator buffers mapping
   SetIndexBuffer(0,mean_price,INDICATOR_DATA);
//---
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
       MqlRates rates[];
       CopyRates(_Symbol,_Period,rates_total-i,1,rates);
       mean_price[i]=(rates[0].high+rates[0].low+rates[0].open+rates[0].close)/4;
       if(i<100) continue;
       
      }
//--- return value of prev_calculated for next call
   return(rates_total);
  }
//+------------------------------------------------------------------+
