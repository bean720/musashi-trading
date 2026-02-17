//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
#include "..\\TradingManager.mqh"
#include "..\\Structs.mqh"

#include "Convergence.mqh"
#include "ConvergenceHandler.mqh"

class ConvergenceStarter{
   public:
   string            trName;
   string            trObjBaseName;
   
   int               trIndex;
   ENUM_TIMEFRAMES   trTimeframe;
   
   datetime          trTimeLast;
   
   StructConvergence trStructConvergence;
   
   ConvergenceStarter(
               int               index,
               
               int               shift
               )
   {
      trIndex              = index;
      trTimeframe          = glArray_Timeframes[trIndex];
      
      trName               = 
                              "DV"+"_"+
                              TM.ToString(trTimeframe)+"_"
                              ;
                              
      trObjBaseName        = glPrefix + "CS_"+ TM.ToString(trTimeframe);                     
                              
                              
      IFLOG
         TM.Log(  
               HEAD_TO_STRING+
               TM.ToString(trName)+" "+
               TM.ToString("created.")+" | "+
               ToString()
               ,shift);
   }
   
   ~ConvergenceStarter(){
      IFLOG
         TM.Log(  
               HEAD_TO_STRING+
               TM.ToString(trName)+" "+
               TM.ToString("deleted.")+" | "+
               ToString()
               );
      
      ObjectsDeleteAll(0, trObjBaseName);         
   }
   
   string ToString(){
      string   val   = StringFormat(" | CConvStarter: tN:%s, SC:%s | ",
                              trName,
                              trStructConvergence.ToString()
                              );
      return   val;                        
   }
   
   void OnTick(int shift){
      FindNewConvergence(shift);
   }
   
   void FindNewConvergence(int shift){
   
      ZeroMemory(trStructConvergence);
   
      datetime timeBase = iTime(_Symbol, _Period, shift);
      int      bar      = iBarShift(_Symbol, trTimeframe, timeBase);
      
      //only closed candles
               bar      = MathMax(bar, 1);
      
      datetime time     = iTime(_Symbol, trTimeframe, bar + 1);
      
      if (time <= trTimeLast) return;
      trTimeLast        = time;
      
      double   yellow0  = TM.GetIndicator_Mdfx(trIndex,0,bar);
      double   yellow1  = TM.GetIndicator_Mdfx(trIndex,0,bar+1);
      
      double   green0   = TM.GetIndicator_Mdfx(trIndex,1,bar);
      double   green1   = TM.GetIndicator_Mdfx(trIndex,1,bar+1);
      
      double   red0     = TM.GetIndicator_Mdfx(trIndex,2,bar);
      double   red1     = TM.GetIndicator_Mdfx(trIndex,2,bar+1);
      
      bool     isBuy    = red1 != EMPTY_VALUE && red0 == EMPTY_VALUE;
      bool     isSell   = green1 != EMPTY_VALUE && green0 == EMPTY_VALUE;
      
      IFLOG{
         TM.Log(
                  HEAD_TO_STRING+
                  TM.ToString(time)+", "+
                  TM.ToString(bar)+", "+
                  TM.ToString(timeBase)+", "+
                  ToString()
                  ,shift);
                  
         TM.Log(
                  HEAD_TO_STRING+
                  TM.ToString(isBuy)+", "+
                  TM.ToString(isSell)+", "+
                  TM.ToString(green0)+", "+
                  TM.ToString(green1)+", "+
                  TM.ToString(red0)+", "+
                  TM.ToString(red1)+", "+
                  ToString()
                  ,shift);
      }
      
      
      if (isBuy || isSell){
         
         if (isBuy){
            trStructConvergence.trSignalType          = BUY;
            trStructConvergence.trSubw_Dn_PriceRight  = yellow1;
            trStructConvergence.trSubw_Dn_TimeRight   = time;
         }
         if (isSell){
            trStructConvergence.trSignalType          = SELL;
            trStructConvergence.trSubw_Up_PriceRight  = yellow1;
            trStructConvergence.trSubw_Up_TimeRight   = time;
         }
         
         IFLOG{
            TM.Log(
                     HEAD_TO_STRING+
                     TM.ToString(isBuy)+", "+
                     TM.ToString(isSell)+", "+
                     trStructConvergence.ToString()+", "+
                     ToString()
                     ,shift);
         }               
         
         Find_NextPoints_SubwLeft(shift, bar, HEAD_TO_STRING);
      }
   }
   
