//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
#include "..\\TradingManager.mqh"
#include "..\\Structs.mqh"

#include "DivergenceZone.mqh"
#include "DivergenceZoneHandler.mqh"

class DivergenceZoneStarter{
   public:
   string            trName;
   string            trObjBaseName;
   
   int               trIndex;
   ENUM_TIMEFRAMES   trTimeframe;
   
   datetime          trTimeLast;
   
   StructConvergence trStructConvergence;
   
   DivergenceZoneStarter(
               int               index,
               
               int               shift
               )
   {
      trIndex              = index;
      trTimeframe          = glArray_Timeframes[trIndex];
      
      trName               = 
                              "DZS"+"_"+
                              TM.ToString(trTimeframe)+"_"
                              ;
                              
      trObjBaseName        = glPrefix + "DZS_"+ TM.ToString(trTimeframe);                     
                              
                              
      IFLOG
         TM.Log(  
               HEAD_TO_STRING+
               TM.ToString(trName)+" "+
               TM.ToString("created.")+" | "+
               ToString()
               ,shift);
   }
   
   ~DivergenceZoneStarter(){
      IFLOG
         TM.Log(  
               HEAD_TO_STRING+
               TM.ToString(trName)+" "+
               TM.ToString("deleted.")+" | "+
               ToString()
               );
      
      ObjectsDeleteAll(0, trObjBaseName);         
   }
   
   string ToString(){
      string   val   = StringFormat(" | DivZoneStarter: tN:%s, SC:%s | ",
                              trName,
                              trStructConvergence.ToString()
                              );
      return   val;                        
   }
   
   void OnTick(int shift){
      FindNewPeak(shift);
   }
   
   void FindNewPeak(int shift){
   
      datetime timeBase = iTime(_Symbol, _Period, shift);
      int      bar      = iBarShift(_Symbol, trTimeframe, timeBase);
      
      //only closed candles
               bar      = MathMax(bar, 1);
      
      datetime time     = iTime(_Symbol, trTimeframe, bar+1);
      
      if (time <= trTimeLast) return;
      trTimeLast        = time;
      
      double   yellow0  = TM.GetIndicator_Mdfx(trIndex,0,bar);
      double   yellow1  = TM.GetIndicator_Mdfx(trIndex,0,bar+1);
      
      double   green0   = TM.GetIndicator_Mdfx(trIndex,1,bar);
      double   green1   = TM.GetIndicator_Mdfx(trIndex,1,bar+1);
      
      double   red0     = TM.GetIndicator_Mdfx(trIndex,2,bar);
      double   red1     = TM.GetIndicator_Mdfx(trIndex,2,bar+1);
      
      bool     isBuy    = red1 != EMPTY_VALUE && red0 == EMPTY_VALUE;
      bool     isSell   = green1 != EMPTY_VALUE && green0 == EMPTY_VALUE;
      
      IFLOG{
         TM.Log(
                  HEAD_TO_STRING+
                  TM.ToString(time)+", "+
                  TM.ToString(bar)+", "+
                  TM.ToString(timeBase)+", "+
                  ToString()
                  ,shift);
                  
         TM.Log(
                  HEAD_TO_STRING+
                  TM.ToString(isBuy)+", "+
                  TM.ToString(isSell)+", "+
                  TM.ToString(green0)+", "+
                  TM.ToString(green1)+", "+
                  TM.ToString(red0)+", "+
                  TM.ToString(red1)+", "+
                  ToString()
                  ,shift);
      }
      
      
      if (isBuy || isSell){
      
         SignalType  signal   = isBuy ? BUY : SELL;
         glArray_DivergenceZoneHandler[trIndex].AddInstance(
            new DivergenceZone(
               shift
               , trIndex
               , trTimeframe
               , signal
               , time
               , yellow1
               , HEAD_TO_STRING
               )
            , shift   
            , HEAD_TO_STRING   
            );
         
         IFLOG{
            TM.Log(
                     HEAD_TO_STRING+
                     TM.ToString(isBuy)+", "+
                     TM.ToString(isSell)+", "+
                     ToString()
                     ,shift);
         }               
         
      }
   }

};
DivergenceZoneStarter* glArray_DivergenceZoneStarter[];