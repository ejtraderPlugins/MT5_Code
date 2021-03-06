//+------------------------------------------------------------------+
//|                                                 ButtonsGroup.mqh |
//|                        Copyright 2015, MetaQuotes Software Corp. |
//|                                              http://www.mql5.com |
//+------------------------------------------------------------------+
#include "..\Element.mqh"
#include "Button.mqh"
//+------------------------------------------------------------------+
//| Class for creating groups of buttons                             |
//+------------------------------------------------------------------+
class CButtonsGroup : public CElement
  {
private:
   //--- Instances for creating a control
   CButton           m_buttons[];
   //    The radio button mode
   bool              m_radio_buttons_mode;
   //--- Radio button display style
   bool              m_radio_buttons_style;
   //--- Height of buttons
   int               m_button_y_size;
   //--- (1) Text and (2) index of the highlighted button
   string            m_selected_button_text;
   int               m_selected_button_index;
   //---
public:
                     CButtonsGroup(void);
                    ~CButtonsGroup(void);
   //--- Methods for creating a button
   bool              CreateButtonsGroup(const int x_gap,const int y_gap);
   //---
private:
   void              InitializeProperties(const int x_gap,const int y_gap);
   bool              CreateButtons(void);
   //---
public:
   //--- Returns pointer to the button at the specified index
   CButton          *GetButtonPointer(const uint index);
   //--- (1) The number of buttons, (2) height of buttons
   int               ButtonsTotal(void)                       const { return(::ArraySize(m_buttons));  }
   void              ButtonYSize(const int y_size)                  { m_button_y_size=y_size;          }
   //--- (1) Setting the mode and (2) display style of radio buttons
   void              RadioButtonsMode(const bool flag)              { m_radio_buttons_mode=flag;       }
   void              RadioButtonsStyle(const bool flag)             { m_radio_buttons_style=flag;      }
   //--- Returns (1) the text and (2) index of the highlighted button
   string            SelectedButtonText(void)                 const { return(m_selected_button_text);  }
   int               SelectedButtonIndex(void)                const { return(m_selected_button_index); }

   //--- Adds a button with specified properties before creation
   void              AddButton(const int x_gap,const int y_gap,const string text,const int width,
                               const color button_color=clrNONE,const color button_color_hover=clrNONE,const color button_color_pressed=clrNONE);
   //--- Toggles the button state by the specified index
   void              SelectButton(const uint index,const bool is_external_call=true);
   //---
public:
   //--- Handler of chart events
   virtual void      OnEvent(const int id,const long &lparam,const double &dparam,const string &sparam);
   //--- Object management
   virtual void      Show(void);
   virtual void      Delete(void);
   //--- Updates the control to display the latest changes
   virtual void      Update(const bool redraw=false);
   //--- Draws the control
   virtual void      Draw(void);
   //---
private:
   //--- Handling the pressing of a button
   bool              OnClickButton(const string pressed_object,const int id,const int index);
  };
//+------------------------------------------------------------------+
//| Constructor                                                      |
//+------------------------------------------------------------------+
CButtonsGroup::CButtonsGroup(void) : m_button_y_size(20),
                                     m_radio_buttons_mode(false),
                                     m_radio_buttons_style(false),
                                     m_selected_button_text(""),
                                     m_selected_button_index(WRONG_VALUE)
  {
//--- Store the name of the control class in the base class  
   CElementBase::ClassName(CLASS_NAME);
//--- Default label
   CElementBase::NamePart("button");
  }
//+------------------------------------------------------------------+
//| Destructor                                                       |
//+------------------------------------------------------------------+
CButtonsGroup::~CButtonsGroup(void)
  {
  }
//+------------------------------------------------------------------+
//| Chart event handler                                              |
//+------------------------------------------------------------------+
void CButtonsGroup::OnEvent(const int id,const long &lparam,const double &dparam,const string &sparam)
  {
//--- Handling the event of left mouse button press on the control
   if(id==CHARTEVENT_CUSTOM+ON_CLICK_BUTTON)
     {
      if(OnClickButton(sparam,(uint)lparam,(uint)dparam))
         return;
      //---
      return;
     }
  }
