//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
#include "..\\TradingManager.mqh"
#include "..\\Structs.mqh"


#include <ChartObjects\\ChartObjectsArrows.mqh>

class Cv9TdfiDiver{
   public:
   string            trObjBaseName;
   
   ENUM_TIMEFRAMES   trTimeframe;
   
   SignalType        trSignalType;
   SignalType        trSignalType_Candles;
   
   StructPoint       trStructPoint_Start_Zone;
   StructPoint       trStructPoint_FirstTrade;
   StructPoint       trStructPoint_PotenTrade;
   
   int               trCounter;
   
   string ToString(){
      string   val   = StringFormat(" | Cv9TdfiDiver: sT:%s, sC:%s, c:%s, Srt:%s, 1st:%s, pot:%s | ",
                                       
                                       EnumToString(trSignalType),
                                       EnumToString(trSignalType_Candles),
                                       TM.ToString(trCounter),
                                       trStructPoint_Start_Zone.ToString(),
                                       trStructPoint_PotenTrade.ToString(),
                                       trStructPoint_PotenTrade.ToString()
                                       );
      return   val;                        
   }
   
   Cv9TdfiDiver(ENUM_TIMEFRAMES tf)
   {
      trTimeframe          = tf;
      trSignalType         = NO;
      
      string   obName      = 
                              "v9TdfiC"+"_"+
                              TM.ToString(trTimeframe)+"_"
                              ;
                              
      trObjBaseName        = glPrefix + obName;   
      
      ZeroMemory(trStructPoint_Start_Zone);
      ResetPoints();
      
      IFLOG{
         TM.Log(
               HEAD_TO_STRING+
               TM.ToString(trObjBaseName)+", "+
               ToString()
               ,0);   
      } 
   }
   
   void ResetPoints(){
      ZeroMemory(trStructPoint_FirstTrade);
      ZeroMemory(trStructPoint_PotenTrade);
   }
   
   void UpdateSignalType(int shift, SignalType signal, string reason){
      if (trSignalType != signal){
         SignalType  old   = trSignalType;
         trSignalType      = signal;
         
         IFLOG{
            TM.Log(
                  HEAD_TO_STRING+
                  TM.ToString(reason)+", "+
                  EnumToString(trSignalType)+", "+
                  EnumToString(old)+", "+
                  ToString()
                  ,shift);   
         } 
         
         ResetCounter(shift, HEAD_TO_STRING);
      }
   }
   
   void ResetCounter(int shift, string reason){
      trCounter   = 0;
      
      IFLOG{
         TM.Log(
               HEAD_TO_STRING+
               TM.ToString(reason)+", "+
               TM.ToString(trCounter)+", "+
               ToString()
               ,shift);   
      } 
      
      ResetPoints();
   }
   
   void UpdateCounter(int shift, string reason){
      trCounter++;
      
      if (trCounter == 1){
      }
      
      datetime time  = 0;
      double   price = 0;
      PrepareExtremum(shift, time, price);
      
      trStructPoint_FirstTrade.Initialize(price, time);
      
      IFLOG{
         TM.Log(
               HEAD_TO_STRING+
               trStructPoint_FirstTrade.ToString()+", "+
               ToString()
               ,shift);   
      } 
   
      IFLOG{
         TM.Log(
               HEAD_TO_STRING+
               TM.ToString(reason)+", "+
               TM.ToString(trCounter)+", "+
               ToString()
               ,shift);   
      } 
   }
   
   void TryTyIdentifyZones(int shift){
      datetime timeBase = iTime(_Symbol,_Period,shift);
      int      barCur   = iBarShift(_Symbol,trTimeframe,timeBase);
      datetime timeC    = iTime(_Symbol, trTimeframe, barCur);
      
      double   buf0_0   = TM.GetIndicator_TDFI(2, barCur);
      double   bufResB  = TM.GetIndicator_TDFI(3, barCur);
      double   bufResS  = TM.GetIndicator_TDFI(5, barCur);
      
      bool     isNotNull      = buf0_0 != EMPTY_VALUE;
      bool     isNotNull_RB   = bufResB != EMPTY_VALUE;
      bool     isNotNull_RS   = bufResS != EMPTY_VALUE;
      
      double   lvl_up_3 = tdfi_lvl_up_1;
      double   lvl_dn_3 = tdfi_lvl_dn_1;
      
      bool     isBuy    = buf0_0 <= lvl_dn_3;
      bool     isSell   = buf0_0 >= lvl_up_3;
      
      IFLOG{
         TM.Log(
               HEAD_TO_STRING+
               TM.ToString(isBuy)+", "+
               TM.ToString(isSell)+", "+
               TM.ToString(buf0_0)+", "+
               TM.ToString(lvl_dn_3)+", "+
               TM.ToString(lvl_up_3)+", "+
               TM.ToString(barCur)+", "+
               TM.ToString(timeC)+", "+
               ToString()
               ,shift);   
      } 
      
      IFLOG{
         TM.Log(
               HEAD_TO_STRING+
               TM.ToString(isNotNull_RB)+", "+
               TM.ToString(bufResB)+", "+
               TM.ToString(isNotNull_RS)+", "+
               TM.ToString(bufResS)+", "+
               ToString()
               ,shift);   
      } 
      
      if (trSignalType == BUY && isNotNull_RB){
         UpdateSignalType(shift, NO, HEAD_TO_STRING);
         ActionDrawVLine(shift, true);
         ZeroMemory(trStructPoint_Start_Zone);
      }
      if (trSignalType == SELL && isNotNull_RS){
         UpdateSignalType(shift, NO, HEAD_TO_STRING);
         ActionDrawVLine(shift, true);
         ZeroMemory(trStructPoint_Start_Zone);
      }
      
      if (isBuy && trSignalType != BUY){
         UpdateSignalType(shift, BUY, HEAD_TO_STRING);
         trStructPoint_Start_Zone.Initialize(buf0_0, timeC);
         ActionDrawVLine(shift);
      }
      if (isSell && trSignalType != SELL){
         UpdateSignalType(shift, SELL, HEAD_TO_STRING);
         trStructPoint_Start_Zone.Initialize(buf0_0, timeC);
         ActionDrawVLine(shift);
      }
   }
   
