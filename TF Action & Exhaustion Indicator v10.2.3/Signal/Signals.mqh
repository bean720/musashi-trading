//+------------------------------------------------------------------+
//|                                                      Signals.mqh |
//|                        Copyright 2017, MetaQuotes Software Corp. |
//|                                             https://www.mql5.com |
//+------------------------------------------------------------------+
#property copyright "Copyright 2017, MetaQuotes Software Corp."
#property link      "https://www.mql5.com"
#property strict
#include "..//Enums.mqh"
#include "SignalBase.mqh"
#include "SignalHandler.mqh"
#include "..//TradingManager.mqh"
#include "..//Divergence//Divergence.mqh"
#include "..//Divergence//DivergenceHandler.mqh"



class Filter_DivergenceZoneSignal : public Signal{
   public:
   
   Filter_DivergenceZoneSignal(){
      name        = "Filter_DivergenceZoneSignal::";
   }
   
   void CalculateOpenSignal(int shift){
      openSignal = NO;
      
      int      size     = ArraySize(glArray_DivergenceZoneHandler);
      
      int   countB   = 0;
      int   countS   = 0;
      string   msg   = "";
      
      for (int i = 0; i < size; i++){
         SignalType  sig   = glArray_DivergenceZoneHandler[i].GetCurrentSignal(shift, msg);
         
         if (sig == BUY){
            countB++;
         }
         if (sig == SELL){
            countS++;
         }
      }

      bool     isBuy    = countB > 0;
      bool     isSell   = countS > 0;
      
      if (isBuy ){
         openSignal  = BUY;
      }
      if (isSell){
         openSignal  = openSignal == NO ? SELL : BOTH;
      }
      
      if (!enable_external_use){
         ArrayResize(openStringVals,0);
      
         TM.AddInArray(openStringVals, TM.ToString(isBuy));
         TM.AddInArray(openStringVals, TM.ToString(isSell));
         
         TM.AddInArray(openStringVals, TM.ToString(SEP));
         TM.AddInArray(openStringVals, TM.ToString(countB));
         TM.AddInArray(openStringVals, TM.ToString(countS));
         
         TM.AddInArray(openStringVals, TM.ToString(SEP));
         TM.AddInArray(openStringVals, TM.ToString(msg));
      }
   }
};



class CalculateMbfxSignal : public Signal{
   public:
   int               sIndex;
   ENUM_TIMEFRAMES   sTf;
   
   CalculateMbfxSignal(int index){
      sIndex   = index;
      sTf      = glArray_Timeframes[sIndex];
      name     = "CalculateMbfxSignal::"+TM.ToString(sTf);
   }
   
   void CalculateOpenSignal(int shift){
      openSignal = NO;
      
      datetime timeBase = iTime(_Symbol,_Period,shift);
      int      barCur   = iBarShift(_Symbol,sTf,timeBase);
      
      double   buf0     = TM.GetIndicator_Mdfx(sIndex,0,barCur);
      double   buf1     = TM.GetIndicator_Mdfx(sIndex,1,barCur);
      double   buf2     = TM.GetIndicator_Mdfx(sIndex,2,barCur);
      
      SetNewData(shift,buf0,buf1,buf2);
      
      if (!enable_external_use){
         ArrayResize(openStringVals,0);
      
         TM.AddInArray(openStringVals, TM.ToString(buf0));
         TM.AddInArray(openStringVals, TM.ToString(buf1));
         TM.AddInArray(openStringVals, TM.ToString(buf2));
         
         TM.AddInArray(openStringVals, TM.ToString(SEP));
         TM.AddInArray(openStringVals, TM.ToString(shift));
         TM.AddInArray(openStringVals, TM.ToString(barCur));
      }
   }
   
   void UpdateData(double &buf0[], double &buf1[], double &buf2[], int shift, double val0, double val1, double val2){
      if (shift != signal_bar) return;
      
      datetime timeBase    = iTime(_Symbol, _Period, shift);
      
      int      barCurExact = iBarShift(_Symbol, sTf, timeBase, true);
      int      barCurAppr  = iBarShift(_Symbol, sTf, timeBase, false);
      int      barCur      = barCurExact < 0 ? barCurAppr + 1 : barCurExact;
      datetime timeCur     = iTime(_Symbol, sTf, barCur);
      
      int      barFinishExact = iBarShift(_Symbol,_Period,timeCur,true);
      int      barFinishAppr  = iBarShift(_Symbol,_Period,timeCur,false);
      int      barFinish      = barFinishExact < 0 ? barFinishAppr + 1 : barFinishExact;
      
      
      
      /*
      IFLOG
         TM.Log(
                  TM.ToString(sTf)+", "+
                  TM.ToString(timeBase)+", "+
                  TM.ToString(timeCur)+", "+
                  TM.ToString(barCurExact)+", "+
                  TM.ToString(barCurAppr)+", "+
                  TM.ToString(barCur)
                  ,shift,_Symbol);
      
      IFLOG
         TM.Log(
                  TM.ToString(sTf)+", "+
                  TM.ToString(barFinish)+", "+
                  TM.ToString(barFinishExact)+", "+
                  TM.ToString(barFinishAppr)
                  ,shift,_Symbol);
      */
      
      for (int i = shift; i <= barFinish && i < iBars(_Symbol, _Period); i++){
         buf0[i]  = val0;
         buf1[i]  = val1;
         buf2[i]  = val2;
      }
   }
   
   void SetNewData(int i, double buf0, double buf1, double buf2){
      switch (sIndex){
         case 0 : 
            bufferMbfxBaseM1[i]  = buf0;
            bufferMbfxUpM1[i]    = buf1;
            bufferMbfxDnM1[i]    = buf2;
            UpdateData(bufferMbfxBaseM1, bufferMbfxUpM1, bufferMbfxDnM1, i, buf0, buf1, buf2);
            break;
         case 1:
            bufferMbfxBaseM5[i]  = buf0;
            bufferMbfxUpM5[i]    = buf1;
            bufferMbfxDnM5[i]    = buf2;
            UpdateData(bufferMbfxBaseM5, bufferMbfxUpM5, bufferMbfxDnM5, i, buf0, buf1, buf2);
            break;
         case 2:
            bufferMbfxBaseM15[i]  = buf0;
            bufferMbfxUpM15[i]    = buf1;
            bufferMbfxDnM15[i]    = buf2;
            UpdateData(bufferMbfxBaseM15, bufferMbfxUpM15, bufferMbfxDnM15, i, buf0, buf1, buf2);
            break;
         case 3:
            bufferMbfxBaseM30[i]  = buf0;
            bufferMbfxUpM30[i]    = buf1;
            bufferMbfxDnM30[i]    = buf2;
            UpdateData(bufferMbfxBaseM30, bufferMbfxUpM30, bufferMbfxDnM30, i, buf0, buf1, buf2);
            break;
         case 4:
            bufferMbfxBaseH1[i]  = buf0;
            bufferMbfxUpH1[i]    = buf1;
            bufferMbfxDnH1[i]    = buf2;
            UpdateData(bufferMbfxBaseH1, bufferMbfxUpH1, bufferMbfxDnH1, i, buf0, buf1, buf2);
            break;
         case 5:
            bufferMbfxBaseH4[i]  = buf0;
            bufferMbfxUpH4[i]    = buf1;
            bufferMbfxDnH4[i]    = buf2;
            UpdateData(bufferMbfxBaseH4, bufferMbfxUpH4, bufferMbfxDnH4, i, buf0, buf1, buf2);
            break;
         case 6:
            bufferMbfxBaseD1[i]  = buf0;
            bufferMbfxUpD1[i]    = buf1;
            bufferMbfxDnD1[i]    = buf2;
            UpdateData(bufferMbfxBaseD1, bufferMbfxUpD1, bufferMbfxDnD1, i, buf0, buf1, buf2);
            break;
         case 7:
            bufferMbfxBaseW1[i]  = buf0;
            bufferMbfxUpW1[i]    = buf1;
            bufferMbfxDnW1[i]    = buf2;
            UpdateData(bufferMbfxBaseW1, bufferMbfxUpW1, bufferMbfxDnW1, i, buf0, buf1, buf2);
            break;
         case 8:
            bufferMbfxBaseMN[i]  = buf0;
            bufferMbfxUpMN[i]    = buf1;
            bufferMbfxDnMN[i]    = buf2;
            UpdateData(bufferMbfxBaseMN, bufferMbfxUpMN, bufferMbfxDnMN, i, buf0, buf1, buf2);
            break;
      }
   }
};