//+------------------------------------------------------------------+
//| Create group of buttons                                          |
//+------------------------------------------------------------------+
bool CButtonsGroup::CreateButtonsGroup(const int x_gap,const int y_gap)
  {
//--- Leave, if there is no pointer to the main control
   if(!CElement::CheckMainPointer())
      return(false);
//--- Initialization of the properties
   InitializeProperties(x_gap,y_gap);
//--- Create buttons
   if(!CreateButtons())
      return(false);
//--- Select the radio button
   if(m_radio_buttons_mode)
      m_buttons[m_selected_button_index].IsPressed(true);
//---
   return(true);
  }
//+------------------------------------------------------------------+
//| Initialization of the properties                                 |
//+------------------------------------------------------------------+
void CButtonsGroup::InitializeProperties(const int x_gap,const int y_gap)
  {
   m_x =CElement::CalculateX(x_gap);
   m_y =CElement::CalculateY(y_gap);
//--- Default values
   m_label_x_gap =(m_label_x_gap!=WRONG_VALUE)? m_label_x_gap : 18;
   m_label_y_gap =(m_label_y_gap!=WRONG_VALUE)? m_label_y_gap : 0;
//--- One radio button must be selected
   if(m_radio_buttons_mode)
      m_selected_button_index=(m_selected_button_index!=WRONG_VALUE)? m_selected_button_index : 0;
//--- Offsets from the extreme point
   CElementBase::XGap(x_gap);
   CElementBase::YGap(y_gap);
//--- Priority as in the main control, since the control does not have its own area for clicking
   CElement::Z_Order(m_main.Z_Order());
  }
//+------------------------------------------------------------------+
//| Creates buttons                                                  |
//+------------------------------------------------------------------+
bool CButtonsGroup::CreateButtons(void)
  {
//--- Coordinates
   int x=0,y=0;
//--- Get the number of buttons
   int buttons_total=ButtonsTotal();
//--- If there is no button in a group, report
   if(buttons_total<1)
     {
      ::Print(__FUNCTION__," > This method is to be called, "
              "if a group contains at least one button! Use the CButtonsGroup::AddButton() method");
      return(false);
     }
//--- Create the specified number of buttons
   for(int i=0; i<buttons_total; i++)
     {
      //--- Store the pointer to the parent control
      m_buttons[i].MainPointer(this);
      //--- Coordinates
      x =m_buttons[i].XGap();
      y =m_buttons[i].YGap();
      //--- Properties
      m_buttons[i].NamePart(CElementBase::NamePart());
      m_buttons[i].Alpha(m_alpha);
      m_buttons[i].IconXGap(m_icon_x_gap);
      m_buttons[i].IconYGap(m_icon_y_gap);
      m_buttons[i].LabelXGap(m_label_x_gap);
      m_buttons[i].LabelYGap(m_label_y_gap);
      m_buttons[i].IsCenterText(CElement::IsCenterText());
      m_buttons[i].IsDropdown(CElementBase::IsDropdown());
      //--- Create a control
      if(!m_buttons[i].CreateButton(m_buttons[i].LabelText(),x,y))
         return(false);
      //--- Click the button, if defined
      if(i==m_selected_button_index)
         m_buttons[i].IsPressed(true);
      //--- Add the control to the array
      CElement::AddToArray(m_buttons[i]);
     }
//---
   return(true);
  }
//+------------------------------------------------------------------+
//| Returns pointer to the button at the specified index             |
//+------------------------------------------------------------------+
CButton *CButtonsGroup::GetButtonPointer(const uint index)
  {
   uint array_size=::ArraySize(m_buttons);
//--- Verifying the size of the object array
   if(array_size<1)
     {
      ::Print(__FUNCTION__," > The group has no buttons!");
      return(NULL);
     }
//--- Adjustment in case the range has been exceeded
   uint i=(index>=array_size)? array_size-1 : index;
//--- Return the object pointer
   return(::GetPointer(m_buttons[i]));
  }
