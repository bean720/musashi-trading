//+------------------------------------------------------------------+
//|                                                   SignalBase.mqh |
//|                        Copyright 2017, MetaQuotes Software Corp. |
//|                                             https://www.mql5.com |
//+------------------------------------------------------------------+
#property copyright "Copyright 2017, MetaQuotes Software Corp."
#property link      "https://www.mql5.com"
#property strict

//06.04.2022
interface SignalInterface{
   void CalculateOpenSignal();
   void CalculateCloseSignal();
   
   SignalType GetOpenSignal();
   SignalType GetCloseSignal();
   
   void LogOpenSignal(string shName);
   void LogCloseSignal(string shName);
};


//06.04.2022
//30.08.2022
//08.09.2022
class Signal : public SignalInterface{
   public:
   string   openStringVals[];
   //double   openVals[];
   
	string   closeStringVals[];
	//double   closeVals[];
	
	SignalType openSignal;
	SignalType closeSignal;
	
	string name;
 
   virtual void CalculateOpenSignal(){
      openSignal  = NO;
      return;
   }
   
   virtual void CalculateCloseSignal(){
      closeSignal = NO;
      return;
   }
   
   SignalType GetOpenSignal(){
      return openSignal;
	}
			
	SignalType GetCloseSignal(){
	   return closeSignal;
   }
   
   virtual void LogOpenSignal(string shName){
      string parameters = "";
      
		for (int i = 0;i < ArrayRange(openStringVals,0);i++){
         parameters += TM.ToString(openStringVals[i]) + ", ";
      }

		TM.Log(
		         TM.ToString(shName)+ ":"+
		         TM.ToString(name)+ " "+
		         "Open signal "+
		         EnumToString(openSignal)+". "+
		         "Parameters: "+
		         parameters
		         );
	}
			
	virtual void LogCloseSignal(string shName){
      string parameters = "";
      
		for (int i = 0;i < ArrayRange(closeStringVals,0);i++){
         parameters += TM.ToString(closeStringVals[i]) + ", ";
      }
		
		TM.Log(
		         TM.ToString(shName)+ ":"+
		         TM.ToString(name)+ " "+
		         "Close signal "+
		         EnumToString(closeSignal)+". "+
		         "Parameters: "+
		         parameters
		         );
	}
};