class FilterDirectionBiasSignal : public Signal{
   public:
   int               sIndex;
   ENUM_TIMEFRAMES   sTf;
   
   bool  sIsForming;
   
   bool  isIsOnlyClosed;
   
   
   FilterDirectionBiasSignal(int index, bool isForming){
      sIndex   = index;
      sTf      = glArray_Timeframes[sIndex];
      sIsForming  = isForming;
      
      isIsOnlyClosed = sIsForming ? false : glArray_enable_use_completed_candles_only[sIndex]; 
      name     = "FilterDirectionBiasSignal::"+TM.ToString(sTf);
   }
   
   void CalculateOpenSignal(int shift){
      openSignal = NO;
      
      datetime timeBase = iTime(_Symbol,_Period,shift);
      int      barCur   = iBarShift(_Symbol,sTf,timeBase);
      int      barCurB     = barCur;
      
      if (isIsOnlyClosed){
         barCur   = MathMax(barCur, 1);
      }
      
      double   buf0_0   = TM.GetIndicator_Mdfx(sIndex, 0, barCur);
      double   buf1_0   = TM.GetIndicator_Mdfx(sIndex, 1, barCur);
      double   buf2_0   = TM.GetIndicator_Mdfx(sIndex, 2, barCur);
      
      bool     isBuy    = buf1_0 != EMPTY_VALUE;
      bool     isSell   = buf2_0 != EMPTY_VALUE;
      
      int      count       = glCv9TdfiDiver.trCounter > 1;
      int      lowerTf     = glButtonHandler.GetMinEnabledTf_Extreme();
      bool     isLower     = lowerTf == sIndex;
      bool     isEnabled   = !count || isLower;
      
      if (!isEnabled){
         openSignal  = BOTH;
      }
      else {      
         if (isBuy){
            openSignal  = BUY;
         }
         if (isSell){
            openSignal  = openSignal == NO ? SELL : BOTH;
         }
      }
      
      if (!enable_external_use){
         ArrayResize(openStringVals,0);
      
         TM.AddInArray(openStringVals, TM.ToString(isBuy));
         TM.AddInArray(openStringVals, TM.ToString(isSell));
      
         TM.AddInArray(openStringVals, TM.ToString(SEP));
         TM.AddInArray(openStringVals, TM.ToString(buf0_0));
         TM.AddInArray(openStringVals, TM.ToString(buf1_0));
         TM.AddInArray(openStringVals, TM.ToString(buf2_0));
         
         TM.AddInArray(openStringVals, TM.ToString(SEP));
         TM.AddInArray(openStringVals, TM.ToString(isEnabled));
         TM.AddInArray(openStringVals, TM.ToString(count));
         TM.AddInArray(openStringVals, TM.ToString(isLower));
         TM.AddInArray(openStringVals, TM.ToString(lowerTf));
         
         TM.AddInArray(openStringVals, TM.ToString(SEP));
         TM.AddInArray(openStringVals, TM.ToString(shift));
         TM.AddInArray(openStringVals, TM.ToString(barCur));
         TM.AddInArray(openStringVals, TM.ToString(barCurB));
      }
   }
};

class FilterDeltaSignal : public Signal{
   public:
   int               sIndex;
   int               sIndex_Next;
   ENUM_TIMEFRAMES   sTf;
   ENUM_TIMEFRAMES   sTf_Next;
   
   FilterDeltaSignal(int index){
      sIndex      = index;
      sTf         = glArray_Timeframes[sIndex];
      int   add   = sTf == PERIOD_M15 ? 2 : 1;
      sIndex_Next = sIndex + add;
      sTf_Next    = glArray_Timeframes[sIndex_Next];
      name        = "FilterDeltaSignal::"+TM.ToString(sTf)+"::"+TM.ToString(sTf_Next);
   }
   
   void CalculateOpenSignal(int shift){
      openSignal = NO;
      
      int      count       = glCv9TdfiDiver.trCounter > 1;
      int      lowerTf     = glButtonHandler.GetMinEnabledTf_Extreme();
      bool     isLower     = lowerTf == sIndex;
      bool     isEnabled   = !count || isLower;
      
      if (!isEnabled){
         openSignal  = BOTH;
         
         if (!enable_external_use){
            ArrayResize(openStringVals,0);
         
            TM.AddInArray(openStringVals, TM.ToString(isEnabled));
            TM.AddInArray(openStringVals, TM.ToString(count));
            TM.AddInArray(openStringVals, TM.ToString(isLower));
            TM.AddInArray(openStringVals, TM.ToString(lowerTf));
         }
         
         return;
      }
      
      
      datetime timeBase    = iTime(_Symbol,_Period,shift);
      int      barCur      = iBarShift(_Symbol,sTf,timeBase);
      double   buf0_0      = TM.GetIndicator_Mdfx(sIndex, 0, barCur);
      
      int      barCur_N    = iBarShift(_Symbol,sTf_Next,timeBase);
      double   buf0_0_N    = TM.GetIndicator_Mdfx(sIndex_Next, 0, barCur_N);
      
      double   delta       = buf0_0_N - buf0_0;
      
      double   lvl_up      = glArray_delta_filter_lvl_up[sIndex];
      double   lvl_dn      = glArray_delta_filter_lvl_dn[sIndex];
      
      bool     isNotNull   = buf0_0 != EMPTY_VALUE && buf0_0_N != EMPTY_VALUE;
      bool     isBuy       = delta > lvl_up;
      bool     isSell      = delta < lvl_dn;
      
      if (isNotNull){
         if (isBuy){
            openSignal  = BUY;
         }
         if (isSell){
            openSignal  = openSignal == NO ? SELL : BOTH;
         }
      }
      
      if (!enable_external_use){
         ArrayResize(openStringVals,0);
      
         TM.AddInArray(openStringVals, TM.ToString(isNotNull));
         TM.AddInArray(openStringVals, TM.ToString(isBuy));
         TM.AddInArray(openStringVals, TM.ToString(isSell));
      
         TM.AddInArray(openStringVals, TM.ToString(SEP));
         TM.AddInArray(openStringVals, TM.ToString(delta));
         TM.AddInArray(openStringVals, TM.ToString(lvl_up));
         TM.AddInArray(openStringVals, TM.ToString(lvl_dn));
      
         TM.AddInArray(openStringVals, TM.ToString(SEP));
         TM.AddInArray(openStringVals, TM.ToString(buf0_0));
         TM.AddInArray(openStringVals, TM.ToString(buf0_0_N));
         
         TM.AddInArray(openStringVals, TM.ToString(SEP));
         TM.AddInArray(openStringVals, TM.ToString(shift));
         TM.AddInArray(openStringVals, TM.ToString(barCur));
         TM.AddInArray(openStringVals, TM.ToString(barCur_N));
      }
   }
};

class Filter_Reason_HiLoSignal : public Signal{
   public:
   
   Filter_Reason_HiLoSignal(){
      sIsReason   = true;
      name        = "Filter_Reason_HiLoSignal";
   }
   
