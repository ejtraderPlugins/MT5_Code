//+------------------------------------------------------------------+
//|                                                  SplitButton.mqh |
//|                        Copyright 2015, MetaQuotes Software Corp. |
//|                                              http://www.mql5.com |
//+------------------------------------------------------------------+
#include "..\Element.mqh"
#include "Button.mqh"
#include "ContextMenu.mqh"
//+------------------------------------------------------------------+
//| Class for creating a split button                                |
//+------------------------------------------------------------------+
class CSplitButton : public CElement
  {
private:
   //--- Object for creating a button
   CButton           m_button;
   CButton           m_drop_button;
   CContextMenu      m_drop_menu;
   //--- State of the context menu 
   bool              m_drop_menu_state;
   //---
public:
                     CSplitButton(void);
                    ~CSplitButton(void);
   //--- Methods for creating a button
   bool              CreateSplitButton(const string text,const int x_gap,const int y_gap);
   //---
private:
   void              InitializeProperties(const string text,const int x_gap,const int y_gap);
   bool              CreateButton(void);
   bool              CreateDropButton(void);
   bool              CreateDropMenu(void);
   //---
public:
   //--- (1) get the pointer to context menu, (2) general state of the button (available/locked)
   CButton          *GetButtonPointer(void)      { return(::GetPointer(m_button));      }
   CButton          *GetDropButtonPointer(void)  { return(::GetPointer(m_drop_button)); }
   CContextMenu     *GetContextMenuPointer(void) { return(::GetPointer(m_drop_menu));   }
   //--- Adds a menu item with specified properties before the creation of the context menu
   void              AddItem(const string text,const string path_bmp_on,const string path_bmp_off);
   //--- Adds a separation line after the specified item before the creation of the context menu
   void              AddSeparateLine(const int item_index);
   //---
public:
   //--- Handler of chart events
   virtual void      OnEvent(const int id,const long &lparam,const double &dparam,const string &sparam);
   //---
private:
   //--- Handling the pressing of a button
   bool              OnClickButton(const string pressed_object,const int id,const int index);
   //--- Handling the pressing of the button with a drop down menu
   bool              OnClickDropButton(const string pressed_object,const int id,const int index);

   //--- Hides the drop-down menu
   void              HideDropDownMenu(void);
  };
//+------------------------------------------------------------------+
//| Constructor                                                      |
//+------------------------------------------------------------------+
CSplitButton::CSplitButton(void) : m_drop_menu_state(false)
  {
//--- Store the name of the control class in the base class  
   CElementBase::ClassName(CLASS_NAME);
  }
//+------------------------------------------------------------------+
//| Destructor                                                       |
//+------------------------------------------------------------------+
CSplitButton::~CSplitButton(void)
  {
  }
//+------------------------------------------------------------------+
//| Event handler                                                    |
//+------------------------------------------------------------------+
void CSplitButton::OnEvent(const int id,const long &lparam,const double &dparam,const string &sparam)
  {
//--- Handling the mouse move event
   if(id==CHARTEVENT_MOUSE_MOVE)
     {
      //--- Checking the focus over controls
      m_drop_button.MouseFocus(m_mouse.X()>m_drop_button.X() && m_mouse.X()<m_drop_button.X2() && 
                               m_mouse.Y()>m_drop_button.Y() && m_mouse.Y()<m_drop_button.Y2());
      //--- Outside of the control area and with pressed mouse button
      if(!CElementBase::MouseFocus() && m_mouse.LeftButtonState())
        {
         //--- Leave, if the focus is in the context menu
         if(m_drop_menu.MouseFocus())
            return;
         //--- Hide the drop-down menu
         HideDropDownMenu();
         return;
        }
      return;
     }
//--- Handling the event of pressing of the free menu item
   if(id==CHARTEVENT_CUSTOM+ON_CLICK_FREEMENU_ITEM)
     {
      //--- Leave, if the identifiers do not match
      if(CElementBase::Id()!=lparam)
         return;
      //--- Hide the drop-down menu
      HideDropDownMenu();
      //--- Send a message
      ::EventChartCustom(m_chart_id,ON_CLICK_CONTEXTMENU_ITEM,lparam,dparam,sparam);
      return;
     }
//--- Handling the event of left mouse button press on the control
   if(id==CHARTEVENT_CUSTOM+ON_CLICK_BUTTON)
     {
      //--- Pressing of the simple button
      if(OnClickButton(sparam,(int)lparam,(int)dparam))
         return;
      //--- Pressing of the button with a drop-down menu
      if(OnClickDropButton(sparam,(int)lparam,(int)dparam))
         return;
     }
  }
