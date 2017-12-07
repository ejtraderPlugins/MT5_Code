//+------------------------------------------------------------------+
//|                                         SymbolAnalysisDialog.mqh |
//|                                                       chizhijing |
//|                                             https://www.mql5.com |
//+------------------------------------------------------------------+
#property copyright "chizhijing"
#property link      "https://www.mql5.com"
#property version   "1.00"
#include <Controls\Dialog.mqh>
#include <Controls\Panel.mqh>
#include <Controls\Edit.mqh>
#include <Controls\Label.mqh>
#include <Controls\SpinEdit.mqh>

#define INDENT_LEFT                         (11)      // left indent (including the border width)
#define INDENT_TOP                          (11)      // top indent (including the border width)
#define INDENT_RIGHT                        (11)      // right indent (including the border width)
#define INDENT_BOTTOM                       (11)      // bottom indent (including the border width)
#define CONTROLS_GAP_X                      (10)      // spacing along the X-axis
#define CONTROLS_GAP_Y                      (10)      // spacing along the Y-axis

//--- for edits
#define CONTROLS_WIDTH                          (50)      // size along the X-axis
#define CONTROLS_HEIGHT                         (20)      // size along the Y-axis
//--- for base colors (RGB)
#define BASE_COLOR_MIN                      (0)       // minimum value of the color component
#define BASE_COLOR_MAX                      (255)     // maximum value of the color component
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
class CSymbolAnalysisDialog : public CAppDialog
  {
private:
   CLabel            m_label_title[];
   CLabel            m_label_symbol[];
   CEdit             m_field[];
public:
                     CSymbolAnalysisDialog();
                    ~CSymbolAnalysisDialog();
   //virtual bool Create(const long chart,const string name,const int subwin,const int x1,const int y1,const int x2,const int y2);
   bool              CreateTable(const string &symbols[],const string &indicators[]);
   void SetIndicatorValues(const double &indicator_values[]);
   //virtual bool      OnResize(void);

  };
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
CSymbolAnalysisDialog::CSymbolAnalysisDialog()
  {
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
CSymbolAnalysisDialog::~CSymbolAnalysisDialog()
  {
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
bool CSymbolAnalysisDialog::CreateTable(const string &symbols[],const string &indicators[])
  {
   int num_symbol=ArraySize(symbols);
   int num_indicator=ArraySize(indicators);
   int pannel_height=(num_symbol+1)*CONTROLS_HEIGHT+(num_symbol+2)*CONTROLS_GAP_Y+30;
   if(!CAppDialog::Create(0,"Symbols Analysis Tools",0,0,0,0,pannel_height)) return false;
   ArrayResize(m_label_title,num_indicator+1);
   ArrayResize(m_label_symbol,num_symbol);
   ArrayResize(m_field,num_indicator*num_symbol);
   int x1=INDENT_LEFT;
   int y1=INDENT_TOP;
   int x2=x1+CONTROLS_WIDTH;
   int y2=y1+CONTROLS_HEIGHT;
   for(int irow=0;irow<num_symbol+1;irow++)
     {
      for(int icol=0;icol<num_indicator+1;icol++)
        {
         if(irow==0)
           {
            string title=icol==0?"Symbol":indicators[icol-1];
            m_label_title[icol].Create(m_chart_id,m_name+"LabelTitle"+string(icol+1),m_subwin,x1,y1,x2,y2);
            m_label_title[icol].Text(title);
            Add(m_label_title[icol]);
            x1+=CONTROLS_WIDTH+CONTROLS_GAP_X;
            x2=x1+CONTROLS_WIDTH;
            continue;
           }
         if(icol==0)
           {
            m_label_symbol[irow-1].Create(m_chart_id,m_name+"LableSymbol"+string(irow),m_subwin,x1,y1,x2,y2);
            m_label_symbol[irow-1].Text(symbols[irow-1]);
            Add(m_label_symbol[irow-1]);
            x1+=CONTROLS_WIDTH+CONTROLS_GAP_X;
            x2=x1+CONTROLS_WIDTH;
            continue;
           }
         int index=(irow-1)*num_indicator+icol-1;
         m_field[index].Create(m_chart_id,m_name+"FieldIndicatorValue"+string(index),m_subwin,x1,y1,x2,y2);
         if(!m_field[index].Text("value")) return(false);
         if(!m_field[index].ReadOnly(true)) return(false);
         if(!Add(m_field[index]))   return false;
         x1+=CONTROLS_WIDTH+CONTROLS_GAP_X;
         x2=x1+CONTROLS_WIDTH;
        }
      x1=INDENT_LEFT;
      x2=x1+CONTROLS_WIDTH;
      y1+=CONTROLS_HEIGHT+CONTROLS_GAP_Y;
      y2=y1+CONTROLS_HEIGHT;
     }

   return true;
  }
void CSymbolAnalysisDialog::SetIndicatorValues(const double &indicator_values[])
   {
    for(int i=0;i<ArraySize(indicator_values);i++)
      {
       m_field[i].Text(DoubleToString(indicator_values[i],3));
      }
    
   }
//+------------------------------------------------------------------+
