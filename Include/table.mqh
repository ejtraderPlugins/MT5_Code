//+------------------------------------------------------------------+
//|                                                        Table.mqh |
//|                                            Copyright 2010, Urain |
//|                            https://login.mql5.com/ru/users/Urain |
//+------------------------------------------------------------------+
#property copyright "Copyright 2010, Urain"
#property link      "https://login.mql5.com/ru/users/Urain"
#property version   "1.00"
//+------------------------------------------------------------------+
//| call of the file                                                 |
//| #include <Table.mqh>                                             |
//+------------------------------------------------------------------+
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
//+------------------------------------------------------------------+
//| #include <int2D.mqh>                                             |
//+------------------------------------------------------------------+
class Cint1D
  {
public:
                     Cint1D(){size=0;};
                    ~Cint1D(){};
   int               index[];
   int               size;
   void              set(int j,int ind){index[j]=ind;};
   int               get(int j){return(index[j]);};
   void              Resize(int j){size=ArrayResize(index,j);};
  };
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
class Cint2D
  {
private:
   Cint1D            index[];
public:
                     Cint2D(){Variant(0);};
                    ~Cint2D(){};
   int               variant;
   int               size_variant;
   void              Ind(int j,int ind){index[variant].set(j,ind);};
   int               Ind(int j){return(index[variant].get(j));};
   void              Variant(int ind);
   int               Variant(){return(variant);};
   void              VariantCopy(int rec,int sor){ArrayCopy(index[rec].index,index[sor].index);};
   void              ResizeIndexes(int c);
  };
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void Cint2D::Variant(int ind)
  {
   if(ind>=size_variant)
      size_variant=ArrayResize(index,ind+1);
   variant=ind;
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void  Cint2D::ResizeIndexes(int c)
  {
   for(int i=0;i<size_variant;i++)
     {
      int size=index[i].size;
      index[i].Resize(c);
      for(int j=size;j<c;j++)
        {
         index[i].set(j,j);
         int temp=index[i].get(j);
         //DebugBreak();
        }
     }
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
//+------------------------------------------------------------------+
//| call of the file                                                 |
//| #include <OneDimensionalArray.mqh>                               |
//+------------------------------------------------------------------+
//+------------------------------------------------------------------+
//| Базовый класс одномерного массива BASE                           |
//+------------------------------------------------------------------+
class CBASEArray
  {
private:
   int               accuracy;// accuracy
protected:
   virtual long      getLONG(int j){return(0);};
   virtual double    getDOUBLE(int j){return(0);};
   virtual datetime  getDATETIME(int j){return(0);};
   virtual string    getSTRING(int j){return("");};
public:
   int               second_size;
                     CBASEArray(void){};
                    ~CBASEArray(void){};
   virtual int       Resize_second(int j){Print("error "+__FUNCTION__);return(0);};
   virtual void      set(int j,long element){};
   virtual void      set(int j,double element){};
   virtual void      set(int j,datetime element){};
   virtual void      set(int j,string element){};

   virtual string    get(int j){return("");};

   virtual void      Get(int j,long &recipient){};
   virtual void      Get(int j,double &recipient){};
   virtual void      Get(int j,datetime &recipient){};
   virtual void      Get(int j,string &recipient){};

   //---
   virtual int       QuickSearch(long element,int beg,int end,Cint2D &index,bool mode=false){return(0);};
   virtual int       SearchFirst(long element,int beg,int end,Cint2D &index,bool mode=false){return(0);};
   virtual int       SearchLast(long element,int beg,int end,Cint2D &index,bool mode=false){return(0);};
   virtual int       SearchGreat(long element,int beg,int end,Cint2D &index,bool mode=false){return(0);};
   virtual int       SearchLess(long element,int beg,int end,Cint2D &index,bool mode=false){return(0);};

   //---
   virtual int       QuickSearch(double element,int beg,int end,Cint2D &index,bool mode=false){return(0);};
   virtual int       SearchFirst(double element,int beg,int end,Cint2D &index,bool mode=false){return(0);};
   virtual int       SearchLast(double element,int beg,int end,Cint2D &index,bool mode=false){return(0);};
   virtual int       SearchGreat(double element,int beg,int end,Cint2D &index,bool mode=false){return(0);};
   virtual int       SearchLess(double element,int beg,int end,Cint2D &index,bool mode=false){return(0);};

   //---
   virtual int       QuickSearch(datetime element,int beg,int end,Cint2D &index,bool mode=false){return(0);};
   virtual int       SearchFirst(datetime element,int beg,int end,Cint2D &index,bool mode=false){return(0);};
   virtual int       SearchLast(datetime element,int beg,int end,Cint2D &index,bool mode=false){return(0);};
   virtual int       SearchGreat(datetime element,int beg,int end,Cint2D &index,bool mode=false){return(0);};
   virtual int       SearchLess(datetime element,int beg,int end,Cint2D &index,bool mode=false){return(0);};

   //---
   virtual int       QuickSearch(string element,int beg,int end,Cint2D &index,bool mode=false){return(0);};
   virtual int       SearchFirst(string element,int beg,int end,Cint2D &index,bool mode=false){return(0);};
   virtual int       SearchLast(string element,int beg,int end,Cint2D &index,bool mode=false){return(0);};
   virtual int       SearchGreat(string element,int beg,int end,Cint2D &index,bool mode=false){return(0);};
   virtual int       SearchLess(string element,int beg,int end,Cint2D &index,bool mode=false){return(0);};

   virtual void      Digits(int digits){};
   virtual int       Digits(){return(-307);};

   virtual void      Sort(Cint2D &index,int beg,int end,bool mode=false){};
  };
//+------------------------------------------------------------------+
//| Class of unidimensional array of long values                     |
//+------------------------------------------------------------------+
class CLONGArray : public CBASEArray
  {
private:
   long              second_data[];// array-column
   void              QuickSort(long &m_data[],Cint2D &index,int beg,int end,bool mode=false);
protected:
   long              getLONG(int j){return(second_data[j]);};
public:
   int               second_size;// column size
                     CLONGArray(void){second_size=0;};
                    ~CLONGArray(void){};
   void              set(int j,long element){second_data[j]=element;};

   string            get(int j){return((string)getLONG(j));};
   void              Get(int j,long &recipient){recipient=second_data[j];};
   int               Resize_second(int j){second_size=j; return(ArrayResize(second_data,second_size));};
   int               QuickSearch(long element,int beg,int end,Cint2D &index,bool mode=false);
   int               SearchFirst(long element,int beg,int end,Cint2D &index,bool mode=false);
   int               SearchLast(long element,int beg,int end,Cint2D &index,bool mode=false);
   int               SearchGreat(long element,int beg,int end,Cint2D &index,bool mode=false);
   int               SearchLess(long element,int beg,int end,Cint2D &index,bool mode=false);
   void              Sort(Cint2D &index,int beg,int end,bool mode=false)
     {
      long m_data[];
      ArrayResize(m_data,ArraySize(second_data));
      for(int i=0;i<ArraySize(m_data);i++)
         m_data[i]=second_data[index.Ind(i)];
      QuickSort(m_data,index,beg,end,mode);
     };
  };
//+------------------------------------------------------------------+
//| Quick search of position of element in a sorted array.           |
//| INPUT:  element - search value.                                  |
//| OUTPUT: position of the found element in the array.              |
//| REMARK: no.                                                      |
//+------------------------------------------------------------------+
int CLONGArray::QuickSearch(long element,int beg,int end,Cint2D &index,bool mode=false)
  {// Quick search of position of an element in the array
   int  i=beg,j=end,m=-1; long temp;
   if(beg<0){Print("Incorrect beg "+__FUNCTION__);return(-1);}
   if(end>=second_size){Print("Incorrect end "+__FUNCTION__);return(-1);}
//--- search
   if(mode)
     {
      while(!IsStopped())
        {
         m=(j+i)>>1;
         if(m<beg || m>end || j<i)return(-1);// element is not found      
         temp=second_data[index.Ind(m)];
         if(temp==element)return(m);
         if(temp>element) j=m-1;
         else               i=m+1;
        }
     }
   else
     {
      while(!IsStopped())
        {
         m=(j+i)>>1;
         if(m<beg || m>end || j<i)return(-1);// element is not found      
         temp=second_data[index.Ind(m)];
         if(temp==element)return(m);
         if(temp<element) j=m-1;
         else             i=m+1;
        }
     }
//---
   return(m);
  }
//+------------------------------------------------------------------+
//| Find position of first appearance of element in a sorted array.  |
//| INPUT:  element - search value.                                  |
//| OUTPUT: position of the found element in the array or -1.        |
//| REMARK: no.                                                      |
//+------------------------------------------------------------------+
int CLONGArray::SearchFirst(long element,int beg,int end,Cint2D &index,bool mode=false)
  {
   int pos;
//--- checking
   if(second_size==0) return(-1);
//--- searching
   pos=QuickSearch(element,beg,end,index,mode);
   if(pos!=-1)
     {
      if(second_data[index.Ind(pos)]==element)
        {
         if(mode)
           {
            while(second_data[index.Ind(pos)]==element)
               if(pos--==beg) break;
            return(pos+1);
           }
         else
           {
            while(second_data[index.Ind(pos)]==element)
               if(--pos==beg-1) break;
            return(pos+1);
           }
        }
     }
//---
   return(-1);
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
int CLONGArray::SearchLast(long element,int beg,int end,Cint2D &index,bool mode=false)
  {
   int pos;
//--- checking
   if(second_size==0) return(-1);
//--- searching
   pos=QuickSearch(element,beg,end,index,mode);
   if(pos!=-1)
     {
      if(second_data[index.Ind(pos)]==element)
        {
         if(mode)
           {
            while(second_data[index.Ind(pos)]==element)
               if(++pos==end+1) break;
            return(pos-1);
           }
         else
           {
            while(second_data[index.Ind(pos)]==element)
               if(pos++==end) break;
            return(pos-1);
           }
        }
     }
//--- 
   return(-1);
  }
//+------------------------------------------------------------------+
//| Search position of the first element which is greater than       |
//| specified in a sorted array.                                     |
//| INPUT:  element - search value.                                  |
//| OUTPUT: position of the found element in the array or -1.        |
//| REMARK: no.                                                      |
//+------------------------------------------------------------------+
int CLONGArray::SearchGreat(long element,int beg,int end,Cint2D &index,bool mode=false)
  {
   int pos;
//--- checking
   if(second_size==0) return(-1);
//--- searching
   pos=QuickSearch(element,beg,end,index,mode);
   if(pos!=-1)
     {
      if(second_data[index.Ind(pos)]==element)
        {
         if(mode)
           {
            while(second_data[index.Ind(pos)]<=element)
               if(++pos==end+1) return(-1);
           }
         else
           {
            while(second_data[index.Ind(pos)]<=element)
               if(--pos==beg-1) return(-1);
           }
        }
     }
//--- 
   return(pos);
  }
//+------------------------------------------------------------------+
//| Search position of the first element which is less than          |
//| specified in the sorted array.                                   |
//| INPUT:  element - search value.                                  |
//| OUTPUT: position of the found element in the array or -1.        |
//| REMARK: no.                                                      |
//+------------------------------------------------------------------+
int CLONGArray::SearchLess(long element,int beg,int end,Cint2D &index,bool mode=false)
  {
   int pos;
//--- checking
   if(second_size==0) return(-1);
//--- searching
   pos=QuickSearch(element,beg,end,index,mode);
   if(pos!=-1)
     {
      if(second_data[index.Ind(pos)]>=element)
        {
         if(mode)
           {
            while(second_data[index.Ind(pos)]==element)
               if(pos--==beg) return(-1);
           }
         else
           {
            while(second_data[index.Ind(pos)]>=element)
               if(pos++==end) return(-1);
           }
        }
     }
//---
   return(pos);
  }
//+------------------------------------------------------------------+
//| Method QuickSort.                                                |
//| INPUT:  beg - start of sorting range,                            |
//|         end - end of sorting range,                              |
//|         mode - mode of sorting.                                  |
//| OUTPUT: no.                                                      |
//| REMARK: no.                                                      |
//+------------------------------------------------------------------+
void CLONGArray::QuickSort(long &m_data[],Cint2D &index,int beg,int end,bool mode=0)
  {
   long p,t; int it;
   if(beg<0 || end<0) return;
   int i=beg,j=end;
   if(mode)
     {
      while(i<end)
        {
         p=m_data[(beg+end)>>1];
         while(i<j)
           {
            while(m_data[i]<p)
              {if(i==second_size-1) break; i++;}
            while(m_data[j]>p)
              {if(j==0) break; j--;}
            if(i<=j)
              {
               t=m_data[i];            it=index.Ind(i);
               m_data[i++]=m_data[j];  index.Ind(i-1,index.Ind(j));
               m_data[j]=t;            index.Ind(j,it);
               if(j==0) break;
               else     j--;
              }
           }
         if(beg<j) QuickSort(m_data,index,beg,j,mode);
         beg=i; i=beg; j=end;
        }
     }
   else
     {
      while(i<end)
        {
         p=m_data[(beg+end)>>1];
         while(i<j)
           {
            while(m_data[i]>p)
              {if(i==second_size-1) break; i++;}
            while(m_data[j]<p)
              {if(j==0) break; j--;}
            if(i<=j)
              {
               t=m_data[i];            it=index.Ind(i);
               m_data[i++]=m_data[j];  index.Ind(i-1,index.Ind(j));
               m_data[j]=t;            index.Ind(j,it);
               if(j==0) break;
               else     j--;
              }
           }
         if(beg<j) QuickSort(m_data,index,beg,j,mode);
         beg=i; i=beg; j=end;
        }
     }
  }
//+------------------------------------------------------------------+

//+------------------------------------------------------------------+
//| Class of unidimensional array of double values                   |
//+------------------------------------------------------------------+
class CDOUBLEArray : public CBASEArray
  {
private:
   int               accuracy;// accuracy
   double            second_data[];// array-column
   void              QuickSort(double &m_data[],Cint2D &index,int beg,int end,bool mode=false);
protected:
   double            getDOUBLE(int j){return(second_data[j]);};
public:
   int               second_size;// column size
                     CDOUBLEArray(void){second_size=0;accuracy=-1;};
                    ~CDOUBLEArray(void){};
   void              set(int j,double element){second_data[j]=element;};

   string            get(int j)
     {
      if(accuracy>=0 || accuracy<=8)return(DoubleToString(getDOUBLE(j),accuracy)); 
      else return((string)getDOUBLE(j));
     };
   void              Get(int j,double &recipient){recipient=second_data[j];};
   int               Resize_second(int j){second_size=j; return(ArrayResize(second_data,second_size));};
   int               QuickSearch(double element,int beg,int end,Cint2D &index,bool mode=false);
   int               SearchFirst(double element,int beg,int end,Cint2D &index,bool mode=false);
   int               SearchLast(double element,int beg,int end,Cint2D &index,bool mode=false);
   int               SearchGreat(double element,int beg,int end,Cint2D &index,bool mode=false);
   int               SearchLess(double element,int beg,int end,Cint2D &index,bool mode=false);

   void              Digits(int digits){accuracy=digits;};
   int               Digits(){return(accuracy);};

   void              Sort(Cint2D &index,int beg,int end,bool mode=false)
     {
      double m_data[];
      ArrayResize(m_data,ArraySize(second_data));
      for(int i=0;i<ArraySize(m_data);i++)
         m_data[i]=second_data[index.Ind(i)];
      QuickSort(m_data,index,beg,end,mode);
     };
  };
//+------------------------------------------------------------------+
//| Quick search of position of element in a sorted array.           |
//| INPUT:  element - search value.                                  |
//| OUTPUT: position of the found element in the array.              |
//| REMARK: no.                                                      |
//+------------------------------------------------------------------+
int CDOUBLEArray::QuickSearch(double element,int beg,int end,Cint2D &index,bool mode=false)
  {// Quick search of position of an element in the array
   int  i=beg,j=end,m=-1; double temp;
   if(beg<0){Print("Incorrect beg "+__FUNCTION__);return(-1);}
   if(end>=second_size){Print("Incorrect end "+__FUNCTION__);return(-1);}
//--- search
   if(mode)
     {
      while(!IsStopped())
        {
         m=(j+i)>>1;
         if(m<beg || m>end || j<i)return(-1);// element is not found      
         temp=second_data[index.Ind(m)];
         if(temp==element)return(m);
         if(temp>element) j=m-1;
         else               i=m+1;
        }
     }
   else
     {
      while(!IsStopped())
        {
         m=(j+i)>>1;
         if(m<beg || m>end || j<i)return(-1);// element is not found      
         temp=second_data[index.Ind(m)];
         if(temp==element)return(m);
         if(temp<element) j=m-1;
         else             i=m+1;
        }
     }
//---
   return(m);
  }
//+------------------------------------------------------------------+
//| Find position of first appearance of element in a sorted array.  |
//| INPUT:  element - search value.                                  |
//| OUTPUT: position of the found element in the array or -1.        |
//| REMARK: no.                                                      |
//+------------------------------------------------------------------+
int CDOUBLEArray::SearchFirst(double element,int beg,int end,Cint2D &index,bool mode=false)
  {
   int pos;
//--- checking
   if(second_size==0) return(-1);
//--- searching
   pos=QuickSearch(element,beg,end,index,mode);
   if(pos!=-1)
     {
      if(second_data[index.Ind(pos)]==element)
        {
         if(mode)
           {
            while(second_data[index.Ind(pos)]==element)
               if(pos--==beg) break;
            return(pos+1);
           }
         else
           {
            while(second_data[index.Ind(pos)]==element)
               if(--pos==beg-1) break;
            return(pos+1);
           }
        }
     }
//---
   return(-1);
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
int CDOUBLEArray::SearchLast(double element,int beg,int end,Cint2D &index,bool mode=false)
  {
   int pos;
//--- checking
   if(second_size==0) return(-1);
//--- searching
   pos=QuickSearch(element,beg,end,index,mode);
   if(pos!=-1)
     {
      if(second_data[index.Ind(pos)]==element)
        {
         if(mode)
           {
            while(second_data[index.Ind(pos)]==element)
               if(++pos==end+1) break;
            return(pos-1);
           }
         else
           {
            while(second_data[index.Ind(pos)]==element)
               if(pos++==end) break;
            return(pos-1);
           }
        }
     }
//--- 
   return(-1);
  }
//+------------------------------------------------------------------+
//| Search position of the first element which is greater than       |
//| specified in a sorted array.                                     |
//| INPUT:  element - search value.                                  |
//| OUTPUT: position of the found element in the array or -1.        |
//| REMARK: no.                                                      |
//+------------------------------------------------------------------+
int CDOUBLEArray::SearchGreat(double element,int beg,int end,Cint2D &index,bool mode=false)
  {
   int pos;
//--- checking
   if(second_size==0) return(-1);
//--- searching
   pos=QuickSearch(element,beg,end,index,mode);
   if(pos!=-1)
     {
      if(second_data[index.Ind(pos)]==element)
        {
         if(mode)
           {
            while(second_data[index.Ind(pos)]<=element)
               if(++pos==end+1) return(-1);
           }
         else
           {
            while(second_data[index.Ind(pos)]<=element)
               if(--pos==beg-1) return(-1);
           }
        }
     }
//--- 
   return(pos);
  }
//+------------------------------------------------------------------+
//| Search position of the first element which is less than          |
//| specified in the sorted array.                                   |
//| INPUT:  element - search value.                                  |
//| OUTPUT: position of the found element in the array or -1.        |
//| REMARK: no.                                                      |
//+------------------------------------------------------------------+
int CDOUBLEArray::SearchLess(double element,int beg,int end,Cint2D &index,bool mode=false)
  {
   int pos;
//--- checking
   if(second_size==0) return(-1);
//--- searching
   pos=QuickSearch(element,beg,end,index,mode);
   if(pos!=-1)
     {
      if(second_data[index.Ind(pos)]>=element)
        {
         if(mode)
           {
            while(second_data[index.Ind(pos)]==element)
               if(pos--==beg) return(-1);
           }
         else
           {
            while(second_data[index.Ind(pos)]>=element)
               if(pos++==end) return(-1);
           }
        }
     }
//---
   return(pos);
  }
//+------------------------------------------------------------------+
//| Method QuickSort.                                                |
//| INPUT:  beg - start of sorting range,                            |
//|         end - end of sorting range,                              |
//|         mode - mode of sorting.                                  |
//| OUTPUT: no.                                                      |
//| REMARK: no.                                                      |
//+------------------------------------------------------------------+
void CDOUBLEArray::QuickSort(double &m_data[],Cint2D &index,int beg,int end,bool mode=0)
  {
   double p,t; int it;
   if(beg<0 || end<0) return;
   int i=beg,j=end;
   if(mode)
     {
      while(i<end)
        {
         p=m_data[(beg+end)>>1];
         while(i<j)
           {
            while(m_data[i]<p)
              {if(i==second_size-1) break; i++;}
            while(m_data[j]>p)
              {if(j==0) break; j--;}
            if(i<=j)
              {
               t=m_data[i];            it=index.Ind(i);
               m_data[i++]=m_data[j];  index.Ind(i-1,index.Ind(j));
               m_data[j]=t;            index.Ind(j,it);
               if(j==0) break;
               else     j--;
              }
           }
         if(beg<j) QuickSort(m_data,index,beg,j,mode);
         beg=i; i=beg; j=end;
        }
     }
   else
     {
      while(i<end)
        {
         p=m_data[(beg+end)>>1];
         while(i<j)
           {
            while(m_data[i]>p)
              {if(i==second_size-1) break; i++;}
            while(m_data[j]<p)
              {if(j==0) break; j--;}
            if(i<=j)
              {
               t=m_data[i];            it=index.Ind(i);
               m_data[i++]=m_data[j];  index.Ind(i-1,index.Ind(j));
               m_data[j]=t;            index.Ind(j,it);
               if(j==0) break;
               else     j--;
              }
           }
         if(beg<j) QuickSort(m_data,index,beg,j,mode);
         beg=i; i=beg; j=end;
        }
     }
  }
//+------------------------------------------------------------------+

//+------------------------------------------------------------------+
//| Class of unidimensional array datetime                           |
//+------------------------------------------------------------------+
class CDATETIMEArray : public CBASEArray
  {
private:
   int               accuracy;// accuracy               
   datetime          second_data[];// array-column
   void              QuickSort(datetime &m_data[],Cint2D &index,int beg,int end,bool mode=false);
protected:
   datetime          getDATETIME(int j){return(second_data[j]);};
public:
   int               second_size;// column size
                     CDATETIMEArray(void){second_size=0;accuracy=-1;};
                    ~CDATETIMEArray(void){};
   void              set(int j,datetime element){second_data[j]=element;};

   string            get(int j)
     {
      if(accuracy!=-1)return(TimeToString(getDATETIME(j)));
      else return((string)getDATETIME(j));
     };
   void              Get(int j,datetime &recipient){recipient=second_data[j];};
   int               Resize_second(int j){second_size=j; return(ArrayResize(second_data,second_size));};
   int               QuickSearch(datetime element,int beg,int end,Cint2D &index,bool mode=false);
   int               SearchFirst(datetime element,int beg,int end,Cint2D &index,bool mode=false);
   int               SearchLast(datetime element,int beg,int end,Cint2D &index,bool mode=false);
   int               SearchGreat(datetime element,int beg,int end,Cint2D &index,bool mode=false);
   int               SearchLess(datetime element,int beg,int end,Cint2D &index,bool mode=false);

   void              Digits(int digits){accuracy=digits;};
   int               Digits(){return(accuracy);};

   void              Sort(Cint2D &index,int beg,int end,bool mode=false)
     {
      datetime m_data[];
      ArrayResize(m_data,ArraySize(second_data));
      for(int i=0;i<ArraySize(m_data);i++)
         m_data[i]=second_data[index.Ind(i)];
      QuickSort(m_data,index,beg,end,mode);
     };
  };
//+------------------------------------------------------------------+
//| Quick search of position of element in a sorted array.           |
//| INPUT:  element - search value.                                  |
//| OUTPUT: position of the found element in the array.              |
//| REMARK: no.                                                      |
//+------------------------------------------------------------------+
int CDATETIMEArray::QuickSearch(datetime element,int beg,int end,Cint2D &index,bool mode=false)
  {// Quick search of position of an element in the array
   int  i=beg,j=end,m=-1; datetime temp;
   if(beg<0){Print("Incorrect beg "+__FUNCTION__);return(-1);}
   if(end>=second_size){Print("Incorrect end "+__FUNCTION__);return(-1);}
//--- search
   if(mode)
     {
      while(!IsStopped())
        {
         m=(j+i)>>1;
         if(m<beg || m>end || j<i)return(-1);// element is not found      
         temp=second_data[index.Ind(m)];
         if(temp==element)return(m);
         if(temp>element) j=m-1;
         else               i=m+1;
        }
     }
   else
     {
      while(!IsStopped())
        {
         m=(j+i)>>1;
         if(m<beg || m>end || j<i)return(-1);// element is not found      
         temp=second_data[index.Ind(m)];
         if(temp==element)return(m);
         if(temp<element) j=m-1;
         else             i=m+1;
        }
     }
//---
   return(m);
  }
//+------------------------------------------------------------------+
//| Find position of first appearance of element in a sorted array.  |
//| INPUT:  element - search value.                                  |
//| OUTPUT: position of the found element in the array or -1.        |
//| REMARK: no.                                                      |
//+------------------------------------------------------------------+
int CDATETIMEArray::SearchFirst(datetime element,int beg,int end,Cint2D &index,bool mode=false)
  {
   int pos;
//--- checking
   if(second_size==0) return(-1);
//--- searching
   pos=QuickSearch(element,beg,end,index,mode);
   if(pos!=-1)
     {
      if(second_data[index.Ind(pos)]==element)
        {
         if(mode)
           {
            while(second_data[index.Ind(pos)]==element)
               if(pos--==beg) break;
            return(pos+1);
           }
         else
           {
            while(second_data[index.Ind(pos)]==element)
               if(--pos==beg-1) break;
            return(pos+1);
           }
        }
     }
//---
   return(-1);
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
int CDATETIMEArray::SearchLast(datetime element,int beg,int end,Cint2D &index,bool mode=false)
  {
   int pos;
//--- checking
   if(second_size==0) return(-1);
//--- searching
   pos=QuickSearch(element,beg,end,index,mode);
   if(pos!=-1)
     {
      if(second_data[index.Ind(pos)]==element)
        {
         if(mode)
           {
            while(second_data[index.Ind(pos)]==element)
               if(++pos==end+1) break;
            return(pos-1);
           }
         else
           {
            while(second_data[index.Ind(pos)]==element)
               if(pos++==end) break;
            return(pos-1);
           }
        }
     }
//--- 
   return(-1);
  }
//+------------------------------------------------------------------+
//| Search position of the first element which is greater than       |
//| specified in a sorted array.                                     |
//| INPUT:  element - search value.                                  |
//| OUTPUT: position of the found element in the array or -1.        |
//| REMARK: no.                                                      |
//+------------------------------------------------------------------+
int CDATETIMEArray::SearchGreat(datetime element,int beg,int end,Cint2D &index,bool mode=false)
  {
   int pos;
//--- checking
   if(second_size==0) return(-1);
//--- searching
   pos=QuickSearch(element,beg,end,index,mode);
   if(pos!=-1)
     {
      if(second_data[index.Ind(pos)]==element)
        {
         if(mode)
           {
            while(second_data[index.Ind(pos)]<=element)
               if(++pos==end+1) return(-1);
           }
         else
           {
            while(second_data[index.Ind(pos)]<=element)
               if(--pos==beg-1) return(-1);
           }
        }
     }
//--- 
   return(pos);
  }
//+------------------------------------------------------------------+
//| Search position of the first element which is less than          |
//| specified in the sorted array.                                   |
//| INPUT:  element - search value.                                  |
//| OUTPUT: position of the found element in the array or -1.        |
//| REMARK: no.                                                      |
//+------------------------------------------------------------------+
int CDATETIMEArray::SearchLess(datetime element,int beg,int end,Cint2D &index,bool mode=false)
  {
   int pos;
//--- checking
   if(second_size==0) return(-1);
//--- searching
   pos=QuickSearch(element,beg,end,index,mode);
   if(pos!=-1)
     {
      if(second_data[index.Ind(pos)]>=element)
        {
         if(mode)
           {
            while(second_data[index.Ind(pos)]==element)
               if(pos--==beg) return(-1);
           }
         else
           {
            while(second_data[index.Ind(pos)]>=element)
               if(pos++==end) return(-1);
           }
        }
     }
//---
   return(pos);
  }
//+------------------------------------------------------------------+
//| Method QuickSort.                                                |
//| INPUT:  beg - start of sorting range,                            |
//|         end - end of sorting range,                              |
//|         mode - mode of sorting.                                  |
//| OUTPUT: no.                                                      |
//| REMARK: no.                                                      |
//+------------------------------------------------------------------+
void CDATETIMEArray::QuickSort(datetime &m_data[],Cint2D &index,int beg,int end,bool mode=0)
  {
   datetime p,t; int it;
   if(beg<0 || end<0) return;
   int i=beg,j=end;
   if(mode)
     {
      while(i<end)
        {
         p=m_data[(beg+end)>>1];
         while(i<j)
           {
            while(m_data[i]<p)
              {if(i==second_size-1) break; i++;}
            while(m_data[j]>p)
              {if(j==0) break; j--;}
            if(i<=j)
              {
               t=m_data[i];            it=index.Ind(i);
               m_data[i++]=m_data[j];  index.Ind(i-1,index.Ind(j));
               m_data[j]=t;            index.Ind(j,it);
               if(j==0) break;
               else     j--;
              }
           }
         if(beg<j) QuickSort(m_data,index,beg,j,mode);
         beg=i; i=beg; j=end;
        }
     }
   else
     {
      while(i<end)
        {
         p=m_data[(beg+end)>>1];
         while(i<j)
           {
            while(m_data[i]>p)
              {if(i==second_size-1) break; i++;}
            while(m_data[j]<p)
              {if(j==0) break; j--;}
            if(i<=j)
              {
               t=m_data[i];            it=index.Ind(i);
               m_data[i++]=m_data[j];  index.Ind(i-1,index.Ind(j));
               m_data[j]=t;            index.Ind(j,it);
               if(j==0) break;
               else     j--;
              }
           }
         if(beg<j) QuickSort(m_data,index,beg,j,mode);
         beg=i; i=beg; j=end;
        }
     }
  }
//+------------------------------------------------------------------+  
//+------------------------------------------------------------------+
//| Class of unidimensional array of string values                   |
//+------------------------------------------------------------------+
class CSTRINGArray : public CBASEArray
  {
private:
   string            second_data[];// array-column
   void              BubbleSort(Cint2D &index,int Start,int End,bool maxx=true);
protected:
   string            getSTRING(int j){return(second_data[j]);};
public:
   int               second_size;// column size
                     CSTRINGArray(void){second_size=0;};
                    ~CSTRINGArray(void){};
   void              set(int j,string element){second_data[j]=element;};

   string            get(int j){return((string)getSTRING(j));};
   void              Get(int j,string &recipient){recipient=second_data[j];};
   int               Resize_second(int j){second_size=j; return(ArrayResize(second_data,second_size));};
   int               QuickSearch(string element,int beg,int end,Cint2D &index,bool mode=false);
   int               SearchFirst(string element,int beg,int end,Cint2D &index,bool mode=false);
   int               SearchLast(string element,int beg,int end,Cint2D &index,bool mode=false);
   int               SearchGreat(string element,int beg,int end,Cint2D &index,bool mode=false);
   int               SearchLess(string element,int beg,int end,Cint2D &index,bool mode=false);
   void              Sort(Cint2D &index,int beg,int end,bool mode=false){BubbleSort(index,beg,end,mode);};
  };
//+------------------------------------------------------------------+
//| Quick search of position of element in a sorted array.           |
//| INPUT:  element - search value.                                  |
//| OUTPUT: position of the found element in the array.              |
//| REMARK: no.                                                      |
//+------------------------------------------------------------------+
int CSTRINGArray::QuickSearch(string element,int beg,int end,Cint2D &index,bool mode=false)
  {// Quick search of position of an element in the array
   int  i=beg,j=end,m=-1; string temp;
   if(beg<0){Print("Incorrect beg "+__FUNCTION__);return(-1);}
   if(end>=second_size){Print("Incorrect end "+__FUNCTION__);return(-1);}
//--- search
   if(mode)
     {
      while(!IsStopped())
        {
         m=(j+i)>>1;
         if(m<beg || m>end || j<i)return(-1);// element is not found      
         temp=second_data[index.Ind(m)];
         if(temp==element)return(m);
         if(StringCompare(temp,element)==1) j=m-1;
         else               i=m+1;
        }
     }
   else
     {
      while(!IsStopped())
        {
         m=(j+i)>>1;
         if(m<beg || m>end || j<i)return(-1);// element is not found      
         temp=second_data[index.Ind(m)];
         if(temp==element)return(m);
         if(StringCompare(temp,element)==-1) j=m-1;
         else             i=m+1;
        }
     }
//---
   return(m);
  }
//+------------------------------------------------------------------+
//| Find position of first appearance of element in a sorted array.  |
//| INPUT:  element - search value.                                  |
//| OUTPUT: position of the found element in the array or -1.        |
//| REMARK: no.                                                      |
//+------------------------------------------------------------------+
int CSTRINGArray::SearchFirst(string element,int beg,int end,Cint2D &index,bool mode=false)
  {
   int pos;
//--- checking
   if(second_size==0) return(-1);
//--- searching
   pos=QuickSearch(element,beg,end,index,mode);
   if(pos!=-1)
     {
      if(second_data[index.Ind(pos)]==element)
        {
         if(mode)
           {
            while(second_data[index.Ind(pos)]==element)
               if(pos--==beg) break;
            return(pos+1);
           }
         else
           {
            while(second_data[index.Ind(pos)]==element)
               if(--pos==beg-1) break;
            return(pos+1);
           }
        }
     }
//---
   return(-1);
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
int CSTRINGArray::SearchLast(string element,int beg,int end,Cint2D &index,bool mode=false)
  {
   int pos;
//--- checking
   if(second_size==0) return(-1);
//--- searching
   pos=QuickSearch(element,beg,end,index,mode);
   if(pos!=-1)
     {
      if(second_data[index.Ind(pos)]==element)
        {
         if(mode)
           {
            while(second_data[index.Ind(pos)]==element)
               if(++pos==end+1) break;
            return(pos-1);
           }
         else
           {
            while(second_data[index.Ind(pos)]==element)
               if(pos++==end) break;
            return(pos-1);
           }
        }
     }
//--- 
   return(-1);
  }
//+------------------------------------------------------------------+
//| Search position of the first element which is greater than       |
//| specified in a sorted array.                                     |
//| INPUT:  element - search value.                                  |
//| OUTPUT: position of the found element in the array or -1.        |
//| REMARK: no.                                                      |
//+------------------------------------------------------------------+
int CSTRINGArray::SearchGreat(string element,int beg,int end,Cint2D &index,bool mode=false)
  {
   int pos;
//--- checking
   if(second_size==0) return(-1);
//--- searching
   pos=QuickSearch(element,beg,end,index,mode);
   if(pos!=-1)
     {
      if(second_data[index.Ind(pos)]==element)
        {
         if(mode)
           {
            while(StringCompare(second_data[index.Ind(pos)],element)<=0)
               if(++pos==end+1) return(-1);
           }
         else
           {
            while(StringCompare(second_data[index.Ind(pos)],element)<=0)
               if(--pos==beg-1) return(-1);
           }
        }
     }
//--- 
   return(pos);
  }
//+------------------------------------------------------------------+
//| Search position of the first element which is less than          |
//| specified in the sorted array.                                   |
//| INPUT:  element - search value.                                  |
//| OUTPUT: position of the found element in the array or -1.        |
//| REMARK: no.                                                      |
//+------------------------------------------------------------------+
int CSTRINGArray::SearchLess(string element,int beg,int end,Cint2D &index,bool mode=false)
  {
   int pos;
//--- checking
   if(second_size==0) return(-1);
//--- searching
   pos=QuickSearch(element,beg,end,index,mode);
   if(pos!=-1)
     {
      if(StringCompare(second_data[index.Ind(pos)],element)>=0)
        {
         if(mode)
           {
            while(second_data[index.Ind(pos)]==element)
               if(pos--==beg) return(-1);
           }
         else
           {
            while(StringCompare(second_data[index.Ind(pos)],element)>=0)
               if(pos++==end) return(-1);
           }
        }
     }
//---
   return(pos);
  }
//+------------------------------------------------------------------+
//| Method BubbleSort.                                               |
//| INPUT:  beg - start of sorting range,                            |
//|         end - end of sorting range,                              |
//|         mode - mode of sorting.                                  |
//| OUTPUT: no.                                                      |
//| REMARK: no.                                                      |
//+------------------------------------------------------------------+
void CSTRINGArray::BubbleSort(Cint2D &index,int Start,int End,bool maxx=true)
  {
   int c=0,start=Start,end=End;
   if(maxx)
     {
      do
        {
         c=0;
         int n=start;// correction of start
         int k=end;// correction of end
         for(int i=start;i<end;i++)
           {
            if(StringCompare(second_data[index.Ind(i)],second_data[index.Ind(i+1)])==1)//>
              {
               int itemp=index.Ind(i+1);
               index.Ind(i+1,index.Ind(i));
               index.Ind(i,itemp);
               k=i;
               c++;
              }
           }
         end=k;
         if(c==0)break;
         c=0;
         for(int i=end;i>start;i--)
           {
            if(StringCompare(second_data[index.Ind(i)],second_data[index.Ind(i-1)])==-1)//<
              {
               int itemp=index.Ind(i-1);
               index.Ind(i-1,index.Ind(i));
               index.Ind(i,itemp);
               n=i;
               c++;
              }
           }
         start=n;
         if(IsStopped())break;
        }
      while(c!=0);
     }
   else
     {
      do
        {
         c=0;
         int n=start;// correction of start
         int k=end;// correction of end
         for(int i=start;i<end;i++)
           {
            if(StringCompare(second_data[index.Ind(i)],second_data[index.Ind(i+1)])==-1)//<
              {
               int itemp=index.Ind(i+1);
               index.Ind(i+1,index.Ind(i));
               index.Ind(i,itemp);
               k=i;
               c++;
              }
           }
         end=k;
         if(c==0)break;
         c=0;
         for(int i=end;i>start;i--)
           {
            if(StringCompare(second_data[index.Ind(i)],second_data[index.Ind(i-1)])==1)//>
              {
               int itemp=index.Ind(i-1);
               index.Ind(i-1,index.Ind(i));
               index.Ind(i,itemp);
               n=i;
               c++;
              }
           }
         start=n;
         if(IsStopped())break;
        }
      while(c!=0);
     }
  }
//+------------------------------------------------------------------+
//+------------------------------------------------------------------+
//| call of the file                                                 |
//| #include <TwoDimensionalArray.mqh>                               |
//+------------------------------------------------------------------+
//+------------------------------------------------------------------+
//| class of two-dimensional array                                   |
//+------------------------------------------------------------------+
#define _CHECK0_ Print(__FUNCTION__+"("+(string)i+","+(string)j+")");return;
#define _CHECK_ Print(__FUNCTION__+"("+(string)i+")");return(-1);
#define _FIRST_ first_data[aic[i]]
#define _PARAM0_ array_index.Ind(j),value
#define _PARAM1_ array_index.Ind(j),recipient
#define _PARAM2_ element,beg,end,array_index,mode 
//+------------------------------------------------------------------+
class CTable
  {
private:   
   int               start_first_size;// initial size or row  
   int               first_size;// row size   
   int               second_size;// columns size   
   CBASEArray       *first_data[];// array-row, heading of array-columns
   Cint2D            array_index;// two-dimensional array of indexes
   int               aic[];// array of indexes of columns aic[]-array_index_column[]
   ENUM_DATATYPE     type_table[];// array of types
   void              SwitchType(int i);
   bool              check_type(int i,ENUM_DATATYPE t);// checking if the type of data correspond to the type array    
public:   
                     CTable(void){first_size=0;};
                    ~CTable(void);
   void              variant(int ind){array_index.Variant(ind);};
   int               variant(){return(array_index.Variant());};
   void              variantcopy(int rec,int sor){array_index.Variant(rec); array_index.VariantCopy(rec,sor);};
   bool              Change(int &sor0,int &sor1);// swap columns
   bool              Insert(int rec,int sor);// insert a column in a specified position with pulling of other columns
   int               FirstSize(){return(first_size);};
   int               SecondSize(){return(second_size);};
   //--- changing size of a two-dimensional array with changing of all associated information.
   void              FirstResize(const ENUM_DATATYPE &TYPE[]); // initial division of array
   void              SecondResize(int j);// second dimension
   void              PruningTable(int count);// new size of the first dimension, the change is possible within the start size
   void              CopyTable(CTable *sor,int sec_beg,int sec_end);// copying of one table to another, a new table is created according to the 'sor' sample
   void              CopyTable(CTable *sor){CopyTable(sor,0,sor.SecondSize()-1);};// copying of one table to another on the entire length of of the second dimension
   ENUM_DATATYPE     TypeTable(int i){return(type_table[aic[i]]);};// returns the type_table value of the column 'i'
   //--- accuracy of printing
   void              StringDigits(int i,int digits){_FIRST_.Digits(digits);};// setting accuracy of printing of double,datetime (-1 means that accuracy is not set)
   int               StringDigits(int i){return(_FIRST_.Digits());};// get accuracy of printing of double,datetime (!= -1 means accuracy of output includes seconds)
   //--- i - index of the first dimension, j index of the second dimension
   //--- setting value
   void              Set(int i,int j,long     value)      {if(!check_type(i,TYPE_LONG))    {_CHECK0_}  _FIRST_.set(_PARAM0_);};// setting value of i-th row and j-th column
   void              Set(int i,int j,double   value)      {if(!check_type(i,TYPE_DOUBLE))  {_CHECK0_}  _FIRST_.set(_PARAM0_);};// setting value of i-th row and j-th column
   void              Set(int i,int j,datetime value)      {if(!check_type(i,TYPE_DATETIME)){_CHECK0_}  _FIRST_.set(_PARAM0_);};// setting value of i-th row and j-th column
   void              Set(int i,int j,string   value);// setting value of i-th row and j-th column; if the selected column is not 'string' the value will be casted to the type of column
   //--- getting value
   void              Get(int i,int j,long     &recipient) {if(!check_type(i,TYPE_LONG))    {_CHECK0_}  _FIRST_.Get(_PARAM1_);};// getting value of i-th row and j-th column
   void              Get(int i,int j,double   &recipient) {if(!check_type(i,TYPE_DOUBLE))  {_CHECK0_}  _FIRST_.Get(_PARAM1_);};// getting value of i-th row and j-th column
   void              Get(int i,int j,datetime &recipient) {if(!check_type(i,TYPE_DATETIME)){_CHECK0_}  _FIRST_.Get(_PARAM1_);};// getting value of i-th row and j-th column
   void              Get(int i,int j,string   &recipient) {if(!check_type(i,TYPE_STRING))  {_CHECK0_}  _FIRST_.Get(_PARAM1_);};// getting value of i-th row and j-th column
   string            sGet(int i,int j){return(_FIRST_.get(array_index.Ind(j)));};// returning value of i-th row and j-th column 
   //--- quick search of position an element in the array
   int               QuickSearch(int i,long element,int beg,int end,bool mode=false) {if(!check_type(i,TYPE_LONG)){_CHECK_}     return(_FIRST_.QuickSearch(_PARAM2_));};
   //--- Searches for the first element that is equal to a pattern in a sorted array 
   int               SearchFirst(int i,long element,int beg,int end,bool mode=false) {if(!check_type(i,TYPE_LONG)){_CHECK_}     return(_FIRST_.SearchFirst(_PARAM2_));};
   //--- Searches for the last element that is equal to a pattern in a sorted array
   int               SearchLast(int i,long element,int beg,int end,bool mode=false) {if(!check_type(i,TYPE_LONG)){_CHECK_}     return(_FIRST_.SearchLast(_PARAM2_));};
   //--- Searches for the closest element that is greater than a pattern in a sorted array
   int               SearchGreat(int i,long element,int beg,int end,bool mode=false) {if(!check_type(i,TYPE_LONG)){_CHECK_}     return(_FIRST_.SearchGreat(_PARAM2_));};
   //--- Searches for the closest element that is less than a pattern in a sorted array
   int               SearchLess(int i,long element,int beg,int end,bool mode=false) {if(!check_type(i,TYPE_LONG)){_CHECK_}     return(_FIRST_.SearchLess(_PARAM2_));};
   //--- Overriding to the types double,datetime,string
   int               QuickSearch(int i,double element,int beg,int end,bool mode=false)   {if(!check_type(i,TYPE_DOUBLE)){_CHECK_}   return(_FIRST_.QuickSearch(_PARAM2_));};
   int               SearchFirst(int i,double element,int beg,int end,bool mode=false)   {if(!check_type(i,TYPE_DOUBLE)){_CHECK_}   return(_FIRST_.SearchFirst(_PARAM2_));};
   int               SearchLast (int i,double element,int beg,int end,bool mode=false)   {if(!check_type(i,TYPE_DOUBLE)){_CHECK_}   return(_FIRST_.SearchLast (_PARAM2_));};
   int               SearchGreat(int i,double element,int beg,int end,bool mode=false)   {if(!check_type(i,TYPE_DOUBLE)){_CHECK_}   return(_FIRST_.SearchGreat(_PARAM2_));};
   int               SearchLess (int i,double element,int beg,int end,bool mode=false)   {if(!check_type(i,TYPE_DOUBLE)){_CHECK_}   return(_FIRST_.SearchLess (_PARAM2_));};
   int               QuickSearch(int i,datetime element,int beg,int end,bool mode=false) {if(!check_type(i,TYPE_DATETIME)){_CHECK_} return(_FIRST_.QuickSearch(_PARAM2_));};
   int               SearchFirst(int i,datetime element,int beg,int end,bool mode=false) {if(!check_type(i,TYPE_DATETIME)){_CHECK_} return(_FIRST_.SearchFirst(_PARAM2_));};
   int               SearchLast (int i,datetime element,int beg,int end,bool mode=false) {if(!check_type(i,TYPE_DATETIME)){_CHECK_} return(_FIRST_.SearchLast (_PARAM2_));};
   int               SearchGreat(int i,datetime element,int beg,int end,bool mode=false) {if(!check_type(i,TYPE_DATETIME)){_CHECK_} return(_FIRST_.SearchGreat(_PARAM2_));};
   int               SearchLess (int i,datetime element,int beg,int end,bool mode=false) {if(!check_type(i,TYPE_DATETIME)){_CHECK_} return(_FIRST_.SearchLess (_PARAM2_));};
   int               QuickSearch(int i,string element,int beg,int end,bool mode=false)   {if(!check_type(i,TYPE_STRING)){_CHECK_}   return(_FIRST_.QuickSearch(_PARAM2_));};
   int               SearchFirst(int i,string element,int beg,int end,bool mode=false)   {if(!check_type(i,TYPE_STRING)){_CHECK_}   return(_FIRST_.SearchFirst(_PARAM2_));};
   int               SearchLast (int i,string element,int beg,int end,bool mode=false)   {if(!check_type(i,TYPE_STRING)){_CHECK_}   return(_FIRST_.SearchLast (_PARAM2_));};
   int               SearchGreat(int i,string element,int beg,int end,bool mode=false)   {if(!check_type(i,TYPE_STRING)){_CHECK_}   return(_FIRST_.SearchGreat(_PARAM2_));};
   int               SearchLess (int i,string element,int beg,int end,bool mode=false)   {if(!check_type(i,TYPE_STRING)){_CHECK_}   return(_FIRST_.SearchLess (_PARAM2_));};
   //--- sorting the second dimension by a selected column, beg - start point, end - end point, 
   //--- mode - direction of sorting  (mode=true means values increase together with indexes)
   void              SortTwoDimArray(int i,int beg,int end,bool mode=false){_FIRST_.Sort(array_index,beg,end,mode);};
  };
//+------------------------------------------------------------------+
//| Destructor of the CTable class                                   |
//+------------------------------------------------------------------+
CTable::~CTable(void)
  {
   for(int i=0;i<start_first_size;i++)
      delete first_data[i];
  }
//+------------------------------------------------------------------+
//| additional constructor, allocation of memory                     |
//| of the first dimension                                           |
//+------------------------------------------------------------------+
void CTable::FirstResize(const ENUM_DATATYPE &TYPE[])
  {
   first_size=ArraySize(TYPE);
   start_first_size=first_size;
   ArrayCopy(type_table,TYPE);
   ArrayResize(first_data,first_size);
   ArrayResize(aic,first_size);
   for(int i=0;i<first_size;i++)
     {
      SwitchType(i);
      aic[i]=i;      
     }
  }
//+------------------------------------------------------------------+
//| partial copying of the 'sor' table                               |
//+------------------------------------------------------------------+
void CTable::CopyTable(CTable *sor,int sec_beg,int sec_end)
  {
   first_size=sor.FirstSize();// determine size of the first dimension by 'sor'
   start_first_size=first_size;
   ArrayResize(type_table,first_size);
   ArrayResize(first_data,first_size);
   ArrayResize(aic,first_size);
   for(int i=0;i<first_size;i++)
     {
      type_table[i]=sor.TypeTable(i);// copy the array of type
      SwitchType(i); // determine type of column
      aic[i]=i; // fill the array of indexes of columns
      StringDigits(i,sor.StringDigits(i));      
     }
   SecondResize(sec_end+1-sec_beg);// set size of the second dimension 
   for(int i=0;i<first_size;i++)
      for(int j=0;j<second_size;j++)
         Set(i,j,sor.sGet(i,j+sec_beg));
  }
//+------------------------------------------------------------------+
//| new size of the first dimension,                                 |
//| the change is possible within the start size                     |
//+------------------------------------------------------------------+
void  CTable::PruningTable(int count)
  {
   if(count<=start_first_size && count>=0)first_size=count;
   else first_size=start_first_size;
  };
//+------------------------------------------------------------------+
//| creation of object of children                                   |
//+------------------------------------------------------------------+
void CTable::SwitchType(int i)
  {
   ENUM_DATATYPE temp=type_table[i];
   switch(type_table[i])
     {
      case TYPE_DATETIME: first_data[i]=new CDATETIMEArray(); break;
      case TYPE_LONG:     first_data[i]=new CLONGArray(); break;
      case TYPE_DOUBLE:   first_data[i]=new CDOUBLEArray(); break;
      case TYPE_STRING:   first_data[i]=new CSTRINGArray(); break;
      default:Print("ERROR case "+__FUNCTION__);break;
     };
  }
//+------------------------------------------------------------------+
//| changing memory allocated for the two-dimensional array          |
//+------------------------------------------------------------------+
void CTable::SecondResize(int j)
  {
   array_index.ResizeIndexes(j);
   for(int i=0;i<first_size;i++)// set size of the second dimension
      first_data[aic[i]].Resize_second(j);
   second_size=j;
  }
//+------------------------------------------------------------------+
//| swap columns                                                     |
//+------------------------------------------------------------------+
bool CTable::Change(int &sor0,int &sor1)
  {
   if(sor0<0||sor0>=first_size)return(false);
   if(sor1<0||sor1>=first_size)return(false);
   int temp=aic[sor0]; aic[sor0]=aic[sor1]; aic[sor1]=temp;
   temp=sor0; sor0=sor1; sor1=temp;  
   return(true);
  };
//+------------------------------------------------------------------+
//|  inserting a column in a specified position with pulling         |
//|  of the other columns                                            |
//+------------------------------------------------------------------+
bool CTable::Insert(int rec,int sor)
  {
   if(rec<0 || rec>=first_size)return(false);
   if(sor<0 || sor>=first_size)return(false);
   int temp;
   if(rec<sor)
     {
      temp=aic[sor];
      for(int i=sor;i>rec;i--)
         aic[i]=aic[i-1];
      aic[rec]=temp;
     }
   else
     {
      temp=aic[sor];
      for(int i=sor;i<rec;i++)
         aic[i]=aic[i+1];
      aic[rec]=temp;
     }   
   return(true);
  };
//+------------------------------------------------------------------+
//| check if the type of data correspond to the type of array        |
//+------------------------------------------------------------------+
bool CTable::check_type(int i,ENUM_DATATYPE t)// if the type doesn't correspond, then 'true'
  {
   if(type_table[aic[i]]==t)return(true);
   else return(false);     
  };
//+------------------------------------------------------------------+
//| setting value for the i-th row and j-th column                   |
//| the 'value' parameter is determined as 'string'                  |
//+------------------------------------------------------------------+
void CTable::Set(int i,int j,string   value)
  {
   if(check_type(i,TYPE_STRING))_FIRST_.set(array_index.Ind(j),value);
   else
     {
      if(check_type(i,TYPE_LONG)){_FIRST_.set(array_index.Ind(j),StringToInteger(value));}
      else
        {
         if(check_type(i,TYPE_DOUBLE)){ _FIRST_.set(array_index.Ind(j),StringToDouble(value));}
         else
           {
            if(check_type(i,TYPE_DATETIME)){ _FIRST_.set(array_index.Ind(j),StringToTime(value));}
           }
        }
     }
  };
//+------------------------------------------------------------------+
//| end CTable                                                       |
//+------------------------------------------------------------------+
