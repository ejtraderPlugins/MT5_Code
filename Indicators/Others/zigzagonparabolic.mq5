//+------------------------------------------------------------------+
//|                                              ZigZag on Parabolic |
//|                                      Copyright © 2009, EarnForex |
//|                                        http://www.earnforex.com/ |
//+------------------------------------------------------------------+
//---- author of the indicator
#property copyright "Copyright © 2009, EarnForex"
//---- link to the website of the author
#property link      "http://www.earnforex.com"
//---- indicator version
#property version   "1.01"
#property description "ZigZag on Parabolic"
//+----------------------------------------------+ 
//|  Indicator drawing parameters                |
//+----------------------------------------------+ 
//---- drawing the indicator in the main window
#property indicator_chart_window 
//---- 3 buffers are used for calculation and drawing the indicator
#property indicator_buffers 3
//---- only 1 plot is used
#property indicator_plots   1
//---- ZIGZAG is used for the indicator
#property indicator_type1   DRAW_COLOR_ZIGZAG
//---- displaying the indicator label
#property indicator_label1  "ZigZag"
//---- the following colors are used for the indicator line
#property indicator_color1 DarkSalmon,DodgerBlue
//---- the indicator line is a long dashed line
#property indicator_style1  STYLE_DASH
//---- indicator line width is equal to 1
#property indicator_width1  1
//+----------------------------------------------+ 
//|  Indicator input parameters                  |
//+----------------------------------------------+ 
input double Step=0.02;         // SAR step
input double Maximum=0.2;       // SAR maximum
input bool ExtremumsShift=true; // Top shift flag
//+----------------------------------------------+
//---- declaration of dynamic arrays that further 
//---- will be used as indicator buffers
double LowestBuffer[];
double HighestBuffer[];
double ColorBuffer[];
//---- declaration of integer variables
int EShift;
//---- declaration of the integer variables for the start of data calculation
int min_rates_total;
//---- declaration of integer variables for the indicators handles
int SAR_Handle;
//+------------------------------------------------------------------+ 
//| Custom indicator initialization function                         |
//+------------------------------------------------------------------+ 
void OnInit()
  {
//---- initialization of variables of the start of data calculation
   min_rates_total=1;
//---- initialize constants   
   if(ExtremumsShift) EShift=1;
   else               EShift=0;
//---- getting handle of the SAR indicator
   SAR_Handle=iSAR(NULL,0,Step,Maximum);
   if(SAR_Handle==INVALID_HANDLE)Print(" Failed to get handle of the SAR indicator");
//---- set LowestBuffer[], HighestBuffer[] and ColorBuffer[] dynamic arrays as indicator buffers
   SetIndexBuffer(0,LowestBuffer,INDICATOR_DATA);
   SetIndexBuffer(1,HighestBuffer,INDICATOR_DATA);
   SetIndexBuffer(2,ColorBuffer,INDICATOR_COLOR_INDEX);
//---- restriction to draw empty values for the indicator
   PlotIndexSetDouble(0,PLOT_EMPTY_VALUE,0.0);
   PlotIndexSetDouble(1,PLOT_EMPTY_VALUE,0.0);
//---- create labels to display in Data Window
   PlotIndexSetString(0,PLOT_LABEL,"ZigZag Lowest");
   PlotIndexSetString(1,PLOT_LABEL,"ZigZag Highest");
//---- indexing the elements in buffers as timeseries   
   ArraySetAsSeries(LowestBuffer,true);
   ArraySetAsSeries(HighestBuffer,true);
   ArraySetAsSeries(ColorBuffer,true);
//---- set the position, from which the Bollinger Bands drawing starts
   PlotIndexSetInteger(0,PLOT_DRAW_BEGIN,min_rates_total);
   PlotIndexSetInteger(1,PLOT_DRAW_BEGIN,min_rates_total);
//---- setting the format of accuracy of displaying the indicator
   IndicatorSetInteger(INDICATOR_DIGITS,_Digits);
//---- name for the data window and for the label of sub-windows 
   string shortname;
   StringConcatenate(shortname,"ZigZag on Parabolic(",
                     double(Step),", ",double(Maximum),", ",bool(ExtremumsShift),")");
   IndicatorSetString(INDICATOR_SHORTNAME,shortname);
//----   
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
//---- checking the number of bars to be enough for the calculation
   if(BarsCalculated(SAR_Handle)<rates_total || rates_total<min_rates_total)return(0);
//---- declarations of local variables 
   static int j_,lastcolor_;
   static bool dir_;
   static double h_,l_;
   int j,limit,climit,to_copy,bar,shift,NewBar,lastcolor;
   double h,l,mid0,mid1,SAR[];
   bool dir;
//---- calculate the limit starting index for loop of bars recalculation and start initialization of variables
   if(prev_calculated>rates_total || prev_calculated<=0)// checking for the first start of the indicator calculation
     {
      limit=rates_total-1-min_rates_total; // starting index for calculation of all bars

      h_=0.0;
      l_=999999999;
      dir_=false;
      j_=0;
      lastcolor_=0;
     }
   else
     {
      limit=rates_total-prev_calculated; // starting index for calculation of new bars
     }

   climit=limit; // starting index for the indicator coloring

   to_copy=limit+2;
   if(limit==0) NewBar=1;
   else         NewBar=0;
//---- indexing elements in arrays as timeseries 
   ArraySetAsSeries(SAR,true);
   ArraySetAsSeries(high,true);
   ArraySetAsSeries(low,true);
//---- copy newly appeared data in the array
   if(CopyBuffer(SAR_Handle,0,0,to_copy,SAR)<=0) return(0);
//---- restore values of the variables
   j=j_;
   dir=dir_;
   h=h_;
   l=l_;
   lastcolor=lastcolor_;
//---- first big indicator calculation loop
   for(bar=limit; bar>=0 && !IsStopped(); bar--)
     {
      //---- store values of the variables before running at the current bar
      if(rates_total!=prev_calculated && bar==0)
        {
         j_=j;
         dir_=dir;
         h_=h;
         l_=l;
        }

      mid0=(high[bar]+low[bar])/2;
      mid1=(high[bar+1]+low[bar+1])/2;

      HighestBuffer[bar]=0.0;
      LowestBuffer[bar]=0.0;

      if(bar>0) j++;

      if(dir)
        {
         if(h<high[bar])
           {
            h=high[bar];
            j=NewBar;
           }
         if(SAR[bar+1]<=mid1 && SAR[bar]>mid0)
           {
            shift=bar+EShift *(j+NewBar);
            if(shift>rates_total-1) shift=rates_total-1;
            HighestBuffer[shift]=h;
            dir=false;
            l=low[bar];
            j=0;
            if(shift>climit) climit=shift;
           }
        }
      else
        {
         if(l>low[bar])
           {
            l=low[bar];
            j=NewBar;
           }
         if(SAR[bar+1]>=mid1 && SAR[bar]<mid0)
           {
            shift=bar+EShift *(j+NewBar);
            if(shift>rates_total-1) shift=rates_total-1;
            LowestBuffer[shift]=l;
            dir=true;
            h=high[bar];
            j=0;
            if(shift>climit) climit=shift;
           }
        }
     }
//---- the third big indicator coloring loop
   for(bar=climit; bar>=0 && !IsStopped(); bar--)
     {
      if(rates_total!=prev_calculated && bar==0)
        {
         lastcolor_=lastcolor;
        }

      if(HighestBuffer[bar]==0.0 || LowestBuffer[bar]==0.0)
         ColorBuffer[bar]=lastcolor;

      if(HighestBuffer[bar]!=0.0 || LowestBuffer[bar]!=0.0)
        {
         if(lastcolor==0)
           {
            ColorBuffer[bar]=1;
            lastcolor=1;
           }
         else
           {
            ColorBuffer[bar]=0;
            lastcolor=0;
           }
        }

      if(HighestBuffer[bar]!=0.0 || LowestBuffer[bar]==0.0)
        {
         ColorBuffer[bar]=1;
         lastcolor=1;
        }

      if(HighestBuffer[bar]==0.0 || LowestBuffer[bar]!=0.0)
        {
         ColorBuffer[bar]=0;
         lastcolor=0;
        }
     }
//----     
   return(rates_total);
  }
//+------------------------------------------------------------------+
