//+------------------------------------------------------------------+
//|                                                   MainWindow.mqh |
//|                        Copyright 2016, MetaQuotes Software Corp. |
//|                                              http://www.mql5.com |
//+------------------------------------------------------------------+
#include "Program.mqh"
//+------------------------------------------------------------------+
//| Creates a form for controls                                      |
//+------------------------------------------------------------------+
bool CProgram::CreateWindow(const string caption_text)
  {
//--- Add the window pointer to the window array
   CWndContainer::AddWindow(m_window);
//--- Coordinates
   int x=(m_window.X()>0) ? m_window.X() : 1;
   int y=(m_window.Y()>0) ? m_window.Y() : 1;
//--- Properties
   m_window.XSize(518);
   m_window.YSize(600);
   m_window.Alpha(200);
   m_window.IconXGap(3);
   m_window.IconYGap(2);
   m_window.IsMovable(true);
   m_window.ResizeMode(true);
   m_window.CloseButtonIsUsed(true);
   m_window.FullscreenButtonIsUsed(true);
   m_window.CollapseButtonIsUsed(true);
   m_window.TooltipsButtonIsUsed(true);
   m_window.RollUpSubwindowMode(true,true);
   m_window.TransparentOnlyCaption(true);
//--- Set the tooltips
   m_window.GetCloseButtonPointer().Tooltip("Close");
   m_window.GetFullscreenButtonPointer().Tooltip("Fullscreen/Minimize");
   m_window.GetCollapseButtonPointer().Tooltip("Collapse/Expand");
   m_window.GetTooltipButtonPointer().Tooltip("Tooltips");
//--- Creating a form
   if(!m_window.CreateWindow(m_chart_id,m_subwin,caption_text,x,y))
      return(false);
//---
   return(true);
  }
//+------------------------------------------------------------------+
//| Creates the status bar                                           |
//+------------------------------------------------------------------+
#resource "\\Images\\EasyAndFastGUI\\Icons\\bmp16\\server_off_1.bmp"
#resource "\\Images\\EasyAndFastGUI\\Icons\\bmp16\\server_off_2.bmp"
#resource "\\Images\\EasyAndFastGUI\\Icons\\bmp16\\server_off_3.bmp"
#resource "\\Images\\EasyAndFastGUI\\Icons\\bmp16\\server_off_4.bmp"
//---
bool CProgram::CreateStatusBar(const int x_gap,const int y_gap)
  {
#define STATUS_LABELS_TOTAL 2
//--- Store the pointer to the main control
   m_status_bar.MainPointer(m_window);
//--- Width
   int width[]={0,130};
//--- Properties
   m_status_bar.YSize(22);
   m_status_bar.AutoXResizeMode(true);
   m_status_bar.AutoXResizeRightOffset(1);
   m_status_bar.AnchorBottomWindowSide(true);
//--- Add items
   for(int i=0; i<STATUS_LABELS_TOTAL; i++)
      m_status_bar.AddItem(width[i]);
//--- Setting the text
   m_status_bar.SetValue(0,"For Help, press F1");
   m_status_bar.SetValue(1,"Disconnected...");
//--- Setting the icons
   m_status_bar.GetItemPointer(1).LabelXGap(25);
   m_status_bar.GetItemPointer(1).AddImagesGroup(5,3);
   m_status_bar.GetItemPointer(1).AddImage(0,"Images\\EasyAndFastGUI\\Icons\\bmp16\\server_off_1.bmp");
   m_status_bar.GetItemPointer(1).AddImage(0,"Images\\EasyAndFastGUI\\Icons\\bmp16\\server_off_2.bmp");
   m_status_bar.GetItemPointer(1).AddImage(0,"Images\\EasyAndFastGUI\\Icons\\bmp16\\server_off_3.bmp");
   m_status_bar.GetItemPointer(1).AddImage(0,"Images\\EasyAndFastGUI\\Icons\\bmp16\\server_off_4.bmp");
//--- Create a control
   if(!m_status_bar.CreateStatusBar(x_gap,y_gap))
      return(false);
//--- Add the object to the common array of object groups
   CWndContainer::AddToElementsArray(0,m_status_bar);
   return(true);
  }
