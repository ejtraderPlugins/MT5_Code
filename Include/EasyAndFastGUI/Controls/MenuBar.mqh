//+------------------------------------------------------------------+
//|                                                      MenuBar.mqh |
//|                        Copyright 2015, MetaQuotes Software Corp. |
//|                                              http://www.mql5.com |
//+------------------------------------------------------------------+
#include "..\Element.mqh"
#include "MenuItem.mqh"
#include "ContextMenu.mqh"
//+------------------------------------------------------------------+
//| Class for creating the main menu                                 |
//+------------------------------------------------------------------+
class CMenuBar : public CElement
  {
private:
   //--- Objects for creating a menu item
   CMenuItem         m_items[];
   //--- Array of context menu pointers
   CContextMenu     *m_contextmenus[];
   //--- State of the main menu
   bool              m_menubar_state;
   //--- Index of the previous activated item
   int               m_prev_active_item_index;
   //---
public:
                     CMenuBar(void);
                    ~CMenuBar(void);
   //--- Methods for creating the control
   bool              CreateMenuBar(const int x_gap,const int y_gap);
   //---
private:
   void              InitializeProperties(const int x_gap,const int y_gap);
   bool              CreateCanvas(void);
   bool              CreateItems(void);
   //---
public:
   //--- (1) Getting the pointer to the specified menu item, (2) getting the pointer to the specified context menu
   CMenuItem        *GetItemPointer(const uint index);
   CContextMenu     *GetContextMenuPointer(const uint index);
   //--- Quantity of (1) menu items and (2) context menus, (3) state of the main menu
   int               ItemsTotal(void)               const { return(::ArraySize(m_items));        }
   int               ContextMenusTotal(void)        const { return(::ArraySize(m_contextmenus)); }
   bool              State(void)                    const { return(m_menubar_state);             }
   void              State(const bool state);
   //--- Adds a menu item with specified properties before creation of the main menu
   void              AddItem(const int width,const string text);
   //--- Attaches the passed context menu to the specified item of the main menu
   void              AddContextMenuPointer(const uint index,CContextMenu &object);
   //---
public:
   //--- Handler of chart events
   virtual void      OnEvent(const int id,const long &lparam,const double &dparam,const string &sparam);
   //--- Deleting
   virtual void      Delete(void);
   //--- Draws the control
   virtual void      Draw(void);
   //---
private:
   //--- Handling clicking on the menu item
   bool              OnClickMenuItem(const int id,const int index);
   //--- Returns the active item of the main menu
   int               ActiveItemIndex(void);
   //--- Switches the context menus of the main menu by hovering the cursor over it
   void              SwitchContextMenuByFocus(void);

   //--- Change the width at the right edge of the window
   virtual void      ChangeWidthByRightWindowSide(void);
  };
//+------------------------------------------------------------------+
//| Constructor                                                      |
//+------------------------------------------------------------------+
CMenuBar::CMenuBar(void) : m_menubar_state(false),
                           m_prev_active_item_index(WRONG_VALUE)
  {
//--- Store the name of the control class in the base class
   CElementBase::ClassName(CLASS_NAME);
//--- Center text in menu items
   CElement::IsCenterText(true);
  }
//+------------------------------------------------------------------+
//| Destructor                                                       |
//+------------------------------------------------------------------+
CMenuBar::~CMenuBar(void)
  {
  }
//+------------------------------------------------------------------+
//| Event handler                                                    |
//+------------------------------------------------------------------+
void CMenuBar::OnEvent(const int id,const long &lparam,const double &dparam,const string &sparam)
  {
//--- Handling the event of changing focus on the menu items
   if(id==CHARTEVENT_CUSTOM+ON_MOUSE_FOCUS)
     {
      //--- Leave, if (2) the main menu has not been activated or (2) identifiers do not match
      if(!m_menubar_state || lparam!=CElementBase::Id())
         return;
      //--- Switch the context menu by the activated item of the main menu
      SwitchContextMenuByFocus();
      return;
     }
//--- Handling of the left mouse click event on the main menu item
   if(id==CHARTEVENT_CUSTOM+ON_CLICK_BUTTON)
     {
      if(OnClickMenuItem((uint)lparam,(uint)dparam))
         return;
      //---
      return;
     }
  }
