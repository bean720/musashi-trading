//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
#property strict

#define  HEAD_TO_STRING __FUNCTION__+" : "+TM.ToString(__LINE__)+" : "

#define  IFLOG          if (enable_logging)

#define  LOG(msg)                \
   if (enable_logging)           \
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
      
#define     SYMPER            _Symbol,_Period
#define     OPEN(bar)         iOpen(SYMPER,bar)
#define     HIGH(bar)         iHigh(SYMPER,bar)
#define     LOW(bar)          iLow(SYMPER,bar)
#define     CLOSE(bar)        iClose(SYMPER,bar)
#define     TIME(bar)         iTime(SYMPER,bar)

#define     CANDLE_DIRECTION(open,close)                                   \
   open < close ? BUY : open > close ? SELL : NO                           \
   

#define  DEF_GLOBAL_PREFIX "GLOB_T_"

#define  glPrefix          "Ex_"
#define  glBaseFileName    glPrefix+_Symbol+"_"+TM.ToString(magic_number)+"_"
#define  glBaseFotmat      ".csv"

#define  IS_NOT_NULL(instance)         CheckPointer(instance) != POINTER_INVALID
#define  TO_STRING_INSTANCE(instance)  IS_NOT_NULL(instance) ? instance.ToString() : " | NULL | "


#define  DEBUG_DELAY_START       ulong msStart  = GetMicrosecondCount();
#define  DEBUG_DELAY_STOP        ulong msStop   = GetMicrosecondCount();
#define  DEBUG_GET_RESULT        DEBUG_DELAY_STOP                          \
                                 static ulong glMicrSecTotal   = 0;        \
                                 ulong difr     = msStop - msStart;        \
                                 glMicrSecTotal += difr;                   \
                                 TM.Log(                                   \
                                       HEAD_TO_STRING+                     \
                                       TM.ToString(glMicrSecTotal)+", "+   \
                                       TM.ToString(difr)+", "+             \
                                       TM.ToString(msStart)+", "+          \
                                       TM.ToString(msStop)                 \
                                       );                                  \


//---


//---
#define ForEachSymbol(symbol, i)                                           \
   string   symbol   = SymbolName(0,true);                                 \
   int      os_total = SymbolsTotal(true);                                 \
   for(int i = 1; i < os_total; i++, symbol = SymbolName(i,true))

//---
#define ForEachOrder(ticket, i)                                                              \
   if (OrderSelect(0,SELECT_BY_POS)){}                                                       \
   int   ticket      = OrderTicket();                                                           \
   int   or_total_1  = OrdersTotal();                                                           \
   for(int i = 0; i < or_total_1; i++, OrderSelect(i,SELECT_BY_POS), ticket = OrderTicket())
//---

#define ForEachOrderStruct(order, i)                                                         \
   int   or_total_2 = OrdersTotal();                                                         \
   StructOrder order;                                                                        \
   ZeroMemory(order);                                                                        \
   order.Initialize(0,SELECT_BY_POS);                                                        \
   for(int i = 0; i < or_total_2; i++, order.Initialize(i,SELECT_BY_POS))

//---
#define FOREACH(i,array)                        \
   for (int i = 0; i < ArraySize(array); i++)   \


/*
   ForEachOrderStruct(order,index){
      LOG(
            TM.ToString(index)+", "+
            TM.ToString(order.ToString())
            );
   }

   ForEachOrder(ticket,index){
      LOG(
            TM.ToString(index)+", "+
            TM.ToString(ticket)
            );
   }
*/

//---

#define XRGB(r,g,b)     (0xFF000000|(uchar(b)<<16)|(uchar(g)<<8)|uchar(r))
#define GETRGB(clr)     ((clr)&0xFFFFFF)
#define clrRandom       (color)GETRGB(XRGB(rand()%255,rand()%255,rand()%255));


const double   SEP      = 123456789.987654321;
const string   MAIN     = "Main";
const string   HEDGE    = "Hedge";


enum SignalType {
   BUY,
   SELL,
   BOTH,
   NO
};

enum MM_TYPE {
   fixed,
   risk_based,
   risk_based_custom,
   lot_per_money
};

enum EnumTradeType {
   MainTrade,
   HedgeTrade,
};

enum EnumTradeDir {
   TradeDirectionOnlyBuy,     //Only Buy
   TradeDirectionOnlySell,    //Only Sell
   TradeDirectionBoth         //Both
};
//+------------------------------------------------------------------+