//+------------------------------------------------------------------+
//| Create icon 1                                                    |
//+------------------------------------------------------------------+
#resource "\\Images\\EasyAndFastGUI\\Controls\\resize_window.bmp"
//---
bool CProgram::CreatePicture1(const int x_gap,const int y_gap)
  {
//--- Store the pointer to the main control
   m_picture1.MainPointer(m_status_bar);
//--- Properties
   m_picture1.XSize(8);
   m_picture1.YSize(8);
   m_picture1.IconFile("Images\\EasyAndFastGUI\\Controls\\resize_window.bmp");
   m_picture1.AnchorRightWindowSide(true);
   m_picture1.AnchorBottomWindowSide(true);
//--- Creating the button
   if(!m_picture1.CreatePicture(x_gap,y_gap))
      return(false);
//--- Add the pointer to control to the base
   CWndContainer::AddToElementsArray(0,m_picture1);
   return(true);
  }
//+------------------------------------------------------------------+
//| Create the "A inc" edit box                                      |
//+------------------------------------------------------------------+
bool CProgram::CreateSpinEditAInc(const int x_gap,const int y_gap,const string text)
  {
//--- Store the pointer to the main control
   m_a_inc.MainPointer(m_window);
//--- Properties
   m_a_inc.XSize(90);
   m_a_inc.MaxValue(1000);
   m_a_inc.MinValue(1);
   m_a_inc.StepValue(0.01);
   m_a_inc.SetDigits(2);
   m_a_inc.SpinEditMode(true);
   m_a_inc.SetValue((string)2);
   m_a_inc.GetTextBoxPointer().XSize(70);
   m_a_inc.GetTextBoxPointer().AutoSelectionMode(true);
   m_a_inc.GetTextBoxPointer().AnchorRightWindowSide(true);
//--- Create a control
   if(!m_a_inc.CreateTextEdit(text,x_gap,y_gap))
      return(false);
//--- Add the object to the common array of object groups
   CWndContainer::AddToElementsArray(0,m_a_inc);
   return(true);
  }
//+------------------------------------------------------------------+
//| Create the "B inc" edit box                                      |
//+------------------------------------------------------------------+
bool CProgram::CreateSpinEditBInc(const int x_gap,const int y_gap,const string text)
  {
//--- Store the pointer to the main control
   m_b_inc.MainPointer(m_window);
//--- Properties
   m_b_inc.XSize(90);
   m_b_inc.MaxValue(1000);
   m_b_inc.MinValue(1);
   m_b_inc.StepValue(0.01);
   m_b_inc.SetDigits(2);
   m_b_inc.SpinEditMode(true);
   m_b_inc.SetValue((string)0);
   m_b_inc.GetTextBoxPointer().XSize(70);
   m_b_inc.GetTextBoxPointer().AutoSelectionMode(true);
   m_b_inc.GetTextBoxPointer().AnchorRightWindowSide(true);
//--- Create a control
   if(!m_b_inc.CreateTextEdit(text,x_gap,y_gap))
      return(false);
//--- Add the object to the common array of object groups
   CWndContainer::AddToElementsArray(0,m_b_inc);
   return(true);
  }
//+------------------------------------------------------------------+
//| Create the "T inc" edit box                                      |
//+------------------------------------------------------------------+
bool CProgram::CreateSpinEditTInc(const int x_gap,const int y_gap,const string text)
  {
//--- Store the pointer to the main control
   m_t_inc.MainPointer(m_window);
//--- Properties
   m_t_inc.XSize(90);
   m_t_inc.MaxValue(1000);
   m_t_inc.MinValue(1);
   m_t_inc.StepValue(0.01);
   m_t_inc.SetDigits(2);
   m_t_inc.SpinEditMode(true);
   m_t_inc.SetValue((string)1);
   m_t_inc.GetTextBoxPointer().XSize(70);
   m_t_inc.GetTextBoxPointer().AutoSelectionMode(true);
   m_t_inc.GetTextBoxPointer().AnchorRightWindowSide(true);
//--- Create a control
   if(!m_t_inc.CreateTextEdit(text,x_gap,y_gap))
      return(false);
//--- Add the object to the common array of object groups
   CWndContainer::AddToElementsArray(0,m_t_inc);
   return(true);
  }
