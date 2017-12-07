//+------------------------------------------------------------------+
//|                                                  PanelDialog.mqh |
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

//+------------------------------------------------------------------+
//| defines                                                          |
//+------------------------------------------------------------------+
//--- indents and spacing
#define INDENT_LEFT                         (11)      // left indent (including the border width)
#define INDENT_TOP                          (11)      // top indent (including the border width)
#define INDENT_RIGHT                        (11)      // right indent (including the border width)
#define INDENT_BOTTOM                       (11)      // bottom indent (including the border width)
#define CONTROLS_GAP_X                      (10)      // spacing along the X-axis
#define CONTROLS_GAP_Y                      (10)      // spacing along the Y-axis
//--- for labels
#define LABEL_WIDTH                         (50)      // size along the X-axis
//--- for edits
#define EDIT_WIDTH                          (50)      // size along the X-axis
#define EDIT_HEIGHT                         (20)      // size along the Y-axis
//--- for base colors (RGB)
#define BASE_COLOR_MIN                      (0)       // minimum value of the color component
#define BASE_COLOR_MAX                      (255)     // maximum value of the color component
//+------------------------------------------------------------------+
//| CPanelDialog class                                               |
//| Function: main application dialog                                |
//+------------------------------------------------------------------+
class CPanelDialog : public CAppDialog
  {
private:
   //--- additional controls
   CPanel            m_color;                         // object for displaying color
   CLabel            m_label_red;                     // "red" level caption object
   CEdit             m_field_red;                     // "red" value display object
   CLabel            m_label_green;                   // "green" level caption object
   CEdit             m_field_green;                   // "green" value display object
   CLabel            m_label_blue;                    // "blue" level caption object
   CSpinEdit         m_edit_blue;                     // "blue" value control object
   //--- parameter values
   int               m_red;                           // "red" value
   int               m_green;                         // "green" value
   int               m_blue;                          // "blue" value

public:
                     CPanelDialog(void);
                    ~CPanelDialog(void);
   //--- creation
   virtual bool      Create(const long chart,const string name,const int subwin,const int x1,const int y1,const int x2,const int y2);
   //--- chart event handler
   virtual bool      OnEvent(const int id,const long &lparam,const double &dparam,const string &sparam);
   //--- properties
   void              SetRed(const int value);
   void              SetGreen(const int value);
   void              SetBlue(const int value);

protected:
   //--- creating additional controls
   bool              CreateColor(void);
   bool              CreateRed(void);
   bool              CreateGreen(void);
   bool              CreateBlue(void);
   //--- internal event handlers
   virtual bool      OnResize(void);
   //--- event handlers for additional controls
   void              OnChangeBlue(void);
   //--- methods
   void              SetColor(void);
  };
//+------------------------------------------------------------------+
//| Event handling                                                   |
//+------------------------------------------------------------------+
EVENT_MAP_BEGIN(CPanelDialog)
   ON_EVENT(ON_CHANGE,m_edit_blue,OnChangeBlue)
EVENT_MAP_END(CAppDialog)
//+------------------------------------------------------------------+
//| Constructor                                                      |
//+------------------------------------------------------------------+
CPanelDialog::CPanelDialog(void) : m_red((BASE_COLOR_MAX-BASE_COLOR_MIN)/2),
                                   m_green((BASE_COLOR_MAX-BASE_COLOR_MIN)/2),
                                   m_blue((BASE_COLOR_MAX-BASE_COLOR_MIN)/2)
  {
  }
//+------------------------------------------------------------------+
//| Destructor                                                       |
//+------------------------------------------------------------------+
CPanelDialog::~CPanelDialog(void)
  {
  }
//+------------------------------------------------------------------+
//| Creation                                                         |
//+------------------------------------------------------------------+
bool CPanelDialog::Create(const long chart,const string name,const int subwin,const int x1,const int y1,const int x2,const int y2)
  {
//--- calling the parent class method
   if(!CAppDialog::Create(chart,name,subwin,x1,y1,x2,y2))                           return(false);
//--- creating additional controls
   if(!CreateColor())                                                               return(false);
   if(!CreateRed())                                                                 return(false);
   if(!CreateGreen())                                                               return(false);
   if(!CreateBlue())                                                                return(false);
//--- setting the panel color
   SetColor();
//--- success
   return(true);
  }
//+------------------------------------------------------------------+
//| Color panel creation                                             |
//+------------------------------------------------------------------+
bool CPanelDialog::CreateColor(void)
  {
//--- coordinates
   int x1=INDENT_LEFT+LABEL_WIDTH+CONTROLS_GAP_X+EDIT_WIDTH+CONTROLS_GAP_X;
   int y1=INDENT_TOP;
   int x2=ClientAreaWidth()-INDENT_RIGHT;
   int y2=ClientAreaHeight()-INDENT_BOTTOM;
//--- creating
   if(!m_color.Create(m_chart_id,m_name+"Color",m_subwin,x1,y1,x2,y2))              return(false);
   if(!m_color.ColorBorder(CONTROLS_EDIT_COLOR_BORDER))                             return(false);
   if(!Add(m_color))                                                                return(false);
//--- success
   return(true);
  }
