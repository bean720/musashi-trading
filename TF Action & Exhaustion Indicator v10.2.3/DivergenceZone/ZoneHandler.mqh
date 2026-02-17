//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
#include "..\\TradingManager.mqh"
#include "Zone.mqh"
#include "..\\Structs.mqh"
#include "..\\Sort\\QSort.mqh"

class ZoneHandler {
public:
   string               trName;

   int                  trIndex;
   ENUM_TIMEFRAMES      trTimeframe;

   Zone*         trArray_Zone[];
   
   //StructZone    trStructZone;
   
   datetime             trTimeLast;
   
   bool                 trIsEnableDrawn;

   ZoneHandler(int index, bool isDrawn) {
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
   
      for (int i = ArraySize(trArray_Zone) - 1; i >= 0; i--){
         if (CheckPointer(trArray_Zone[i]) != POINTER_INVALID){
            trArray_Zone[i].UpdateIsEnableDrawn(shift, isDrawn, reason+"::"+HEAD_TO_STRING);
         }
      }
   }

   ~ZoneHandler() {
      for (int i = 0;i < ArrayRange(trArray_Zone,0);i++){
         delete trArray_Zone[i];
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
      for (int i = ArraySize(trArray_Zone) - 1; i >= 0; i--){
         if (CheckPointer(trArray_Zone[i]) != POINTER_INVALID){
            trArray_Zone[i].OnTick(shift);   
            break;  
         }
      } 
   }
   
   void AddInstance(Zone *val, int shift, string reason){
      val.UpdateIsEnableDrawn(shift, trIsEnableDrawn, reason+"::"+HEAD_TO_STRING);
   
      ArrayResize(trArray_Zone, ArrayRange(trArray_Zone,0) + 1);
      trArray_Zone[ArrayRange(trArray_Zone, 0) - 1] = GetPointer(val);
   }

   Zone* GetLast(){
      Zone* val   = NULL;
      
      for (int i = ArraySize(trArray_Zone) - 1; i >= 0; i--){
         if (CheckPointer(trArray_Zone[i]) != POINTER_INVALID){
            val   = trArray_Zone[i];
            break;
         }
      }
      
      return   val;
   }

};
//+------------------------------------------------------------------+