//+------------------------------------------------------------------+
//| Create "Button" control                                          |
//+------------------------------------------------------------------+
bool CSplitButton::CreateSplitButton(const string text,const int x_gap,const int y_gap)
  {
//--- Leave, if there is no pointer to the main control
   if(!CElement::CheckMainPointer())
      return(false);
//--- Initialization of the properties
   InitializeProperties(text,x_gap,y_gap);
//--- Creating the button
   if(!CreateButton())
      return(false);
   if(!CreateDropButton())
      return(false);
   if(!CreateDropMenu())
      return(false);
//---
   return(true);
  }
//+------------------------------------------------------------------+
//| Initialization of the properties                                 |
//+------------------------------------------------------------------+
void CSplitButton::InitializeProperties(const string text,const int x_gap,const int y_gap)
  {
   m_x          =CElement::CalculateX(x_gap);
   m_y          =CElement::CalculateY(y_gap);
   m_label_text =text;
   m_x_size     =(m_x_size<1)? 80 : m_x_size;
   m_y_size     =(m_y_size<1)? 20 : m_y_size;
//--- Offsets from the extreme point
   CElementBase::XGap(x_gap);
   CElementBase::YGap(y_gap);
//--- Priority as in the main control, since the control does not have its own area for clicking
   CElement::Z_Order(m_main.Z_Order());
  }
//+------------------------------------------------------------------+
//| Creates button                                                   |
//+------------------------------------------------------------------+
bool CSplitButton::CreateButton(void)
  {
//--- Store the pointer to the parent control
   m_button.MainPointer(this);
//--- Size
   int x_size=m_x_size-18;
//--- Coordinates
   int x=0,y=0;
//--- Margins for the image
   int icon_x_gap =(m_button.IconXGap()<1)? 3 : m_button.IconXGap();
   int icon_y_gap =(m_button.IconYGap()<1)? 3 : m_button.IconYGap();
//--- Properties
   m_button.NamePart("split_button");
   m_button.Index(0);
   m_button.Alpha(m_alpha);
   m_button.XSize(x_size);
   m_button.YSize(m_y_size);
   m_button.IconXGap(icon_x_gap);
   m_button.IconYGap(icon_y_gap);
   m_button.IconFile(IconFile());
   m_button.IconFileLocked(IconFileLocked());
//--- Create a control
   if(!m_button.CreateButton(m_label_text,x,y))
      return(false);
//--- Add the control to the array
   CElement::AddToArray(m_button);
   return(true);
  }
//+------------------------------------------------------------------+
//| Create button to call the context menu                           |
//+------------------------------------------------------------------+
#resource "\\Images\\EasyAndFastGUI\\Controls\\up_thin_black.bmp"
#resource "\\Images\\EasyAndFastGUI\\Controls\\down_thin_black.bmp"
//---
bool CSplitButton::CreateDropButton(void)
  {
//--- Store the pointer to the parent control
   m_drop_button.MainPointer(this);
//--- Size
   int x_size=18;
//--- Coordinates
   int x=m_button.XSize()-1,y=0;
//--- Margins for the image
   int icon_x_gap =(m_drop_button.IconXGap()<1)? 1 : m_drop_button.IconXGap();
   int icon_y_gap =(m_drop_button.IconYGap()<1)? 3 : m_drop_button.IconYGap();
//--- Set properties before creation
   m_drop_button.NamePart("split_button");
   m_drop_button.Index(1);
   m_drop_button.Alpha(m_alpha);
   m_drop_button.TwoState(true);
   m_drop_button.XSize(x_size);
   m_drop_button.YSize(m_y_size);
   m_drop_button.IconXGap(icon_x_gap);
   m_drop_button.IconYGap(icon_y_gap);
   m_drop_button.IconFile("Images\\EasyAndFastGUI\\Controls\\down_thin_black.bmp");
   m_drop_button.IconFileLocked("Images\\EasyAndFastGUI\\Controls\\down_thin_black.bmp");
   m_drop_button.IconFilePressed("Images\\EasyAndFastGUI\\Controls\\up_thin_black.bmp");
   m_drop_button.IconFilePressedLocked("Images\\EasyAndFastGUI\\Controls\\up_thin_black.bmp");
//--- Create a control
   if(!m_drop_button.CreateButton("",x,y))
      return(false);
//--- Add the control to the array
   CElement::AddToArray(m_drop_button);
   return(true);
  }
