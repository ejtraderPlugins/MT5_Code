//+------------------------------------------------------------------+  
//|                                                        test3.mq5 |  
//|                        Copyright 2017, MetaQuotes Software Corp. |  
//|                                             https://www.mql5.com |  
//+------------------------------------------------------------------+  
//下面三行是版权信息，可以忽略，我这里是默认的  
#property copyright "Copyright 2017, MetaQuotes Software Corp."  
#property link      "https://www.mql5.com"  
#property version   "1.00"  
//单独绘制在幅图窗口上  
//#property indicator_separate_window  
//附加在主图上  
#property indicator_chart_window  
//这两个要一一对应，具体查表  
#property indicator_type1   DRAW_LINE  
#property indicator_plots   1  
//申请一个缓冲区域，其实就是像程序申请一块内存，然后用于划线  
#property indicator_buffers 1  
//指定划线的颜色  
#property indicator_color1 Blue



//指定一个数组，用于存放要每日平均值的点  
double ExtMapBuffer1[];  
//+------------------------------------------------------------------+  
//| Custom indicator initialization function                         |  
//+------------------------------------------------------------------+  
//这函数是初始化的时候执行的，MT5他爹规定的名字,就得这么写  
int OnInit()  
  {  
//--- indicator buffers mapping  
    //将数组和申请的缓冲区绑定，缓冲区是从0开始的，这句的意思就是 ExtMapBuffer1这个数组会用于缓冲区画图  
 SetIndexBuffer(0,ExtMapBuffer1);  
//---  
   return(INIT_SUCCEEDED);  
  }  
//+------------------------------------------------------------------+  
//| Custom indicator iteration function                              |  
//+------------------------------------------------------------------+  
//每次价格跳动的时候都会执行  
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
    for(int i=0;i<rates_total;i++)  
   {  
      ExtMapBuffer1[i]=(open[i]+high[i]+low[i]+close[i])/4;
      CopyClose("XAUUSD",  
      datetime NY=D'2017.02.01 00:00';     // 2015年初的时间   
      //画一条垂线  
      ObjectCreate(0,"test",OBJ_VLINE,0,NY,0);  
   }  
//--- return value of prev_calculated for next call  
   Print("hello");
   return(rates_total);  
  }  
//+------------------------------------------------------------------+  