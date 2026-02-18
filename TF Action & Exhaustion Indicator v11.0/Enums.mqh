//+------------------------------------------------------------------+
//|                                                        Enums.mqh |
//|                        Copyright 2017, MetaQuotes Software Corp. |
//|                                             https://www.mql5.com |
//+------------------------------------------------------------------+
#property copyright "Copyright 2017, MetaQuotes Software Corp."
#property link      "https://www.mql5.com"
#property strict

#define  HEAD_TO_STRING __FUNCTION__+" : "+TM.ToString(__LINE__)+" : "

#define  IFLOG          if (!enable_external_use)

#define  glPrefix       "EX_"

#define  IS_NOT_NULL(instance)   CheckPointer(instance) != POINTER_INVALID

#define  ADD_REASON_SIGNALS(sh)                                         \
   if (hilo_enable){                                                    \
      sh.AddSignal(new Filter_Reason_HiLoSignal());                     \
   }                                                                    \
   if (reason_ema_m1){                                                  \
      if (_Period <= PERIOD_M5){                                        \
         sh.AddSignal(new Filter_Reason_EmaTfSignal(PERIOD_M1));        \
      }                                                                 \
   }                                                                    \
   if (reason_ema_m5){                                                  \
      if (_Period <= PERIOD_M15){                                       \
         sh.AddSignal(new Filter_Reason_EmaTfSignal(PERIOD_M5));        \
      }                                                                 \
   }                                                                    \
   if (reason_ema_m15){                                                 \
      if (_Period <= PERIOD_H1){                                        \
         sh.AddSignal(new Filter_Reason_EmaTfSignal(PERIOD_M15));       \
      }                                                                 \
   }                                                                    \
   if (reason_ema_h1){                                                  \
      if (_Period <= PERIOD_H4){                                        \
         sh.AddSignal(new Filter_Reason_EmaTfSignal(PERIOD_H1));        \
      }                                                                 \
   }                                                                    \
   if (reason_ema_h4){                                                  \
      if (_Period <= PERIOD_D1){                                        \
         sh.AddSignal(new Filter_Reason_EmaTfSignal(PERIOD_H4));        \
      }                                                                 \
   }                                                                    \
   if (reason_ema_d1){                                                  \
      if (_Period <= PERIOD_W1){                                        \
         sh.AddSignal(new Filter_Reason_EmaTfSignal(PERIOD_D1));        \
      }                                                                 \
   }                                                                    \
   if (reason_ema_w1){                                                  \
      if (_Period <= PERIOD_MN1){                                       \
         sh.AddSignal(new Filter_Reason_EmaTfSignal(PERIOD_W1));        \
      }                                                                 \
   }                                                                    \
   if (reason_ema_mn1){                                                 \
      if (_Period <= PERIOD_MN1){                                       \
         sh.AddSignal(new Filter_Reason_EmaTfSignal(PERIOD_MN1));       \
      }                                                                 \
   }                                                                    \
   sh.AddSignal(new FilterReasonCommulativeSignal());                   \




const double   SEP      = 123456789.987654321;


enum SignalType{
   BUY,
   SELL,
   BOTH,
   NO
};

enum EnumShowConvergence{
   EnumShowConvergence_All,            //All
   EnumShowConvergence_OnlyUpcomming,  //Upcomming
   EnumShowConvergence_LastTwo         //Last Two
};

enum maTypes
{
   ma_sma,     // simple moving average - SMA
   ma_ema,     // exponential moving average - EMA
   ma_dsema,   // double smoothed exponential moving average - DSEMA
   ma_dema,    // double exponential moving average - DEMA
   ma_tema,    // tripple exponential moving average - TEMA
   ma_smma,    // smoothed moving average - SMMA
   ma_lwma,    // linear weighted moving average - LWMA
   ma_pwma,    // parabolic weighted moving average - PWMA
   ma_alxma,   // Alexander moving average - ALXMA
   ma_vwma,    // volume weighted moving average - VWMA
   ma_hull,    // Hull moving average
   ma_tma,     // triangular moving average
   ma_sine,    // sine weighted moving average
   ma_linr,    // linear regression value
   ma_ie2,     // IE/2
   ma_nlma,    // non lag moving average
   ma_zlma,    // zero lag moving average
   ma_lead,    // leader exponential moving average
   ma_ssm,     // super smoother
   ma_smoo     // smoother
};
