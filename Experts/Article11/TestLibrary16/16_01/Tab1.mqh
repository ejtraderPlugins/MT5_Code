//+------------------------------------------------------------------+
//|                                                         Tab1.mqh |
//|                        Copyright 2017, MetaQuotes Software Corp. |
//|                                              http://www.mql5.com |
//+------------------------------------------------------------------+
#include "Program.mqh"
//+------------------------------------------------------------------+
//| Create button to call the color picker 1                         |
//+------------------------------------------------------------------+
bool CProgram::CreateBackColor(const int x_gap,const int y_gap,const string text)
  {
//--- Store the pointer to the main control
   m_back_color.MainPointer(m_tabs1);
//--- Attach to tab
   m_tabs1.AddToElementsArray(0,m_back_color);
//--- Properties
   m_back_color.XSize(190);
   m_back_color.YSize(20);
   m_back_color.IconYGap(2);
   m_back_color.CurrentColor(clrWhiteSmoke);
   m_back_color.GetButtonPointer().XSize(95);
   m_back_color.GetButtonPointer().AnchorRightWindowSide(true);
//--- Create control
   if(!m_back_color.CreateColorButton(text,x_gap,y_gap))
      return(false);
//--- Add the pointer to control to the base
   CWndContainer::AddToElementsArray(0,m_back_color);
   return(true);
  }
//+------------------------------------------------------------------+
//| Create button to call the color picker 1                         |
//+------------------------------------------------------------------+
bool CProgram::CreateMainColor(const int x_gap,const int y_gap,const string text)
  {
//--- Store the pointer to the main control
   m_back_main_color.MainPointer(m_tabs1);
//--- Attach to tab
   m_tabs1.AddToElementsArray(0,m_back_main_color);
//--- Properties
   m_back_main_color.XSize(190);
   m_back_main_color.YSize(20);
   m_back_main_color.IconYGap(2);
   m_back_main_color.CurrentColor(m_graph1.GetGraphicPointer().BackgroundMainColor());
   m_back_main_color.GetButtonPointer().XSize(95);
   m_back_main_color.GetButtonPointer().AnchorRightWindowSide(true);
//--- Create control
   if(!m_back_main_color.CreateColorButton(text,x_gap,y_gap))
      return(false);
//--- Add the pointer to control to the base
   CWndContainer::AddToElementsArray(0,m_back_main_color);
   return(true);
  }
//+------------------------------------------------------------------+
//| Create button to call the color picker 1                         |
//+------------------------------------------------------------------+
bool CProgram::CreateSubColor(const int x_gap,const int y_gap,const string text)
  {
//--- Store the pointer to the main control
   m_back_sub_color.MainPointer(m_tabs1);
//--- Attach to tab
   m_tabs1.AddToElementsArray(0,m_back_sub_color);
//--- Properties
   m_back_sub_color.XSize(190);
   m_back_sub_color.YSize(20);
   m_back_sub_color.IconYGap(2);
   m_back_sub_color.CurrentColor(m_graph1.GetGraphicPointer().BackgroundSubColor());
   m_back_sub_color.GetButtonPointer().XSize(95);
   m_back_sub_color.GetButtonPointer().AnchorRightWindowSide(true);
//--- Create control
   if(!m_back_sub_color.CreateColorButton(text,x_gap,y_gap))
      return(false);
//--- Add the pointer to control to the base
   CWndContainer::AddToElementsArray(0,m_back_sub_color);
   return(true);
  }
//+------------------------------------------------------------------+
//| Create the "Main text" edit box                                  |
//+------------------------------------------------------------------+
bool CProgram::CreateMainText(const int x_gap,const int y_gap,const string text)
  {
//--- Store the pointer to the main control
   m_main_text.MainPointer(m_tabs1);
//--- Attach the control to tab
   m_tabs1.AddToElementsArray(0,m_main_text);
//--- Properties
   m_main_text.XSize(150);
   m_main_text.MaxValue(10000);
   m_main_text.MinValue(3);
   m_main_text.StepValue(1);
   m_main_text.SetDigits(0);
   m_main_text.GetTextBoxPointer().XSize(90);
   m_main_text.GetTextBoxPointer().AutoSelectionMode(true);
   m_main_text.GetTextBoxPointer().AnchorRightWindowSide(true);
   m_main_text.GetTextBoxPointer().DefaultText("Enter text");
//--- Create a control
   if(!m_main_text.CreateTextEdit(text,x_gap,y_gap))
      return(false);
//--- Add the object to the common array of object groups
   CWndContainer::AddToElementsArray(0,m_main_text);
   return(true);
  }