//+------------------------------------------------------------------+
//| Creates a drop-down menu                                         |
//+------------------------------------------------------------------+
bool CSplitButton::CreateDropMenu(void)
  {
//--- Store the pointer to the main control
   m_drop_menu.MainPointer(this);
//--- Detached context menu
   m_drop_menu.FreeContextMenu(true);
//--- Coordinates
   int x=0,y=m_y_size;
//--- set properties
   m_drop_menu.XSize((m_drop_menu.XSize()>0)? m_drop_menu.XSize() : m_x_size-1);
//--- Set up a context menu
   if(!m_drop_menu.CreateContextMenu(x,y))
      return(false);
//--- Add the control to the array
   CElement::AddToArray(m_drop_menu);
   return(true);
  }
//+------------------------------------------------------------------+
//| Adds a menu item                                                 |
//+------------------------------------------------------------------+
void CSplitButton::AddItem(const string text,const string path_bmp_on,const string path_bmp_off)
  {
   m_drop_menu.AddItem(text,path_bmp_on,path_bmp_off,MI_SIMPLE);
  }
//+------------------------------------------------------------------+
//| Adds a separation line                                           |
//+------------------------------------------------------------------+
void CSplitButton::AddSeparateLine(const int item_index)
  {
   m_drop_menu.AddSeparateLine(item_index);
  }
//+------------------------------------------------------------------+
//| Pressing the button                                              |
//+------------------------------------------------------------------+
bool CSplitButton::OnClickButton(const string pressed_object,const int id,const int index)
  {
//--- Leave, if clicking was not on the button
   if(::StringFind(pressed_object,"split_button")<0)
      return(false);
//--- Leave, if (1) the identifiers do not match or (2) the control is locked
   if(id!=CElementBase::Id() || index!=m_button.Index() || CElementBase::IsLocked())
      return(false);
//--- Hide the menu
   HideDropDownMenu();
//--- Send a message about it
   ::EventChartCustom(m_chart_id,ON_CLICK_BUTTON,CElementBase::Id(),CElementBase::Index(),"");
   return(true);
  }
//+------------------------------------------------------------------+
//| Pressing of the button with a drop-down menu                     |
//+------------------------------------------------------------------+
bool CSplitButton::OnClickDropButton(const string pressed_object,const int id,const int index)
  {
//--- Leave, if clicking was not on the button
   if(::StringFind(pressed_object,"split_button")<0)
      return(false);
//--- Leave, if (1) the identifiers do not match or (2) the control is locked
   if(id!=CElementBase::Id() || index!=m_drop_button.Index() || CElementBase::IsLocked())
      return(false);
//--- If the list is shown, hide it
   if(m_drop_menu_state)
     {
      m_drop_menu_state=false;
      m_drop_menu.Hide();
      //--- Send a message to determine the available controls
      
::EventChartCustom(m_chart_id,ON_SET_AVAILABLE,CElementBase::Id(),1,"");
     }
//--- If the list is hidden, show it
   else
     {
      m_drop_menu_state=true;
      m_drop_menu.Show();
      //--- Send a message to determine the available controls
      ::EventChartCustom(m_chart_id,ON_SET_AVAILABLE,CElementBase::Id(),0,"");
     }
//--- Send a message about the change in the graphical interface
   ::EventChartCustom(m_chart_id,ON_CHANGE_GUI,CElementBase::Id(),0.0,"");
   return(true);
  }
//+------------------------------------------------------------------+
//| Hides a drop-down menu                                           |
//+------------------------------------------------------------------+
void CSplitButton::HideDropDownMenu(void)
  {
//--- Hide the menu and set up corresponding indications
   m_drop_menu.Hide();
   m_drop_menu_state=false;
//--- Release the button if pressed
   if(m_drop_button.IsPressed())
     {
      m_drop_button.IsPressed(false);
      m_drop_button.Update(true);
      //--- Send a message to determine the available controls
      
::EventChartCustom(m_chart_id,ON_SET_AVAILABLE,CElementBase::Id(),1,"");      
      //--- Send a message about the change in the graphical interface
      ::EventChartCustom(m_chart_id,ON_CHANGE_GUI,CElementBase::Id(),0.0,"");
     }
  }
//+------------------------------------------------------------------+
