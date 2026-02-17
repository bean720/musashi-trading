//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
#property strict
#include "CTradeGroup.mqh"

//---

class CTradeGroupsHandler{
   public:
   string   trName;
   CTradeGroup*   cTradeGroups[];
   
   //string   thFilenameCTradeGroups;
   
   CTradeGroupsHandler(string msg, bool isLoad){
      if (isLoad){
         LoadCTradeGroups(msg);
         return;
      }
      trName            = msg;
      //thFilenameCTradeGroups  = glPrefix+"_"+"TRGH"+"_"+_Symbol+"_"+TM.ToString(magic_number)+".csv";
   }
   
   ~CTradeGroupsHandler(){
      for (int i = 0;i < ArrayRange(cTradeGroups,0);i++){
         delete cTradeGroups[i];
      }
   }
   
   int GetTotalTrades(){
      return ArraySize(cTradeGroups);
   }
   
   int DeleteGlobals(string reason){
      int   result   = 0;
      
      for (int i = ArraySize(cTradeGroups) - 1; i >= 0; i--){
         if (!cTradeGroups[i].trIsFinished){
            cTradeGroups[i].DeleteGlobalVal(reason+"::"+HEAD_TO_STRING);
            result++;
         }
      }
      
      return   result;
   }
   
   int CreateGlobals(string reason){
      int   result   = 0;
      
      for (int i = ArraySize(cTradeGroups) - 1; i >= 0; i--){
         if (!cTradeGroups[i].trIsFinished){
            cTradeGroups[i].CreateGlobalVal(reason+"::"+HEAD_TO_STRING);
            result++;
         }
      }
      
      return   result;
   }
   
   int GetTotalTrades_Market(){
      int   result   = 0;
      
      for (int i = ArraySize(cTradeGroups) - 1; i >= 0; i--){
         if (!cTradeGroups[i].trIsFinished){
            result++;
         }
      }
      
      return   result;
   }
   
   void AddCTradeGroup(CTradeGroup *cTradeGroup){
      ArrayResize(cTradeGroups,ArrayRange(cTradeGroups,0)+1);
      cTradeGroups[ArrayRange(cTradeGroups,0)-1] = GetPointer(cTradeGroup);
   }
   
   void OnTick(){
      for (int i = 0;i < ArrayRange(cTradeGroups,0);i++){
         if (CheckPointer(cTradeGroups[i]) != POINTER_INVALID){
            cTradeGroups[i].OnTick();
            //if (cTradeGroups[i].trIsFinished)
            //   delete cTradeGroups[i];
         }
		}
   }
   
   bool IsFinished(){
      bool  result   = true;
      
      int   size  = ArrayRange(cTradeGroups,0);
      
      if (size <= 0){
         result   = false;
      }
      
      for (int i = 0;i < size;i++){
         if (CheckPointer(cTradeGroups[i]) != POINTER_INVALID){
            if (!cTradeGroups[i].trIsFinished){
               result   = false;
               break;
            }
         }
		}
		return   result;
   }
   
   
   CTradeGroup *GetLastTradeGroup(){
      CTradeGroup* result  = NULL;
      for (int i = ArrayRange(cTradeGroups,0) - 1;i >= 0;i--){
         if (CheckPointer(cTradeGroups[i]) != POINTER_INVALID && !cTradeGroups[i].trIsFinished){
            result   = cTradeGroups[i];
            break;
         }
		}
		return   result;
   }
   
   CTradeGroup *GetFirstTradeGroup(){
      CTradeGroup* result  = NULL;
      for (int i = 0;i < ArrayRange(cTradeGroups,0);i++){
         if (CheckPointer(cTradeGroups[i]) != POINTER_INVALID && !cTradeGroups[i].trIsFinished){
            result   = cTradeGroups[i];
            break;
         }
		}
		return   result;
   }
   
   int GetFirstTicketMarket(){
      int   result   = 0;
      
      for (int i = 0;i < ArrayRange(cTradeGroups,0);i++){
         if (CheckPointer(cTradeGroups[i]) != POINTER_INVALID){
            
            int   size  = ArraySize(cTradeGroups[i].trTickets);
            
            for (int y = 0; y < size; y++){
               StructOrder order;
               order.Initialize(cTradeGroups[i].trTickets[y]);
               
               if (order.trType < 2){
                  result   = order.trTicket;
                  return   result;
               }
            }
         }
		}
		
		return   result;
   }
   
   void ActionBreakEven(StructTableParameters& trStructTableParameters, string reason){
      int   result   = 0;
      for (int i = 0;i < ArrayRange(cTradeGroups,0);i++){
         if (CheckPointer(cTradeGroups[i]) != POINTER_INVALID && !cTradeGroups[i].trIsFinished){
            result += cTradeGroups[i].ActionBreakEven(trStructTableParameters, reason+"::"+HEAD_TO_STRING);
         }
      }
   }
   