   void CalculateOpenSignal(int shift){
      openSignal           = NO;
      openSignal_Reason    = NO;
      
      int      lastBars    = 3;
      
      int      highest     = iHighest(_Symbol,_Period,MODE_HIGH,lastBars,shift);
      double   high        = iHigh(_Symbol,_Period,highest);
      
      int      lowest      = iLowest(_Symbol,_Period,MODE_LOW,lastBars,shift);
      double   low         = iLow(_Symbol,_Period,lowest);
      
      double   levelUp     = glCHiLo.trStructPoint_HiLo_Highest.trPrice;
      double   levelDn     = glCHiLo.trStructPoint_HiLo_Lowest.trPrice;
      
      bool     isNotNull   = levelUp > 0 && levelDn > 0;
      bool     isBuy       = low <= levelDn;
      bool     isSell      = high >= levelUp;
      
      if (isNotNull){
         if (isBuy){
            openSignal_Reason = BUY;
         }
         if (isSell){
            openSignal_Reason = openSignal_Reason == NO ? SELL : BOTH;
         }
      }
      
      openSignal  = BOTH;
      
      if (!enable_external_use){
         ArrayResize(openStringVals,0);
      
         TM.AddInArray(openStringVals, TM.ToString(isNotNull));
         TM.AddInArray(openStringVals, TM.ToString(isBuy));
         TM.AddInArray(openStringVals, TM.ToString(isSell));
         
         TM.AddInArray(openStringVals, TM.ToString(SEP));
         TM.AddInArray(openStringVals, EnumToString(openSignal_Reason));
      
         TM.AddInArray(openStringVals, TM.ToString(SEP));
         TM.AddInArray(openStringVals, TM.ToString(high));
         TM.AddInArray(openStringVals, TM.ToString(levelUp));
         TM.AddInArray(openStringVals, TM.ToString(low));
         TM.AddInArray(openStringVals, TM.ToString(levelDn));
      
         TM.AddInArray(openStringVals, TM.ToString(SEP));
         TM.AddInArray(openStringVals, TM.ToString(highest));
         TM.AddInArray(openStringVals, TM.ToString(lowest));
         
         TM.AddInArray(openStringVals, TM.ToString(SEP));
         TM.AddInArray(openStringVals, TM.ToString(glCHiLo.ToString()));
      }
   }
};


class Filter_Reason_EmaTfSignal : public Signal{
   public:
   ENUM_TIMEFRAMES   sTF;
   
   Filter_Reason_EmaTfSignal(ENUM_TIMEFRAMES tf){
      sTF         = tf;
      sIsReason   = true;
      name        = "Filter_Reason_EmaTfSignal"+EnumToString(sTF);
   }
   
   color GetColorM50(){
      color val   = clrNONE;
      switch (sTF){
         case PERIOD_M1:
            val   = reason_ema_50_clr_m1;
            break;
            
         case PERIOD_M5:
            val   = reason_ema_50_clr_m5;
            break;
            
         case PERIOD_M15:
            val   = reason_ema_50_clr_m15;
            break;
            
         case PERIOD_M30:
            val   = clrNONE;
            break;
            
         case PERIOD_H1:
            val   = reason_ema_50_clr_h1;
            break;
            
         case PERIOD_H4:
            val   = reason_ema_50_clr_h4;
            break;
            
         case PERIOD_D1:
            val   = reason_ema_50_clr_d1;
            break;
            
         case PERIOD_W1:
            val   = reason_ema_50_clr_w1;
            break;
            
         case PERIOD_MN1:
            val   = reason_ema_50_clr_mn1;
            break;
      
      }
      return val;
   }
   
   color GetColorM100(){
      color val   = clrNONE;
      switch (sTF){
         case PERIOD_M1:
            val   = reason_ema_100_clr_m1;
            break;
            
         case PERIOD_M5:
            val   = reason_ema_100_clr_m5;
            break;
            
         case PERIOD_M15:
            val   = reason_ema_100_clr_m15;
            break;
            
         case PERIOD_M30:
            val   = clrNONE;
            break;
            
         case PERIOD_H1:
            val   = reason_ema_100_clr_h1;
            break;
            
         case PERIOD_H4:
            val   = reason_ema_100_clr_h4;
            break;
            
         case PERIOD_D1:
            val   = reason_ema_100_clr_d1;
            break;
            
         case PERIOD_W1:
            val   = reason_ema_100_clr_w1;
            break;
            
         case PERIOD_MN1:
            val   = reason_ema_100_clr_mn1;
            break;
      
      }
      return val;
   }
      
   void CalculateOpenSignal(int shift){
      openSignal           = NO;
      openSignal_Reason    = NO;
      
      int      bar         = shift;
      
      datetime time_0      = iTime(_Symbol,_Period,bar);
      int      barMTF_0    = iBarShift(_Symbol, sTF, time_0);
      
      datetime time_1      = iTime(_Symbol,_Period,bar+1);
      int      barMTF_1    = iBarShift(_Symbol, sTF, time_1);
      
      double   high_0      = iHigh(_Symbol,_Period,bar);
      double   high_1      = iHigh(_Symbol,_Period,bar+1);
      double   low_0       = iLow(_Symbol,_Period,bar);
      double   low_1       = iLow(_Symbol,_Period,bar+1);
      
      double   close_0     = iClose(_Symbol,_Period,bar);
      
      int      perReal_50        = 0;
      ENUM_TIMEFRAMES   tfR_50   = ENUM_TIMEFRAMES(-1);
      
      double   ema50_0     = TM.GetIndicator_MA_50(sTF, tfR_50, perReal_50, barMTF_0);
      double   ema50_1     = TM.GetIndicator_MA_50(sTF, tfR_50, perReal_50, barMTF_1);
      
      if (enable_draw_ema){
         string   obName   = glPrefix + "EMA50_"+EnumToString(sTF)+"_"+TM.ToString((int)time_0);
         
         CChartObjectTrend obj;
         
         if (!obj.Create(0,obName,0,time_0,ema50_0,time_0,ema50_0)){
            obj.Attach(0,obName,0, 2);
         }
         
         obj.Price(0,ema50_0);
         obj.Price(1,ema50_0);
         obj.Color(GetColorM50());
         obj.Width(3);
         //obj.Tooltip(TM.ToString(ema50_0));
         obj.Tooltip("EMA "+TM.ToString(sTF)+" "+TM.ToString(50));
         //EMA H1 100
         obj.Detach();
      }
      
      int      perReal_100       = 0;
      ENUM_TIMEFRAMES   tfR_100  = ENUM_TIMEFRAMES(-1);
      
      double   ema100_0    = TM.GetIndicator_MA_100(sTF, tfR_100, perReal_100, barMTF_0);
      double   ema100_1    = TM.GetIndicator_MA_100(sTF, tfR_100, perReal_100, barMTF_1);
      
      if (enable_draw_ema){
         string   obName   = glPrefix + "EMA100_"+EnumToString(sTF)+"_"+TM.ToString((int)time_0);
         
         CChartObjectTrend obj;
         
         if (!obj.Create(0,obName,0,time_0,ema100_0,time_0,ema100_0)){
            obj.Attach(0,obName,0, 2);
         }
         
         obj.Price(0,ema100_0);
         obj.Price(1,ema100_0);
         obj.Color(GetColorM100());
         obj.Width(3);
         //obj.Tooltip(TM.ToString(ema100_0));
         obj.Tooltip("EMA "+TM.ToString(sTF)+" "+TM.ToString(100));
         obj.Detach();
      }
      
      //double   max_0       = MathMax(ema50_0, ema100_0);
      //double   min_0       = MathMin(ema50_0, ema100_0);
      
      bool     isNotNull         = ema100_1 > 0 && ema50_1 > 0;
      
      bool     isWick_50_0       = (high_0 - ema50_0) * (low_0 - ema50_0) <= 0;
      bool     isWick_50_1       = (high_1 - ema50_1) * (low_1 - ema50_1) <= 0;
      
      bool     isWick_100_0      = (high_0 - ema100_0) * (low_0 - ema100_0) <= 0;
      bool     isWick_100_1      = (high_1 - ema100_1) * (low_1 - ema100_1) <= 0;
      
      bool     isPrice_50_buy    = close_0 > ema50_0;
      bool     isPrice_50_sell   = close_0 < ema50_0;
      
      bool     isPrice_100_buy   = close_0 > ema100_0;
      bool     isPrice_100_sell  = close_0 < ema100_0;
      
      bool     isBuy_50          = (isWick_50_0 || isWick_50_1) && isPrice_50_buy;
      bool     isBuy_100         = (isWick_100_0 || isWick_100_1) && isPrice_100_buy;
      
      bool     isSell_50         = (isWick_50_0 || isWick_50_1) && isPrice_50_sell;
      bool     isSell_100        = (isWick_100_0 || isWick_100_1) && isPrice_100_sell;
      
      bool     isBuy             = isBuy_50 || isBuy_100;
      bool     isSell            = isSell_50 || isSell_100;
      
      if (isNotNull){
         if (isBuy){
            openSignal_Reason = BUY;
         }
         if (isSell){
            openSignal_Reason = openSignal_Reason == NO ? SELL : BOTH;
         }
      }
      
      openSignal  = BOTH;
      
      if (!enable_external_use){
         ArrayResize(openStringVals,0);
      
         TM.AddInArray(openStringVals, TM.ToString(SEP));
         TM.AddInArray(openStringVals, TM.ToString(bar));
         TM.AddInArray(openStringVals, TM.ToString(barMTF_0));
         TM.AddInArray(openStringVals, TM.ToString(time_0));
         TM.AddInArray(openStringVals, TM.ToString(iTime(_Symbol,sTF, barMTF_0)));
      
         TM.AddInArray(openStringVals, TM.ToString(SEP));
         TM.AddInArray(openStringVals, EnumToString(openSignal_Reason));
         TM.AddInArray(openStringVals, TM.ToString(isNotNull));
         TM.AddInArray(openStringVals, TM.ToString(isBuy));
         TM.AddInArray(openStringVals, TM.ToString(isSell));
         
         TM.AddInArray(openStringVals, TM.ToString(SEP));
         TM.AddInArray(openStringVals, TM.ToString(isBuy_50));
         TM.AddInArray(openStringVals, TM.ToString(isBuy_100));
         TM.AddInArray(openStringVals, TM.ToString(isSell_50));
         TM.AddInArray(openStringVals, TM.ToString(isSell_100));
         
         TM.AddInArray(openStringVals, TM.ToString(SEP));
         TM.AddInArray(openStringVals, TM.ToString(isPrice_50_buy));
         TM.AddInArray(openStringVals, TM.ToString(isPrice_100_buy));
         TM.AddInArray(openStringVals, TM.ToString(isPrice_50_sell));
         TM.AddInArray(openStringVals, TM.ToString(isPrice_100_sell));
         
         TM.AddInArray(openStringVals, TM.ToString(SEP));
         TM.AddInArray(openStringVals, TM.ToString(isWick_50_0));
         TM.AddInArray(openStringVals, TM.ToString(isWick_50_1));
         TM.AddInArray(openStringVals, TM.ToString(isWick_100_0));
         TM.AddInArray(openStringVals, TM.ToString(isWick_100_1));
      
         TM.AddInArray(openStringVals, TM.ToString(SEP));
         TM.AddInArray(openStringVals, TM.ToString(isPrice_50_buy));
         TM.AddInArray(openStringVals, TM.ToString(isPrice_50_sell));
      
         TM.AddInArray(openStringVals, TM.ToString(SEP));
         TM.AddInArray(openStringVals, TM.ToString(ema50_0));
         TM.AddInArray(openStringVals, TM.ToString(ema50_1));
         TM.AddInArray(openStringVals, TM.ToString(ema100_0));
         TM.AddInArray(openStringVals, TM.ToString(ema100_1));
         
         TM.AddInArray(openStringVals, TM.ToString(SEP));
         TM.AddInArray(openStringVals, TM.ToString(close_0));
         TM.AddInArray(openStringVals, TM.ToString(high_0));
         TM.AddInArray(openStringVals, TM.ToString(high_1));
         TM.AddInArray(openStringVals, TM.ToString(low_0));
         TM.AddInArray(openStringVals, TM.ToString(low_1));
         
         TM.AddInArray(openStringVals, TM.ToString(SEP));
         TM.AddInArray(openStringVals, TM.ToString(perReal_50));
         TM.AddInArray(openStringVals, TM.ToString(perReal_100));
         TM.AddInArray(openStringVals, EnumToString(tfR_50));
         TM.AddInArray(openStringVals, EnumToString(tfR_100));
      }
   }
};