//+------------------------------------------------------------------+
//| Creates the main menu                                            |
//+------------------------------------------------------------------+
bool CMenuBar::CreateMenuBar(const int x_gap,const int y_gap)
  {
//--- Leave, if there is no pointer to the main control
   if(!CElement::CheckMainPointer())
      return(false);
//--- Initialization of the properties
   InitializeProperties(x_gap,y_gap);
//--- Create control
   if(!CreateCanvas())
      return(false);
   if(!CreateItems())
      return(false);
//---
   return(true);
  }
//+------------------------------------------------------------------+
//| Initialization of the properties                                 |
//+------------------------------------------------------------------+
void CMenuBar::InitializeProperties(const int x_gap,const int y_gap)
  {
   m_x        =CElement::CalculateX(x_gap);
   m_y        =CElement::CalculateY(y_gap);
   m_x_size   =(m_x_size<1 || m_auto_xresize_mode)? m_main.X2()-m_x-m_auto_xresize_right_offset : m_x_size;
   m_y_size   =(m_y_size<1)? 22 : m_y_size;
//--- Default properties
   m_back_color           =(m_back_color!=clrNONE)? m_back_color : C'225,225,225';
   m_back_color_hover     =(m_back_color_hover!=clrNONE)? m_back_color_hover : C'51,153,255';
   m_back_color_pressed   =(m_back_color_pressed!=clrNONE)? m_back_color_pressed : m_back_color_hover;
   m_border_color         =(m_border_color!=clrNONE)? m_border_color : m_back_color;
   m_border_color_hover   =(m_border_color_hover!=clrNONE)? m_border_color_hover : m_back_color;
   m_border_color_pressed =(m_border_color_pressed!=clrNONE)? m_border_color_pressed : m_back_color;
   m_label_y_gap          =(m_label_y_gap!=WRONG_VALUE)? m_label_y_gap : 3;
   m_label_color          =(m_label_color!=clrNONE)? m_label_color : clrBlack;
   m_label_color_hover    =(m_label_color_hover!=clrNONE)? m_label_color_hover : clrWhite;
   m_label_color_pressed  =(m_label_color_pressed!=clrNONE)? m_label_color_pressed : clrWhite;
//--- Offsets from the extreme point
   CElementBase::XGap(x_gap);
   CElementBase::YGap(y_gap);
  }
//+------------------------------------------------------------------+
//| Creates the canvas for drawing                                   |
//+------------------------------------------------------------------+
bool CMenuBar::CreateCanvas(void)
  {
//--- Forming the object name
   string name=CElementBase::ElementName("menubar");
//--- Creating an object
   if(!CElement::CreateCanvas(name,m_x,m_y,m_x_size,m_y_size))
      return(false);
//---
   return(true);
  }
//+------------------------------------------------------------------+
//| Creates a list of menu items                                     |
//+------------------------------------------------------------------+
bool CMenuBar::CreateItems(void)
  {
//--- Coordinates
   int x=0,y=0;
//---
   int items_total=ItemsTotal();
   for(int i=0; i<items_total; i++)
     {
      //--- Calculation of the X coordinate
      x=(i>0)? x+m_items[i-1].XSize() : x;
      //--- Store the pointer to the main control
      m_items[i].MainPointer(this);
      //--- Set properties before creation
      m_items[i].Index(i);
      m_items[i].NamePart("menu_item");
      m_items[i].TwoState(true);
      m_items[i].TypeMenuItem(MI_HAS_CONTEXT_MENU);
      m_items[i].ShowRightArrow(false);
      m_items[i].XSize(m_items[i].XSize());
      m_items[i].YSize(m_y_size);
      m_items[i].BackColor(m_back_color);
      m_items[i].BackColorHover(m_back_color_hover);
      m_items[i].BackColorPressed(m_back_color_pressed);
      m_items[i].BorderColor(m_border_color);
      m_items[i].BorderColorHover(m_border_color_hover);
      m_items[i].BorderColorPressed(m_border_color_pressed);
      m_items[i].IconXGap(3);
      m_items[i].IconYGap(4);
      m_items[i].LabelXGap(m_label_x_gap);
      m_items[i].LabelYGap(m_label_y_gap);
      m_items[i].LabelColor(m_label_color);
      m_items[i].LabelColorHover(m_label_color_hover);
      m_items[i].LabelColorPressed(m_label_color_pressed);
      m_items[i].IsCenterText(CElement::IsCenterText());
      //--- Creating a menu item
      if(!m_items[i].CreateMenuItem(m_items[i].LabelText(),x,y))
         return(false);
      //--- Add the control to the array
      CElement::AddToArray(m_items[i]);
     }
//---
   return(true);
  }
