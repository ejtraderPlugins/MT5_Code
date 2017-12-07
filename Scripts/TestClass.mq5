//+------------------------------------------------------------------+
//|                                                    TestClass.mq5 |
//|                                                       chizhijing |
//|                                             https://www.mql5.com |
//+------------------------------------------------------------------+
#property copyright "chizhijing"
#property link      "https://www.mql5.com"
#property version   "1.00"
//+------------------------------------------------------------------+
//| Script program start function                                    |
//+------------------------------------------------------------------+
void OnStart()
  {
//---
   Shape *s[10];
   template
   RecShape *temp=new RecShape();
   Cicle *temp2=
   s[0]=temp;
  }
//+------------------------------------------------------------------+
class Shape
   {
      protected:
         double Area;
      public:
      virtual void cal_area();
      double GetArea(void){return Area;};
   };
class RecShape:Shape
   {
      private:
         double x;
         double y;
      public:
         RecShape(void){x=3;y=3;};
         virtual void cal_area(){Area=x*y;}
   };
class Cirle:Shape
   {
      private:
       double r;
       public:
         Cirle(void){r=1/3.141592654;};
         virtual void cal_area(){Area=3.141592654*r;};
   };   