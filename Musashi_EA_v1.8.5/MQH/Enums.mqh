//+------------------------------------------------------------------+
//|                                                        Enums.mqh |
//|                        Copyright 2017, MetaQuotes Software Corp. |
//|                                             https://www.mql5.com |
//+------------------------------------------------------------------+
#property copyright "Copyright 2017, MetaQuotes Software Corp."
#property link      "https://www.mql5.com"
#property strict

#define  HEAD_TO_STRING __FUNCTION__+" : "+TM.ToString(__LINE__)+" : "

#define        FILE_SEP_LEVEL_TRADES   ";"
#define        FILE_SEP_LEVEL_2        "%"
#define        FILE_SEP_LEVEL_1        "|"

#define        FILE_SEP_LEVEL_3        "@"
#define        FILE_SEP_LEVEL_4        "^"
#define        FILE_SEP_LEVEL_5        "!"

#define        DEF_GLOBAL_PREFIX       "GLOB_T_"


#define        COMBOBOX_EMPTY          "--- File with inputs..."

const double   SEP      = 123456789.987654321;
const string   PANEL    = "Panel";
const string   MAIN     = "Main";
const string   PYRAMID  = "Pyramid";
const string   LOSS_REC = "LossRec";

#define  LOG(msg)                \
      TM.Log(                    \
               HEAD_TO_STRING+   \
               msg               \
               );                \
               
               
#define  LOG_NEWBAR(msg)         \
   if (TM.new_bar)               \
      LOG(msg)                   \

#define  LOG_NEWBAR_OR(condition, msg) \
   if (TM.new_bar || condition)        \
      LOG(msg)      
               
               
#define  IS_NOT_NULL(instance)         CheckPointer(instance) != POINTER_INVALID
#define  TO_STRING_INSTANCE(instance)  IS_NOT_NULL(instance) ? instance.ToString() : " | NULL | "


#define     SYMPER            _Symbol,_Period
#define     OPEN(bar)         iOpen(SYMPER,bar)
#define     HIGH(bar)         iHigh(SYMPER,bar)
#define     LOW(bar)          iLow(SYMPER,bar)
#define     CLOSE(bar)        iClose(SYMPER,bar)
#define     TIME(bar)         iTime(SYMPER,bar)

#define     CANDLE_DIRECTION(open,close)                                   \
   open < close ? BUY : open > close ? SELL : NO                           \
   

//--- 

#define  DEBUG_DELAY_START       ulong msStart  = GetMicrosecondCount();
#define  DEBUG_DELAY_STOP        ulong msStop   = GetMicrosecondCount();
#define  DEBUG_GET_RESULT        DEBUG_DELAY_STOP                          \
                                 static ulong glMicrSecTotal   = 0;        \
                                 ulong difr     = (msStop - msStart);      \
                                 ulong difrMs   = difr / 1000;             \
                                 glMicrSecTotal += difr;                   \
                                 if (TM.new_bar || difrMs >= 100)          \
                                    LOG(                                   \
                                       TM.ToString(difrMs)+", "+           \
                                       TM.ToString(difr)+", "+             \
                                       TM.ToString(glMicrSecTotal)+", "+   \
                                       TM.ToString(msStart)+", "+          \
                                       TM.ToString(msStop)                 \
                                       );                                  \


//---


               
               
#define XRGB(r,g,b)     (0xFF000000|(uchar(b)<<16)|(uchar(g)<<8)|uchar(r))
#define GETRGB(clr)     ((clr)&0xFFFFFF)
#define clrRandom       (color)GETRGB(XRGB(rand()%255,rand()%255,rand()%255))


enum EnumColumnType{
   ColumnTypeHead1,   
   ColumnTypeHead2,   
   ColumnTypeMain,    
   ColumnTypeFoot,    
};

enum SignalType{
   BUY,
   SELL,
   BOTH,
   NO
};

enum MM_TYPE{
   fixed,
   risk_based
};

enum EnumTradeType{
   MainTrade,
   HedgeTrade,
};

enum EnumPyramidType{
   PyramidTypeBase,
   PyramidTypeMbfx,
};

enum EnumPriceAboveMa{
   PriceAboveMaBuy,        //Buy
   PriceAboveMaSell,       //Sell
};

enum EnumSlType{
   SlTypeAtrs,     //ATR
   SlTypePips,    //Pips
};

enum EnumLossRecoveryType{
   LossRecoveryTypePips,   //Pips
   LossRecoveryTypePerc,   //Percentage
};

enum EnumTradeDir{
   TradeDirectionOnlyBuy,     //Only Buy
   TradeDirectionOnlySell,    //Only Sell
   TradeDirectionBoth         //Both
};

enum EnumTPadEntryType{
   TPadEntryTypeDisabled,     //Disabled
   TPadEntryTypePrice,        //Price
   //TPadEntryTypeEma,          //EMA
};

enum EnumTPadExitType_TP{
   TPadExitType_TP_Disabled,     
   TPadExitType_TP_Price,     
   TPadExitType_TP_Pips,     
   TPadExitType_TP_Ema,     
};

enum EnumTPadExitType_SL{
   TPadExitType_SL_Disabled,     
   TPadExitType_SL_Price,     
   TPadExitType_SL_Pips,     
   TPadExitType_SL_Ema,     
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
