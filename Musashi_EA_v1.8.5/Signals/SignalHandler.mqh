//+------------------------------------------------------------------+
//|                                                SignalHandler.mqh |
//|                        Copyright 2017, MetaQuotes Software Corp. |
//|                                             https://www.mql5.com |
//+------------------------------------------------------------------+
#property copyright "Copyright 2017, MetaQuotes Software Corp."
#property link      "https://www.mql5.com"
#property strict
#include "Signals.mqh"
#include "SignalBase.mqh"


class SignalHandler{
   public:
   string   sh_name;
   Signal*  signals[];
   
   SignalHandler(string name){
      sh_name  = name;
   }
   
   ~SignalHandler(){
      for (int i = 0;i < ArrayRange(signals,0);i++){
         delete signals[i];
      }
   }
   
   void AddSignal(Signal *signal){
      ArrayResize(signals,ArrayRange(signals,0)+1);
      signals[ArrayRange(signals,0)-1] = GetPointer(signal);
   }
   
   void OnTick(){
      for (int i = 0;i < ArrayRange(signals,0);i++){
        // TM.Log(
        //          HEAD_TO_STRING+
        //          TM.ToString(i)+", "+
       //           TM.ToString(ArrayRange(signals,0))+", "+
       //           TM.ToString(signals[i].name)
       //           );
         signals[i].CalculateOpenSignal();
		}
		for (int i = 0;i < ArrayRange(signals,0);i++){
         //TM.Log(
        //          HEAD_TO_STRING+
        //          TM.ToString(i)+", "+
        //          TM.ToString(ArrayRange(signals,0))+", "+
        //          TM.ToString(signals[i].name)
        //          );
         signals[i].CalculateCloseSignal();
		}
   }
   
   SignalType GetOpenSignal(){
      SignalType signal = NO;
      int q_of_buy_signals = 0;
      int q_of_sell_signals = 0;
      for (int i = 0;i < ArrayRange(signals,0);i++){
         if (signals[i].GetOpenSignal() == BUY || signals[i].GetOpenSignal() == BOTH){
            q_of_buy_signals++;
         }
         if (signals[i].GetOpenSignal() == SELL || signals[i].GetOpenSignal() == BOTH){
            q_of_sell_signals++;
         }
      }
      if (q_of_buy_signals == ArrayRange(signals,0)){
         signal = BUY;
      }
      if (q_of_sell_signals == ArrayRange(signals,0)){
         signal = SELL;
      }
      if (q_of_buy_signals == ArrayRange(signals,0) && q_of_sell_signals == ArrayRange(signals,0)){
         signal = BOTH;
      }
      return signal;
   }
   
   void LogOpenSignal_ExceptSkipped(){
      TM.Log(
               "------"
               );
               
      for (int i = 0;i < ArrayRange(signals,0);i++){
         if (signals[i].trIsReadyForSkipping) continue;
      
         signals[i].LogOpenSignal();
      }
      TM.Log(
               sh_name + 
               " : ES: Open Signal = "+
               EnumToString(GetOpenSignal_ExceptSkipped())
               );
      TM.Log(
               "------"
               );
   }
   
   
   SignalType GetOpenSignal_ExceptSkipped(){
   
      SignalType signal = NO;
      
      int   q_of_buy_signals  = 0;
      int   q_of_sell_signals = 0;
      int   total             = 0;
      
      for (int i = 0;i < ArrayRange(signals,0);i++){
         if (signals[i].trIsReadyForSkipping) continue;
         
         total++;
         
         if (signals[i].GetOpenSignal() == BUY || signals[i].GetOpenSignal() == BOTH){
            q_of_buy_signals++;
         }
         if (signals[i].GetOpenSignal() == SELL || signals[i].GetOpenSignal() == BOTH){
            q_of_sell_signals++;
         }
      }
      if (q_of_buy_signals == total){
         signal = BUY;
      }
      if (q_of_sell_signals == total){
         signal = SELL;
      }
      if (q_of_buy_signals == total && q_of_sell_signals == total){
         signal = BOTH;
      }
      return signal;
   }
      
   SignalType GetCloseSignal(){
      SignalType signal = NO;
      int q_of_buy_signals = 0;
      int q_of_sell_signals = 0;
      for (int i = 0;i < ArrayRange(signals,0);i++){
         if (signals[i].GetCloseSignal() == BUY || signals[i].GetCloseSignal() == BOTH){
            q_of_buy_signals++;
         }
         if (signals[i].GetCloseSignal() == SELL || signals[i].GetCloseSignal() == BOTH){
            q_of_sell_signals++;
         }
      }
      if (q_of_buy_signals > 0){
         signal = BUY;
      }
      if (q_of_sell_signals > 0){
         signal = SELL;
      }
      if (q_of_buy_signals > 0 && q_of_sell_signals > 0){
         signal = BOTH;
      }
      return signal;
   }
   
   void LogOpenSignal(){
      for (int i = 0;i < ArrayRange(signals,0);i++){
         signals[i].LogOpenSignal();
      }
      TM.Log(
               sh_name + 
               " : Open Signal = "+
               EnumToString(GetOpenSignal())
               );
   }
   
   void LogCloseSignal(){
      for (int i = 0;i < ArrayRange(signals,0);i++){
         signals[i].LogCloseSignal();
      }
      TM.Log(sh_name + " : Close Signal = "+EnumToString(GetCloseSignal()));
   }
};
SignalHandler* signal_handler;
SignalHandler* signal_handler_trade_exit_indicator;
SignalHandler* signal_handler_exit_atr;
//SignalHandler* signal_handler_scale;
SignalHandler* signal_handler_loss_rec;

SignalHandler* signal_handler_exit_profit;
SignalHandler* signal_handler_exit_all;

SignalHandler* glSignalHandler_TradePanelNoIndicator;


//SignalHandler* glSignalHandlerMbfxPyr;