//+------------------------------------------------------------------+
//| Creates a separation line                                        |
//+------------------------------------------------------------------+
bool CProgram::CreateSepLine1(const int x_gap,const int y_gap)
  {
//--- Store the window pointer
   m_sep_line1.MainPointer(m_window);
//--- Size
   int x_size=2;
   int y_size=72;
//--- Properties
   m_sep_line1.DarkColor(C'150,150,150');
   m_sep_line1.LightColor(clrWhite);
   m_sep_line1.TypeSepLine(V_SEP_LINE);
//--- Create control
   if(!m_sep_line1.CreateSeparateLine(x_gap,y_gap,x_size,y_size))
      return(false);
//--- Add the pointer to control to the base
   CWndContainer::AddToElementsArray(0,m_sep_line1);
   return(true);
  }
//+------------------------------------------------------------------+
//| Create the "Animate" edit box                                    |
//+------------------------------------------------------------------+
bool CProgram::CreateCheckBoxEditAnimate(const int x_gap,const int y_gap,const string text)
  {
//--- Store the pointer to the main control
   m_animate.MainPointer(m_window);
//--- Properties
   m_animate.XSize(140);
   m_animate.MaxValue(1);
   m_animate.MinValue(0);
   m_animate.StepValue(0.01);
   m_animate.SetDigits(2);
   m_animate.CheckBoxMode(true);
   m_animate.SpinEditMode(true);
   m_animate.SetValue((string)0);
   m_animate.GetTextBoxPointer().XSize(70);
   m_animate.GetTextBoxPointer().AutoSelectionMode(true);
   m_animate.GetTextBoxPointer().AnchorRightWindowSide(true);
//--- Create a control
   if(!m_animate.CreateTextEdit(text,x_gap,y_gap))
      return(false);
//--- Add the object to the common array of object groups
   CWndContainer::AddToElementsArray(0,m_animate);
   return(true);
  }
//+------------------------------------------------------------------+
//| Create the "Array size" edit box                                 |
//+------------------------------------------------------------------+
bool CProgram::CreateSpinEditArraySize(const int x_gap,const int y_gap,const string text)
  {
//--- Store the pointer to the main control
   m_array_size.MainPointer(m_window);
//--- Properties
   m_array_size.XSize(140);
   m_array_size.MaxValue(10000);
   m_array_size.MinValue(3);
   m_array_size.StepValue(1);
   m_array_size.SetDigits(0);
   m_array_size.SpinEditMode(true);
   m_array_size.SetValue((string)100);
   m_array_size.GetTextBoxPointer().XSize(70);
   m_array_size.GetTextBoxPointer().AutoSelectionMode(true);
   m_array_size.GetTextBoxPointer().AnchorRightWindowSide(true);
//--- Create a control
   if(!m_array_size.CreateTextEdit(text,x_gap,y_gap))
      return(false);
//--- Add the object to the common array of object groups
   CWndContainer::AddToElementsArray(0,m_array_size);
   return(true);
  }
//+------------------------------------------------------------------+
//| Create the "Random" button                                       |
//+------------------------------------------------------------------+
bool CProgram::CreateButtonRandom(const int x_gap,const int y_gap,const string text)
  {
//--- Store the pointer to the main control
   m_random.MainPointer(m_window);
//--- Properties
   m_random.XSize(140);
   m_random.YSize(20);
   m_random.IconXGap(3);
   m_random.IconYGap(3);
   m_random.IsCenterText(true);
//--- Create a control
   if(!m_random.CreateButton(text,x_gap,y_gap))
      return(false);
//--- Add the pointer to control to the base
   CWndContainer::AddToElementsArray(0,m_random);
   return(true);
  }
//+------------------------------------------------------------------+
//| Creates a separation line                                        |
//+------------------------------------------------------------------+
bool CProgram::CreateSepLine2(const int x_gap,const int y_gap)
  {
//--- Store the window pointer
   m_sep_line2.MainPointer(m_window);
//--- Size
   int x_size=2;
   int y_size=72;
//--- Properties
   m_sep_line2.DarkColor(C'150,150,150');
   m_sep_line2.LightColor(clrWhite);
   m_sep_line2.TypeSepLine(V_SEP_LINE);
//--- Create control
   if(!m_sep_line2.CreateSeparateLine(x_gap,y_gap,x_size,y_size))
      return(false);
//--- Add the pointer to control to the base
   CWndContainer::AddToElementsArray(0,m_sep_line2);
   return(true);
  }