//+------------------------------------------------------------------+
//| Create the "Sub text" edit box                                   |
//+------------------------------------------------------------------+
bool CProgram::CreateSubText(const int x_gap,const int y_gap,const string text)
  {
//--- Store the pointer to the main control
   m_sub_text.MainPointer(m_tabs1);
//--- Attach the control to tab
   m_tabs1.AddToElementsArray(0,m_sub_text);
//--- Properties
   m_sub_text.XSize(150);
   m_sub_text.MaxValue(10000);
   m_sub_text.MinValue(3);
   m_sub_text.StepValue(1);
   m_sub_text.SetDigits(0);
   m_sub_text.GetTextBoxPointer().XSize(90);
   m_sub_text.GetTextBoxPointer().AutoSelectionMode(true);
   m_sub_text.GetTextBoxPointer().AnchorRightWindowSide(true);
   m_sub_text.GetTextBoxPointer().DefaultText("Enter text");
//--- Create a control
   if(!m_sub_text.CreateTextEdit(text,x_gap,y_gap))
      return(false);
//--- Add the object to the common array of object groups
   CWndContainer::AddToElementsArray(0,m_sub_text);
   return(true);
  }
//+------------------------------------------------------------------+
//| Create the "Main size" edit box                                  |
//+------------------------------------------------------------------+
bool CProgram::CreateFontMainSize(const int x_gap,const int y_gap,const string text)
  {
//--- Store the pointer to the main control
   m_font_main_size.MainPointer(m_tabs1);
//--- Attach the control to tab
   m_tabs1.AddToElementsArray(0,m_font_main_size);
//--- Properties
   m_font_main_size.XSize(110);
   m_font_main_size.MaxValue(10000);
   m_font_main_size.MinValue(3);
   m_font_main_size.StepValue(1);
   m_font_main_size.SetDigits(0);
   m_font_main_size.SpinEditMode(true);
   m_font_main_size.SetValue((string)24);
   m_font_main_size.GetTextBoxPointer().XSize(50);
   m_font_main_size.GetTextBoxPointer().AutoSelectionMode(true);
   m_font_main_size.GetTextBoxPointer().AnchorRightWindowSide(true);
//--- Create a control
   if(!m_font_main_size.CreateTextEdit(text,x_gap,y_gap))
      return(false);
//--- Add the object to the common array of object groups
   CWndContainer::AddToElementsArray(0,m_font_main_size);
   return(true);
  }
//+------------------------------------------------------------------+
//| Create the "Sub size" edit box                                   |
//+------------------------------------------------------------------+
bool CProgram::CreateFontSubSize(const int x_gap,const int y_gap,const string text)
  {
//--- Store the pointer to the main control
   m_font_sub_size.MainPointer(m_tabs1);
//--- Attach the control to tab
   m_tabs1.AddToElementsArray(0,m_font_sub_size);
//--- Properties
   m_font_sub_size.XSize(110);
   m_font_sub_size.MaxValue(10000);
   m_font_sub_size.MinValue(3);
   m_font_sub_size.StepValue(1);
   m_font_sub_size.SetDigits(0);
   m_font_sub_size.SpinEditMode(true);
   m_font_sub_size.SetValue((string)16);
   m_font_sub_size.GetTextBoxPointer().XSize(50);
   m_font_sub_size.GetTextBoxPointer().AutoSelectionMode(true);
   m_font_sub_size.GetTextBoxPointer().AnchorRightWindowSide(true);
//--- Create a control
   if(!m_font_sub_size.CreateTextEdit(text,x_gap,y_gap))
      return(false);
//--- Add the object to the common array of object groups
   CWndContainer::AddToElementsArray(0,m_font_sub_size);
   return(true);
  }
//+------------------------------------------------------------------+