//+------------------------------------------------------------------+
//| Setting the state of the main menu                               |
//+------------------------------------------------------------------+
void CMenuBar::State(const bool state)
  {
   if(state)
      m_menubar_state=true;
   else
     {
      m_menubar_state=false;
      //--- Iterate over all items of the main menu for setting the status of disabled context menus
      int items_total=ItemsTotal();
      for(int i=0; i<items_total; i++)
        {
         m_items[i].IsPressed(false);
         m_items[i].Update(true);
        }
     }
  }
//+------------------------------------------------------------------+
//| Returns a menu item pointer by the index                         |
//+------------------------------------------------------------------+
CMenuItem *CMenuBar::GetItemPointer(const uint index)
  {
   uint array_size=::ArraySize(m_items);
//--- If the main menu does not contain any item, report
   if(array_size<1)
     {
      ::Print(__FUNCTION__," > This method is to be called, "
              "when the main menu contains at least one item!");
     }
//--- Adjustment in case the range has been exceeded
   uint i=(index>=array_size)? array_size-1 : index;
//--- Return the pointer
   return(::GetPointer(m_items[i]));
  }
//+------------------------------------------------------------------+
//| Returns the context menu pointer by the index                    |
//+------------------------------------------------------------------+
CContextMenu *CMenuBar::GetContextMenuPointer(const uint index)
  {
   uint array_size=::ArraySize(m_contextmenus);
//--- If the main menu does not contain any item, report
   if(array_size<1)
     {
      ::Print(__FUNCTION__," > This method is to be called, "
              "when the main menu contains at least one item!");
     }
//--- Adjustment in case the range has been exceeded
   uint i=(index>=array_size)? array_size-1 : index;
//--- Return the pointer
   return(::GetPointer(m_contextmenus[i]));
  }
//+------------------------------------------------------------------+
//| Adds a menu item                                                 |
//+------------------------------------------------------------------+
void CMenuBar::AddItem(const int width,const string text)
  {
//--- Increase the array size by one element  
   int array_size=::ArraySize(m_items);
   ::ArrayResize(m_items,array_size+1);
   ::ArrayResize(m_contextmenus,array_size+1);
//--- Store the value of passed parameters
   m_items[array_size].XSize(width);
   m_items[array_size].LabelText(text);
  }
//+------------------------------------------------------------------+
//| Adds the context menu pointer                                    |
//+------------------------------------------------------------------+
void CMenuBar::AddContextMenuPointer(const uint index,CContextMenu &object)
  {
//--- Checking for exceeding the array range
   uint size=::ArraySize(m_contextmenus);
   if(size<1 || index>=size)
      return;
//--- Store the pointer
   m_contextmenus[index]=::GetPointer(object);
  }
//+------------------------------------------------------------------+
//| Deleting                                                         |
//+------------------------------------------------------------------+
void CMenuBar::Delete(void)
  {
//--- Removing objects  
   CElement::Delete();
//--- Emptying the control arrays
   ::ArrayFree(m_items);
   ::ArrayFree(m_contextmenus);
  }
//+------------------------------------------------------------------+
//| Clicking on the main menu item                                   |
//+------------------------------------------------------------------+
bool CMenuBar::OnClickMenuItem(const int id,const int index)
  {
//--- Leave, if (1) the identifiers do not match or (2) the control is locked
   if(id!=CElementBase::Id() || CElementBase::IsLocked())
      return(false);
//--- If there is a context menu pointer
   if(::CheckPointer(m_contextmenus[index])!=POINTER_INVALID)
     {
      //--- The state of the main menu depends on the visibility of the context menu
      m_menubar_state=(m_contextmenus[index].IsVisible())? false : true;
      //--- Determine the selected item
      m_prev_active_item_index=(m_menubar_state)? index : WRONG_VALUE;
     }
//---
   return(true);
  }
