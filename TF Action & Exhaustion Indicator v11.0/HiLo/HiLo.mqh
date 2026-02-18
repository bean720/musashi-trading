//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
#include "..\\TradingManager.mqh"
#include "..\\Structs.mqh"

#include "..\\HiLo//HiLo.mqh"


#include <ChartObjects\\ChartObjectsArrows.mqh>

class CHiLo{
   public:
   string            trObjBaseName;
   
   datetime          trLastDayTime;
   
   StructPoint_HiLo  trStructPoint_HiLo_Highest;
   StructPoint_HiLo  trStructPoint_HiLo_Lowest;

   StructHiLoLineParam  trStructHiLoLineParam_Highest;
   StructHiLoLineParam  trStructHiLoLineParam_Lowest;


   string ToString(){
      string   val   = StringFormat(" | CHiLo: ldt:%s, h:%s, l:%s, ph:%s, pl:%s | ",
                                       
                                       TM.ToString(trLastDayTime),
                                       trStructPoint_HiLo_Highest.ToString(),
                                       trStructPoint_HiLo_Lowest.ToString(),
                                       trStructHiLoLineParam_Highest.ToString(),
                                       trStructHiLoLineParam_Lowest.ToString()
                                       );
      return   val;                        
   }
   
   CHiLo()
   {
      trLastDayTime        = 0;
      
      string   obName      = 
                              "HiLo"+"_"+
                              TM.ToString(_Period)+"_"
                              ;
                              
      trObjBaseName        = glPrefix + obName;   
      
      trStructHiLoLineParam_Highest.Initialize(hilo_clr_high, hilo_width_high);
      trStructHiLoLineParam_Lowest.Initialize(hilo_clr_low, hilo_width_low);
      
      
      IFLOG{
         TM.Log(
               HEAD_TO_STRING+
               TM.ToString(trObjBaseName)
               ,0);   
      } 
   }
   
   void ResetPoints(){
      ZeroMemory(trStructPoint_HiLo_Highest);
      ZeroMemory(trStructPoint_HiLo_Lowest);
   }
   
   void OnTick(int shift){
      
      datetime timeBase    = iTime(_Symbol, _Period, shift);
      int      barCur      = iBarShift(_Symbol, PERIOD_D1, timeBase);
      datetime time        = iTime(_Symbol, PERIOD_D1, barCur);
      
      if (time != trLastDayTime){
         trLastDayTime  = time;
         ResetPoints();
      }
      
      double   high  = iHigh(_Symbol,_Period,shift);
      double   low   = iLow(_Symbol,_Period,shift);
      
      if (!trStructPoint_HiLo_Highest.trIsInitialized){
         trStructPoint_HiLo_Highest.Initialize(shift, "H", high, timeBase, time, trStructHiLoLineParam_Highest, HEAD_TO_STRING);
      }
      if (high > trStructPoint_HiLo_Highest.trPrice){
         trStructPoint_HiLo_Highest.Initialize(shift, "H", high, timeBase, time, trStructHiLoLineParam_Highest, HEAD_TO_STRING);
      }
      
      if (!trStructPoint_HiLo_Lowest.trIsInitialized){
         trStructPoint_HiLo_Lowest.Initialize(shift, "L", low, timeBase, time, trStructHiLoLineParam_Lowest, HEAD_TO_STRING);
      }
      if (low < trStructPoint_HiLo_Lowest.trPrice){
         trStructPoint_HiLo_Lowest.Initialize(shift, "L", low, timeBase, time, trStructHiLoLineParam_Lowest, HEAD_TO_STRING);
      }
      
   }
};
CHiLo *glCHiLo;