//+------------------------------------------------------------------+
//| Create the "Line smooth" checkbox                                |
//+------------------------------------------------------------------+
bool CProgram::CreateCheckBoxLineSmooth(const int x_gap,const int y_gap,const string text)
  {
//--- Store the pointer to the main control
   m_line_smooth.MainPointer(m_window);
//--- Set properties before creation
   m_line_smooth.XSize(90);
   m_line_smooth.YSize(14);
   m_line_smooth.IsPressed(false);
//--- Create a control
   if(!m_line_smooth.CreateCheckBox(text,x_gap,y_gap))
      return(false);
//--- Add the object to the common array of object groups
   CWndContainer::AddToElementsArray(0,m_line_smooth);
   return(true);
  }
//+------------------------------------------------------------------+
//| Create the "Curve type" combo box                                |
//+------------------------------------------------------------------+
bool CProgram::CreateComboBoxCurveType(const int x_gap,const int y_gap,const string text)
  {
#define ROWS3_TOTAL 5
//--- Store the pointer to the main control
   m_curve_type.MainPointer(m_window);
//--- Properties
   m_curve_type.XSize(215);
   m_curve_type.ItemsTotal(ROWS3_TOTAL);
   m_curve_type.GetButtonPointer().XSize(150);
   m_curve_type.GetButtonPointer().AnchorRightWindowSide(true);
//--- Array of the chart line types
   string array[]={"CURVE_POINTS","CURVE_LINES","CURVE_POINTS_AND_LINES","CURVE_STEPS","CURVE_HISTOGRAM"};
//--- Populate the combo box list
   for(int i=0; i<ROWS3_TOTAL; i++)
      m_curve_type.SetValue(i,array[i]);
//--- List properties
   CListView *lv=m_curve_type.GetListViewPointer();
   lv.LightsHover(true);
   lv.SelectItem(lv.SelectedItemIndex()==WRONG_VALUE ? 1 : lv.SelectedItemIndex());
//--- Create a control
   if(!m_curve_type.CreateComboBox(text,x_gap,y_gap))
      return(false);
//--- Add the object to the common array of object groups
   CWndContainer::AddToElementsArray(0,m_curve_type);
   return(true);
  }
//+------------------------------------------------------------------+
//| Create the "Point type" combo box                                |
//+------------------------------------------------------------------+
bool CProgram::CreateComboBoxPointType(const int x_gap,const int y_gap,const string text)
  {
#define ROWS4_TOTAL 10
//--- Store the pointer to the main control
   m_point_type.MainPointer(m_window);
//--- Properties
   m_point_type.XSize(215);
   m_point_type.ItemsTotal(ROWS4_TOTAL);
   m_point_type.GetButtonPointer().XSize(150);
   m_point_type.GetButtonPointer().AnchorRightWindowSide(true);
//--- Array of the chart point types
   string array[]=
     {
      "POINT_CIRCLE","POINT_SQUARE","POINT_DIAMOND","POINT_TRIANGLE","POINT_TRIANGLE_DOWN",
      "POINT_X_CROSS","POINT_PLUS","POINT_STAR","POINT_HORIZONTAL_DASH","POINT_VERTICAL_DASH"
     };
//--- Populate the combo box list
   for(int i=0; i<ROWS4_TOTAL; i++)
      m_point_type.SetValue(i,array[i]);
//--- List properties
   CListView *lv=m_point_type.GetListViewPointer();
   lv.YSize(183);
   lv.LightsHover(true);
   lv.SelectItem(lv.SelectedItemIndex()==WRONG_VALUE ? 0 : lv.SelectedItemIndex());
//--- Create a control
   if(!m_point_type.CreateComboBox(text,x_gap,y_gap))
      return(false);
//--- Add the object to the common array of object groups
   CWndContainer::AddToElementsArray(0,m_point_type);
   return(true);
  }
