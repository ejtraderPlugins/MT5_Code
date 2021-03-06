//+------------------------------------------------------------------+
//|                                         EventChartConsoleAdd.mqh |
//|                                 Copyright 2015, Vasiliy Sokolov. |
//|                                              http://www.mql5.com |
//+------------------------------------------------------------------+
#property copyright "Copyright 2015, Vasiliy Sokolov."
#property link      "http://www.mql5.com"
//+------------------------------------------------------------------+
//|                                        EventChartPBarChanged.mqh |
//|                                 Copyright 2015, Vasiliy Sokolov. |
//|                                              http://www.mql5.com |
//+------------------------------------------------------------------+
#property copyright "Copyright 2015, Vasiliy Sokolov."
#property link      "http://www.mql5.com"
#property version   "1.00"
#include "Event.mqh"
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
class CEventCharConsoleChLast : public CEvent
  {
private:
   int               m_console_id;           //
   string            m_message;              //
public:
                     CEventCharConsoleChLast(int progress_bar_id,string message);
   int               ConsoleID(void);
   string            Message(void);
  };
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
CEventCharConsoleChLast::CEventCharConsoleChLast(int console_id,string message) : CEvent(EVENT_CHART_CONSOLE_CHLAST)
  {
   m_console_id=console_id;
   m_message=message;
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
int CEventCharConsoleChLast::ConsoleID(void)
  {
   return m_console_id;
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
string CEventCharConsoleChLast::Message(void)
  {
   return m_message;
  }
//+------------------------------------------------------------------+