class FilterReasonCommulativeSignal : public Signal{
   public:
   
   FilterReasonCommulativeSignal(){
      name     = "FilterReasonCommulativeSignal";
   }
   
   void CalculateOpenSignal(int shift){
      openSignal = NO;
      
      int      countBuy    = glReason_Count_Buy;
      int      countSell   = glReason_Count_Sell;
      
      int      limit       = number_of_reasons;
      
      bool     isBuy       = countBuy >= limit;
      bool     isSell      = countSell >= limit;
      
      if (isBuy){
         openSignal  = BUY;
      }
      if (isSell){
         openSignal  = openSignal == NO ? SELL : BOTH;
      }
      
      if (!enable_external_use){
         ArrayResize(openStringVals,0);
      
         TM.AddInArray(openStringVals, TM.ToString(isBuy));
         TM.AddInArray(openStringVals, TM.ToString(isSell));
      
         TM.AddInArray(openStringVals, TM.ToString(SEP));
         TM.AddInArray(openStringVals, TM.ToString(countBuy));
         TM.AddInArray(openStringVals, TM.ToString(countSell));
         TM.AddInArray(openStringVals, TM.ToString(limit));
      }
   }
};


class FilterV8Ema50Signal : public Signal{
   public:
   int               sIndex;
   ENUM_TIMEFRAMES   sTf;
   
   FilterV8Ema50Signal(int index){
      sIndex   = index;
      sTf      = glArray_Timeframes[sIndex];
      name     = "FilterV8Ema50Signal::"+TM.ToString(sTf);
   }
   
   void CalculateOpenSignal(int shift){
      openSignal = NO;
      
      int      count       = glCv9TdfiDiver.trCounter > 1;
      int      lowerTf     = glButtonHandler.GetMinEnabledTf_Extreme();
      bool     isLower     = lowerTf == sIndex;
      bool     isEnabled   = !count || isLower;
      
      if (!isEnabled){
         openSignal  = BOTH;
         
         if (!enable_external_use){
            ArrayResize(openStringVals,0);
         
            TM.AddInArray(openStringVals, TM.ToString(isEnabled));
            TM.AddInArray(openStringVals, TM.ToString(count));
            TM.AddInArray(openStringVals, TM.ToString(isLower));
            TM.AddInArray(openStringVals, TM.ToString(lowerTf));
         }
         
         return;
      }
      
      
      int      bar         = shift;
      
      
      int      perReal_50        = 0;
      ENUM_TIMEFRAMES   tfR_50   = ENUM_TIMEFRAMES(-1);
      
      int      bars        = 3;
      
      bool     isBuy       = false;
      bool     isSell      = false;
      
      if (!enable_external_use){
         ArrayResize(openStringVals,2);
      }
      
      for (int i = shift; i < shift + bars; i++){
         double   high_i      = iHigh(_Symbol, _Period, i);
         double   low_i       = iLow(_Symbol, _Period, i);
         
         datetime time_i      = iTime(_Symbol,_Period,i);
         int      barMTF_i    = iBarShift(_Symbol, sTf, time_i);
      
         double   ema_i       = TM.GetIndicator_MA_50(sTf, tfR_50, perReal_50, barMTF_i);
         
         bool     isBuy_i     = high_i < ema_i;
         bool     isSell_i    = low_i > ema_i;
         
         if (isBuy_i){
            isBuy = true;
         }
         if (isSell_i){
            isSell = true;
         }
         
         if (!enable_external_use){
         
            TM.AddInArray(openStringVals, TM.ToString(SEP));
            TM.AddInArray(openStringVals, TM.ToString(i));
            TM.AddInArray(openStringVals, TM.ToString(isBuy_i));
            TM.AddInArray(openStringVals, TM.ToString(isSell_i));
         
            TM.AddInArray(openStringVals, TM.ToString(" => "));
            TM.AddInArray(openStringVals, TM.ToString(high_i));
            TM.AddInArray(openStringVals, TM.ToString(low_i));
            TM.AddInArray(openStringVals, TM.ToString(ema_i));
         }
      }
      
      if (isBuy){
         openSignal  = BUY;
      }
      if (isSell){
         openSignal  = openSignal == NO ? SELL : BOTH;
      }
      
      if (!enable_external_use){
         openStringVals[0] = TM.ToString(isBuy);
         openStringVals[1] = TM.ToString(isSell);
      }
   }
};

class FilterV8Ema100Signal : public Signal{
   public:
   int               sIndex;
   ENUM_TIMEFRAMES   sTf;
   
   FilterV8Ema100Signal(int index){
      sIndex   = index;
      sTf      = glArray_Timeframes[sIndex];
      name     = "FilterV8Ema100Signal::"+TM.ToString(sTf);
   }
   