//+------------------------------------------------------------------+
//| Adds a button                                                    |
//+------------------------------------------------------------------+
#resource "\\Images\\EasyAndFastGUI\\Controls\\radio_button_off.bmp"
#resource "\\Images\\EasyAndFastGUI\\Controls\\radio_button_on.bmp"
#resource "\\Images\\EasyAndFastGUI\\Controls\\radio_button_on_locked.bmp"
#resource "\\Images\\EasyAndFastGUI\\Controls\\radio_button_off_locked.bmp"
//---
void CButtonsGroup::AddButton(const int x_gap,const int y_gap,const string text,const int width,
                              const color button_color=clrNONE,const color button_color_hover=clrNONE,const color button_color_pressed=clrNONE)
  {
//--- Reserve size
   int reserve_size=100;
//--- Increase the array size by one element
   int array_size=::ArraySize(m_buttons);
   int new_size=array_size+1;
   ::ArrayResize(m_buttons,new_size,reserve_size);
//--- set properties
   m_buttons[array_size].Index(array_size);
   m_buttons[array_size].TwoState(true);
   m_buttons[array_size].XSize(width);
   m_buttons[array_size].YSize(m_button_y_size);
   m_buttons[array_size].XGap(x_gap);
   m_buttons[array_size].YGap(y_gap);
   m_buttons[array_size].LabelText(text);
   m_buttons[array_size].BackColor(button_color);
   m_buttons[array_size].BackColorHover(button_color_hover);
   m_buttons[array_size].BackColorPressed(button_color_pressed);
//--- Leave, if the radio button style is disabled
   if(!m_radio_buttons_style)
      return;
//---
   m_buttons[array_size].BackColor(m_main.BackColor());
   m_buttons[array_size].BackColorHover(m_main.BackColor());
   m_buttons[array_size].BackColorPressed(m_main.BackColor());
   m_buttons[array_size].BackColorLocked(m_main.BackColor());
   m_buttons[array_size].BorderColor(m_main.BackColor());
   m_buttons[array_size].BorderColorHover(m_main.BackColor());
   m_buttons[array_size].BorderColorPressed(m_main.BackColor());
   m_buttons[array_size].BorderColorLocked(m_main.BackColor());
   m_buttons[array_size].LabelColorHover(C'0,120,215');
   m_buttons[array_size].IconXGap(m_icon_x_gap);
   m_buttons[array_size].IconYGap(m_icon_y_gap);
   m_buttons[array_size].IconFileLocked("Images\\EasyAndFastGUI\\Controls\\radio_button_off_locked.bmp");
   m_buttons[array_size].IconFile("Images\\EasyAndFastGUI\\Controls\\radio_button_off.bmp");
   m_buttons[array_size].IconFileLocked("Images\\EasyAndFastGUI\\Controls\\radio_button_off_locked.bmp");
   m_buttons[array_size].IconFilePressed("Images\\EasyAndFastGUI\\Controls\\radio_button_on.bmp");
   m_buttons[array_size].IconFilePressedLocked("Images\\EasyAndFastGUI\\Controls\\radio_button_on_locked.bmp");
  }
