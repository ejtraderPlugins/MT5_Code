//+------------------------------------------------------------------+
//|                                          TrendAnalysisSingle.mq5 |
//|                                                       chizhijing |
//|                                             https://www.mql5.com |
//+------------------------------------------------------------------+
#property copyright "chizhijing"
#property link      "https://www.mql5.com"
#property version   "1.00"
#include <ChartObjects\ChartObjectsTxtControls.mqh>
//---
#include "TrendAnalysis.mqh"
string init_str[]=
  {
   "Symbol","Period","MA","BOLL","Fibonacci"
  };
//+------------------------------------------------------------------+
//| Script to testing the use of class CAccountInfo.                 |
//+------------------------------------------------------------------+
//---
//+------------------------------------------------------------------+
//| Account Info Sample script class                                 |
//+------------------------------------------------------------------+
class CSymbolInfo
  {
protected:
   //--- chart objects
   CChartObjectLabel m_label[5];
   CChartObjectLabel m_label_info[5];

public:
                     CSymbolInfo(void);
                    ~CSymbolInfo(void);
   //---
   bool              Init(void);
   void              Deinit(void);
   void              Processing(void);

private:
   void              CSymbolInfoToChart(void);
  };
//---
CSymbolInfo ExtScript;
//+------------------------------------------------------------------+
//| Constructor                                                      |
//+------------------------------------------------------------------+
CSymbolInfo::CSymbolInfo(void)
  {
  }
//+------------------------------------------------------------------+
//| Destructor                                                       |
//+------------------------------------------------------------------+
CSymbolInfo::~CSymbolInfo(void)
  {
  }
//+------------------------------------------------------------------+
//| Method Init.                                                     |
//+------------------------------------------------------------------+
bool CSymbolInfo::Init(void)
  {
   int   i,sy=10;
   int   dy=20;
   color color_label;
   color color_info;
//--- tuning colors
   color_info =(color)(ChartGetInteger(0,CHART_COLOR_BACKGROUND)^0xFFFFFF);
   color_label=(color)(color_info^0x202020);
//---
   if(ChartGetInteger(0,CHART_SHOW_OHLC))
      sy+=16;
//--- creation Labels[]
   for(i=0;i<5;i++)
     {
      m_label[i].Create(0,"Label"+IntegerToString(i),0,20,sy+dy*i);
      m_label[i].Description(init_str[i]);
      m_label[i].Color(color_label);
      m_label[i].FontSize(10);
      //---
         m_label_info[i].Create(0,"LabelInfo"+IntegerToString(i),0,120,sy+dy*i);
         m_label_info[i].Description(" ");
         m_label_info[i].Color(color_info);
         m_label_info[i].FontSize(10);

     }
   CSymbolInfoToChart();
//--- redraw chart
   ChartRedraw();
//---
   return(0);
  }
//+------------------------------------------------------------------+
//| Method Deinit.                                                   |
//+------------------------------------------------------------------+
void CSymbolInfo::Deinit(void)
  {
  }
//+------------------------------------------------------------------+
//| Method Processing.                                               |
//+------------------------------------------------------------------+
void CSymbolInfo::Processing(void)
  {
   CSymbolInfoToChart();
//--- redraw chart
   ChartRedraw();
   Sleep(50);
  }
//+------------------------------------------------------------------+
//| Method InfoToChart.                                              |
//+------------------------------------------------------------------+
void CSymbolInfo::CSymbolInfoToChart(void)
  {
      LongTermAnalysis *lta=new LongTermAnalysis(_Symbol,_Period);
      m_label_info[0].Description(_Symbol);
      m_label_info[1].Description((string) _Period);
      m_label_info[2].Description((string) NormalizeDouble(lta.dist_price_with_ma,3));
      m_label_info[3].Description((string) NormalizeDouble(lta.dist_price_with_boll,3));
      m_label_info[4].Description((string) NormalizeDouble(lta.fibonacci_ratio,2));
  }
//+------------------------------------------------------------------+
//| Script program start function                                    |
//+------------------------------------------------------------------+
void OnStart(void)
  {
//--- call init function
   if(ExtScript.Init()==0)
     {
      //--- cycle until the script is not halted
      while(!IsStopped())
         ExtScript.Processing();
     }
//--- call deinit function
   ExtScript.Deinit();
  }
//+------------------------------------------------------------------+