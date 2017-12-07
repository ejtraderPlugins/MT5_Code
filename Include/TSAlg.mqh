//+------------------------------------------------------------------+
//|                                                        TSAlg.mqh |
//|                                                       chizhijing |
//|                                             https://www.mql5.com |
//+------------------------------------------------------------------+
#property copyright "chizhijing"
#property link      "https://www.mql5.com"
#include "Arrays\ArrayDouble.mqh"
#include "Arrays\ArrayInt.mqh"
//+------------------------------------------------------------------+
//| defines                                                          |
//+------------------------------------------------------------------+
// #define MacrosHello   "Hello, world!"
// #define MacrosYear    2010
//+------------------------------------------------------------------+
//| DLL imports                                                      |
//+------------------------------------------------------------------+
// #import "user32.dll"
//   int      SendMessageA(int hWnd,int Msg,int wParam,int lParam);
// #import "my_expert.dll"
//   int      ExpertRecalculate(int wParam,int lParam);
// #import
//+------------------------------------------------------------------+
//| EX5 imports                                                      |
//+------------------------------------------------------------------+
// #import "stdlib.ex5"
//   string ErrorDescription(int error_code);
// #import
//+------------------------------------------------------------------+
//data standard
int data_standard(const double& price[], double& standard_price[])
   {
    int max_loc=ArrayMaximum(price);
    int min_loc=ArrayMinimum(price);
    ArrayResize(standard_price,ArraySize(price));
    if(price[max_loc]==price[min_loc])
      {
       ArrayCopy(standard_price,price);
       return 1;
      }
    for(int i=0;i<ArraySize(price);i++)
       standard_price[i]=(price[i]-price[min_loc])/(price[max_loc]-price[min_loc]);
    return 1; 
   }
//data smooth
int smooth_ts(const int window, const double& price[], double& smooth_price[])
   {
   int size=ArraySize(price);
   for(int i=0;i<size;i++)
      {
       int count=0;
       double sum=0;
       int begin=MathMax(0,i-window);
       int end=MathMin(i+window,size);
       for(int j=begin;j<end;j++)
         {
          count++;
          sum+=price[j];
         }
       smooth_price[i]=sum/count;   
      }
    return size;
   }
   
    
//turning points
int turning_points(const double thread, const double &price[], int& tp_loc[])
   {
    CArrayDouble arr_price;
    CArrayInt arr_loc;
    arr_price.AddArray(price);
    for(int i=0;i<arr_price.Total();i++)
      arr_loc.Add(i);
    bool all_cal=false;
    double min_dist;
    int min_loc=0;
    while(!all_cal)
      {
       min_dist = thread+1;
       for(int i=0; i<arr_price.Total();i++)
         {
          if(i==0||i==arr_price.Total()-1) continue;
          double dist=dist_point_to_line(arr_loc[i-1],arr_price[i-1],arr_loc[i+1],arr_price[i+1],arr_loc[i],arr_price[i]);         
          if(dist<min_dist)
            {
             min_dist=dist;
             min_loc=i;
            }
         }
       if(min_dist>thread)
         all_cal=true;
       else
         {
          arr_price.Delete(min_loc);
          arr_loc.Delete(min_loc);
         }    
      }
    ArrayResize(tp_loc,arr_loc.Total());      
    for(int i=0;i<arr_loc.Total();i++)
      tp_loc[i]=arr_loc[i];
    return arr_loc.Total();
   }    
   
//dist of point to line
double dist_point_to_line(const int x1, const double y1, const int x2,const double y2,const int x,const double y)
   {
    double A = y2-y1;
    double B = x1-x2;
    double C = y1*x2-x1*y2;
    return MathAbs(A*x+B*y+C)/MathSqrt(A*A+B*B);
   }