//+------------------------------------------------------------------+
//| Create chart 1                                                   |
//+------------------------------------------------------------------+
bool CProgram::CreateGraph1(const int x_gap,const int y_gap)
  {
//--- Store the pointer to the main control
   m_graph1.MainPointer(m_window);
//--- Properties of the control
   m_graph1.AutoXResizeMode(true);
   m_graph1.AutoYResizeMode(true);
   m_graph1.AutoXResizeRightOffset(2);
   m_graph1.AutoYResizeBottomOffset(23);
//--- Create control
   if(!m_graph1.CreateGraph(x_gap,y_gap))
      return(false);
//--- Chart properties
   CGraphic *graph=m_graph1.GetGraphicPointer();
   graph.BackgroundColor(::ColorToARGB(clrWhiteSmoke));
   graph.HistoryNameWidth(0);
//--- Properties of the X axis
   CAxis *x_axis=graph.XAxis();
   x_axis.AutoScale(false);
   x_axis.DefaultStep(0.5);
   x_axis.Max(3.5);
   x_axis.Min(-3.5);
//--- Properties of the Y axis
   CAxis *y_axis=graph.YAxis();
   y_axis.ValuesWidth(30);
   y_axis.AutoScale(false);
   y_axis.DefaultStep(0.5);
   y_axis.Max(3.5);
   y_axis.Min(-3.5);
//--- Initialize the arrays
   InitArrays();
//--- Create a curve
   CCurve *curve1=graph.CurveAdd(x_norm,y_norm,::ColorToARGB(clrCornflowerBlue),CURVE_LINES);
//--- Plot the data on the chart
   graph.CurvePlotAll();
//--- Output text
   TextAdd();
//--- Add the pointer to control to the base
   CWndContainer::AddToElementsArray(0,m_graph1);
   return(true);
  }
//+------------------------------------------------------------------+
//| Resize the arrays                                                |
//+------------------------------------------------------------------+
void CProgram::ResizeArrays(void)
  {
   int array_size =::ArraySize(x_norm);
   int new_size   =(int)m_array_size.GetValue();
//--- Leave, if the size has not changed
   if(array_size==new_size)
      return;
//--- Set the new size
   ::ArrayResize(a_inc,new_size);
   ::ArrayResize(b_inc,new_size);
   ::ArrayResize(t_inc,new_size);
   ::ArrayResize(x_source,new_size);
   ::ArrayResize(y_source,new_size);
   ::ArrayResize(x_norm,new_size);
   ::ArrayResize(y_norm,new_size);
  }
//+------------------------------------------------------------------+
//| Initialization of arrays                                         |
//+------------------------------------------------------------------+
void CProgram::InitArrays(void)
  {
//--- Resize the arrays
   ResizeArrays();
//--- Calculate the values using formulas
   int total=(int)m_array_size.GetValue();
   for(int i=0; i<total; i++)
     {
      if(i<1)
        {
         a_inc[i] =1+(double)m_animate.GetValue();
         b_inc[i] =1+(double)m_animate.GetValue();
         t_inc[i] =1+(double)m_animate.GetValue();
        }
      else
        {
         a_inc[i] =a_inc[i-1]+(double)m_a_inc.GetValue();
         b_inc[i] =b_inc[i-1]+(double)m_b_inc.GetValue();
         t_inc[i] =t_inc[i-1]+(double)m_t_inc.GetValue();
        }
      //---
      double a=a_inc[i];
      double b=b_inc[i];
      double t=t_inc[i];
      //---
      x_source[i] =(a-b)*cos(t)+b*cos((a/b-1)*t);
      y_source[i] =(a-b)*sin(t)+b*sin((a/b-1)*t);
     }
//--- Calculate the mean
   x_mean=MathMean(x_source);
   y_mean=MathMean(y_source);
//--- Calculate the standard deviation
   x_sdev=MathStandardDeviation(x_source);
   y_sdev=MathStandardDeviation(y_source);
//--- Adjustment to void division by zero
   x_sdev =(x_sdev==0)? 1 : x_sdev;
   y_sdev =(y_sdev==0)? 1 : y_sdev;
//--- Normalize the data
   for(int i=0; i<total; i++)
     {
      x_norm[i] =(x_source[i]-x_mean)/x_sdev;
      y_norm[i] =(y_source[i]-y_mean)/y_sdev;
     }
  }
