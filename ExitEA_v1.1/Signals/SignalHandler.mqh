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
   string   shName;
   Signal*  signals[];
   
   SignalHandler(string name){
      shName  = name;
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
         signals[i].CalculateOpenSignal();
		}
		for (int i = 0;i < ArrayRange(signals,0);i++){
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
   
//06.04.2022
   void LogOpenSignal(){
      for (int i = 0;i < ArrayRange(signals,0);i++){
         signals[i].LogOpenSignal(shName);
      }
      TM.Log(
             TM.ToString(shName)+ " : "+
             "Open Signal = "+
             EnumToString(GetOpenSignal())
             );
   }
   
//06.04.2022
   void LogCloseSignal(){
      for (int i = 0;i < ArrayRange(signals,0);i++){
         signals[i].LogCloseSignal(shName);
      }
      TM.Log(
               TM.ToString(shName) + " : "+
               "Close Signal = "+
               EnumToString(GetCloseSignal())
               );
   }
};
SignalHandler* glSignalHandler;