   void Find_NextPoints_SubwLeft(int shift, int bar, string reason){
      int   barRightStart  = bar + 1;
      int   bars           = iBars(_Symbol, trTimeframe);
      
      IFLOG{
         TM.Log(
                  HEAD_TO_STRING+
                  TM.ToString(bar)+", "+
                  TM.ToString(barRightStart)+", "+
                  TM.ToString(bars)+", "+
                  ToString()
                  ,shift);
      }               
      
      
      SignalType  signal   = trStructConvergence.trSignalType;
      
      
      for (int i = barRightStart; i < bars - 1; i++){
         datetime time     = iTime(_Symbol, trTimeframe, i + 1);
         
         IFLOG{
            TM.Log(
                     HEAD_TO_STRING+
                     TM.ToString(i)+", "+
                     TM.ToString(time)+", "+
                     ToString()
                     ,shift);
         }               
            
         double   yellow0  = TM.GetIndicator_Mdfx(trIndex,0,i);
         double   yellow1  = TM.GetIndicator_Mdfx(trIndex,0,i+1);
         
         double   green0   = TM.GetIndicator_Mdfx(trIndex,1,i);
         double   green1   = TM.GetIndicator_Mdfx(trIndex,1,i+1);
         
         double   red0     = TM.GetIndicator_Mdfx(trIndex,2,i);
         double   red1     = TM.GetIndicator_Mdfx(trIndex,2,i+1);
      
         bool     isNotNull   = yellow0 != EMPTY_VALUE;
         
         if (!isNotNull) break;
         
         bool        isBuy    = red1 != EMPTY_VALUE && red0 == EMPTY_VALUE;
         bool        isSell   = green1 != EMPTY_VALUE && green0 == EMPTY_VALUE;
         SignalType  curSig   = isBuy ? BUY : isSell ? SELL : NO;
         
         if (isBuy || isSell){
         
            IFLOG{
               TM.Log(
                        HEAD_TO_STRING+
                        TM.ToString(i)+", "+
                        EnumToString(curSig)+", "+
                        EnumToString(signal)+", "+
                        TM.ToString(isBuy)+", "+
                        TM.ToString(isSell)+", "+
                        ToString()
                        ,shift);
            }               
         
            if (isBuy){
               if (trStructConvergence.trSubw_Dn_TimeRight == 0){
                  trStructConvergence.trSubw_Dn_PriceRight  = yellow1;
                  trStructConvergence.trSubw_Dn_TimeRight   = time;
               }
               else if (trStructConvergence.trSubw_Dn_TimeLeft == 0){
                  trStructConvergence.trSubw_Dn_PriceLeft  = yellow1;
                  trStructConvergence.trSubw_Dn_TimeLeft   = time;
               }
            }
            if (isSell){
               if (trStructConvergence.trSubw_Up_TimeRight == 0){
                  trStructConvergence.trSubw_Up_PriceRight  = yellow1;
                  trStructConvergence.trSubw_Up_TimeRight   = time;
               }
               else if (trStructConvergence.trSubw_Up_TimeLeft == 0){
                  trStructConvergence.trSubw_Up_PriceLeft  = yellow1;
                  trStructConvergence.trSubw_Up_TimeLeft   = time;
               }
            }
            
            if (trStructConvergence.trSubw_Up_TimeLeft != 0 && trStructConvergence.trSubw_Dn_TimeLeft != 0){
               IFLOG{
                  TM.Log(
                           HEAD_TO_STRING+
                           TM.ToString(i)+", "+
                           TM.ToString("4 points")+", "+
                           trStructConvergence.ToString()+", "+
                           ToString()
                           ,shift);
               }               
               
               CheckIfConvergence(shift, HEAD_TO_STRING);
               
               break;
            }
         }
      }
   }   
   
   void CheckIfConvergence(int shift, string reason){
      trStructConvergence.GetItersection(trTimeframe, shift);
      bool  isBoth   = trStructConvergence.isValidCrossing();
      
      IFLOG{
         TM.Log(
                  HEAD_TO_STRING+
                  TM.ToString(isBoth)+", "+
                  trStructConvergence.ToString()
                  ,shift);
      }               
      
      if (isBoth){
         trStructConvergence.trIsInitialized = true;
      
         glArray_ConvergenceHandler[trIndex].AddConvergence(shift, new Convergence(shift, trIndex, trTimeframe, trStructConvergence, HEAD_TO_STRING), HEAD_TO_STRING);
      }
   }
   
   

};
ConvergenceStarter* glArray_ConvergenceStarter[];