//+------------------------------------------------------------------+
//| Set and update series on the chart                               |
//+------------------------------------------------------------------+
void CProgram::UpdateSeries(void)
  {
//--- Get the pointer to the chart
   CGraphic *graph=m_graph1.GetGraphicPointer();
//--- Update all series of the chart
   int total=graph.CurvesTotal();
   if(total>0)
     {
      //--- Get the curve pointer
      CCurve *curve=graph.CurveGetByIndex(0);
      //--- Set the data arrays
      curve.Update(x_norm,y_norm);
      //--- Ger the values of the curve properties
      ENUM_CURVE_TYPE curve_type =(ENUM_CURVE_TYPE)m_curve_type.GetListViewPointer().SelectedItemIndex();
      ENUM_POINT_TYPE point_type =(ENUM_POINT_TYPE)m_point_type.GetListViewPointer().SelectedItemIndex();
      //--- Set the properties
      curve.LinesSmooth(m_line_smooth.IsPressed());
      curve.PointsType(point_type);
      curve.Type(curve_type);
     }
//--- Apply 
   graph.Redraw(true);
//--- Output text
   TextAdd();
//--- Refresh the chart
   graph.Update();
  }
//+------------------------------------------------------------------+
//| Recalculate the series on the chart                              |
//+------------------------------------------------------------------+
void CProgram::RecalculatingSeries(void)
  {
//--- Calculate the values and initialize the arrays
   InitArrays();
//--- Update the series
   UpdateSeries();
  }
//+------------------------------------------------------------------+
//| Add text to the chart                                            |
//+------------------------------------------------------------------+
void CProgram::TextAdd(void)
  {
//--- Get the pointer to the chart
   CGraphic *graph=m_graph1.GetGraphicPointer();
//---  
   int  x     =graph.ScaleX(graph.XAxis().Min())+50;
   int  y     =graph.ScaleY(graph.YAxis().Max())+10;
   int  y2    =y+20;
   uint clr   =::ColorToARGB(clrBlack);
   uint align =TA_RIGHT;
//---
   string str[8];
   str[0] ="x mean:";
   str[1] ="y mean:";
   str[2] =::DoubleToString(x_mean,2);
   str[3] =::DoubleToString(y_mean,2);
   str[4] ="x sdev:";
   str[5] ="y sdev:";
   str[6] =::DoubleToString(x_sdev,2);
   str[7] =::DoubleToString(y_sdev,2);
//--- Calculate the coordinates and output the text on the chart
   int l_x=0,l_y=0;
   for(int i=0; i<8; i++)
     {
      if(i<2)
         l_x=x;
      else if(i<6)
         l_x=(i%2==0)? l_x+50 : l_x;
      else
         l_x=(i%2==0)? l_x+60 : l_x;
      //---
      l_y=(i%2==0)? y : y2;
      //---
      graph.TextAdd(l_x,l_y,str[i],clr,align);
     }
  }
//+------------------------------------------------------------------+
//| Update the chart by timer                                        |
//+------------------------------------------------------------------+
void CProgram::UpdateGraphByTimer(void)
  {
//--- Leave, if (1) the form is minimized or (2) animation is disabled
   if(m_window.IsMinimized() || !m_animate.IsPressed())
      return;
//--- Animate the chart series
   AnimateGraphSeries();
//--- Update arrays and series on the chart
   RecalculatingSeries();
  }
//+------------------------------------------------------------------+
//| Animate the chart series                                         |
//+------------------------------------------------------------------+
void CProgram::AnimateGraphSeries(void)
  {
//--- To specify the direction to resize the arrays
   static bool counter_direction=false;
//--- Switch the direction if the minimum has been reached
   if((double)m_animate.GetValue()<=(double)m_animate.MinValue())
      counter_direction=false;
//--- Switch the direction if the maximum has been reached
   if((double)m_animate.GetValue()>=(double)m_animate.MaxValue())
      counter_direction=true;
//--- Resize the array in the specified direction
   string value="";
   if(!counter_direction)
      value=string((double)m_animate.GetValue()+m_animate.StepValue());
   else
      value=string((double)m_animate.GetValue()-m_animate.StepValue());
//--- Set the new value and update the text box
   m_animate.SetValue(value,false);
   m_animate.GetTextBoxPointer().Update(true);
  }
//+------------------------------------------------------------------+