//+------------------------------------------------------------------+
//| Toggles the button state by the specified index                  |
//+------------------------------------------------------------------+
void CButtonsGroup::SelectButton(const uint index,const bool is_external_call=true)
  {
//--- For checking for a pressed button in a group
   bool check_pressed_button=false;
//--- Get the number of buttons
   uint buttons_total=ButtonsTotal();
//--- If there is no button in a group, report
   if(buttons_total<1)
     {
      ::Print(__FUNCTION__," > This method is to be called, ...\n"
              "... if a group contains at least one button! Use the CButtonsGroup::AddButton() method");
     }
//--- Adjust the index value if the array range is exceeded
   uint correct_index=(index>=buttons_total)? buttons_total-1 : index;
//---
   if(is_external_call && !m_radio_buttons_mode)
      m_buttons[correct_index].IsPressed(!m_buttons[correct_index].IsPressed());
//--- Iterate over a group of buttons
   for(uint i=0; i<buttons_total; i++)
     {
      if(i==correct_index)
        {
         if(m_radio_buttons_mode)
            m_buttons[i].IsPressed(true);
         //---
         check_pressed_button=true;
         continue;
        }
      //--- Release the remaining buttons
      if(m_buttons[i].IsPressed())
         m_buttons[i].IsPressed(false);
     }
//--- If there is a pressed button, store its text and index
   m_selected_button_text  =(check_pressed_button)? m_buttons[correct_index].LabelText() : "";
   m_selected_button_index =(check_pressed_button)? (int)correct_index : WRONG_VALUE;
  }
//+------------------------------------------------------------------+
//| Showing                                                          |
//+------------------------------------------------------------------+
void CButtonsGroup::Show(void)
  {
   CElement::Show();
   int total=ButtonsTotal();
   for(int i=0; i<total; i++)
      m_buttons[i].Show();
  }
//+------------------------------------------------------------------+
//| Deleting                                                         |
//+------------------------------------------------------------------+
void CButtonsGroup::Delete(void)
  {
   CElement::Delete();
//--- Emptying the control arrays
   ::ArrayFree(m_buttons);
  }
//+------------------------------------------------------------------+
//| Updating the control                                             |
//+------------------------------------------------------------------+
void CButtonsGroup::Update(const bool redraw=false)
  {
   int buttons_total=ButtonsTotal();
//--- With redrawing the control
   if(redraw)
     {
      for(int i=0; i<buttons_total; i++)
         m_buttons[i].Draw();
      for(int i=0; i<buttons_total; i++)
         m_buttons[i].Update();
      //---
      return;
     }
//--- Apply
   for(int i=0; i<buttons_total; i++)
      m_buttons[i].Update();
  }
//+------------------------------------------------------------------+
//| Pressing a button in a group                                     |
//+------------------------------------------------------------------+
bool CButtonsGroup::OnClickButton(const string pressed_object,const int id,const int index)
  {
//--- Leave, if the pressing was on this control
   if(!CElementBase::CheckElementName(pressed_object))
      return(false);
//--- Leave, if (1) the identifiers do not match or (2) the control is locked
   if(id!=CElementBase::Id() || CElementBase::IsLocked())
      return(false);
//--- If this button is already pressed
   if(index==m_selected_button_index)
     {
      //--- Toggle the button state
      SelectButton(m_selected_button_index,false);
      return(true);
     }
//---
   int check_index=WRONG_VALUE;
//--- Check, if the pressing was on one of the buttons of this group
   int buttons_total=ButtonsTotal();
//--- If the pressing took place, store the index
   for(int i=0; i<buttons_total; i++)
     {
      if(m_buttons[i].Index()==index)
        {
         check_index=i;
         break;
        }
     }
//--- Leave, if the button of this group was not pressed
   if(check_index==WRONG_VALUE)
      return(false);
//--- Toggle the button state
   SelectButton(check_index,false);
   Update(true);
//--- Send a message about it
   ::EventChartCustom(m_chart_id,ON_CLICK_GROUP_BUTTON,CElementBase::Id(),m_selected_button_index,m_selected_button_text);
   return(true);
  }
//+------------------------------------------------------------------+
//| Draws the control                                                |
//+------------------------------------------------------------------+
void CButtonsGroup::Draw(void)
  {
   int buttons_total=ButtonsTotal();
   for(int i=0; i<buttons_total; i++)
      m_buttons[i].Draw();
  }
//+------------------------------------------------------------------+
