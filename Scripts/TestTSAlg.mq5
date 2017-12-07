//+------------------------------------------------------------------+
//|                                                    TestTSAlg.mq5 |
//|                                                       chizhijing |
//|                                             https://www.mql5.com |
//+------------------------------------------------------------------+
#property copyright "chizhijing"
#property link      "https://www.mql5.com"
#property version   "1.00"
#include <TSAlg.mqh>
#include <Graphics\Graphic.mqh>
#define SIZE_X 600
#define SIZE_Y 200

//+------------------------------------------------------------------+
//| Script program start function                                    |
//+------------------------------------------------------------------+
void OnStart()
  {
//---
  Print("Hello World!");
  const int period=200;
  double close_price[];
  double standard_price[];
  double tp_price1[];
  double tp_price2[];
  double s_price[];
  int tp_loc1[];
  int tp_loc2[];
  double tp_x1[];
  double tp_x2[];
  ArrayResize(close_price,period);
  ArrayResize(s_price,period);
  CopyClose(_Symbol,_Period,0,period,close_price);
  data_standard(close_price, standard_price);
  int size = smooth_ts(20,close_price,s_price);
  int tp_size1 = turning_points(0.5,s_price,tp_loc1);
  int tp_size2 = turning_points(0.3,standard_price,tp_loc2);
  ArrayResize(tp_price1,tp_size1);
  ArrayResize(tp_x1,tp_size1);
  ArrayResize(tp_price2,tp_size2);
  ArrayResize(tp_x2,tp_size2);
  for(int i=0;i<tp_size1;i++)
   {
    tp_price1[i]=close_price[tp_loc1[i]];
    tp_x1[i]=tp_loc1[i];
   }
 for(int i=0;i<tp_size2;i++)
   {
    tp_price2[i]=close_price[tp_loc2[i]];
    tp_x2[i]=tp_loc2[i];
   }    
  
  CGraphic graph_tp;
  graph_tp.Create(0,"tp",0,0,0,SIZE_X+6,SIZE_Y);
  graph_tp.XAxis().MaxGrace(0);
  graph_tp.HistorySymbolSize(10);
  graph_tp.CurveAdd(close_price,ColorToARGB(clrRed,255),CURVE_LINES,"tp");
  graph_tp.CurveAdd(s_price,ColorToARGB(clrBlue,255),CURVE_LINES,"s_tp");
  graph_tp.CurveAdd(tp_x1,tp_price1,ColorToARGB(clrGreen,255),CURVE_POINTS_AND_LINES,"TP");
  graph_tp.CurveAdd(tp_x2,tp_price2,ColorToARGB(clrBlack,255),CURVE_POINTS_AND_LINES,"TP2");
  graph_tp.CurvePlotAll();
  graph_tp.Redraw(true);
  graph_tp.Update();
   
  }
//+------------------------------------------------------------------+
