//+------------------------------------------------------------------+
//|                                      XAUUSD_USDJPY_SUM_POINT.mq5 |
//|                        Copyright 2017, MetaQuotes Software Corp. |
//|                                             https://www.mql5.com |
//+------------------------------------------------------------------+

#property copyright "Copyright 2017, MetaQuotes Software Corp."
#property link      "https://www.mql5.com"
#property version   "1.00"
#property indicator_separate_window

#property indicator_buffers 4
#property indicator_plots   4

#property indicator_label1  "Mean"
#property indicator_type1   DRAW_LINE
#property indicator_color1  clrMagenta
#property indicator_style1  STYLE_SOLID
#property indicator_width1  1

#property indicator_label2  "BOLL_Medium"
#property indicator_type2   DRAW_LINE
#property indicator_color2  clrYellow
#property indicator_style2  STYLE_SOLID
#property indicator_width2  1

#property indicator_label3  "BOLL_Up"
#property indicator_type3   DRAW_LINE
#property indicator_color3  clrLawnGreen
#property indicator_style3  STYLE_SOLID
#property indicator_width3  1

#property indicator_label4  "BOLL_Down"
#property indicator_type4   DRAW_LINE
#property indicator_color4  clrLawnGreen
#property indicator_style4  STYLE_SOLID
#property indicator_width4  1

//--- input parameters
input int      period_tau=240;
input float    boll_delta=2.0;
//--- indicator buffers
double         SUM_POINTBuffer[];
double         BOLL_UPBuffer[];
double         BOLL_MIDDLEBuffer[];
double         BOLL_DOWNBuffer[];

#include <Math\Stat\Math.mqh> 
//+------------------------------------------------------------------+
//| Custom indicator initialization function                         |
//+------------------------------------------------------------------+
int OnInit()
  {
//--- indicator buffers mapping
   SetIndexBuffer(0,SUM_POINTBuffer,INDICATOR_DATA);
   SetIndexBuffer(1,BOLL_MIDDLEBuffer,INDICATOR_DATA);
   SetIndexBuffer(2,BOLL_UPBuffer,INDICATOR_DATA);
   SetIndexBuffer(3,BOLL_DOWNBuffer,INDICATOR_DATA);

//---
   return(INIT_SUCCEEDED);
  }
//+------------------------------------------------------------------+
//| Custom indicator iteration function                              |
//+------------------------------------------------------------------+
int OnCalculate(const int rates_total,
                const int prev_calculated,
                const int begin,
                const double &price[],
                )
  {
   int limit;
   if(prev_calculated == 0)
         limit=0;
   else
         limit=prev_calculated;
   double  close_xauusd[];
   double  close_usdjpy[];
   CopyClose("XAUUSD",PERIOD_CURRENT,0,rates_total,close_xauusd);
   CopyClose("USDJPY",PERIOD_CURRENT,0,rates_total,close_usdjpy);
   int num_loss_xauusd = rates_total -ArraySize(close_xauusd);
   int num_loss_usdjpy = rates_total -ArraySize(close_usdjpy);
   for(int i=limit;i<rates_total;i++)
      {  
         //Print(ArraySize(close_xauusd)," ", ArraySize(close_usdjpy), " ", rates_total, " ",num_loss_xauusd, " ",num_loss_usdjpy);
         //Print(mql_xauusd[i_xauusd].time, " ",mql_xauusd[i_xauusd].close," ", mql_usdjpy[i_usdjpy].close);
         if(i<num_loss_xauusd || i<num_loss_usdjpy)
            SUM_POINTBuffer[i]=0;
         else
            SUM_POINTBuffer[i]=(close_xauusd[i-num_loss_xauusd]*100+close_usdjpy[i-num_loss_usdjpy]*1000)/2;
      }
      
   BollOnBuffer(rates_total,prev_calculated,0,period_tau,boll_delta,SUM_POINTBuffer,BOLL_MIDDLEBuffer, BOLL_UPBuffer,BOLL_DOWNBuffer);
   //Print(ArraySize(SUM_POINTBuffer));
   return(rates_total);
  }
//+------------------------------------------------------------------+


//+------------------------------------------------------------------+

int BollOnBuffer(const int rates_total,const int prev_calculated,const int begin,
                 const int period,const double boll_slope, const double &price[],double &buffer_boll_mean[], double &buffer_boll_up[],double &buffer_boll_down[])
  {
   int i,limit;
//--- check for data
   if(period<=1 || rates_total-begin<period) return(0);
//--- save as_series flags
   bool as_series_price=ArrayGetAsSeries(price);
   bool as_series_buffer_mean=ArrayGetAsSeries(buffer_boll_mean);
   bool as_series_buffer_up=ArrayGetAsSeries(buffer_boll_up);
   bool as_series_buffer_down=ArrayGetAsSeries(buffer_boll_down);
   
   if(as_series_price) ArraySetAsSeries(price,false);
   if(as_series_buffer_mean) ArraySetAsSeries(buffer_boll_mean,false);
   if(as_series_buffer_up) ArraySetAsSeries(buffer_boll_up,false);
   if(as_series_buffer_down) ArraySetAsSeries(buffer_boll_down,false);
//--- first calculation or number of bars was changed
   if(prev_calculated==0) // first calculation
     {
      limit=period+begin;
      //--- set empty value for first bars
      for(i=0;i<limit-1;i++)
         {
            buffer_boll_mean[i]=0.0;
            buffer_boll_up[i]=0.0;
            buffer_boll_down[i]=0.0;
         } 
      //--- calculate first visible value
      double firstValue=0;
      for(i=begin;i<limit;i++)
         firstValue+=price[i];
      firstValue/=period;
      buffer_boll_mean[limit-1]=firstValue;
      buffer_boll_up[limit-1]=firstValue;
      buffer_boll_down[limit-1]=firstValue;
     }
   else limit=prev_calculated-1;
//--- main loop
   for(i=limit;i<rates_total;i++)
      {
         double mean=0;
         double move_price[];
         ArrayResize(move_price, period, period);
         int i_price=0;
         double std=0;
         for(int j=i-period;j<i;j++)
            {  
               move_price[i_price]=price[j];
               i_price++;
            }
         mean=MathMean(move_price);
         std=MathStandardDeviation(move_price);
         
         buffer_boll_mean[i]=mean;
         buffer_boll_up[i]=mean+boll_slope*std;
         buffer_boll_down[i]=mean-boll_slope*std;
      }
//--- restore as_series flags
   if(as_series_price) ArraySetAsSeries(price,true);
   if(as_series_buffer_mean) ArraySetAsSeries(buffer_boll_mean,true);
   if(as_series_buffer_up) ArraySetAsSeries(buffer_boll_up,true);
   if(as_series_buffer_down) ArraySetAsSeries(buffer_boll_down,true);
//---
   return(rates_total);
  }
//+------------------------------------------------------------------+