//+------------------------------------------------------------------+
//| Returns the index of the activated menu item                     |
//+------------------------------------------------------------------+
int CMenuBar::ActiveItemIndex(void)
  {
   int active_item_index=WRONG_VALUE;
//---
   int items_total=ItemsTotal();
   for(int i=0; i<items_total; i++)
     {
      //--- If the item is in focus
      if(m_items[i].MouseFocus())
        {
         //--- Store the index and stop the loop
         active_item_index=i;
         break;
        }
     }
//---
   return(active_item_index);
  }
//+------------------------------------------------------------------+
//| Switches context menus of the main menu by hovering cursor over  |
//+------------------------------------------------------------------+
void CMenuBar::SwitchContextMenuByFocus(void)
  {
//--- Get the index of the activated item of the main menu
   int active_item_index=ActiveItemIndex();
//--- Leave, if (1) the menu is not activated or (2) this is the same menu item
   if(active_item_index==WRONG_VALUE || active_item_index==m_prev_active_item_index)
      return;
//--- Move to the following item menu if this one does not have a context menu
   if(::CheckPointer(m_contextmenus[active_item_index])!=POINTER_INVALID)
     {
      //--- Make the context menu visible
      m_contextmenus[active_item_index].Show();
      m_items[active_item_index].IsPressed(true);
     }
//--- Get the pointer to the previous selected item
   CContextMenu *cm=m_contextmenus[m_prev_active_item_index];
//--- Hide the context menus, which are open from other context menus.
//    Iterate over the items of the current context menus to find out if there are any.
   int cm_items_total=cm.ItemsTotal();
   for(int c=0; c<cm_items_total; c++)
     {
      CMenuItem *mi=cm.GetItemPointer(c);
      //--- Move to the following menu item if the pointer to this one is incorrect
      if(::CheckPointer(mi)==POINTER_INVALID)
         continue;
      //--- Move to the following menu item if this one does not contain a context menu
      if(mi.TypeMenuItem()!=MI_HAS_CONTEXT_MENU)
         continue;
      //--- If the context menu is activated
      if(mi.IsPressed())
        {
         //--- Send a signal for closing all context menus, which are open from this one
         ::EventChartCustom(m_chart_id,ON_HIDE_BACK_CONTEXTMENUS,CElementBase::Id(),0,"");
         break;
        }
     }
//--- Hide the context menu of the main menu
   m_contextmenus[m_prev_active_item_index].Hide();
   m_items[m_prev_active_item_index].IsPressed(false);
   m_items[m_prev_active_item_index].Update(true);
//--- Store the index of the currently activated menu
   m_prev_active_item_index=active_item_index;
//--- Send a message to determine the available controls
   ::EventChartCustom(m_chart_id,ON_SET_AVAILABLE,CElementBase::Id(),0,"");
//--- Send a message about the change in the graphical interface
   ::EventChartCustom(m_chart_id,ON_CHANGE_GUI,CElementBase::Id(),0.0,"");
  }
//+------------------------------------------------------------------+
//| Change the width at the right edge of the form                   |
//+------------------------------------------------------------------+
void CMenuBar::ChangeWidthByRightWindowSide(void)
  {
//--- Leave, if the anchoring mode to the right side of the form is enabled
   if(m_anchor_right_window_side)
      return;
//--- Size
   int x_size=0;
//--- Calculate and set the new size to the control background
   x_size=m_main.X2()-m_canvas.X()-m_auto_xresize_right_offset;
   CElementBase::XSize(x_size);
   m_canvas.XSize(x_size);
   m_canvas.Resize(x_size,m_y_size);
//--- Redraw the control
   Draw();
//--- Update the position of objects
   Moving();
  }
//+------------------------------------------------------------------+
//| Draws the control                                                |
//+------------------------------------------------------------------+
void CMenuBar::Draw(void)
  {
//--- Draw the background
   CElement::DrawBackground();
  }
//+------------------------------------------------------------------+
