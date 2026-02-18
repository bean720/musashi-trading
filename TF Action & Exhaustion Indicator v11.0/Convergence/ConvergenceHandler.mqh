//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
#include "..\\TradingManager.mqh"
#include "Convergence.mqh"
#include "..\\Structs.mqh"
#include "..\\Sort\\QSort.mqh"

class ConvergenceHandler {
public:
   string               trName;

   int                  trIndex;
   ENUM_TIMEFRAMES      trTimeframe;

   Convergence*         trArray_Convergence[];
   
   StructConvergence    trStructConvergence;
   
   datetime             trTimeLast;
   
   bool                 trIsEnableDrawn;

   ConvergenceHandler(int index, bool isDrawn) {
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

   ~ConvergenceHandler() {
      for (int i = 0;i < ArrayRange(trArray_Convergence,0);i++){
         delete trArray_Convergence[i];
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
                                    trName,
                                    
                                    trStructConvergence.ToString()
                                   );
      return   val;
   }

   void OnTick(int shift) {
      for (int i = ArraySize(trArray_Convergence) - 1; i >= 0; i--){
         if (CheckPointer(trArray_Convergence[i]) != POINTER_INVALID){
            trArray_Convergence[i].OnTick(shift);     
         }
      } 
      
      SortConvergences(shift);  
      
      DrawObjects(shift);
   }
   
   void OnTick_Alert(int shift) {
      for (int i = ArraySize(trArray_Convergence) - 1; i >= 0; i--){
         if (CheckPointer(trArray_Convergence[i]) != POINTER_INVALID){
            trArray_Convergence[i].OnTick_Alert(shift);     
         }
      } 
   }   
   
   void DrawObjects(int shift){
      if (show_convergence != EnumShowConvergence_All){
         for (int i = ArraySize(trArray_Convergence) - 1; i >= 0; i--){
            if (CheckPointer(trArray_Convergence[i]) != POINTER_INVALID){
               trArray_Convergence[i].UpdateIsReadyForDrawn(shift, false, HEAD_TO_STRING);     
            }
         } 
         
         if (show_convergence == EnumShowConvergence_OnlyUpcomming){
            Draw_OnlyUpcomming(shift, true);
         }
         if (show_convergence == EnumShowConvergence_LastTwo){
            Draw_TwoLast(shift, true);
         }
      }
      
      for (int i = ArraySize(trArray_Convergence) - 1; i >= 0; i--){
         if (CheckPointer(trArray_Convergence[i]) != POINTER_INVALID){
            trArray_Convergence[i].ActionDrawing(HEAD_TO_STRING);
         }
      }   
   }
   
   void Draw_OnlyUpcomming(int shift, bool isDrawn){
      
      datetime time  = iTime(_Symbol, trTimeframe, 0);
      
      for (int i = ArraySize(trArray_Convergence) - 1; i >= 0; i--){
         if (CheckPointer(trArray_Convergence[i]) != POINTER_INVALID){
            if (trArray_Convergence[i].trStructConvergence.trStructPoint_ExactCross.trTime > time){
               trArray_Convergence[i].UpdateIsReadyForDrawn(shift, isDrawn, HEAD_TO_STRING);
            }
            else{
               break;
            }
         }
      }
      
   }

   void UpdateIsEnableDrawn(int shift, bool isDrawn, string reason){
      trIsEnableDrawn = isDrawn;
   
      for (int i = ArraySize(trArray_Convergence) - 1; i >= 0; i--){
         if (CheckPointer(trArray_Convergence[i]) != POINTER_INVALID){
            trArray_Convergence[i].UpdateIsEnableDrawn(shift, isDrawn, reason+"::"+HEAD_TO_STRING);
         }
      }
   }

   void UpdateIsInvalidFor_LastTwo_Mode(int shift, bool val, datetime time, string reason){
      for (int i = ArraySize(trArray_Convergence) - 1; i >= 0; i--){
         if (CheckPointer(trArray_Convergence[i]) != POINTER_INVALID){
            if (trArray_Convergence[i].trStructConvergence.trStructPoint_ExactCross.trTime > time)
               trArray_Convergence[i].UpdateIsInvalidFor_LastTwo_Mode(shift, val, reason+"::"+HEAD_TO_STRING);
         }
      }
   }

   void Draw_TwoLast(int shift, bool isDrawn){
      Convergence* hist   = GetNearestHistoryConvergence(shift);
      Convergence* real   = GetNearestFutureConvergence(shift);
      
      if (IS_NOT_NULL(hist)){
         hist.UpdateIsReadyForDrawn(shift, isDrawn, HEAD_TO_STRING);
      }
      if (IS_NOT_NULL(real)){
         real.UpdateIsReadyForDrawn(shift, isDrawn, HEAD_TO_STRING);
      }
      
   }

   
   Convergence* GetNearestFutureConvergence(int shift){
      Convergence* val   = NULL;
      
      datetime time  = iTime(_Symbol, trTimeframe, 0);
      
      for (int i = ArraySize(trArray_Convergence) - 1; i >= 0; i--){
         if (CheckPointer(trArray_Convergence[i]) != POINTER_INVALID && !trArray_Convergence[i].trIsInvalidFor_All_Modes){
            if (trArray_Convergence[i].trStructConvergence.trStructPoint_ExactCross.trTime > time){
               val   = trArray_Convergence[i];
            }
            else{
               break;
            }
         }
      }
      
      return   val;
   }

   Convergence* GetNearestHistoryConvergence(int shift){
      Convergence* val   = NULL;
      
      datetime time  = iTime(_Symbol, trTimeframe, 0);
      
      for (int i = ArraySize(trArray_Convergence) - 1; i >= 0; i--){
         if (CheckPointer(trArray_Convergence[i]) != POINTER_INVALID && !trArray_Convergence[i].trIsInvalidFor_All_Modes){
            if (trArray_Convergence[i].trStructConvergence.trStructPoint_ExactCross.trTime <= time){
               val   = trArray_Convergence[i];
               break;
            }
         }
      }
      
      return   val;
   }

   void SortConvergences(int shift){
      QSort::QuickSort(trArray_Convergence);
   }
   
   void AddConvergence(int shift, Convergence *val, string reason){
      val.UpdateIsEnableDrawn(shift, trIsEnableDrawn, reason+"::"+HEAD_TO_STRING);
      
      datetime time        = iTime(_Symbol, trTimeframe, shift);
      datetime crossTime   = val.trStructConvergence.trStructPoint_ExactCross.trTime;
      bool     isFuture    = crossTime > time;
      
      IFLOG
         TM.Log(
            HEAD_TO_STRING +
            TM.ToString(isFuture) + ", " +
            TM.ToString(crossTime) + ", " +
            TM.ToString(time) + ", " +
            ToString()
      ,shift);
      
      if (isFuture){
         UpdateIsInvalidFor_LastTwo_Mode(shift, true, crossTime, reason +"::"+HEAD_TO_STRING);
      }   
      
      ArrayResize(trArray_Convergence, ArrayRange(trArray_Convergence,0) + 1);
      trArray_Convergence[ArrayRange(trArray_Convergence, 0) - 1] = GetPointer(val);
   }
   
   Convergence* GetLastConvergence(SignalType type){
      Convergence* val   = NULL;
      
      for (int i = ArraySize(trArray_Convergence) - 1; i >= 0; i--){
         if (CheckPointer(trArray_Convergence[i]) != POINTER_INVALID){
            if (trArray_Convergence[i].trSignalType == type || type == BOTH){
               val   = trArray_Convergence[i];
               break;
            }
         }
      }
      
      return   val;
   }

};
ConvergenceHandler* glArray_ConvergenceHandler[];
//+------------------------------------------------------------------+
