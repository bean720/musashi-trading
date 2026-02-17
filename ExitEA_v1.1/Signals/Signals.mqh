//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+

#property strict
#include "..\MQH\Enums.mqh"
#include "SignalBase.mqh"
#include "..\MQH\TradingManager.mqh"

//---
class ExitIndicatorArrowSignal : public Signal{
   public:
   
   ExitIndicatorArrowSignal(){
      name = "ExitIndicatorArrowSignal";
   }
   
   void CalculateOpenSignal(){
      openSignal     = NO;
   }
   
   void CalculateCloseSignal(){
      closeSignal    = NO;
      
      int      bar      = signal_bar;
      double   up_0     = TM.GetIndicator_Exit(0,bar);
      double   dn_1     = TM.GetIndicator_Exit(1,bar);
      double   up_2     = TM.GetIndicator_Exit(2,bar);
      double   dn_3     = TM.GetIndicator_Exit(3,bar);
      
      bool     isBuy    = up_0 != EMPTY_VALUE || up_2 != EMPTY_VALUE;
      bool     isSell   = dn_1 != EMPTY_VALUE || dn_3 != EMPTY_VALUE;
      
      if (isBuy)
         closeSignal = BUY;
      if (isSell)
         closeSignal = (closeSignal == NO) ? SELL : BOTH;
      
      IFLOG{
         ArrayResize(closeStringVals,0);
      
         TM.AddInArray(closeStringVals,TM.ToString(isBuy));
         TM.AddInArray(closeStringVals,TM.ToString(isSell));
         
         TM.AddInArray(closeStringVals,TM.ToString(SEP));
         TM.AddInArray(closeStringVals,TM.ToString(up_0));
         TM.AddInArray(closeStringVals,TM.ToString(dn_1));
         TM.AddInArray(closeStringVals,TM.ToString(up_2));
         TM.AddInArray(closeStringVals,TM.ToString(dn_3));
      }
      
   }
};


class TemplateSignal : public Signal{
   public:
   
   TemplateSignal(){
      name = "TemplateSignal";
   }
   
   void CalculateOpenSignal(){
      openSignal     = NO;
      
      double   val   = 0;
      
      if (val != EMPTY_VALUE)
         openSignal = BUY;
      if (val != EMPTY_VALUE)
         openSignal = (openSignal == NO) ? SELL : BOTH;
      
      if (enable_logging){
         ArrayResize(openStringVals,0);
         
      
         TM.AddInArray(openStringVals,TM.ToString(val));
      }
   }
   
   void CalculateCloseSignal(){
      closeSignal    = NO;
      
      double   val   = 0;
      
      if (val != EMPTY_VALUE)
         closeSignal = BUY;
      if (val != EMPTY_VALUE)
         closeSignal = (closeSignal == NO) ? SELL : BOTH;
      
      if (enable_logging){
         ArrayResize(closeStringVals,0);
         
      
         TM.AddInArray(closeStringVals,TM.ToString(val));
      }
   }
};