   void CalculateOpenSignal(int shift){
      openSignal = NO;
      
      int      bar         = shift;
      
      
      int      perReal_50        = 0;
      ENUM_TIMEFRAMES   tfR_50   = ENUM_TIMEFRAMES(-1);
      
      int      bars        = 3;
      
      bool     isBuy       = false;
      bool     isSell      = false;
      
      if (!enable_external_use){
         ArrayResize(openStringVals,2);
      }
      
      for (int i = shift; i < shift + bars; i++){
         double   high_i      = iHigh(_Symbol, _Period, i);
         double   low_i       = iLow(_Symbol, _Period, i);
         
         datetime time_i      = iTime(_Symbol,_Period,i);
         int      barMTF_i    = iBarShift(_Symbol, sTf, time_i);
      
         double   ema_i       = TM.GetIndicator_MA_100(sTf, tfR_50, perReal_50, barMTF_i);
         
         bool     isBuy_i     = high_i < ema_i;
         bool     isSell_i    = low_i > ema_i;
         
         if (isBuy_i){
            isBuy = true;
         }
         if (isSell_i){
            isSell = true;
         }
         
         if (!enable_external_use){
         
            TM.AddInArray(openStringVals, TM.ToString(SEP));
            TM.AddInArray(openStringVals, TM.ToString(i));
            TM.AddInArray(openStringVals, TM.ToString(isBuy_i));
            TM.AddInArray(openStringVals, TM.ToString(isSell_i));
         
            TM.AddInArray(openStringVals, TM.ToString(" => "));
            TM.AddInArray(openStringVals, TM.ToString(high_i));
            TM.AddInArray(openStringVals, TM.ToString(low_i));
            TM.AddInArray(openStringVals, TM.ToString(ema_i));
         }
      }
      
      if (isBuy){
         openSignal  = BUY;
      }
      if (isSell){
         openSignal  = openSignal == NO ? SELL : BOTH;
      }
      
      if (!enable_external_use){
         openStringVals[0] = TM.ToString(isBuy);
         openStringVals[1] = TM.ToString(isSell);
      }
   }
};

/*
class FilterV8Ema50_100Signal : public Signal{
   public:
   int               sIndex;
   ENUM_TIMEFRAMES   sTf;
   
   FilterV8Ema50_100Signal(int index){
      sIndex   = index;
      sTf      = glArray_Timeframes[sIndex];
      name     = "FilterV8Ema50_100Signal::"+TM.ToString(sTf);
   }
   
   void CalculateOpenSignal(int shift){
      openSignal = NO;
      
      int      bar         = shift;
      
      datetime time_0      = iTime(_Symbol,_Period,bar);
      int      barMTF_0    = iBarShift(_Symbol, sTf, time_0);
      
      int      perReal_50        = 0;
      ENUM_TIMEFRAMES   tfR_50   = ENUM_TIMEFRAMES(-1);
      int      perReal_100       = 0;
      ENUM_TIMEFRAMES   tfR_100  = ENUM_TIMEFRAMES(-1);
      
      int      bars        = 3;
      
      bool     isBuy       = false;
      bool     isSell      = false;
      
      if (!enable_external_use){
         ArrayResize(openStringVals,2);
      }
      
      for (int i = barMTF_0; i < barMTF_0 + bars; i++){
         double   ema50_0     = TM.GetIndicator_MA_50(sTf, tfR_50, perReal_50, i);
         double   ema100_0    = TM.GetIndicator_MA_100(sTf, tfR_100, perReal_100, i);
         double   min_0       = MathMin(ema50_0, ema100_0);
         double   max_0       = MathMax(ema50_0, ema100_0);
      
         double   high_i      = iHigh(_Symbol, tfR_50, i);
         double   low_i       = iLow(_Symbol, tfR_50, i);
         
         bool     isBuy_i     = high_i < min_0;
         bool     isSell_i    = low_i > max_0;
         
         if (isBuy_i){
            isBuy = true;
         }
         if (isSell_i){
            isSell = true;
         }
         
         if (!enable_external_use){
         
            TM.AddInArray(openStringVals, TM.ToString(SEP));
            TM.AddInArray(openStringVals, TM.ToString(i));
            TM.AddInArray(openStringVals, TM.ToString(isBuy_i));
            TM.AddInArray(openStringVals, TM.ToString(isSell_i));
         
            TM.AddInArray(openStringVals, TM.ToString(" => "));
            TM.AddInArray(openStringVals, TM.ToString(high_i));
            TM.AddInArray(openStringVals, TM.ToString(low_i));
            TM.AddInArray(openStringVals, TM.ToString(min_0));
            TM.AddInArray(openStringVals, TM.ToString(max_0));
         }
      }
      
      if (isBuy){
         openSignal  = BUY;
      }
      if (isSell){
         openSignal  = openSignal == NO ? SELL : BOTH;
      }
      
      if (!enable_external_use){
         openStringVals[0] = TM.ToString(isBuy);
         openStringVals[1] = TM.ToString(isSell);
      }
   }
};
*/


class FilterExtremeLevelSignal : public Signal{
   public:
   int               sIndex;
   ENUM_TIMEFRAMES   sTf;
   
   bool  sIsForming;
   
   bool  isIsOnlyClosed;
   
   FilterExtremeLevelSignal(int index, bool isForming){
      sIndex      = index;
      sTf         = glArray_Timeframes[sIndex];
      sIsForming  = isForming;
      
      isIsOnlyClosed = sIsForming ? false : glArray_enable_use_completed_candles_only[sIndex]; 
      
      name        = "FilterExtremeLevelSignal::"+TM.ToString(sTf);
   }
   
   void CalculateOpenSignal(int shift){
      openSignal = NO;
      
      datetime timeBase    = iTime(_Symbol,_Period,shift);
      int      barCur      = iBarShift(_Symbol,sTf,timeBase);
      int      barCurB     = barCur;
      
      if (isIsOnlyClosed){
         barCur   = MathMax(barCur, 1);
      }
      
      double   buf0_0      = TM.GetIndicator_Mdfx(sIndex, 0, barCur);
      double   upper_buy   = glArray_upper_level_buy_x[sIndex];
      double   lower_buy   = glArray_lower_level_buy_x[sIndex];
      double   upper_sell  = glArray_upper_level_sell_x[sIndex];
      double   lower_sell  = glArray_lower_level_sell_x[sIndex];
      
      bool     isNotNull   = buf0_0 != EMPTY_VALUE;
      bool     isBuy       = buf0_0 <= upper_buy && buf0_0 >= lower_buy;
      bool     isSell      = buf0_0 >= lower_sell && buf0_0 <= upper_sell;
      
      int      count       = glCv9TdfiDiver.trCounter;
      bool     isCount     = count > 0;
      int      lowerTf     = glButtonHandler.GetMinEnabledTf_Extreme();
      bool     isLower     = lowerTf == sIndex;
      bool     isEnabled   = !isCount || isLower;
      
      if (!isEnabled){
         openSignal  = BOTH;
      }
      else if (isNotNull){
         if (isBuy){
            openSignal  = BUY;
         }
         if (isSell){
            openSignal  = openSignal == NO ? SELL : BOTH;
         }
      }
      
      if (!enable_external_use){
         ArrayResize(openStringVals,0);
      
         TM.AddInArray(openStringVals, TM.ToString(isNotNull));
         TM.AddInArray(openStringVals, TM.ToString(isBuy));
         TM.AddInArray(openStringVals, TM.ToString(isSell));
      
         TM.AddInArray(openStringVals, TM.ToString(isNotNull));
         TM.AddInArray(openStringVals, TM.ToString(sIsForming));
         TM.AddInArray(openStringVals, TM.ToString(isIsOnlyClosed));
      
         TM.AddInArray(openStringVals, TM.ToString(SEP));
         TM.AddInArray(openStringVals, TM.ToString(buf0_0));
         TM.AddInArray(openStringVals, TM.ToString(upper_buy));
         TM.AddInArray(openStringVals, TM.ToString(lower_buy));
         TM.AddInArray(openStringVals, TM.ToString(upper_sell));
         TM.AddInArray(openStringVals, TM.ToString(lower_sell));
         
         TM.AddInArray(openStringVals, TM.ToString(SEP));
         TM.AddInArray(openStringVals, TM.ToString(isEnabled));
         TM.AddInArray(openStringVals, TM.ToString(isCount));
         TM.AddInArray(openStringVals, TM.ToString(count));
         TM.AddInArray(openStringVals, TM.ToString(isLower));
         TM.AddInArray(openStringVals, TM.ToString(lowerTf));
         
         TM.AddInArray(openStringVals, TM.ToString(SEP));
         TM.AddInArray(openStringVals, TM.ToString(shift));
         TM.AddInArray(openStringVals, TM.ToString(barCur));
         TM.AddInArray(openStringVals, TM.ToString(barCurB));
         
      }
   }
};