   void ActionDrawVLine(int shift, bool isNull = false){
      if (true) return;
      
      datetime timeBase = iTime(_Symbol,_Period,shift);
      int      barCur   = iBarShift(_Symbol,trTimeframe,timeBase);
      datetime timeC    = iTime(_Symbol, trTimeframe, barCur);
      
      CChartObjectVLine line;
      
      datetime time  = isNull ? timeC : trStructPoint_Start_Zone.trTime;
      string   name  = 
         glPrefix+
         "TdfiDiv_"+
         TM.ToString((int)(time))
      ;
      
      line.Create(
                     0,
                     name,
                     0,//TM.GetIndicatorSubWindow(),
                     trStructPoint_Start_Zone.trTime
                     );
                     
      line.Attach(0,name,0,1);   
      line.Time(0, time);
      line.Color(trSignalType == BUY ? clrAqua : trSignalType == SELL ? clrRoyalBlue : clrCrimson);
      line.Tooltip(trSignalType == BUY ? "BUY" : trSignalType == SELL ? "SELL" : "RESET");    
      line.Detach();               
   }
   
   void TryToCheckCandles(int shift){
      trSignalType_Candles = NO;
      
      if (trCounter < 1) {
         trSignalType_Candles = trSignalType;
         return;
      }
   
      int   candles  = 3;
      int   bars     = iBars(_Symbol,_Period);
      
      datetime time  = 0;
      double   price = 0;
      
      PrepareExtremum(shift, time, price);
      
      trStructPoint_PotenTrade.Initialize(price, time);
      
      bool  isBoth   = trSignalType == BUY ? trStructPoint_FirstTrade.trPrice > trStructPoint_PotenTrade.trPrice : trStructPoint_FirstTrade.trPrice < trStructPoint_PotenTrade.trPrice;
      
      IFLOG{
         TM.Log(
               HEAD_TO_STRING+
               TM.ToString(isBoth)+", "+
               TM.ToString(time)+", "+
               TM.ToString(price)+", "+
               ToString()
               ,shift);   
      } 
      
      if (isBoth){
         trSignalType_Candles = trSignalType;
      }
   }
   
   SignalType GetFinalSignal(){
      if (trSignalType != NO && trSignalType == trSignalType_Candles){
         return trSignalType;
      }
      return   NO;
   }
   
   void PrepareExtremum(int shift, datetime &_time, double &_price){
      int   candles  = 3;
      int   bars     = iBars(_Symbol,_Period);
      
      if (trSignalType == BUY){
         for (int i = shift; i < bars && i < shift + candles; i++){
            double   price = iLow(_Symbol,trTimeframe,i);
            datetime time  = iTime(_Symbol,trTimeframe,i);
            
            if (_price <= 0){
               _price   = price;
               _time    = time;
            }
            
            if (price < _price){
               _price   = price;
               _time    = time;
            }
         }
      }
      if (trSignalType == SELL){
         for (int i = shift; i < bars && i < shift + candles; i++){
            double   price = iHigh(_Symbol,trTimeframe,i);
            datetime time  = iTime(_Symbol,trTimeframe,i);
            
            if (_price <= 0){
               _price   = price;
               _time    = time;
            }
            
            if (price > _price){
               _price   = price;
               _time    = time;
            }
         }
      }
   }
      
   void OnTick(int shift){
      if (shift == 0) return;
      trSignalType_Candles = NO;
      
      TryTyIdentifyZones(shift);
      TryToCheckCandles(shift);
      
   }
};
Cv9TdfiDiver *glCv9TdfiDiver;