   void ActionBreakEven_ByCandle(StructTableParameters& trStructTableParameters, string reason){
      int   result   = 0;
      for (int i = 0;i < ArrayRange(cTradeGroups,0);i++){
         if (CheckPointer(cTradeGroups[i]) != POINTER_INVALID && !cTradeGroups[i].trIsFinished){
            result += cTradeGroups[i].ActionBreakEven_ByCandle(trStructTableParameters, reason+"::"+HEAD_TO_STRING);
         }
      }
   }
   
   void ActionTrailingStop(StructTableParameters& trStructTableParameters, string reason){
      int   result   = 0;
      for (int i = 0;i < ArrayRange(cTradeGroups,0);i++){
         if (CheckPointer(cTradeGroups[i]) != POINTER_INVALID && !cTradeGroups[i].trIsFinished){
            result += cTradeGroups[i].ActionTrailingStop(trStructTableParameters, reason+"::"+HEAD_TO_STRING);
         }
      }
   }
   
   
   int DestroyGroups(string reason){
      int   result   = 0;
   
      for (int i = 0;i < ArrayRange(cTradeGroups,0);i++){
         if (CheckPointer(cTradeGroups[i]) != POINTER_INVALID && !cTradeGroups[i].trIsFinished){
            result += cTradeGroups[i].DestroyGroup(reason+"::"+HEAD_TO_STRING);
         }
      }
      
      return   result;   
   }
   
   void LoadCTradeGroups(string str){
      //string   filename = thFilenameCTradeGroups;
      LOG(
               "Loading cTradeGroups from the file: "+
               TM.ToString(str)
               );
               
      string   sep_lvl  = FILE_SEP_LEVEL_1;
      string   support[];
      TM.ParseStringToArray(str,support,sep_lvl);
      
      int   count  = 0;
      trName                  = support[count++];
      string   trades         = support[count++];    
               
               
      string   sep_trades     = FILE_SEP_LEVEL_3;
      string   supportTrades[];
      TM.ParseStringToArray(trades,supportTrades,sep_trades);
      
      int   size  = ArraySize(supportTrades);
      int   q     = 0;
      
      LOG(
            TM.ToString(trades)
            );
      LOG(
            TM.ToString(size)
            );
      
      for (int i = 0; i < size; i++){
         q++;
         string   newStr   = supportTrades[i];
         
         LOG(
               TM.ToString(newStr)
               );
         
         LOG(
               TM.ToString(newStr == "")+", "+
               TM.ToString(newStr == NULL)+", "+
               TM.ToString(TM.ToString(newStr) == "Null_String")
               );
         
         if (newStr == "" || newStr == NULL || TM.ToString(newStr) == "Null_String") continue;
         
         CTradeGroup* new_cTradeGroup = new CTradeGroup(newStr);
         AddCTradeGroup(new_cTradeGroup);
      }        
      
      LOG(
               "CTradeGroups restored. ->"+
               TM.ToString(q)
               );
      
   }
   
   void SaveCTradeGroups(){

//      LOG(
//               "Saving cTradeGroups to file: "+
//               filename
//               );
//      int file_handle = FileOpen(filename,FILE_WRITE|FILE_CSV,';');
//      for (int i = 0;i < ArrayRange(cTradeGroups,0);i++){
//         if (CheckPointer(cTradeGroups[i]) != POINTER_INVALID){
//            FileWrite(file_handle,cTradeGroups[i].SaveString());
//         }
//      }
//      FileFlush(file_handle);
//      FileClose(file_handle);
//      
//      TM.Log(
//               HEAD_TO_STRING+
//               "Try to save th. -> "+ 
//               TM.ToString(file_handle)
//               );
//      
   }
   
   string SaveString(){
      LOG(
               "Saving cTradeGroups to file "
               );
      
      string   result   = "";
      string   sep_lvl  = FILE_SEP_LEVEL_3;
      
      for (int i = 0;i < ArrayRange(cTradeGroups,0);i++){
         if (CheckPointer(cTradeGroups[i]) != POINTER_INVALID){
            result   += cTradeGroups[i].SaveString()+sep_lvl;
         }
      }
      
      LOG(
               "Try to save -> "+ 
               TM.ToString(result)
               );
      
      int   length   = StringLen(result);
      if (length > 0){
         StringSetLength(result,length-1);
      }

      LOG(
               "Try to save -> "+ 
               TM.ToString(result)
               );
               
      return   result;         
   }   
   
};
CTradeGroupsHandler* glCTradeGroupsHandler;
