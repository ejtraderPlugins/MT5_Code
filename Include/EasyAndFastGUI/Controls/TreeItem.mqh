//+------------------------------------------------------------------+
//|                                                     TreeItem.mqh |
//|                        Copyright 2015, MetaQuotes Software Corp. |
//|                                              http://www.mql5.com |
//+------------------------------------------------------------------+
#include "..\Element.mqh"
#include "Button.mqh"
//+------------------------------------------------------------------+
//| Class for creating a tree view item                              |
//+------------------------------------------------------------------+
class CTreeItem : public CButton
  {
private:
   //--- Indent for an arrow (sign of a list presence)
   int               m_arrow_x_gap;
   //--- Item type
   ENUM_TYPE_TREE_ITEM m_item_type;
   //--- Index of the item in the general list
   int               m_list_index;
   //--- Node level
   int               m_node_level;
   //--- Displayed text of the item
   string            m_item_text;
   //--- Item list state (open/minimized)
   bool              m_item_state;
   //---
public:
                     CTreeItem(void);
                    ~CTreeItem(void);
   //--- Methods for creating a tree view item
   bool              CreateTreeItem(const int x_gap,const int y_gap,const ENUM_TYPE_TREE_ITEM type,
                                    const int list_index,const int node_level,const string text,const bool item_state);
   //---
private:
   void              InitializeProperties(const int x_gap,const int y_gap,const ENUM_TYPE_TREE_ITEM type,
                                          const int list_index,const int node_level,const string text,const bool item_state);
   //---
public:
   //--- (1) State of the item (minimized/maximized), (2) item type
   void              ItemState(const int state);
   bool              ItemState(void) const { return(m_item_state); }
   ENUM_TYPE_TREE_ITEM Type(void)    const { return(m_item_type);  }
   //--- Indent for the arrow
   int               ArrowXGap(const int node_level);
   int               ArrowXGap(void) const { return(m_arrow_x_gap); }
   //--- Update the coordinates and width
   void              UpdateX(const int x);
   void              UpdateY(const int y);
   void              UpdateWidth(const int width);
   //---
public:
   //--- Handler of chart events
   virtual void      OnEvent(const int id,const long &lparam,const double &dparam,const string &sparam);
   //--- Draws the control
   virtual void      Draw(void);
   //---
private:
   //--- Draws the image
   virtual void      DrawImage(void);
  };
//+------------------------------------------------------------------+
//| Constructor                                                      |
//+------------------------------------------------------------------+
CTreeItem::CTreeItem(void) : m_node_level(0),
                             m_arrow_x_gap(5),
                             m_item_type(TI_SIMPLE)
  {
//--- Store the name of the control class in the base class
   CElementBase::ClassName(CLASS_NAME);
//--- The item will be a drop-down control
   CElementBase::IsDropdown(true);
  }
//+------------------------------------------------------------------+
//| Destructor                                                       |
//+------------------------------------------------------------------+
CTreeItem::~CTreeItem(void)
  {
  }
//+------------------------------------------------------------------+
//| Event handler                                                    |
//+------------------------------------------------------------------+
void CTreeItem::OnEvent(const int id,const long &lparam,const double &dparam,const string &sparam)
  {
//--- Leave, if the main control is not available
   if(!m_main.IsAvailable())
      return;
//--- Handle the event in the base class
   CButton::OnEvent(id,lparam,dparam,sparam);
  }
//+------------------------------------------------------------------+
//| Create a tree view item                                          |
//+------------------------------------------------------------------+
#resource "\\Images\\EasyAndFastGUI\\Controls\\right_thick_black.bmp"
#resource "\\Images\\EasyAndFastGUI\\Controls\\down_thick_black.bmp"
//---
bool CTreeItem::CreateTreeItem(const int x_gap,const int y_gap,const ENUM_TYPE_TREE_ITEM type,
                               const int list_index,const int node_level,const string text,const bool item_state)
  {
//--- Leave, if there is no pointer to the main control
   if(!CElement::CheckMainPointer())
      return(false);
//--- Initialization of the properties
   InitializeProperties(x_gap,y_gap,type,list_index,node_level,text,item_state);
//--- Set the images if he item has a drop-down list
   if(m_item_type==TI_HAS_ITEMS)
     {
      CElement::AddImagesGroup(m_arrow_x_gap,2);
      CElement::AddImage(1,"Images\\EasyAndFastGUI\\Controls\\down_thick_black.bmp");
      CElement::AddImage(1,"Images\\EasyAndFastGUI\\Controls\\right_thick_black.bmp");
      //--- Select the appropriate image
      CButton::ChangeImage(1,(m_item_state)? 1 : 0);
     }
//--- Properties
   CButton::TwoState(true);
//--- Create a control
   if(!CButton::CreateButton(text,x_gap,y_gap))
      return(false);
//---
   return(true);
  }
