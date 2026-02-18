//+------------------------------------------------------------------+
//|                                                   SignalBase.mqh |
//|                        Copyright 2017, MetaQuotes Software Corp. |
//|                                             https://www.mql5.com |
//+------------------------------------------------------------------+
#property copyright "Copyright 2017, MetaQuotes Software Corp."
#property link      "https://www.mql5.com"
#property strict
#include "..//TradingManager.mqh"


interface SignalInterface{
   void CalculateOpenSignal(int shift);
   SignalType GetOpenSignal(int shift);
   void LogOpenSignal(string shName, int shift);
};



class Signal : public SignalInterface{
   public:
   
   string      openStringVals[];
   datetime    openDatetimeVals[];
   double      openVals[];
   
	SignalType  openSignal;
	SignalType  openSignal_Reason;
	string      name;
	
	bool        sIsReason;
   
   virtual void CalculateOpenSignal(int shift){return;}

   SignalType GetOpenSignal(int shift){
      return openSignal;
	}

   virtual void LogOpenSignal(string shName, int shift){
      SignalType signal = GetOpenSignal(shift);
      string parameters = "";
      
		for (int i = 0;i < ArrayRange(openStringVals,0);i++){
         parameters += TM.ToString(openStringVals[i]) + ", ";
      }
		for (int i = 0;i < ArrayRange(openDatetimeVals,0);i++){
         parameters += TM.ToString(openDatetimeVals[i]) + ", ";
      }
		for (int i = 0;i < ArrayRange(openVals,0);i++){
         parameters += TM.ToString(openVals[i]) + ", ";
      }
      
		TM.Log(shName+"::"+name+" Open signal "+EnumToString(openSignal)+". Parameters: "+parameters,shift,Symbol());
	}
};