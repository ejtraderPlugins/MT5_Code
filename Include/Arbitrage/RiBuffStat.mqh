//+------------------------------------------------------------------+
//|                                                   RiBuffStat.mqh |
//|                                                       chizhijing |
//|                                             https://www.mql5.com |
//+------------------------------------------------------------------+
#property copyright "chizhijing"
#property link      "https://www.mql5.com"

#include<RingBuffer\RiBuffDbl.mqh>

//+------------------------------------------------------------------+
//|    缓冲区统计量计算                                              |
//+------------------------------------------------------------------+
class CRiBuffStats:public CRiBuffDbl
  {
private:
   double            sum_x;
   double            sum_x2;
protected:
   virtual void      OnAddValue(double value);
   virtual void      OnRemoveValue(double value);
   virtual void      OnChangeValue(int index,double del_value,double new_value);
public:
                     CRiBuffStats(void);
                     CRiBuffStats(const CRiBuffStats& obj);
   double            Mu(void);
   double            Sigma(void);
   CRiBuffStats      Copy(void);

  };

//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
CRiBuffStats::CRiBuffStats(void)
  {
   sum_x=0.0;
   sum_x2=0.0;
   ma=0;
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
CRiBuffStats::OnAddValue(double value)
  {
   sum_x+=value;
   sum_x2+=value*value;
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
CRiBuffStats::OnRemoveValue(double value)
  {
   sum_x-=value;
   sum_x2-=value*value;
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
CRiBuffStats::OnChangeValue(int index,double del_value,double new_value)
  {
   sum_x-=del_value;
   sum_x2-=del_value*del_value;
   sum_x+=new_value;
   sum_x2+=new_value*new_value;
  }
  
CRiBuffStats::CRiBuffStats(const CRiBuffStats &obj):CRiBuffDbl(obj)
   {
    sum_x=obj.sum_x;
    sum_x2=obj.sum_x2;
   }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
double CRiBuffStats::Mu(void)
  {
   return sum_x/GetTotal();
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
double CRiBuffStats::Sigma(void)
  {
   return MathPow(sum_x2/GetTotal()-MathPow((sum_x/GetTotal()),2),0.5);
  }