//+------------------------------------------------------------------+
//| Initialization of the properties                                 |
//+------------------------------------------------------------------+
void CTreeItem::InitializeProperties(const int x_gap,const int y_gap,const ENUM_TYPE_TREE_ITEM type,
                                     const int list_index,const int node_level,const string text,const bool item_state)
  {
   m_x           =CElement::CalculateX(x_gap);
   m_y           =CElement::CalculateY(y_gap);
   m_item_type   =type;
   m_list_index  =list_index;
   m_node_level  =node_level;
   m_item_text   =text;
   m_item_state  =item_state;
   m_label_text  =text;
//--- Default properties
   m_back_color           =m_main.BackColor();
   m_back_color_hover     =C'229,243,255';
   m_back_color_pressed   =C'204,232,255';
   m_border_color         =m_main.BackColor();
   m_border_color_hover   =m_back_color_hover;
   m_border_color_pressed =C'153,209,255';
   m_label_color          =clrBlack;
   m_label_color_hover    =clrBlack;
   m_label_color_pressed  =clrBlack;
   m_label_x_gap          =(m_label_x_gap!=WRONG_VALUE)? m_icon_x_gap+m_label_x_gap : m_icon_x_gap+22;
   m_label_y_gap          =4;
//--- Offsets from the extreme point
   CElementBase::XGap(x_gap);
   CElementBase::YGap(y_gap);
  }
//+------------------------------------------------------------------+
//| Setting the item state (minimized/maximized)                   |
//+------------------------------------------------------------------+
void CTreeItem::ItemState(const int state)
  {
   m_item_state=state;

  }
//+------------------------------------------------------------------+
//| Indent for the arrow                                             |
//+------------------------------------------------------------------+
int CTreeItem::ArrowXGap(const int node_level)
  {
   return((m_arrow_x_gap=(node_level>0)? (12*node_level)+5 : 5));
  }
//+------------------------------------------------------------------+
//| Update the X coordinate                                          |
//+------------------------------------------------------------------+
void CTreeItem::UpdateX(const int x)
  {
//--- Update the common coordinates and indents form the edge point
   CElementBase::X(CElement::CalculateX(x));
   CElementBase::XGap(x);
//--- Coordinates and offset
   m_canvas.X(x);
   m_canvas.XGap(x);
  }
//+------------------------------------------------------------------+
//| Update the Y coordinate                                          |
//+------------------------------------------------------------------+
void CTreeItem::UpdateY(const int y)
  {
//--- Update the common coordinates and indents form the edge point
   CElementBase::Y(CElement::CalculateY(y));
   CElementBase::YGap(y);
//--- Coordinates and offset
   m_canvas.Y(y);
   m_canvas.YGap(y);
  }
//+------------------------------------------------------------------+
//| Update width                                                     |
//+------------------------------------------------------------------+
void CTreeItem::UpdateWidth(const int width)
  {
//--- Background width
   CElementBase::XSize(width);
   m_canvas.XSize(width);
   m_canvas.Resize(width,m_y_size);
  }
//+------------------------------------------------------------------+
//| Draws the control                                                |
//+------------------------------------------------------------------+
void CTreeItem::Draw(void)
  {
//--- Draw the background
   CButton::DrawBackground();
//--- Draw icon
   if(m_item_type==TI_HAS_ITEMS)
      CTreeItem::DrawImage();
   else
      CButton::DrawImage();
//--- Draw text
   CElement::DrawText();
  }
//+------------------------------------------------------------------+
//| Draws the image                                                  |
//+------------------------------------------------------------------+
void CTreeItem::DrawImage(void)
  {
//--- Determine the index
   uint image_index=(m_item_state)? 0 : 1;
//--- Store the index of the selected image
   CElement::ChangeImage(1,image_index);
//--- Draw the image
   CElement::DrawImage();
  }
//+------------------------------------------------------------------+
