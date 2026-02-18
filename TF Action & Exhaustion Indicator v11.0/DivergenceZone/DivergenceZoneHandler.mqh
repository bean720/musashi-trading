//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
#include "..\\TradingManager.mqh"
#include "DivergenceZone.mqh"
#include "..\\Structs.mqh"
#include "..\\Sort\\QSort.mqh"

class DivergenceZoneHandler {
public:
   string               trName;

   int                  trIndex;
   ENUM_TIMEFRAMES      trTimeframe;

   DivergenceZone*         trArray_DivergenceZone[];
   
   //StructDivergenceZone    trStructDivergenceZone;
   
   datetime             trTimeLast;
   
   bool                 trIsEnableDrawn;

   DivergenceZoneHandler(int index, bool isDrawn) {
      trIndex     = index;
      trTimeframe = glArray_Timeframes[trIndex];
      trName      = "CV_" + TM.ToString(trTimeframe);
      
      UpdateIsEnableDrawn(0, isDrawn, HEAD_TO_STRING);
      
      IFLOG
         TM.Log(
            HEAD_TO_STRING +
            TM.ToString(trName) + " " +
            TM.ToString("created.") + " | " +
            ToString()
      );
   }

   void UpdateIsEnableDrawn(int shift, bool isDrawn, string reason){
      trIsEnableDrawn = isDrawn;
   
      for (int i = ArraySize(trArray_DivergenceZone) - 1; i >= 0; i--){
         if (CheckPointer(trArray_DivergenceZone[i]) != POINTER_INVALID){
            trArray_DivergenceZone[i].UpdateIsEnableDrawn(shift, isDrawn, reason+"::"+HEAD_TO_STRING);
         }
      }
   }

   SignalType GetCurrentSignal(int shift, string &msg){
      SignalType  res   = NO;
      
      for (int i = ArraySize(trArray_DivergenceZone) - 1; i >= 0; i--){
         if (CheckPointer(trArray_DivergenceZone[i]) != POINTER_INVALID){
         
            if (trArray_DivergenceZone[i].trIsFinished) break;
            
            res   = trArray_DivergenceZone[i].GetCurrentSignal(shift);
            msg += " | "+TM.ToString(trArray_DivergenceZone[i].trIndex) + " -> " + EnumToString(res)+" : "+ trArray_DivergenceZone[i].trName + " | ";
            
            if (res == NO){
               string   msg1  = "M1";
               
               res = trArray_DivergenceZone[i].GetCurrentSignal_3BarRule(shift, msg1);
               msg += " || " + msg1 + " || ";
            }
         }
      }
      
      return   res;
   }


   ~DivergenceZoneHandler() {
      for (int i = 0;i < ArrayRange(trArray_DivergenceZone,0);i++){
         delete trArray_DivergenceZone[i];
      }
      
      IFLOG
         TM.Log(
            HEAD_TO_STRING +
            TM.ToString(trName) + " " +
            TM.ToString("deleted.") + " | " +
            ToString()
      );
   }
   
   string ToString() {
      string   val   = StringFormat(" | tr:%s, SD:%s | ",
                                    trName
                                    
                                   );
      return   val;
   }

   void OnTick(int shift) {
      for (int i = ArraySize(trArray_DivergenceZone) - 1; i >= 0; i--){
         if (CheckPointer(trArray_DivergenceZone[i]) != POINTER_INVALID){
            trArray_DivergenceZone[i].OnTick(shift);     
         }
      } 
   }
   
   void AddInstance(DivergenceZone *val, int shift, string reason){
      val.UpdateIsEnableDrawn(shift, trIsEnableDrawn, reason+"::"+HEAD_TO_STRING);
   
      ArrayResize(trArray_DivergenceZone, ArrayRange(trArray_DivergenceZone,0) + 1);
      trArray_DivergenceZone[ArrayRange(trArray_DivergenceZone, 0) - 1] = GetPointer(val);
   }

};
DivergenceZoneHandler* glArray_DivergenceZoneHandler[];
//+------------------------------------------------------------------+
