//+------------------------------------------------------------------+
//|                                                SignalHandler.mqh |
//|                        Copyright 2017, MetaQuotes Software Corp. |
//|                                             https://www.mql5.com |
//+------------------------------------------------------------------+
#property copyright "Copyright 2017, MetaQuotes Software Corp."
#property link      "https://www.mql5.com"
#property strict

class SignalHandler{
   public:
   Signal* signals[];
   string   shName;
   
   SignalHandler(string name){
      shName   = name;
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
   
   void OnTick(int shift){
      glReason_Count_Buy   = 0;
      glReason_Count_Sell  = 0;
      for (int i = 0;i < ArrayRange(signals,0);i++){
         signals[i].CalculateOpenSignal(shift);
         
         if (signals[i].sIsReason){
            if (signals[i].openSignal_Reason == NO) continue;
            
            if (signals[i].openSignal_Reason != SELL){
               glReason_Count_Buy++;
            }
            if (signals[i].openSignal_Reason != BUY){
               glReason_Count_Sell++;
            }
         }
		}
   }
   
   SignalType GetOpenSignal(int shift){
      SignalType signal = NO;
      int q_of_buy_signals = 0;
      int q_of_sell_signals = 0;
      for (int i = 0;i < ArrayRange(signals,0);i++){
         if (signals[i].GetOpenSignal(shift) == BUY || signals[i].GetOpenSignal(shift) == BOTH){
            q_of_buy_signals++;
         }
         if (signals[i].GetOpenSignal(shift) == SELL || signals[i].GetOpenSignal(shift) == BOTH){
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
   
   void LogOpenSignal(int shift){
      for (int i = 0;i < ArrayRange(signals,0);i++){
         signals[i].LogOpenSignal(shName,shift);
      }
      TM.Log(shName+" : Open Signal "+EnumToString(GetOpenSignal(shift)),shift,Symbol());
   }
};
SignalHandler* glSignalHandler;
SignalHandler* glSignalHandler_Arrow;
SignalHandler* glSignalHandler_Arrow_Poten;

SignalHandler* glSignalHandler_Alert_PotenColorChange;
SignalHandler* glSignalHandler_Alert_LastClosedColorChange;
SignalHandler* glSignalHandler_Alert_ZoneReached;
