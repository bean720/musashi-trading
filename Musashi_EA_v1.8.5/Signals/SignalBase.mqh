//+------------------------------------------------------------------+
//|                                                   SignalBase.mqh |
//|                        Copyright 2017, MetaQuotes Software Corp. |
//|                                             https://www.mql5.com |
//+------------------------------------------------------------------+
#property copyright "Copyright 2017, MetaQuotes Software Corp."
#property link      "https://www.mql5.com"
#property strict

interface SignalInterface{
   void CalculateOpenSignal();
   void CalculateCloseSignal();
   SignalType GetOpenSignal();
   SignalType GetCloseSignal();
   void LogOpenSignal();
   void LogCloseSignal();
};



class Signal : public SignalInterface{
   public:
   string   openStringVals[];
   datetime openDatetimeVals[];
   double   openVals[];
   
	string   closeStringVals[];
	datetime closeDatetimeVals[];
	double   closeVals[];
	
	SignalType  openSignal;
	SignalType  closeSignal;
	string      name;
	
	bool        trIsReadyForSkipping;
   
   virtual void CalculateOpenSignal(){return;}
   
   virtual void CalculateCloseSignal(){return;}
   
   SignalType GetOpenSignal(){
      return openSignal;
	}
			
	SignalType GetCloseSignal(){
	   return closeSignal;
   }
   
   virtual void LogOpenSignal(){
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
		TM.Log(name+" Open signal "+EnumToString(openSignal)+". Parameters: "+parameters);
	}
			
	virtual void LogCloseSignal(){
      string parameters = "";
		for (int i = 0;i < ArrayRange(closeStringVals,0);i++){
         parameters += TM.ToString(closeStringVals[i]) + ", ";
      }
		for (int i = 0;i < ArrayRange(closeDatetimeVals,0);i++){
         parameters += TM.ToString(closeDatetimeVals[i]) + ", ";
      }
		for (int i = 0;i < ArrayRange(closeVals,0);i++){
         parameters += TM.ToString(closeVals[i]) + ", ";
      }
		TM.Log(name+" Close signal "+EnumToString(closeSignal)+". Parameters: "+parameters);
	}
};