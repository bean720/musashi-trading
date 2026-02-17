//+------------------------------------------------------------------+
//|                                                TradesHandler.mqh |
//|                        Copyright 2017, MetaQuotes Software Corp. |
//|                                             https://www.mql5.com |
//+------------------------------------------------------------------+
#property copyright "Copyright 2017, MetaQuotes Software Corp."
#property link      "https://www.mql5.com"
#property strict
#include "Trade.mqh"

class TradesHandler{
   public:
   Trade* trades[];
   Trade* tradesForTable[];
   
   string   thFilenameTrades;
   
   TradesHandler(){
      thFilenameTrades  = 
                           glPrefix+
                           "TH"+"_"+
                           _Symbol+"_"+
                           TM.ToString(magic_number)+"_"+
                           TM.ToString(magic_number_panel)+
                           ".txt"
                           ;
      LoadTrades();
   }
   
   ~TradesHandler(){
      SaveTrades(HEAD_TO_STRING);
      
      for (int i = 0;i < ArrayRange(trades,0);i++){
         delete trades[i];
      }
   }
   
   void AddTrade(Trade *trade){
      ArrayResize(trades,ArrayRange(trades,0)+1);
      trades[ArrayRange(trades,0)-1] = GetPointer(trade);
   }
   
   void ResetIsSelected(Trade *trade, bool state = false){
      for (int i = 0;i < ArrayRange(trades,0);i++){
         if (CheckPointer(trades[i]) != POINTER_INVALID){
            if (trades[i] != trade){
               trades[i].SetIsSelected(state,HEAD_TO_STRING);
            }
         }
		}
   }
   
   
   void OnTick(){
      for (int i = 0;i < ArrayRange(trades,0);i++){
         if (CheckPointer(trades[i]) != POINTER_INVALID){
            trades[i].OnTick();
            //if (trades[i].trIsFinished)
            //   delete trades[i];
         }
		}
   }
   
   string GetText_RTRAmount(){
      string   initialRisk    = "$"+GetText_RTRValue_InitialRisk();
      string   trailingReward = "$TX" + GetText_RTRValue_TrailingReward();
      string   initialReward  = "$"+GetText_RTRValue_InitialReward();
      
      string   val   = 
                        initialRisk + " : " +
                        trailingReward + " : " +
                        initialReward
                        ;
      
      return   val;                  
   }
   
   
   string GetText_RTRValue_InitialRisk(){
      string   val   = "-";
      double   total = 0;
      
      bool     flag  = false;
      
      for (int i = 0;i < ArrayRange(trades,0);i++){
         if (CheckPointer(trades[i]) != POINTER_INVALID){
            if (!trades[i].trIsFinished && !trades[i].trIsInvalidated){
               int      lastTicket  = trades[i].GetLastTicket();
               StructOrder order;
               order.Initialize(lastTicket);
               
               if (lastTicket > 0 && order.trType < 2){
                  flag  = true;
                  total += trades[i].GetText_RTRValue_InitialRisk_Double();
               }
            }
         }
		}
		
		if (flag)
         val   = TM.ToString(total,2);
         
      return   val;   
   }
      
   string GetText_RTRValue_InitialReward(){
      string   val   = "-";
      double   total = 0;
      
      bool     flag  = false;
      
      for (int i = 0;i < ArrayRange(trades,0);i++){
         if (CheckPointer(trades[i]) != POINTER_INVALID){
            if (!trades[i].trIsFinished && !trades[i].trIsInvalidated){
               int      lastTicket  = trades[i].GetLastTicket();
               StructOrder order;
               order.Initialize(lastTicket);
               
               if (lastTicket > 0 && order.trType < 2){
                  flag  = true;
                  total += trades[i].trInitReward_Value;
               }
            }
         }
		}
		
		if (flag)
         val   = TM.ToString(total,2);
         
      return   val;   
   }
      
   string GetText_RTRValue_TrailingReward(){
      string   val   = "-";
      double   total = 0;
      
      bool     flag  = false;
      
      for (int i = 0;i < ArrayRange(trades,0);i++){
         if (CheckPointer(trades[i]) != POINTER_INVALID){
            if (!trades[i].trIsFinished && !trades[i].trIsInvalidated){
               int      lastTicket  = trades[i].GetLastTicket();
               StructOrder order;
               order.Initialize(lastTicket);
               
               if (lastTicket > 0 && order.trType < 2){
                  flag  = true;
                  total += trades[i].GetText_RTRValue_TrailingReward_Double();
               }
            }
         }
		}
		
		if (flag)
         val   = TM.ToString(total,2);
         
      return   val;   
   }
      
   
   /*
   int SendOrders(SignalType openSignal){
      int   val   = 0;
      
      for (int i = 0;i < ArrayRange(trades,0);i++){
         if (CheckPointer(trades[i]) != POINTER_INVALID){
         TM.Log(
                  HEAD_TO_STRING+
                  EnumToString(openSignal)+", "+
                  EnumToString(trades[i].trType)+", "+
                  TM.ToString(trades[i].trStructTableParameters.trIsTableTrade)+", "+
                  TM.ToString(!trades[i].trIsFinished)+", "+
                  TM.ToString(!trades[i].trIsExpire)+", "+
                  TM.ToString(trades[i].trIsReadyToSendOrder)+", "+
                  trades[i].ToString()
                  );
         
            if (trades[i].trType == openSignal || openSignal == BOTH){
                        
               if (  
                     trades[i].GetLastTicket() <= 0 &&
                     trades[i].trStructTableParameters.trIsTableTrade &&
                     !trades[i].trIsFinished && 
                     !trades[i].trIsExpire && 
                     trades[i].trIsReadyToSendOrder){
                     
                   trades[i].TryToSendOrder(HEAD_TO_STRING);     
               }
            }
         }
		}
		
		return   val;
   }
   */
   