class Entry_Poten_Alert_ColorChangeSignal : public Signal{
   public:
   int               sIndex;
   ENUM_TIMEFRAMES   sTf;
   datetime          sLastAlertTime;
   
   Entry_Poten_Alert_ColorChangeSignal(int index){
      sIndex         = index;
      sTf            = glArray_Timeframes[sIndex];
      name           = "Entry_Poten_Alert_ColorChangeSignal::"+TM.ToString(sTf);
      sLastAlertTime = 0;
   }
   
   void CalculateOpenSignal(int shift){
      openSignal = NO;
      
      glPoten_IsColorChanged  = false;
      
      datetime timeBase = iTime(_Symbol,_Period,shift);
      int      barCur   = iBarShift(_Symbol,sTf,timeBase);
      datetime timeC    = iTime(_Symbol, sTf, barCur);
      
      double   buf0_0   = TM.GetIndicator_Mdfx(sIndex, 0, barCur);
      double   buf1_0   = TM.GetIndicator_Mdfx(sIndex, 1, barCur);
      double   buf2_0   = TM.GetIndicator_Mdfx(sIndex, 2, barCur);
      
      double   buf0_1   = TM.GetIndicator_Mdfx(sIndex, 0, barCur + 1);
      double   buf1_1   = TM.GetIndicator_Mdfx(sIndex, 1, barCur + 1);
      double   buf2_1   = TM.GetIndicator_Mdfx(sIndex, 2, barCur + 1);
      
      bool     isBuy    = buf1_0 != EMPTY_VALUE && buf1_1 == EMPTY_VALUE;
      bool     isSell   = buf2_0 != EMPTY_VALUE && buf2_1 == EMPTY_VALUE;
      
      if (isBuy){
         openSignal  = BUY;
         
         if (barCur == 0 && timeC != sLastAlertTime){
            glPoten_IsColorChanged     = true;
            glPoten_ColorChangedTf     = sTf;
            glPoten_ColorChangedTime   = timeC;
            
            UpdateLastAlertTime(shift, timeC, HEAD_TO_STRING);
            //TM.trStructAlert.Alert_ColorChange_Poten(shift, sTf, openSignal, timeC);
         }
      }
      if (isSell){
         openSignal  = openSignal == NO ? SELL : BOTH;
         
         if (barCur == 0 && timeC != sLastAlertTime){
            glPoten_IsColorChanged     = true;
            glPoten_ColorChangedTf     = sTf;
            glPoten_ColorChangedTime   = timeC;
            
            UpdateLastAlertTime(shift, timeC, HEAD_TO_STRING);
            //TM.trStructAlert.Alert_ColorChange_Poten(shift, sTf, openSignal, timeC);
         }
      }
      
      if (!enable_external_use){
         ArrayResize(openStringVals,0);
      
         TM.AddInArray(openStringVals, TM.ToString(isBuy));
         TM.AddInArray(openStringVals, TM.ToString(isSell));
         TM.AddInArray(openStringVals, TM.ToString(glPoten_IsColorChanged));
         
         TM.AddInArray(openStringVals, TM.ToString(SEP));
         TM.AddInArray(openStringVals, TM.ToString(sLastAlertTime));
         TM.AddInArray(openStringVals, TM.ToString(timeC));
      
         TM.AddInArray(openStringVals, TM.ToString(SEP));
         TM.AddInArray(openStringVals, TM.ToString(buf0_0));
         TM.AddInArray(openStringVals, TM.ToString(buf1_0));
         TM.AddInArray(openStringVals, TM.ToString(buf2_0));
         
         TM.AddInArray(openStringVals, TM.ToString(SEP));
         TM.AddInArray(openStringVals, TM.ToString(buf0_1));
         TM.AddInArray(openStringVals, TM.ToString(buf1_1));
         TM.AddInArray(openStringVals, TM.ToString(buf2_1));
         
         TM.AddInArray(openStringVals, TM.ToString(SEP));
         TM.AddInArray(openStringVals, TM.ToString(shift));
         TM.AddInArray(openStringVals, TM.ToString(barCur));
      }
   }
   
   void UpdateLastAlertTime(int shift, datetime val, string reason){
      if (sLastAlertTime != val){
         datetime  old   = sLastAlertTime;
         sLastAlertTime = val;
         
         if (!enable_external_use){
            TM.Log(
                  HEAD_TO_STRING+
                  TM.ToString(sLastAlertTime)+", "+
                  TM.ToString(old)+", "+
                  TM.ToString(reason)
                  ,shift);
         }
      }
   
   }
   
};

class Entry_Alert_ColorChangeSignal : public Signal{
   public:
   int               sIndex;
   ENUM_TIMEFRAMES   sTf;
   SignalType        sLastSignal;
   
   Entry_Alert_ColorChangeSignal(int index){
      sIndex      = index;
      sTf         = glArray_Timeframes[sIndex];
      name        = "Entry_Alert_ColorChangeSignal::"+TM.ToString(sTf);
      sLastSignal = NO;
   }
   
   void CalculateOpenSignal(int shift){
      openSignal = NO;
      
      datetime timeBase = iTime(_Symbol,_Period,shift);
      int      barCur   = iBarShift(_Symbol,sTf,timeBase);
      datetime timeC    = iTime(_Symbol, sTf, barCur);
      
      double   buf0_0   = TM.GetIndicator_Mdfx(sIndex, 0, barCur);
      double   buf1_0   = TM.GetIndicator_Mdfx(sIndex, 1, barCur);
      double   buf2_0   = TM.GetIndicator_Mdfx(sIndex, 2, barCur);
      
      bool     isBuy    = buf1_0 != EMPTY_VALUE;
      bool     isSell   = buf2_0 != EMPTY_VALUE;
      
      if (isBuy && sLastSignal != BUY){
         openSignal  = BUY;
         UpdateLastSignal(shift, openSignal, HEAD_TO_STRING);
         
         if (barCur == 1){
            glLClosed_IsColorChanged   = true;
            glLClosed_ColorChangedTf   = sTf;
            glLClosed_ColorChangedTime = timeC;
            
            //TM.trStructAlert.Alert_ColorChange(shift, sTf, sLastSignal, timeC);
         }
      }
      if (isSell && sLastSignal != SELL){
         openSignal  = openSignal == NO ? SELL : BOTH;
         UpdateLastSignal(shift, openSignal, HEAD_TO_STRING);
         
         if (barCur == 1){
            glLClosed_IsColorChanged   = true;
            glLClosed_ColorChangedTf   = sTf;
            glLClosed_ColorChangedTime = timeC;
         
            //TM.trStructAlert.Alert_ColorChange(shift, sTf, sLastSignal, timeC);
         }
      }
      
      if (!enable_external_use){
         ArrayResize(openStringVals,0);
      
         TM.AddInArray(openStringVals, TM.ToString(isBuy));
         TM.AddInArray(openStringVals, TM.ToString(isSell));
         
         TM.AddInArray(openStringVals, TM.ToString(SEP));
         TM.AddInArray(openStringVals, EnumToString(sLastSignal));
      
         TM.AddInArray(openStringVals, TM.ToString(SEP));
         TM.AddInArray(openStringVals, TM.ToString(buf0_0));
         TM.AddInArray(openStringVals, TM.ToString(buf1_0));
         TM.AddInArray(openStringVals, TM.ToString(buf2_0));
         
         TM.AddInArray(openStringVals, TM.ToString(SEP));
         TM.AddInArray(openStringVals, TM.ToString(shift));
         TM.AddInArray(openStringVals, TM.ToString(barCur));
      }
   }
   
   void UpdateLastSignal(int shift, SignalType val, string reason){
      if (sLastSignal != val){
         SignalType  old   = sLastSignal;
         sLastSignal = val;
         
         if (!enable_external_use){
            TM.Log(
                  HEAD_TO_STRING+
                  EnumToString(sLastSignal)+", "+
                  EnumToString(old)+", "+
                  TM.ToString(reason)
                  ,shift);
         }
      }
   
   }
   
};

