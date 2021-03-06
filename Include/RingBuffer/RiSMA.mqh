//+------------------------------------------------------------------+
//|                                                   RingBuffer.mqh |
//|                                 Copyright 2016, Vasiliy Sokolov. |
//|                                              http://www.mql5.com |
//+------------------------------------------------------------------+
#property copyright "Copyright 2016, Vasiliy Sokolov."
#property link      "http://www.mql5.com"
#include "RiBuffDbl.mqh"
//+------------------------------------------------------------------+
//| Calculate moving average in the ring buffer                      |
//+------------------------------------------------------------------+
class CRiSMA : public CRiBuffDbl
{
private:
   double        m_sum;
protected:
   virtual void  OnAddValue(double value);
   virtual void  OnRemoveValue(double value);
   virtual void  OnChangeValue(int index, double del_value, double new_value);
public:
                 CRiSMA(void);
   
   double        SMA(void);
};

CRiSMA::CRiSMA(void) : m_sum(0.0)
{
}
//+------------------------------------------------------------------+
//| Increase the total sum                                           |
//+------------------------------------------------------------------+
void CRiSMA::OnAddValue(double value)
{
   m_sum += value;
}
//+------------------------------------------------------------------+
//| Decrease the total sum                                           |
//+------------------------------------------------------------------+
void CRiSMA::OnRemoveValue(double value)
{
   m_sum -= value;
}
//+------------------------------------------------------------------+
//| Change the total sum                                             |
//+------------------------------------------------------------------+
void CRiSMA::OnChangeValue(int index,double del_value,double new_value)
{
   m_sum -= del_value;
   m_sum += new_value;
}
//+------------------------------------------------------------------+
//| Get the simple moving average                                    |
//+------------------------------------------------------------------+
double CRiSMA::SMA(void)
{
   return m_sum/GetTotal();
}