   bool IsTicketAdded(int ticket, string reason){
      bool  val   = false;
      
      for (int i = ArrayRange(trades,0) - 1;i >= 0;i--){
         if (CheckPointer(trades[i]) != POINTER_INVALID){
            if (TM.IsInArray(ticket,trades[i].trTickets)){
               val   = true;
               break;
            }
         }
		}
		
		return   val;
   }
   
   void ActionJustClosingByTicket(int ticket, string reason){
      if (number_of_trades > 0) return;
   
      for (int i = ArrayRange(trades,0) - 1;i >= 0;i--){
         if (CheckPointer(trades[i]) != POINTER_INVALID){
            if (trades[i].GetLastTicket() == ticket){
               trades[i].SetIsFinished(true,HEAD_TO_STRING+"::"+reason);
               break;
            }
         }
		}
		
		if (CheckPointer(glPanel) != POINTER_INVALID)
         glPanel.UpdateMainLines();
   }
   
   void PrepairTradesForTable(){
      ArrayResize(tradesForTable,0);
      
      for (int i = 0;i < ArrayRange(trades,0);i++){
         if (CheckPointer(trades[i]) != POINTER_INVALID){
            if (!trades[i].trIsFinished){
               TM.AddInArrayClass(tradesForTable,trades[i]);
            }
         }
		}
   }
   
   
   
   void OnClickButton_Close(string reason){
      Trade *tr = GetTradeSelected();
      
      if (CheckPointer(tr) != POINTER_INVALID){
         
         tr.OnClickButton_Close(HEAD_TO_STRING+"::"+reason);
         
         //tr.SetIsSelected(false,HEAD_TO_STRING);
         //tr.SetIsFinished(true,HEAD_TO_STRING);
      }
      
   }
   
   Trade * GetTradeSelected(){
      Trade  *val   = NULL;
      
      for (int i = ArrayRange(trades,0) - 1;i >= 0;i--){
         if (CheckPointer(trades[i]) != POINTER_INVALID){
            if (!trades[i].trIsFinished && trades[i].trIsSelected){
               val   = trades[i];
               break;
            }
         }
		}
		
      return   val;
   }
   
   void LoadTrades(){
      string   filename = thFilenameTrades;
      LOG(
               "Loading trades from the file: "+
               filename
               );
      string sep  = FILE_SEP_LEVEL_TRADES;         
      int   file_handle = FileOpen(filename,FILE_READ|FILE_TXT,sep);
      int   q           = 0;
      while (!FileIsEnding(file_handle)){
         string str = FileReadString(file_handle);
         Trade* new_trade = new Trade(str);
         
         if (new_trade.trIsPanel){
            delete   new_trade;
            TradePanel* tradePanel  = new TradePanel(str);
            AddTrade(tradePanel);
         }
         else{
            AddTrade(new_trade);
         }
         
         q++;
      }
      FileClose(file_handle);
      FileDelete(filename);
      
      LOG(
               "Trades restored. ->"+
               TM.ToString(q)+", "+
               TM.ToString(file_handle)
               );
      
   }
   
   void SaveTrades(string reason){
      string filename   = thFilenameTrades;
      LOG(
               "Saving trades to file: "+
               TM.ToString(filename)+", "+
               TM.ToString(reason)
               );
      
      ResetIsSelected(NULL);         
               
      string sep  = FILE_SEP_LEVEL_TRADES;         
      int file_handle = FileOpen(filename,FILE_WRITE|FILE_TXT,sep);
      int   count = 0;
      for (int i = 0;i < ArrayRange(trades,0);i++){
         if (CheckPointer(trades[i]) != POINTER_INVALID && !trades[i].trIsFinished){
            count++;
            FileWrite(file_handle,trades[i].Save());
         }
      }
      FileFlush(file_handle);
      FileClose(file_handle);
      
      LOG(
               "Try to save th. -> "+ 
               TM.ToString(count)+", "+
               TM.ToString(file_handle)
               );
      
   }
   
   void OnChartEvent(const int id,        
                     const long& lparam,   
                     const double& dparam,  
                     const string& sparam  
                     ){
      for (int i = 0;i < ArrayRange(trades,0);i++){
         if (CheckPointer(trades[i]) != POINTER_INVALID){
            if (!trades[i].trIsFinished){
               trades[i].OnChartEvent(id,lparam,dparam,sparam);
            }
         }
		}
   }
};
TradesHandler* glTradesHandler;
