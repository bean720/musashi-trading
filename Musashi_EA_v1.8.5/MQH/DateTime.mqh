//+------------------------------------------------------------------+
//|                                                     DateTime.mqh |
//|                        Copyright 2017, MetaQuotes Software Corp. |
//|                                             https://www.mql5.com |
//+------------------------------------------------------------------+
#property copyright "Copyright 2017, MetaQuotes Software Corp."
#property link      "https://www.mql5.com"
#property strict

class DateTime{
   public:
   datetime time;
   
   DateTime(int year,int month,int day,int hour,int minute,int second){
      string time_str = (string)year+"."+(string)month+"."+(string)day+" "+(string)hour+":"+(string)minute+":"+(string)second;
      time = StringToTime(time_str);
   }
};