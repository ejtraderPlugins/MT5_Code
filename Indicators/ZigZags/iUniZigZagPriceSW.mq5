//+------------------------------------------------------------------+
//|                                                 iUniZigZagSW.mq5 |
//|                        Copyright 2016, MetaQuotes Software Corp. |
//|                                             https://www.mql5.com |
//+------------------------------------------------------------------+
#property copyright "Copyright 2016, MetaQuotes Software Corp."
#property link      "https://www.mql5.com"
#property version   "1.00"
#property indicator_separate_window
#property indicator_buffers 6
#property indicator_plots   3
//--- plot High
#property indicator_label1  "High"
#property indicator_type1   DRAW_LINE
#property indicator_color1  clrGreen
#property indicator_style1  STYLE_SOLID
#property indicator_width1  1
//--- plot Low
#property indicator_label2  "Low"
#property indicator_type2   DRAW_LINE
#property indicator_color2  clrGreen
#property indicator_style2  STYLE_SOLID
#property indicator_width2  1
//--- plot ZigZag
#property indicator_label3  "ZigZag"
#property indicator_type3   DRAW_SECTION
#property indicator_color3  clrRed
#property indicator_style3  STYLE_SOLID
#property indicator_width3  1
//--- plot Direction
#property indicator_label4  "Direction"
#property indicator_type4   DRAW_LINE
#property indicator_style4  STYLE_SOLID
#property indicator_width4  1
//--- plot LastHighBar
#property indicator_label5  "LastHighBar"
#property indicator_type5   DRAW_LINE
#property indicator_style5  STYLE_SOLID
#property indicator_width5  1
//--- plot LastLowBar
#property indicator_label6  "LastLowBar"
#property indicator_type6   DRAW_LINE
#property indicator_style6  STYLE_SOLID
#property indicator_width6  1

#include <ZigZag\CSorceData.mqh>
#include <ZigZag\CZZDirection.mqh>
#include <ZigZag\CZZDraw.mqh>
enum EDirection
  {
   Dir_NBars=0,
   Dir_CCI=1
  };
//--- input parameters
input EDirection  DirSelect=Dir_NBars;
input int                  CCIPeriod   =  14;
input ENUM_APPLIED_PRICE   CCIPrice    =  PRICE_TYPICAL;
input int                  ZZPeriod=14;

CZZDirection*dir;
CZZDraw*zz;

//--- indicator buffers
double         HighBuffer[];
double         LowBuffer[];
double         ZigZagBuffer[];
double         DirectionBuffer[];
double         LastHighBarBuffer[];
double         LastLowBarBuffer[];
//+------------------------------------------------------------------+
//| Custom indicator initialization function                         |
//+------------------------------------------------------------------+
int OnInit()
  {
   switch(DirSelect)
     {
      case Dir_NBars:
         dir=new CNBars(ZZPeriod);
         break;
      case Dir_CCI:
         dir=new CCCIDir(CCIPeriod,CCIPrice);
         break;
     }
   if(!dir.CheckHandle())
     {
      Alert("Ошибка загрузки индикатора 2");
      return(INIT_FAILED);
     }
   zz=new CSimpleDraw();
//--- indicator buffers mapping
   SetIndexBuffer(0,HighBuffer,INDICATOR_DATA);
   SetIndexBuffer(1,LowBuffer,INDICATOR_DATA);
   SetIndexBuffer(2,ZigZagBuffer,INDICATOR_DATA);
   SetIndexBuffer(3,DirectionBuffer,INDICATOR_CALCULATIONS);
   SetIndexBuffer(4,LastHighBarBuffer,INDICATOR_CALCULATIONS);
   SetIndexBuffer(5,LastLowBarBuffer,INDICATOR_CALCULATIONS);
//---
   return(INIT_SUCCEEDED);
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void OnDeinit(const int reason)
  {
   if(CheckPointer(dir)==POINTER_DYNAMIC)
     {
      delete(dir);
     }
   if(CheckPointer(zz)==POINTER_DYNAMIC)
     {
      delete(zz);
     }
  }
//+------------------------------------------------------------------+
//| Custom indicator iteration function                              |
//+------------------------------------------------------------------+
int OnCalculate(const int rates_total,
                const int prev_calculated,
                const int begin,
                const double &price[]
                )
  {
   int start;

   if(prev_calculated==0)
     {
      start=0;
     }
   else
     {
      start=prev_calculated-1;
     }

   for(int i=start;i<rates_total;i++)
     {
      HighBuffer[i]=price[i];
      LowBuffer[i]=price[i];
     }

   int rv;
   rv=dir.Calculate(rates_total,
                    prev_calculated,
                    HighBuffer,
                    LowBuffer,
                    DirectionBuffer);
   if(rv==0)return(0);
   zz.Calculate(rates_total,
                prev_calculated,
                HighBuffer,
                LowBuffer,
                DirectionBuffer,
                LastHighBarBuffer,
                LastLowBarBuffer,
                ZigZagBuffer);

   return(rates_total);
  }
//+------------------------------------------------------------------+