class Calc_Alert_ExtremeLevelSignal : public Signal{
   public:
   int               sIndex;
   ENUM_TIMEFRAMES   sTf;
   SignalType        sLastSignal;
   
   Calc_Alert_ExtremeLevelSignal(int index){
      sIndex      = index;
      sTf         = glArray_Timeframes[sIndex];
      sLastSignal = NO;
      name        = "Calc_Alert_ExtremeLevelSignal::"+TM.ToString(sTf);
   }
   
   void CalculateOpenSignal(int shift){
      openSignal = NO;
      
      datetime timeBase    = iTime(_Symbol,_Period,shift);
      int      barCur      = iBarShift(_Symbol,sTf,timeBase);
      datetime timeC       = iTime(_Symbol, sTf, barCur);
      
      double   buf0_0      = TM.GetIndicator_Mdfx(sIndex, 0, barCur);
      double   upper_buy   = glArray_upper_level_buy_x[sIndex];
      double   lower_buy   = glArray_lower_level_buy_x[sIndex];
      double   upper_sell  = glArray_upper_level_sell_x[sIndex];
      double   lower_sell  = glArray_lower_level_sell_x[sIndex];
      
      bool     isNotNull   = buf0_0 != EMPTY_VALUE;
      bool     isBuy       = buf0_0 <= upper_buy && buf0_0 >= lower_buy;
      bool     isSell      = buf0_0 >= lower_sell && buf0_0 <= upper_sell;
      
      
      int      lowerTf     = glButtonHandler.GetMinEnabledTf_Extreme();
      bool     isLower     = lowerTf == sIndex;
      
      
      if (isNotNull){
         if (isBuy && sLastSignal != BUY){
            UpdateLastSignal(shift, BUY, HEAD_TO_STRING);
            if (isLower && barCur == 1){
               glCurrent_IsZoneReached    = true;
               glCurrent_ZoneReachedTf    = sTf;
               glCurrent_ZoneReachedTime  = timeC;
               
            }
         }
         if (isSell && sLastSignal != SELL){
            UpdateLastSignal(shift, SELL, HEAD_TO_STRING);
            if (isLower && barCur == 1){
               glCurrent_IsZoneReached    = true;
               glCurrent_ZoneReachedTf    = sTf;
               glCurrent_ZoneReachedTime  = timeC;
            
            }
         }
         
         if (!isBuy && !isSell){
            UpdateLastSignal(shift, NO, HEAD_TO_STRING);
         }
      }
      
      openSignal  = BOTH;
      
      if (!enable_external_use){
         ArrayResize(openStringVals,0);
      
         TM.AddInArray(openStringVals, TM.ToString(isNotNull));
         TM.AddInArray(openStringVals, TM.ToString(isBuy));
         TM.AddInArray(openStringVals, TM.ToString(isSell));
         
         TM.AddInArray(openStringVals, TM.ToString(SEP));
         TM.AddInArray(openStringVals, TM.ToString(isLower));
         TM.AddInArray(openStringVals, TM.ToString(lowerTf));
         TM.AddInArray(openStringVals, TM.ToString(sIndex));
      
         TM.AddInArray(openStringVals, TM.ToString(SEP));
         TM.AddInArray(openStringVals, TM.ToString(buf0_0));
         TM.AddInArray(openStringVals, TM.ToString(upper_buy));
         TM.AddInArray(openStringVals, TM.ToString(lower_buy));
         TM.AddInArray(openStringVals, TM.ToString(upper_sell));
         TM.AddInArray(openStringVals, TM.ToString(lower_sell));
         
         TM.AddInArray(openStringVals, TM.ToString(SEP));
         TM.AddInArray(openStringVals, TM.ToString(shift));
         TM.AddInArray(openStringVals, TM.ToString(barCur));
         
         TM.AddInArray(openStringVals, TM.ToString(SEP));
         TM.AddInArray(openStringVals, TM.ToString(glCurrent_IsZoneReached));
         TM.AddInArray(openStringVals, TM.ToString(glCurrent_ZoneReachedTf));
         TM.AddInArray(openStringVals, TM.ToString(glCurrent_ZoneReachedTime));
      }
   }
   
   void UpdateLastSignal(int shift, SignalType val, string reason){
      if (sLastSignal != val){
         SignalType  old   = sLastSignal;
         sLastSignal = val;
         
         if (!enable_external_use){
            TM.Log(
                  HEAD_TO_STRING+
                  EnumToString(sLastSignal)+", "+
                  EnumToString(old)+", "+
                  TM.ToString(reason)
                  ,shift);
         }
      }
   
   }
};



class FilterDivergenceSignal : public Signal{
   public:
   int               sIndex;
   ENUM_TIMEFRAMES   sTf;
   
   FilterDivergenceSignal(int index){
      sIndex   = index;
      sTf      = glArray_Timeframes[sIndex];
      name     = "FilterDivergenceSignal::"+TM.ToString(sTf);
   }
   
   void CalculateOpenSignal(int shift){
      openSignal = NO;
      
      int      count       = glCv9TdfiDiver.trCounter > 1;
      int      lowerTf     = glButtonHandler.GetMinEnabledTf_Extreme();
      bool     isLower     = lowerTf == sIndex;
      bool     isEnabled   = !count || isLower;
      
      if (!isEnabled){
         openSignal  = BOTH;
         
         if (!enable_external_use){
            ArrayResize(openStringVals,0);
         
            TM.AddInArray(openStringVals, TM.ToString(isEnabled));
            TM.AddInArray(openStringVals, TM.ToString(count));
            TM.AddInArray(openStringVals, TM.ToString(isLower));
            TM.AddInArray(openStringVals, TM.ToString(lowerTf));
         }
         
         return;
      }
           
      
      
      Divergence* diver    = glArray_DivergenceHandler[sIndex].GetLastDivergence(BOTH);
      
      ENUM_POINTER_TYPE pointer  = CheckPointer(diver);
      
      datetime timeBase    = iTime(_Symbol, _Period, shift);
      int      barCur      = iBarShift(_Symbol, sTf, timeBase);
               barCur      = MathMax(1, barCur);
      datetime timeCur     = iTime(_Symbol, sTf, barCur);         
               
      if (!enable_external_use){
         ArrayResize(openStringVals,0);
      
         TM.AddInArray(openStringVals, EnumToString(pointer));
         TM.AddInArray(openStringVals, TM.ToString(barCur));
      
      }
      
      if (pointer != POINTER_INVALID){
         int   bar      = diver.GetBarIndex();
         int   addBar   = sTf == _Period || shift <= 1 ? 1 : 2;
         bool  isReady  = bar == barCur + addBar;
         
         if (!enable_external_use){
         
            TM.AddInArray(openStringVals, TM.ToString(SEP));
            TM.AddInArray(openStringVals, TM.ToString(isReady));
            TM.AddInArray(openStringVals, TM.ToString(bar));
            TM.AddInArray(openStringVals, TM.ToString(addBar));
            TM.AddInArray(openStringVals, TM.ToString(barCur));
         
            TM.AddInArray(openStringVals, TM.ToString(SEP));
            TM.AddInArray(openStringVals, TM.ToString(diver.ToString()));
         }
         
         if (isReady){
            openSignal  = diver.trSignalType;
         }
      }
      
      if (!enable_external_use){
      
         TM.AddInArray(openStringVals, TM.ToString(SEP));
         TM.AddInArray(openStringVals, TM.ToString(timeBase));
         TM.AddInArray(openStringVals, TM.ToString(timeCur));
      }
   }
};

class Filter_Poten_DivergenceSignal : public Signal{
   public:
   int               sIndex;
   ENUM_TIMEFRAMES   sTf;
   
   Filter_Poten_DivergenceSignal(int index){
      sIndex   = index;
      sTf      = glArray_Timeframes[sIndex];
      name     = "Filter_Poten_DivergenceSignal::"+TM.ToString(sTf);
   }
   
