//закрытие конкретно треугольника

#include "head.mqh"

void fnCloseThree(stThree &MxSmb[], int accounttype, int i)
   {
      // перед закрытием объязательно проверим на доступность всех пар в треугольнике
      // разрывать треугольник крайне неправильно и опасно, а если работать на неттинговом счёте
      // то в последствии будет вообще не разобраться с хаосом который будет твориться в позициях
      
      if(fnSmbCheck(MxSmb[i].smb1.name))
      if(fnSmbCheck(MxSmb[i].smb2.name))
      if(fnSmbCheck(MxSmb[i].smb3.name))          
      
      // если всё доступно, то с помощью стандартной библиотеки закрываем все 3 позиции
      // после закрытия опять же необходимо проверить успешность действия
      switch(accounttype)
      {
         case  ACCOUNT_MARGIN_MODE_RETAIL_HEDGING:     
         
         ctrade.PositionClose(MxSmb[i].smb1.tkt);
         ctrade.PositionClose(MxSmb[i].smb2.tkt);
         ctrade.PositionClose(MxSmb[i].smb3.tkt);              
         break;
         default:
         break;
      }       
   }   