//+------------------------------------------------------------------+
//| Creating the display element "Red" with explanatory caption      |
//+------------------------------------------------------------------+
bool CPanelDialog::CreateRed(void)
  {
//--- coordinates
   int x1=INDENT_LEFT;
   int y1=INDENT_TOP;
   int x2=x1+EDIT_WIDTH;
   int y2=y1+EDIT_HEIGHT;
//--- creating the caption
   if(!m_label_red.Create(m_chart_id,m_name+"LabelRed",m_subwin,x1,y1+1,x2,y2))     return(false);
   if(!m_label_red.Text("Red"))                                                     return(false);
   if(!Add(m_label_red))                                                            return(false);
//--- adjusting the coordinates
   x1+=LABEL_WIDTH+CONTROLS_GAP_X;
   x2=x1+EDIT_WIDTH;
//--- creating the display element
   if(!m_field_red.Create(m_chart_id,m_name+"Red",m_subwin,x1,y1,x2,y2))            return(false);
   if(!m_field_red.Text(IntegerToString(m_red)))                                    return(false);
   if(!m_field_red.ReadOnly(true))                                                  return(false);
   if(!Add(m_field_red))                                                            return(false);
//--- success
   return(true);
  }
//+------------------------------------------------------------------+
//| Creating the display element "Green" with explanatory caption    |
//+------------------------------------------------------------------+
bool CPanelDialog::CreateGreen(void)
  {
//--- coordinates
   int x1=INDENT_LEFT;
   int y1=INDENT_TOP+(EDIT_HEIGHT+CONTROLS_GAP_Y);
   int x2=x1+EDIT_WIDTH;
   int y2=y1+EDIT_HEIGHT;
//--- creating the caption
   if(!m_label_green.Create(m_chart_id,m_name+"LabelGreen",m_subwin,x1,y1+1,x2,y2)) return(false);
   if(!m_label_green.Text("Green"))                                                 return(false);
   if(!Add(m_label_green))                                                          return(false);
//--- adjusting the coordinates
   x1+=LABEL_WIDTH+CONTROLS_GAP_X;
   x2=x1+EDIT_WIDTH;
//--- creating the display element
   if(!m_field_green.Create(m_chart_id,m_name+"Green",m_subwin,x1,y1,x2,y2))        return(false);
   if(!m_field_green.Text(IntegerToString(m_green)))                                return(false);
   if(!m_field_green.ReadOnly(true))                                                return(false);
   if(!Add(m_field_green))                                                          return(false);
//--- success
   return(true);
  }
//+------------------------------------------------------------------+
//| Creating the control "Blue" with explanatory caption             |
//+------------------------------------------------------------------+
bool CPanelDialog::CreateBlue(void)
  {
//--- coordinates
   int x1=INDENT_LEFT;
   int y1=INDENT_TOP+2*(EDIT_HEIGHT+CONTROLS_GAP_Y);
   int x2=x1+EDIT_WIDTH;
   int y2=y1+EDIT_HEIGHT;
//--- creating the caption
   if(!m_label_blue.Create(m_chart_id,m_name+"LabelBlue",m_subwin,x1,y1+1,x2,y2))   return(false);
   if(!m_label_blue.Text("Blue"))                                                   return(false);
   if(!Add(m_label_blue))                                                           return(false);
//--- adjusting the coordinates
   x1+=LABEL_WIDTH+CONTROLS_GAP_X;
   x2=x1+EDIT_WIDTH;
//--- creating the display element
   if(!m_edit_blue.Create(m_chart_id,m_name+"Blue",m_subwin,x1,y1,x2,y2))           return(false);
   if(!Add(m_edit_blue))                                                            return(false);
   m_edit_blue.MinValue(BASE_COLOR_MIN);
   m_edit_blue.MaxValue(BASE_COLOR_MAX);
   m_edit_blue.Value(m_blue);
//--- success
   return(true);
  }
//+------------------------------------------------------------------+
//| Setting the "Red" value                                          |
//+------------------------------------------------------------------+
void CPanelDialog::SetRed(const int value)
  {
//--- checking
   if(value<0 || value>255) return;
//--- saving
   m_red=value;
//--- setting
   m_field_red.Text(IntegerToString(value));
//--- setting the panel color
   SetColor();
  }
//+------------------------------------------------------------------+
//| Setting the "Green" value                                        |
//+------------------------------------------------------------------+
void CPanelDialog::SetGreen(const int value)
  {
//--- checking
   if(value<0 || value>255) return;
//--- saving
   m_green=value;
//--- setting
   m_field_green.Text(IntegerToString(value));
//--- setting the panel color
   SetColor();
  }
//+------------------------------------------------------------------+
//| Setting the "Blue" value                                         |
//+------------------------------------------------------------------+
void CPanelDialog::SetBlue(const int value)
  {
//--- checking
   if(value<0 || value>255) return;
//--- saving
   m_blue=value;
//--- setting
   m_edit_blue.Value(value);
//--- setting the panel color
   SetColor();
  }
//+------------------------------------------------------------------+
//| Resize handler                                                   |
//+------------------------------------------------------------------+
bool CPanelDialog::OnResize(void)
  {
//--- calling the parent class method
   if(!CAppDialog::OnResize()) return(false);
//--- changing the color panel width
   m_color.Width(ClientAreaWidth()-(INDENT_RIGHT+LABEL_WIDTH+CONTROLS_GAP_X+EDIT_WIDTH+CONTROLS_GAP_X+INDENT_LEFT));
//--- success
   return(true);
  }
//+------------------------------------------------------------------+
//| Handler of the event of changing the "blue" level                |
//+------------------------------------------------------------------+
void CPanelDialog::OnChangeBlue(void)
  {
//--- saving
   m_blue=m_edit_blue.Value();
//--- setting the panel color
   SetColor();
  }
//+------------------------------------------------------------------+
//| Setting the panel color                                          |
//+------------------------------------------------------------------+
void CPanelDialog::SetColor(void)
  {
   m_color.ColorBackground(m_red+(m_green<<8)+(m_blue<<16));
  }
//+------------------------------------------------------------------+