   void CalculateOpenSignal(int shift){
      openSignal = NO;
      
      Divergence* diver    = glArray_DivergenceHandler_Forming[sIndex].GetLastDivergence(BOTH);
      
      ENUM_POINTER_TYPE pointer  = CheckPointer(diver);
      
      datetime timeBase    = iTime(_Symbol, _Period, shift);
      int      barCur      = iBarShift(_Symbol, sTf, timeBase);
               barCur      = MathMax(1, barCur);
      datetime timeCur     = iTime(_Symbol, sTf, barCur);         
               
      if (!enable_external_use){
         ArrayResize(openStringVals,0);
      
         TM.AddInArray(openStringVals, EnumToString(pointer));
         TM.AddInArray(openStringVals, TM.ToString(barCur));
      
      }
      
      if (pointer != POINTER_INVALID){
         int   bar      = diver.GetBarIndex();
         int   addBar   = sTf == _Period || shift <= 1 ? 1 : 2;
         bool  isReady  = bar == barCur + addBar;
         
         if (!enable_external_use){
         
            TM.AddInArray(openStringVals, TM.ToString(SEP));
            TM.AddInArray(openStringVals, TM.ToString(isReady));
            TM.AddInArray(openStringVals, TM.ToString(bar));
            TM.AddInArray(openStringVals, TM.ToString(addBar));
            TM.AddInArray(openStringVals, TM.ToString(barCur));
         
            TM.AddInArray(openStringVals, TM.ToString(SEP));
            TM.AddInArray(openStringVals, TM.ToString(diver.ToString()));
         }
         
         if (isReady){
            openSignal  = diver.trSignalType;
         }
      }
      
      if (!enable_external_use){
      
         TM.AddInArray(openStringVals, TM.ToString(SEP));
         TM.AddInArray(openStringVals, TM.ToString(timeBase));
         TM.AddInArray(openStringVals, TM.ToString(timeCur));
      }
   }
};

class Filter_Tdfi_ZoneSignal : public Signal{
   public:
   ENUM_TIMEFRAMES   sTf;
   SignalType        sLastSignal;
   
   Filter_Tdfi_ZoneSignal(ENUM_TIMEFRAMES tf){
      sTf         = tf;
      name        = "Filter_Tdfi_ZoneSignal::"+TM.ToString(sTf);
      sLastSignal = NO;
   }
   
   void CalculateOpenSignal(int shift){
      openSignal = NO;
      
      datetime timeBase = iTime(_Symbol,_Period,shift);
      int      barCur   = iBarShift(_Symbol,sTf,timeBase);
      datetime timeC    = iTime(_Symbol, sTf, barCur);
      
      double   buf0_0   = TM.GetIndicator_TDFI(2, barCur);
      
      bool     isNotNull   = buf0_0 != EMPTY_VALUE;
      
      double   lvl_up_1 = tdfi_lvl_up_1;
      //double   lvl_up_2 = tdfi_lvl_up_2;
      //double   lvl_up_3 = tdfi_lvl_up_3;
      
      double   lvl_dn_1 = tdfi_lvl_dn_1;
      //double   lvl_dn_2 = tdfi_lvl_dn_2;
      //double   lvl_dn_3 = tdfi_lvl_dn_3;
      
      bool     isBuy    = buf0_0 <= lvl_up_1;//(buf0_0 <= lvl_dn_1 && buf0_0 >= lvl_dn_2) || buf0_0 <= lvl_dn_3;
      bool     isSell   = buf0_0 >= lvl_dn_1;//(buf0_0 >= lvl_up_1 && buf0_0 <= lvl_up_2) || buf0_0 >= lvl_up_3;
      
      if (isBuy ){
         openSignal  = BUY;
      }
      if (isSell){
         openSignal  = openSignal == NO ? SELL : BOTH;
      }
      
      if (!enable_external_use){
         ArrayResize(openStringVals,0);
      
         TM.AddInArray(openStringVals, TM.ToString(isBuy));
         TM.AddInArray(openStringVals, TM.ToString(isSell));
         
         TM.AddInArray(openStringVals, TM.ToString(SEP));
         TM.AddInArray(openStringVals, TM.ToString(buf0_0));
         
         TM.AddInArray(openStringVals, TM.ToString(SEP));
         TM.AddInArray(openStringVals, TM.ToString(lvl_up_1));
         //TM.AddInArray(openStringVals, TM.ToString(lvl_up_2));
         //TM.AddInArray(openStringVals, TM.ToString(lvl_up_3));
         TM.AddInArray(openStringVals, TM.ToString(lvl_dn_1));
         //TM.AddInArray(openStringVals, TM.ToString(lvl_dn_2));
         //TM.AddInArray(openStringVals, TM.ToString(lvl_dn_3));
         
         TM.AddInArray(openStringVals, TM.ToString(SEP));
         TM.AddInArray(openStringVals, TM.ToString(shift));
         TM.AddInArray(openStringVals, TM.ToString(barCur));
      }
   }
};


class Filter_v9TdfiDiver_ZoneSignal : public Signal{
   public:
   ENUM_TIMEFRAMES   sTf;
   
   Filter_v9TdfiDiver_ZoneSignal(ENUM_TIMEFRAMES tf){
      sTf         = tf;
      name        = "Filter_v9TdfiDiver_ZoneSignal::"+TM.ToString(sTf);
   }
   
   void CalculateOpenSignal(int shift){
      openSignal = NO;
      
      SignalType  signal   = glCv9TdfiDiver.GetFinalSignal();
      
      openSignal  = signal;
      
      if (!enable_external_use){
         ArrayResize(openStringVals,0);
      
         TM.AddInArray(openStringVals, EnumToString(signal));
         TM.AddInArray(openStringVals, glCv9TdfiDiver.ToString());
      }
   }
};

class FilterTimeSessionSignal : public Signal{
   public:
   datetime sTimeCur;
   
   datetime sArray_TimeStart[];
   datetime sArray_TimeEnd[];
   
   FilterTimeSessionSignal(){
      name = "FilterTimeSessionSignal";
   }
   
   void CalculateOpenSignal(int shift){
      openSignal = NO;
      CalculateTimeSession(trading_session, shift);

      bool  isBoth   = false;
      
      int   sizeS    = ArraySize(sArray_TimeStart);
      int   sizeE    = ArraySize(sArray_TimeEnd);
      
      IFLOG{
         ArrayResize(openStringVals,0);
         
         TM.AddInArray(openStringVals,TM.ToString(sizeS));
         TM.AddInArray(openStringVals,TM.ToString(sizeE));
         TM.AddInArray(openStringVals,TM.ToString(sTimeCur));
         TM.AddInArray(openStringVals,TM.ToString(trading_session));
      }
      
      
      if (sizeS == sizeE && sizeS > 0){
         for (int i = 0; i < sizeE; i++){
         
            datetime sTimeStart  = sArray_TimeStart[i];
            datetime sTimeEnd    = sArray_TimeEnd[i];
            
            bool     isInside    = sTimeCur >= sTimeStart && sTimeCur < sTimeEnd;
            
            if (isInside){
               isBoth   = true;
            }
            
            IFLOG{
               TM.AddInArray(openStringVals,TM.ToString(SEP));
               TM.AddInArray(openStringVals,TM.ToString(isInside));
               TM.AddInArray(openStringVals,TM.ToString(i));
               TM.AddInArray(openStringVals,TM.ToString(sTimeStart));
               TM.AddInArray(openStringVals,TM.ToString(sTimeEnd));
            }
         }
      }

      if (isBoth)
         openSignal = BOTH;
         
   }
   
   void CalculateTimeSession(string session, int shift){
      sTimeCur    = iTime(_Symbol,_Period,shift);
      
      ArrayResize(sArray_TimeStart, 0);
      ArrayResize(sArray_TimeEnd, 0);
   
      string   sessions[]; 
      StringSplit(session,StringGetCharacter("@",0),sessions);
      
      for (int i = 0; i < ArraySize(sessions); i++){
         string   support[]; 
         StringSplit(sessions[i], StringGetCharacter("/",0), support);
         
         datetime sTimeStart  = TM.StrToTimeModified(support[0], shift);
         datetime sTimeEnd    = TM.StrToTimeModified(support[1], shift);
         
         if (sTimeStart >= sTimeEnd){
            if (sTimeEnd > sTimeCur){
               sTimeStart -= 24 * 60 * 60;
            }
            else{
               sTimeEnd += 24 * 60 * 60;
            }
         }
         
         TM.AddInArray(sArray_TimeStart, sTimeStart);
         TM.AddInArray(sArray_TimeEnd, sTimeEnd);
      }
   }
};