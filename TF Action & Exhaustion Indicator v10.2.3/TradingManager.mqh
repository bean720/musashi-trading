//+------------------------------------------------------------------+
//|                                               TradingManager.mqh |
//|                        Copyright 2017, MetaQuotes Software Corp. |
//|                                             https://www.mql5.com |
//+------------------------------------------------------------------+
#property copyright "Copyright 2017, MetaQuotes Software Corp."
#property link      "https://www.mql5.com"
#property strict
#include "Enums.mqh"
#include "Structs.mqh"

class TradingManager{
   public:
   StructAlert trStructAlert;
   
   bool     new_bar;
   
   void PrepareInputs(){
      string   filename = fileName+".csv";
      TM.Log(
               HEAD_TO_STRING+
               "Loading data from the file: "+
               filename
               );
               
      int   file_handle = FileOpen(filename,FILE_READ|FILE_CSV,'%');
      int   q           = 0;
      
      string   support[];
      ArrayResize(support,0);
      
      while (!FileIsEnding(file_handle)){
         string str = FileReadString(file_handle);
         
         bool  isLineEnding   = FileIsLineEnding(file_handle);
         
         TM.Log(
                  HEAD_TO_STRING+
                  TM.ToString(isLineEnding)+", "+
                  TM.ToString(str)
                  );
                  
         string sup[];
         TM.ParseStringToArray(str,sup,";");
         
         string   val   = sup[2];         
            
         TM.AddInArray(support, val);   
      }
      
      FileClose(file_handle);
      
      int   size  = ArraySize(support);
      
      TM.Log(
               HEAD_TO_STRING+
               TM.ToString(size)+", "+
               TM.ToStringArray(support,":")
               );
      
      TM.Log(
               HEAD_TO_STRING+
               "restored. ->"+
               TM.ToString(GetLastError())+", "+
               TM.ToString(q)+", "+
               TM.ToString(file_handle)
               );
      
      if (size > 0){
         ParseData(support);
      }
      
      if (true){
         string   obName   = glPrefix+"IsLoaded";
         
         CChartObjectLabel obj;
         
         if (!obj.Create(0,obName,0,20,20)){
            obj.Attach(0,obName,0,1);
         }
         
         obj.Description(size > 0 ? ("File is uploaded: '"+fileName+"'") : ("File is not found: '"+fileName+"'"));
         obj.Color(clrAqua);
         obj.Corner(CORNER_RIGHT_LOWER);
         obj.Anchor(ANCHOR_RIGHT);
         
         obj.Detach();
      }
      
   }
   
   template<typename T1> 
   string ToStringArray(T1 &arr[], string sep, bool isReverse = false){
      string   val   = "";
      int      size  = ArraySize(arr);
      
      if (!isReverse){
         for (int i = 0; i < size; i++){
            val   += ToString(arr[i]);
            
            if (i < size - 1)
               val   += sep;
         }
      }
      else{
         for (int i = size - 1; i >= 0; i--){
            val   += ToString(arr[i]);
            
            if (i > 0)
               val   += sep;
         }
      }
      return   val;
   }
      
   void ParseData(string &support[]){
   
      int   i  = 0;
      
      enable_external_use = (int)support[i++];
      max_bars = (int)support[i++];
      alert_trade_alerts_only = (int)support[i++];
      alert_divergence_enabled = (int)support[i++];
      alert_trade_signal = (int)support[i++];
      divergence_chart_draw_enable = (int)support[i++];
      divergence_forming_enable = (int)support[i++];
      divergence_all_timeframes = (int)support[i++];
      enable_alert = (int)support[i++];
      enable_email = (int)support[i++];
      enable_mobile = (int)support[i++];
      
      color_arrow_up = StringToColor(support[i++]);
      color_arrow_dn = StringToColor(support[i++]);
      width_arrow_up = (int)support[i++];
      width_arrow_dn = (int)support[i++];
      
      color_arrow_up_v9_tdfi_diver = StringToColor(support[i++]);
      color_arrow_dn_v9_tdfi_diver = StringToColor(support[i++]);
      width_arrow_up_v9_tdfi_diver = (int)support[i++];
      width_arrow_dn_v9_tdfi_diver = (int)support[i++];
      
      show_convergence = (EnumShowConvergence)support[i++];
      enable_alert_convergence = (int)support[i++];
      enable_alert_convergence_before_x_min = (int)support[i++];
      alert_convergence_before_x_min = (int)support[i++];
      enable_alert_convergence_line = (int)support[i++];
      panel_settings = support[i++];
      text_input = support[i++];
      startYForText = (int)support[i++];
      text_size = (int)support[i++];
      text_color = StringToColor(support[i++]);
      startXForBut = (int)support[i++];
      startYForBut = (int)support[i++];
      panel_scale = StringToDouble(support[i++]);
      reason_settings = support[i++];
      number_of_reasons = (int)support[i++];
      hilo_enable = (int)support[i++];
      hilo_clr_high = StringToColor(support[i++]);
      hilo_width_high = (int)support[i++];
      hilo_clr_low = StringToColor(support[i++]);
      hilo_width_low = (int)support[i++];
      
      enable_draw_ema         = (int)support[i++];
      reason_ema_m1           = (int)support[i++];
      reason_ema_50_clr_m1    = StringToColor(support[i++]);
      reason_ema_100_clr_m1   = StringToColor(support[i++]);
      reason_ema_m5           = (int)support[i++];
      reason_ema_50_clr_m5    = StringToColor(support[i++]);
      reason_ema_100_clr_m5   = StringToColor(support[i++]);
      reason_ema_m15          = (int)support[i++];
      reason_ema_50_clr_m15   = StringToColor(support[i++]);
      reason_ema_100_clr_m15  = StringToColor(support[i++]);
      reason_ema_h1           = (int)support[i++];
      reason_ema_50_clr_h1    = StringToColor(support[i++]);
      reason_ema_100_clr_h1   = StringToColor(support[i++]);
      reason_ema_h4           = (int)support[i++];
      reason_ema_50_clr_h4    = StringToColor(support[i++]);
      reason_ema_100_clr_h4   = StringToColor(support[i++]);
      reason_ema_d1           = (int)support[i++];
      reason_ema_50_clr_d1    = StringToColor(support[i++]);
      reason_ema_100_clr_d1   = StringToColor(support[i++]);
      reason_ema_w1           = (int)support[i++];
      reason_ema_50_clr_w1    = StringToColor(support[i++]);
      reason_ema_100_clr_w1   = StringToColor(support[i++]);
      reason_ema_mn1          = (int)support[i++];
      reason_ema_50_clr_mn1   = StringToColor(support[i++]);
      reason_ema_100_clr_mn1  = StringToColor(support[i++]);
      
      
      session_settings = support[i++];
      enable_trading_session = (int)support[i++];
      trading_session = support[i++];
      tdfi_settings = support[i++];
      tdfi_enable = (int)support[i++];
      tdfi_tf = (ENUM_TIMEFRAMES)support[i++];
      tdfi_lvl_up_1 = StringToDouble(support[i++]);
      //tdfi_lvl_up_2 = StringToDouble(support[i++]);
      //tdfi_lvl_up_3 = StringToDouble(support[i++]);
      tdfi_lvl_dn_1 = StringToDouble(support[i++]);
      //tdfi_lvl_dn_2 = StringToDouble(support[i++]);
      //tdfi_lvl_dn_3 = StringToDouble(support[i++]);
      tdfi_trendPeriod = (int)support[i++];
      tdfi_MaMethod = (maTypes)support[i++];
      tdfi_MaPeriod = (int)support[i++];
      tdfi_ColorChangeOnZeroCross = (int)support[i++];
      tdfi_Interpolate = (int)support[i++];
      
      
      
      v8_settings                   = support[i++];//"--------------------< v8 Settings >--------------------";//v8 Settings ............................................................................................................
      v8_filter_enable_ema50_m1     = (int)support[i++];
      v8_filter_enable_ema100_m1    = (int)support[i++];
      v8_filter_enable_ema50_m5     = (int)support[i++];
      v8_filter_enable_ema100_m5    = (int)support[i++];
      v8_filter_enable_ema50_m15    = (int)support[i++];
      v8_filter_enable_ema100_m15   = (int)support[i++];
      v8_filter_enable_ema50_m30    = (int)support[i++];
      v8_filter_enable_ema100_m30   = (int)support[i++];
      v8_filter_enable_ema50_h1     = (int)support[i++];
      v8_filter_enable_ema100_h1    = (int)support[i++];
      v8_filter_enable_ema50_h4     = (int)support[i++];
      v8_filter_enable_ema100_h4    = (int)support[i++];
      v8_filter_enable_ema50_d1     = (int)support[i++];
      v8_filter_enable_ema100_d1    = (int)support[i++];
      v8_filter_enable_ema50_w1     = (int)support[i++];
      v8_filter_enable_ema100_w1    = (int)support[i++];
      v8_filter_enable_ema50_mn     = (int)support[i++];
      v8_filter_enable_ema100_mn    = (int)support[i++];
      
      v9_settings                   = support[i++];//"--------------------< v9 Settings >--------------------";//v9 Settings ............................................................................................................
      v9_filter_enable_tdfi_diver   = (int)support[i++];//false;                //Toggle TDFI divergence 
      
      
      
      mbfx_settings_m1 = support[i++];
      mbfx_Len_m1 = (int)support[i++];
      mbfx_Filter_m1 = StringToDouble(support[i++]);
      mbfx_color_buf0_m1 = StringToColor(support[i++]);
      mbfx_color_buf1_m1 = StringToColor(support[i++]);
      mbfx_color_buf2_m1 = StringToColor(support[i++]);
      mbfx_width_buf0_m1 = StringToColor(support[i++]);
      mbfx_width_buf1_m1 = StringToColor(support[i++]);
      mbfx_width_buf2_m1 = StringToColor(support[i++]);
      enable_use_completed_candles_only_m1 = (int)support[i++];
      directional_bias_enable_m1 = (int)support[i++];
      signal_on_color_change_m1 = (int)support[i++];
      extreme_level_enable_m1 = (int)support[i++];
      upper_level_buy_x_m1 = StringToDouble(support[i++]);
      lower_level_buy_x_m1 = StringToDouble(support[i++]);
      upper_level_sell_x_m1 = StringToDouble(support[i++]);
      lower_level_sell_x_m1 = StringToDouble(support[i++]);
      
      divergence_zone_enable_m1 = (int)support[i++];
      divergence_zone_color_buy_m1 = StringToColor(support[i++]);
      divergence_zone_color_sell_m1 = StringToColor(support[i++]);
      divergence_zone_width_m1 = (int)support[i++];
      
      divergence_enable_m1 = (int)support[i++];
      divergence_color_buy_m1 = StringToColor(support[i++]);
      divergence_color_sell_m1 = StringToColor(support[i++]);
      divergence_width_m1 = (int)support[i++];
      
      convergence_enable_m1 = (int)support[i++];
      convergence_color_m1 = StringToColor(support[i++]);
      convergence_width_m1 = (int)support[i++]; 
      delta_filter_enable_m1 = (int)support[i++]; 
      delta_filter_lvl_up_m1 = StringToDouble(support[i++]);
      delta_filter_lvl_dn_m1 = StringToDouble(support[i++]);
      //v8_filter_enable_ema50_100_m1 = StringToDouble(support[i++]);
      
      mbfx_settings_m5 = support[i++]; 
      mbfx_Len_m5 = (int)support[i++]; 
      mbfx_Filter_m5 = StringToDouble(support[i++]);
      mbfx_color_buf0_m5 = StringToColor(support[i++]);
      mbfx_color_buf1_m5 = StringToColor(support[i++]);
      mbfx_color_buf2_m5 = StringToColor(support[i++]);
      mbfx_width_buf0_m5 = StringToColor(support[i++]);
      mbfx_width_buf1_m5 = StringToColor(support[i++]);
      mbfx_width_buf2_m5 = StringToColor(support[i++]);
      enable_use_completed_candles_only_m5 = (int)support[i++];
      directional_bias_enable_m5 = (int)support[i++]; 
      signal_on_color_change_m5 = (int)support[i++]; 
      extreme_level_enable_m5 = (int)support[i++]; 
      upper_level_buy_x_m5 = StringToDouble(support[i++]);
      lower_level_buy_x_m5 = StringToDouble(support[i++]);
      upper_level_sell_x_m5 = StringToDouble(support[i++]);
      lower_level_sell_x_m5 = StringToDouble(support[i++]);
      
      divergence_zone_enable_m5 = (int)support[i++];
      divergence_zone_color_buy_m5 = StringToColor(support[i++]);
      divergence_zone_color_sell_m5 = StringToColor(support[i++]);
      divergence_zone_width_m5 = (int)support[i++];
      
      divergence_enable_m5 = (int)support[i++];
      divergence_color_buy_m5 = StringToColor(support[i++]);
      divergence_color_sell_m5 = StringToColor(support[i++]);
      divergence_width_m5 = (int)support[i++];
      
      convergence_enable_m5 = (int)support[i++];
      convergence_color_m5 = StringToColor(support[i++]);
      convergence_width_m5 = (int)support[i++];
      delta_filter_enable_m5 = (int)support[i++];
      delta_filter_lvl_up_m5 = StringToDouble(support[i++]);
      delta_filter_lvl_dn_m5 = StringToDouble(support[i++]);
      //v8_filter_enable_ema50_100_m5 = StringToDouble(support[i++]);


      mbfx_settings_m15 = support[i++];
      mbfx_Len_m15 = (int)support[i++];
      mbfx_Filter_m15 = StringToDouble(support[i++]);
      mbfx_color_buf0_m15 = StringToColor(support[i++]);
      mbfx_color_buf1_m15 = StringToColor(support[i++]);
      mbfx_color_buf2_m15 = StringToColor(support[i++]);
      mbfx_width_buf0_m15 = (int)support[i++];
      mbfx_width_buf1_m15 = (int)support[i++];
      mbfx_width_buf2_m15 = (int)support[i++];
      enable_use_completed_candles_only_m15 = (int)support[i++];
      directional_bias_enable_m15 = (int)support[i++];
      signal_on_color_change_m15 = StringToColor(support[i++]);
      extreme_level_enable_m15 = (int)support[i++];
      upper_level_buy_x_m15 = StringToDouble(support[i++]);
      lower_level_buy_x_m15 = StringToDouble(support[i++]);
      upper_level_sell_x_m15 = StringToDouble(support[i++]);
      lower_level_sell_x_m15 = StringToDouble(support[i++]);
      
      divergence_zone_enable_m15 = (int)support[i++];
      divergence_zone_color_buy_m15 = StringToColor(support[i++]);
      divergence_zone_color_sell_m15 = StringToColor(support[i++]);
      divergence_zone_width_m15 = (int)support[i++];

      divergence_enable_m15 = (int)support[i++];
      divergence_color_buy_m15 = StringToColor(support[i++]);
      divergence_color_sell_m15 = StringToColor(support[i++]);
      divergence_width_m15 = (int)support[i++];
      convergence_enable_m15 = (int)support[i++];
      convergence_color_m15 = StringToColor(support[i++]);
      convergence_width_m15 = (int)support[i++];
      delta_filter_enable_m15 = (int)support[i++];
      delta_filter_lvl_up_m15 = StringToDouble(support[i++]);
      delta_filter_lvl_dn_m15 = StringToDouble(support[i++]);
      //v8_filter_enable_ema50_100_m15 = StringToDouble(support[i++]);
      
      mbfx_settings_m30 = support[i++];
      mbfx_Len_m30 = (int)support[i++];
      mbfx_Filter_m30 = StringToDouble(support[i++]);
      mbfx_color_buf0_m30 = StringToColor(support[i++]);
      mbfx_color_buf1_m30 = StringToColor(support[i++]);
      mbfx_color_buf2_m30 = StringToColor(support[i++]);
      mbfx_width_buf0_m30 = (int)support[i++];
      mbfx_width_buf1_m30 = (int)support[i++];
      mbfx_width_buf2_m30 = (int)support[i++];
      enable_use_completed_candles_only_m30 = (int)support[i++];
      directional_bias_enable_m30 = (int)support[i++];
      signal_on_color_change_m30 = (int)support[i++];
      extreme_level_enable_m30 = (int)support[i++];
      upper_level_buy_x_m30 = StringToDouble(support[i++]);
      lower_level_buy_x_m30 = StringToDouble(support[i++]);
      upper_level_sell_x_m30 = StringToDouble(support[i++]);
      lower_level_sell_x_m30 = StringToDouble(support[i++]);
      
      divergence_zone_enable_m30 = (int)support[i++];
      divergence_zone_color_buy_m30 = StringToColor(support[i++]);
      divergence_zone_color_sell_m30 = StringToColor(support[i++]);
      divergence_zone_width_m30 = (int)support[i++];

      divergence_enable_m30 = (int)support[i++];
      divergence_color_buy_m30 = StringToColor(support[i++]);
      divergence_color_sell_m30 = StringToColor(support[i++]);
      divergence_width_m30 = (int)support[i++];
      convergence_enable_m30 = (int)support[i++];
      convergence_color_m30 = StringToColor(support[i++]);
      convergence_width_m30 = (int)support[i++];
      //v8_filter_enable_ema50_100_m30 = StringToDouble(support[i++]);
      
      mbfx_settings_h1 = support[i++];
      mbfx_Len_h1 = (int)support[i++];
      mbfx_Filter_h1 = StringToDouble(support[i++]);
      mbfx_color_buf0_h1 = StringToColor(support[i++]);
      mbfx_color_buf1_h1 = StringToColor(support[i++]);
      mbfx_color_buf2_h1 = StringToColor(support[i++]);
      mbfx_width_buf0_h1 = (int)support[i++];
      mbfx_width_buf1_h1 = (int)support[i++];
      mbfx_width_buf2_h1 = (int)support[i++];
      enable_use_completed_candles_only_h1 = (int)support[i++];
      directional_bias_enable_h1 = (int)support[i++];
      signal_on_color_change_h1 = (int)support[i++];
      extreme_level_enable_h1 = (int)support[i++];
      upper_level_buy_x_h1 = StringToDouble(support[i++]);
      lower_level_buy_x_h1 = StringToDouble(support[i++]);
      upper_level_sell_x_h1 = StringToDouble(support[i++]);
      lower_level_sell_x_h1 = StringToDouble(support[i++]);
      
      divergence_zone_enable_h1 = (int)support[i++];
      divergence_zone_color_buy_h1 = StringToColor(support[i++]);
      divergence_zone_color_sell_h1 = StringToColor(support[i++]);
      divergence_zone_width_h1 = (int)support[i++];

      divergence_enable_h1 = (int)support[i++];
      divergence_color_buy_h1 = StringToColor(support[i++]);
      divergence_color_sell_h1 = StringToColor(support[i++]);
      divergence_width_h1 = (int)support[i++];
      convergence_enable_h1 = (int)support[i++];
      convergence_color_h1 = StringToColor(support[i++]);
      convergence_width_h1 = (int)support[i++];
      delta_filter_enable_h1 = (int)support[i++];
      delta_filter_lvl_up_h1 = StringToDouble(support[i++]);
      delta_filter_lvl_dn_h1 = StringToDouble(support[i++]);
      //v8_filter_enable_ema50_100_h1 = StringToDouble(support[i++]);
      
      mbfx_settings_h4 = support[i++];
      mbfx_Len_h4 = (int)support[i++];
      mbfx_Filter_h4 = StringToDouble(support[i++]);
      mbfx_color_buf0_h4 = StringToColor(support[i++]);
      mbfx_color_buf1_h4 = StringToColor(support[i++]);
      mbfx_color_buf2_h4 = StringToColor(support[i++]);
      mbfx_width_buf0_h4 = (int)support[i++];
      mbfx_width_buf1_h4 = (int)support[i++];
      mbfx_width_buf2_h4 = (int)support[i++];
      enable_use_completed_candles_only_h4 = (int)support[i++];
      directional_bias_enable_h4 = (int)support[i++];
      signal_on_color_change_h4 = (int)support[i++];
      extreme_level_enable_h4 = (int)support[i++];
      upper_level_buy_x_h4 = StringToDouble(support[i++]);
      lower_level_buy_x_h4 = StringToDouble(support[i++]);
      upper_level_sell_x_h4 = StringToDouble(support[i++]);
      lower_level_sell_x_h4 = StringToDouble(support[i++]);
      
      divergence_zone_enable_h4 = (int)support[i++];
      divergence_zone_color_buy_h4 = StringToColor(support[i++]);
      divergence_zone_color_sell_h4 = StringToColor(support[i++]);
      divergence_zone_width_h4 = (int)support[i++];

      divergence_enable_h4 = (int)support[i++];
      divergence_color_buy_h4 = StringToColor(support[i++]);
      divergence_color_sell_h4 = StringToColor(support[i++]);
      divergence_width_h4 = (int)support[i++];
      convergence_enable_h4 = (int)support[i++];
      convergence_color_h4 = StringToColor(support[i++]);
      convergence_width_h4 = (int)support[i++];
      delta_filter_enable_h4 = (int)support[i++];
      delta_filter_lvl_up_h4 = StringToDouble(support[i++]);
      delta_filter_lvl_dn_h4 = StringToDouble(support[i++]);
      //v8_filter_enable_ema50_100_h4 = StringToDouble(support[i++]);
      
      mbfx_settings_d1 = support[i++];
      mbfx_Len_d1 = (int)support[i++];
      mbfx_Filter_d1 = StringToDouble(support[i++]);
      mbfx_color_buf0_d1 = StringToColor(support[i++]);
      mbfx_color_buf1_d1 = StringToColor(support[i++]);
      mbfx_color_buf2_d1 = StringToColor(support[i++]);
      mbfx_width_buf0_d1 = (int)support[i++];
      mbfx_width_buf1_d1 = (int)support[i++];
      mbfx_width_buf2_d1 = (int)support[i++];
      enable_use_completed_candles_only_d1 = (int)support[i++];
      directional_bias_enable_d1 = (int)support[i++];
      signal_on_color_change_d1 = (int)support[i++];
      extreme_level_enable_d1 = (int)support[i++];
      upper_level_buy_x_d1 = StringToDouble(support[i++]);
      lower_level_buy_x_d1 = StringToDouble(support[i++]);
      upper_level_sell_x_d1 = StringToDouble(support[i++]);
      lower_level_sell_x_d1 = StringToDouble(support[i++]);
      
      divergence_zone_enable_d1 = (int)support[i++];
      divergence_zone_color_buy_d1 = StringToColor(support[i++]);
      divergence_zone_color_sell_d1 = StringToColor(support[i++]);
      divergence_zone_width_d1 = (int)support[i++];

      divergence_enable_d1 = (int)support[i++];
      divergence_color_buy_d1 = StringToColor(support[i++]);
      divergence_color_sell_d1 = StringToColor(support[i++]);
      divergence_width_d1 = (int)support[i++];
      convergence_enable_d1 = (int)support[i++];
      convergence_color_d1 = StringToColor(support[i++]);
      convergence_width_d1 = (int)support[i++];
      delta_filter_enable_d1 = (int)support[i++];
      delta_filter_lvl_up_d1 = StringToDouble(support[i++]);
      delta_filter_lvl_dn_d1 = StringToDouble(support[i++]);
      //v8_filter_enable_ema50_100_d1 = StringToDouble(support[i++]);
      
      mbfx_settings_w1 = support[i++];
      mbfx_Len_w1 = (int)support[i++];
      mbfx_Filter_w1 = StringToDouble(support[i++]);
      mbfx_color_buf0_w1 = StringToColor(support[i++]);
      mbfx_color_buf1_w1 = StringToColor(support[i++]);
      mbfx_color_buf2_w1 = StringToColor(support[i++]);
      mbfx_width_buf0_w1 = (int)support[i++];
      mbfx_width_buf1_w1 = (int)support[i++];
      mbfx_width_buf2_w1 = (int)support[i++];
      enable_use_completed_candles_only_w1 = (int)support[i++];
      directional_bias_enable_w1 = (int)support[i++];
      signal_on_color_change_w1 = (int)support[i++];
      extreme_level_enable_w1 = (int)support[i++];
      upper_level_buy_x_w1 = StringToDouble(support[i++]);
      lower_level_buy_x_w1 = StringToDouble(support[i++]);
      upper_level_sell_x_w1 = StringToDouble(support[i++]);
      lower_level_sell_x_w1 = StringToDouble(support[i++]);
      
      divergence_zone_enable_w1 = (int)support[i++];
      divergence_zone_color_buy_w1 = StringToColor(support[i++]);
      divergence_zone_color_sell_w1= StringToColor(support[i++]);
      divergence_zone_width_w1 = (int)support[i++];

      divergence_enable_w1 = (int)support[i++];
      divergence_color_buy_w1 = StringToColor(support[i++]);
      divergence_color_sell_w1 = StringToColor(support[i++]);
      divergence_width_w1 = (int)support[i++];
      convergence_enable_w1 = (int)support[i++];
      convergence_color_w1 = StringToColor(support[i++]);
      convergence_width_w1 = (int)support[i++];
      delta_filter_enable_w1 = (int)support[i++];
      delta_filter_lvl_up_w1 = StringToDouble(support[i++]);
      delta_filter_lvl_dn_w1 = StringToDouble(support[i++]);
      //v8_filter_enable_ema50_100_w1 = StringToDouble(support[i++]);
      
      mbfx_settings_mn = support[i++];
      mbfx_Len_mn = (int)support[i++];
      mbfx_Filter_mn = StringToDouble(support[i++]);
      mbfx_color_buf0_mn = StringToColor(support[i++]);
      mbfx_color_buf1_mn = StringToColor(support[i++]);
      mbfx_color_buf2_mn = StringToColor(support[i++]);
      mbfx_width_buf0_mn = (int)support[i++];
      mbfx_width_buf1_mn = (int)support[i++];
      mbfx_width_buf2_mn = (int)support[i++];
      enable_use_completed_candles_only_mn = (int)support[i++];
      directional_bias_enable_mn = (int)support[i++];
      signal_on_color_change_mn = (int)support[i++];
      extreme_level_enable_mn = (int)support[i++];
      upper_level_buy_x_mn = StringToDouble(support[i++]);
      lower_level_buy_x_mn = StringToDouble(support[i++]);
      upper_level_sell_x_mn = StringToDouble(support[i++]);
      lower_level_sell_x_mn = StringToDouble(support[i++]);
      
      divergence_zone_enable_mn = (int)support[i++];
      divergence_zone_color_buy_mn = StringToColor(support[i++]);
      divergence_zone_color_sell_mn = StringToColor(support[i++]);
      divergence_zone_width_mn = (int)support[i++];

      divergence_enable_mn = (int)support[i++];
      divergence_color_buy_mn = StringToColor(support[i++]);
      divergence_color_sell_mn = StringToColor(support[i++]);
      divergence_width_mn = (int)support[i++];
      convergence_enable_mn = (int)support[i++];
      convergence_color_mn = StringToColor(support[i++]);
      convergence_width_mn = (int)support[i++];
      //v8_filter_enable_ema50_100_mn = StringToDouble(support[i++]);
   
   }
      
   
   TradingManager(){
   
   }

   void OnTick(){
      NewBar();
   }

   void NewBar(){
      new_bar = false;
      static datetime flag = 0;
      if (flag != iTime(_Symbol,_Period,0)){
         flag = iTime(_Symbol,_Period,0);
         new_bar = true;
         Log(
               HEAD_TO_STRING+
               ToString(new_bar)+", "+
               ToString(flag)+", "+
               ToString(TimeCurrent())
               );
      }
   }

   void Log(string msg, int shift = 0, string symbol = ""){
      symbol   = symbol == "" ? _Symbol : symbol;
      
      datetime time = ArraySize(Time) ? Time[shift] : TimeCurrent();
      if (!enable_external_use) Print(symbol+", "+TimeToString(time,TIME_DATE|TIME_MINUTES)+", Logger: "+msg);
   }
   
   
   

   
   
   
   
   
   void PrepairData(){
      PrepairPanel();
      PrepairTimeframes();
      PrepairMbfx();
   }
   
   void PrepairPanel(){
      ySizeForBut    = int(20 * panel_scale);  
      xSizeForBut    = int(35 * panel_scale);  
      yPadding       = int(2 * panel_scale);  
      xPadding       = int(2 * panel_scale);  
   }    
   
   void PrepairTimeframes(){
      ArrayResize(glArray_Timeframes,0);
      TM.AddInArray(glArray_Timeframes,PERIOD_M1);
      TM.AddInArray(glArray_Timeframes,PERIOD_M5);
      TM.AddInArray(glArray_Timeframes,PERIOD_M15);
      TM.AddInArray(glArray_Timeframes,PERIOD_M30);
      TM.AddInArray(glArray_Timeframes,PERIOD_H1);
      TM.AddInArray(glArray_Timeframes,PERIOD_H4);
      TM.AddInArray(glArray_Timeframes,PERIOD_D1);
      TM.AddInArray(glArray_Timeframes,PERIOD_W1);
      TM.AddInArray(glArray_Timeframes,PERIOD_MN1);
      
      ActionCopyRate();
   }
   
   
   int GetTfIndexByValue(int tf){
      int      val   = -1;
      for (int i = 0; i < ArraySize(glArray_Timeframes); i++){
         if (glArray_Timeframes[i] == tf){
            val   = i;
            break;
         }
      }
      return   val;
   }
   
   void ActionCopyRate(){
      datetime startTime   = iTime(_Symbol,_Period,max_bars*2);
      datetime stopTime    = TimeCurrent();
      
      for (int i = 0; i < ArraySize(glArray_Timeframes); i++){
         int   tf    = glArray_Timeframes[i];
         int   bars  = iBars(_Symbol,tf);
         MqlRates array[];
         int   count = CopyRates(_Symbol,tf,startTime,stopTime,array);
         ZeroMemory(array);
         
         Log(
               HEAD_TO_STRING+
               EnumToString(ENUM_TIMEFRAMES(tf))+", "+
               ToString(count)+", "+
               ToString(bars)+", "+
               ToString(startTime)+", "+
               ToString(stopTime)
               ,0,_Symbol
               );
      }
   }

   
   void PrepairMbfx(){
   
      int   period   = _Period;
      
      ArrayResize(glArray_mbfx_enable,0);
      TM.AddInArray(glArray_mbfx_enable,period <= PERIOD_M1);
      TM.AddInArray(glArray_mbfx_enable,period <= PERIOD_M5);
      TM.AddInArray(glArray_mbfx_enable,period <= PERIOD_M15);
      TM.AddInArray(glArray_mbfx_enable,period <= PERIOD_M30);
      TM.AddInArray(glArray_mbfx_enable,period <= PERIOD_H1);
      TM.AddInArray(glArray_mbfx_enable,period <= PERIOD_H4);
      TM.AddInArray(glArray_mbfx_enable,period <= PERIOD_D1);
      TM.AddInArray(glArray_mbfx_enable,period <= PERIOD_W1);
      TM.AddInArray(glArray_mbfx_enable,period <= PERIOD_MN1);
      
      ArrayResize(glArray_mbfx_Len,0);
      TM.AddInArray(glArray_mbfx_Len,mbfx_Len_m1);
      TM.AddInArray(glArray_mbfx_Len,mbfx_Len_m5);
      TM.AddInArray(glArray_mbfx_Len,mbfx_Len_m15);
      TM.AddInArray(glArray_mbfx_Len,mbfx_Len_m30);
      TM.AddInArray(glArray_mbfx_Len,mbfx_Len_h1);
      TM.AddInArray(glArray_mbfx_Len,mbfx_Len_h4);
      TM.AddInArray(glArray_mbfx_Len,mbfx_Len_d1);
      TM.AddInArray(glArray_mbfx_Len,mbfx_Len_w1);
      TM.AddInArray(glArray_mbfx_Len,mbfx_Len_mn);
      
      ArrayResize(glArray_mbfx_Filter,0);
      TM.AddInArray(glArray_mbfx_Filter,mbfx_Filter_m1);
      TM.AddInArray(glArray_mbfx_Filter,mbfx_Filter_m5);
      TM.AddInArray(glArray_mbfx_Filter,mbfx_Filter_m15);
      TM.AddInArray(glArray_mbfx_Filter,mbfx_Filter_m30);
      TM.AddInArray(glArray_mbfx_Filter,mbfx_Filter_h1);
      TM.AddInArray(glArray_mbfx_Filter,mbfx_Filter_h4);
      TM.AddInArray(glArray_mbfx_Filter,mbfx_Filter_d1);
      TM.AddInArray(glArray_mbfx_Filter,mbfx_Filter_w1);
      TM.AddInArray(glArray_mbfx_Filter,mbfx_Filter_mn);
      
      ArrayResize(glArray_signal_on_color_change,0);
      TM.AddInArray(glArray_signal_on_color_change,signal_on_color_change_m1);
      TM.AddInArray(glArray_signal_on_color_change,signal_on_color_change_m5);
      TM.AddInArray(glArray_signal_on_color_change,signal_on_color_change_m15);
      TM.AddInArray(glArray_signal_on_color_change,signal_on_color_change_m30);
      TM.AddInArray(glArray_signal_on_color_change,signal_on_color_change_h1);
      TM.AddInArray(glArray_signal_on_color_change,signal_on_color_change_h4);
      TM.AddInArray(glArray_signal_on_color_change,signal_on_color_change_d1);
      TM.AddInArray(glArray_signal_on_color_change,signal_on_color_change_w1);
      TM.AddInArray(glArray_signal_on_color_change,signal_on_color_change_mn);
      
      
      
      
      /*
      bool                 glArray_directional_bias[];
      bool                 glArray_extreme_level_enable[];
      double               glArray_extreme_level_buy_x[];
      double               glArray_extreme_level_sell_x[];
      bool                 glArray_divergence_enable[];
      color                glArray_divergence_color_buy[];
      int                  glArray_divergence_width[];
      
      */
      
      
      
      
      ArrayResize(glArray_directional_bias,0);
      TM.AddInArray(glArray_directional_bias, directional_bias_enable_m1);
      TM.AddInArray(glArray_directional_bias, directional_bias_enable_m5);
      TM.AddInArray(glArray_directional_bias, directional_bias_enable_m15);
      TM.AddInArray(glArray_directional_bias, directional_bias_enable_m30);
      TM.AddInArray(glArray_directional_bias, directional_bias_enable_h1);
      TM.AddInArray(glArray_directional_bias, directional_bias_enable_h4);
      TM.AddInArray(glArray_directional_bias, directional_bias_enable_d1);
      TM.AddInArray(glArray_directional_bias, directional_bias_enable_w1);
      TM.AddInArray(glArray_directional_bias, directional_bias_enable_mn);
      
      ArrayResize(glArray_extreme_level_enable,0);
      TM.AddInArray(glArray_extreme_level_enable, extreme_level_enable_m1);
      TM.AddInArray(glArray_extreme_level_enable, extreme_level_enable_m5);
      TM.AddInArray(glArray_extreme_level_enable, extreme_level_enable_m15);
      TM.AddInArray(glArray_extreme_level_enable, extreme_level_enable_m30);
      TM.AddInArray(glArray_extreme_level_enable, extreme_level_enable_h1);
      TM.AddInArray(glArray_extreme_level_enable, extreme_level_enable_h4);
      TM.AddInArray(glArray_extreme_level_enable, extreme_level_enable_d1);
      TM.AddInArray(glArray_extreme_level_enable, extreme_level_enable_w1);
      TM.AddInArray(glArray_extreme_level_enable, extreme_level_enable_mn);
      
      ArrayResize(glArray_enable_use_completed_candles_only,0);
      TM.AddInArray(glArray_enable_use_completed_candles_only, enable_use_completed_candles_only_m1);
      TM.AddInArray(glArray_enable_use_completed_candles_only, enable_use_completed_candles_only_m5);
      TM.AddInArray(glArray_enable_use_completed_candles_only, enable_use_completed_candles_only_m15);
      TM.AddInArray(glArray_enable_use_completed_candles_only, enable_use_completed_candles_only_m30);
      TM.AddInArray(glArray_enable_use_completed_candles_only, enable_use_completed_candles_only_h1);
      TM.AddInArray(glArray_enable_use_completed_candles_only, enable_use_completed_candles_only_h4);
      TM.AddInArray(glArray_enable_use_completed_candles_only, enable_use_completed_candles_only_d1);
      TM.AddInArray(glArray_enable_use_completed_candles_only, enable_use_completed_candles_only_w1);
      TM.AddInArray(glArray_enable_use_completed_candles_only, enable_use_completed_candles_only_mn);
      
      
      ArrayResize(glArray_reason_ema_50_clr,0);
      TM.AddInArray(glArray_reason_ema_50_clr, reason_ema_50_clr_m1);
      TM.AddInArray(glArray_reason_ema_50_clr, reason_ema_50_clr_m5);
      TM.AddInArray(glArray_reason_ema_50_clr, reason_ema_50_clr_m15);
      TM.AddInArray(glArray_reason_ema_50_clr, clrNONE);
      TM.AddInArray(glArray_reason_ema_50_clr, reason_ema_50_clr_h1);
      TM.AddInArray(glArray_reason_ema_50_clr, reason_ema_50_clr_h4);
      TM.AddInArray(glArray_reason_ema_50_clr, reason_ema_50_clr_d1);
      TM.AddInArray(glArray_reason_ema_50_clr, reason_ema_50_clr_w1);
      TM.AddInArray(glArray_reason_ema_50_clr, reason_ema_50_clr_mn1);

      ArrayResize(glArray_reason_ema_100_clr,0);
      TM.AddInArray(glArray_reason_ema_100_clr, reason_ema_100_clr_m1);
      TM.AddInArray(glArray_reason_ema_100_clr, reason_ema_100_clr_m5);
      TM.AddInArray(glArray_reason_ema_100_clr, reason_ema_100_clr_m15);
      TM.AddInArray(glArray_reason_ema_100_clr, clrNONE);
      TM.AddInArray(glArray_reason_ema_100_clr, reason_ema_100_clr_h1);
      TM.AddInArray(glArray_reason_ema_100_clr, reason_ema_100_clr_h4);
      TM.AddInArray(glArray_reason_ema_100_clr, reason_ema_100_clr_d1);
      TM.AddInArray(glArray_reason_ema_100_clr, reason_ema_100_clr_w1);
      TM.AddInArray(glArray_reason_ema_100_clr, reason_ema_100_clr_mn1);


      
      ArrayResize(glArray_upper_level_buy_x,0);
      TM.AddInArray(glArray_upper_level_buy_x, upper_level_buy_x_m1);
      TM.AddInArray(glArray_upper_level_buy_x, upper_level_buy_x_m5);
      TM.AddInArray(glArray_upper_level_buy_x, upper_level_buy_x_m15);
      TM.AddInArray(glArray_upper_level_buy_x, upper_level_buy_x_m30);
      TM.AddInArray(glArray_upper_level_buy_x, upper_level_buy_x_h1);
      TM.AddInArray(glArray_upper_level_buy_x, upper_level_buy_x_h4);
      TM.AddInArray(glArray_upper_level_buy_x, upper_level_buy_x_d1);
      TM.AddInArray(glArray_upper_level_buy_x, upper_level_buy_x_w1);
      TM.AddInArray(glArray_upper_level_buy_x, upper_level_buy_x_mn);
      
      ArrayResize(glArray_lower_level_buy_x,0);
      TM.AddInArray(glArray_lower_level_buy_x, lower_level_buy_x_m1);
      TM.AddInArray(glArray_lower_level_buy_x, lower_level_buy_x_m5);
      TM.AddInArray(glArray_lower_level_buy_x, lower_level_buy_x_m15);
      TM.AddInArray(glArray_lower_level_buy_x, lower_level_buy_x_m30);
      TM.AddInArray(glArray_lower_level_buy_x, lower_level_buy_x_h1);
      TM.AddInArray(glArray_lower_level_buy_x, lower_level_buy_x_h4);
      TM.AddInArray(glArray_lower_level_buy_x, lower_level_buy_x_d1);
      TM.AddInArray(glArray_lower_level_buy_x, lower_level_buy_x_w1);
      TM.AddInArray(glArray_lower_level_buy_x, lower_level_buy_x_mn);
      
      ArrayResize(glArray_upper_level_sell_x,0);
      TM.AddInArray(glArray_upper_level_sell_x, upper_level_sell_x_m1);
      TM.AddInArray(glArray_upper_level_sell_x, upper_level_sell_x_m5);
      TM.AddInArray(glArray_upper_level_sell_x, upper_level_sell_x_m15);
      TM.AddInArray(glArray_upper_level_sell_x, upper_level_sell_x_m30);
      TM.AddInArray(glArray_upper_level_sell_x, upper_level_sell_x_h1);
      TM.AddInArray(glArray_upper_level_sell_x, upper_level_sell_x_h4);
      TM.AddInArray(glArray_upper_level_sell_x, upper_level_sell_x_d1);
      TM.AddInArray(glArray_upper_level_sell_x, upper_level_sell_x_w1);
      TM.AddInArray(glArray_upper_level_sell_x, upper_level_sell_x_mn);
      
      ArrayResize(glArray_lower_level_sell_x,0);
      TM.AddInArray(glArray_lower_level_sell_x, lower_level_sell_x_m1);
      TM.AddInArray(glArray_lower_level_sell_x, lower_level_sell_x_m5);
      TM.AddInArray(glArray_lower_level_sell_x, lower_level_sell_x_m15);
      TM.AddInArray(glArray_lower_level_sell_x, lower_level_sell_x_m30);
      TM.AddInArray(glArray_lower_level_sell_x, lower_level_sell_x_h1);
      TM.AddInArray(glArray_lower_level_sell_x, lower_level_sell_x_h4);
      TM.AddInArray(glArray_lower_level_sell_x, lower_level_sell_x_d1);
      TM.AddInArray(glArray_lower_level_sell_x, lower_level_sell_x_w1);
      TM.AddInArray(glArray_lower_level_sell_x, lower_level_sell_x_mn);
      



      ArrayResize(glArray_divergence_zone_enable,0);
      TM.AddInArray(glArray_divergence_zone_enable, divergence_zone_enable_m1);
      TM.AddInArray(glArray_divergence_zone_enable, divergence_zone_enable_m5);
      TM.AddInArray(glArray_divergence_zone_enable, divergence_zone_enable_m15);
      TM.AddInArray(glArray_divergence_zone_enable, divergence_zone_enable_m30);
      TM.AddInArray(glArray_divergence_zone_enable, divergence_zone_enable_h1);
      TM.AddInArray(glArray_divergence_zone_enable, divergence_zone_enable_h4);
      TM.AddInArray(glArray_divergence_zone_enable, divergence_zone_enable_d1);
      TM.AddInArray(glArray_divergence_zone_enable, divergence_zone_enable_w1);
      TM.AddInArray(glArray_divergence_zone_enable, divergence_zone_enable_mn);
      
      ArrayResize(glArray_divergence_zone_color_buy,0);
      TM.AddInArray(glArray_divergence_zone_color_buy, divergence_zone_color_buy_m1);
      TM.AddInArray(glArray_divergence_zone_color_buy, divergence_zone_color_buy_m5);
      TM.AddInArray(glArray_divergence_zone_color_buy, divergence_zone_color_buy_m15);
      TM.AddInArray(glArray_divergence_zone_color_buy, divergence_zone_color_buy_m30);
      TM.AddInArray(glArray_divergence_zone_color_buy, divergence_zone_color_buy_h1);
      TM.AddInArray(glArray_divergence_zone_color_buy, divergence_zone_color_buy_h4);
      TM.AddInArray(glArray_divergence_zone_color_buy, divergence_zone_color_buy_d1);
      TM.AddInArray(glArray_divergence_zone_color_buy, divergence_zone_color_buy_w1);
      TM.AddInArray(glArray_divergence_zone_color_buy, divergence_zone_color_buy_mn);
      
      ArrayResize(glArray_divergence_zone_color_sell,0);
      TM.AddInArray(glArray_divergence_zone_color_sell, divergence_zone_color_sell_m1);
      TM.AddInArray(glArray_divergence_zone_color_sell, divergence_zone_color_sell_m5);
      TM.AddInArray(glArray_divergence_zone_color_sell, divergence_zone_color_sell_m15);
      TM.AddInArray(glArray_divergence_zone_color_sell, divergence_zone_color_sell_m30);
      TM.AddInArray(glArray_divergence_zone_color_sell, divergence_zone_color_sell_h1);
      TM.AddInArray(glArray_divergence_zone_color_sell, divergence_zone_color_sell_h4);
      TM.AddInArray(glArray_divergence_zone_color_sell, divergence_zone_color_sell_d1);
      TM.AddInArray(glArray_divergence_zone_color_sell, divergence_zone_color_sell_w1);
      TM.AddInArray(glArray_divergence_zone_color_sell, divergence_zone_color_sell_mn);
      
      ArrayResize(glArray_divergence_zone_width,0);
      TM.AddInArray(glArray_divergence_zone_width, divergence_zone_width_m1);
      TM.AddInArray(glArray_divergence_zone_width, divergence_zone_width_m5);
      TM.AddInArray(glArray_divergence_zone_width, divergence_zone_width_m15);
      TM.AddInArray(glArray_divergence_zone_width, divergence_zone_width_m30);
      TM.AddInArray(glArray_divergence_zone_width, divergence_zone_width_h1);
      TM.AddInArray(glArray_divergence_zone_width, divergence_zone_width_h4);
      TM.AddInArray(glArray_divergence_zone_width, divergence_zone_width_d1);
      TM.AddInArray(glArray_divergence_zone_width, divergence_zone_width_w1);
      TM.AddInArray(glArray_divergence_zone_width, divergence_zone_width_mn);
      
      
      
      
      


      ArrayResize(glArray_divergence_enable,0);
      TM.AddInArray(glArray_divergence_enable, divergence_enable_m1);
      TM.AddInArray(glArray_divergence_enable, divergence_enable_m5);
      TM.AddInArray(glArray_divergence_enable, divergence_enable_m15);
      TM.AddInArray(glArray_divergence_enable, divergence_enable_m30);
      TM.AddInArray(glArray_divergence_enable, divergence_enable_h1);
      TM.AddInArray(glArray_divergence_enable, divergence_enable_h4);
      TM.AddInArray(glArray_divergence_enable, divergence_enable_d1);
      TM.AddInArray(glArray_divergence_enable, divergence_enable_w1);
      TM.AddInArray(glArray_divergence_enable, divergence_enable_mn);
      
      for (int i = 0; i < ArraySize(glArray_divergence_enable); i++){
         TM.Log(
            HEAD_TO_STRING
            +", "+TM.ToString(i)
            +", "+TM.ToString(glArray_divergence_enable[i])
         , 0);
      }
      
      ArrayResize(glArray_divergence_color_buy,0);
      TM.AddInArray(glArray_divergence_color_buy, divergence_color_buy_m1);
      TM.AddInArray(glArray_divergence_color_buy, divergence_color_buy_m5);
      TM.AddInArray(glArray_divergence_color_buy, divergence_color_buy_m15);
      TM.AddInArray(glArray_divergence_color_buy, divergence_color_buy_m30);
      TM.AddInArray(glArray_divergence_color_buy, divergence_color_buy_h1);
      TM.AddInArray(glArray_divergence_color_buy, divergence_color_buy_h4);
      TM.AddInArray(glArray_divergence_color_buy, divergence_color_buy_d1);
      TM.AddInArray(glArray_divergence_color_buy, divergence_color_buy_w1);
      TM.AddInArray(glArray_divergence_color_buy, divergence_color_buy_mn);
      
      ArrayResize(glArray_divergence_color_sell,0);
      TM.AddInArray(glArray_divergence_color_sell, divergence_color_sell_m1);
      TM.AddInArray(glArray_divergence_color_sell, divergence_color_sell_m5);
      TM.AddInArray(glArray_divergence_color_sell, divergence_color_sell_m15);
      TM.AddInArray(glArray_divergence_color_sell, divergence_color_sell_m30);
      TM.AddInArray(glArray_divergence_color_sell, divergence_color_sell_h1);
      TM.AddInArray(glArray_divergence_color_sell, divergence_color_sell_h4);
      TM.AddInArray(glArray_divergence_color_sell, divergence_color_sell_d1);
      TM.AddInArray(glArray_divergence_color_sell, divergence_color_sell_w1);
      TM.AddInArray(glArray_divergence_color_sell, divergence_color_sell_mn);
      
      ArrayResize(glArray_divergence_width,0);
      TM.AddInArray(glArray_divergence_width, divergence_width_m1);
      TM.AddInArray(glArray_divergence_width, divergence_width_m5);
      TM.AddInArray(glArray_divergence_width, divergence_width_m15);
      TM.AddInArray(glArray_divergence_width, divergence_width_m30);
      TM.AddInArray(glArray_divergence_width, divergence_width_h1);
      TM.AddInArray(glArray_divergence_width, divergence_width_h4);
      TM.AddInArray(glArray_divergence_width, divergence_width_d1);
      TM.AddInArray(glArray_divergence_width, divergence_width_w1);
      TM.AddInArray(glArray_divergence_width, divergence_width_mn);
      
      
            



      ArrayResize(glArray_convergence_enable,0);
      TM.AddInArray(glArray_convergence_enable, convergence_enable_m1);
      TM.AddInArray(glArray_convergence_enable, convergence_enable_m5);
      TM.AddInArray(glArray_convergence_enable, convergence_enable_m15);
      TM.AddInArray(glArray_convergence_enable, convergence_enable_m30);
      TM.AddInArray(glArray_convergence_enable, convergence_enable_h1);
      TM.AddInArray(glArray_convergence_enable, convergence_enable_h4);
      TM.AddInArray(glArray_convergence_enable, convergence_enable_d1);
      TM.AddInArray(glArray_convergence_enable, convergence_enable_w1);
      TM.AddInArray(glArray_convergence_enable, convergence_enable_mn);
      
      ArrayResize(glArray_convergence_color,0);
      TM.AddInArray(glArray_convergence_color, convergence_color_m1);
      TM.AddInArray(glArray_convergence_color, convergence_color_m5);
      TM.AddInArray(glArray_convergence_color, convergence_color_m15);
      TM.AddInArray(glArray_convergence_color, convergence_color_m30);
      TM.AddInArray(glArray_convergence_color, convergence_color_h1);
      TM.AddInArray(glArray_convergence_color, convergence_color_h4);
      TM.AddInArray(glArray_convergence_color, convergence_color_d1);
      TM.AddInArray(glArray_convergence_color, convergence_color_w1);
      TM.AddInArray(glArray_convergence_color, convergence_color_mn);
      
      ArrayResize(glArray_convergence_width,0);
      TM.AddInArray(glArray_convergence_width, convergence_width_m1);
      TM.AddInArray(glArray_convergence_width, convergence_width_m5);
      TM.AddInArray(glArray_convergence_width, convergence_width_m15);
      TM.AddInArray(glArray_convergence_width, convergence_width_m30);
      TM.AddInArray(glArray_convergence_width, convergence_width_h1);
      TM.AddInArray(glArray_convergence_width, convergence_width_h4);
      TM.AddInArray(glArray_convergence_width, convergence_width_d1);
      TM.AddInArray(glArray_convergence_width, convergence_width_w1);
      TM.AddInArray(glArray_convergence_width, convergence_width_mn);
      

      ArrayResize(glArray_v8_filter_enable_ema50,0);
      TM.AddInArray(glArray_v8_filter_enable_ema50, v8_filter_enable_ema50_m1);
      TM.AddInArray(glArray_v8_filter_enable_ema50, v8_filter_enable_ema50_m5);
      TM.AddInArray(glArray_v8_filter_enable_ema50, v8_filter_enable_ema50_m15);
      TM.AddInArray(glArray_v8_filter_enable_ema50, v8_filter_enable_ema50_m30);
      TM.AddInArray(glArray_v8_filter_enable_ema50, v8_filter_enable_ema50_h1);
      TM.AddInArray(glArray_v8_filter_enable_ema50, v8_filter_enable_ema50_h4);
      TM.AddInArray(glArray_v8_filter_enable_ema50, v8_filter_enable_ema50_d1);
      TM.AddInArray(glArray_v8_filter_enable_ema50, v8_filter_enable_ema50_w1);
      TM.AddInArray(glArray_v8_filter_enable_ema50, v8_filter_enable_ema50_mn);
      

      ArrayResize(glArray_v8_filter_enable_ema100,0);
      TM.AddInArray(glArray_v8_filter_enable_ema100, v8_filter_enable_ema100_m1);
      TM.AddInArray(glArray_v8_filter_enable_ema100, v8_filter_enable_ema100_m5);
      TM.AddInArray(glArray_v8_filter_enable_ema100, v8_filter_enable_ema100_m15);
      TM.AddInArray(glArray_v8_filter_enable_ema100, v8_filter_enable_ema100_m30);
      TM.AddInArray(glArray_v8_filter_enable_ema100, v8_filter_enable_ema100_h1);
      TM.AddInArray(glArray_v8_filter_enable_ema100, v8_filter_enable_ema100_h4);
      TM.AddInArray(glArray_v8_filter_enable_ema100, v8_filter_enable_ema100_d1);
      TM.AddInArray(glArray_v8_filter_enable_ema100, v8_filter_enable_ema100_w1);
      TM.AddInArray(glArray_v8_filter_enable_ema100, v8_filter_enable_ema100_mn);
      



      ArrayResize(glArray_delta_filter_enable,0);
      TM.AddInArray(glArray_delta_filter_enable, delta_filter_enable_m1);
      TM.AddInArray(glArray_delta_filter_enable, delta_filter_enable_m5);
      TM.AddInArray(glArray_delta_filter_enable, delta_filter_enable_m15);
      TM.AddInArray(glArray_delta_filter_enable, delta_filter_enable_m30);
      TM.AddInArray(glArray_delta_filter_enable, delta_filter_enable_h1);
      TM.AddInArray(glArray_delta_filter_enable, delta_filter_enable_h4);
      TM.AddInArray(glArray_delta_filter_enable, delta_filter_enable_d1);
      TM.AddInArray(glArray_delta_filter_enable, delta_filter_enable_w1);
      TM.AddInArray(glArray_delta_filter_enable, delta_filter_enable_mn);
      
      ArrayResize(glArray_delta_filter_lvl_up,0);
      TM.AddInArray(glArray_delta_filter_lvl_up, delta_filter_lvl_up_m1);
      TM.AddInArray(glArray_delta_filter_lvl_up, delta_filter_lvl_up_m5);
      TM.AddInArray(glArray_delta_filter_lvl_up, delta_filter_lvl_up_m15);
      TM.AddInArray(glArray_delta_filter_lvl_up, delta_filter_lvl_up_m30);
      TM.AddInArray(glArray_delta_filter_lvl_up, delta_filter_lvl_up_h1);
      TM.AddInArray(glArray_delta_filter_lvl_up, delta_filter_lvl_up_h4);
      TM.AddInArray(glArray_delta_filter_lvl_up, delta_filter_lvl_up_d1);
      TM.AddInArray(glArray_delta_filter_lvl_up, delta_filter_lvl_up_w1);
      TM.AddInArray(glArray_delta_filter_lvl_up, delta_filter_lvl_up_mn);
      
      ArrayResize(glArray_delta_filter_lvl_dn,0);
      TM.AddInArray(glArray_delta_filter_lvl_dn, delta_filter_lvl_dn_m1);
      TM.AddInArray(glArray_delta_filter_lvl_dn, delta_filter_lvl_dn_m5);
      TM.AddInArray(glArray_delta_filter_lvl_dn, delta_filter_lvl_dn_m15);
      TM.AddInArray(glArray_delta_filter_lvl_dn, delta_filter_lvl_dn_m30);
      TM.AddInArray(glArray_delta_filter_lvl_dn, delta_filter_lvl_dn_h1);
      TM.AddInArray(glArray_delta_filter_lvl_dn, delta_filter_lvl_dn_h4);
      TM.AddInArray(glArray_delta_filter_lvl_dn, delta_filter_lvl_dn_d1);
      TM.AddInArray(glArray_delta_filter_lvl_dn, delta_filter_lvl_dn_w1);
      TM.AddInArray(glArray_delta_filter_lvl_dn, delta_filter_lvl_dn_mn);
      
      
   }
   
   ENUM_TIMEFRAMES GetLowestTimeframe(){
      ENUM_TIMEFRAMES   val   = (ENUM_TIMEFRAMES)-1;
      
      for (int i = 0; i < ArraySize(glArray_mbfx_enable); i++){
         
         if (glArray_mbfx_enable[i]){
            val   = glArray_Timeframes[i];
            break;
         }
         
      }
      
      return   val;
   }
   
   double GetIndicator_Mdfx(int index,int mode,int shift){
      double val = iCustom(Symbol(),
                                 glArray_Timeframes[index],
                                 glPathIndicator_mbfx_timing_indicator,
                                 
                                 glArray_mbfx_Len[index],
                                 glArray_mbfx_Filter[index],
                                 
                                 mode,shift
                                 );
      return val;                           
   }
   
   double GetIndicator_TDFI(int mode,int shift){
      double val = iCustom(Symbol(),
                                 tdfi_tf,
                                 glPathIndicator_tdfia,
                                 
                                 tdfi_TimeFrame                ,// PERIOD_CURRENT;
                                 tdfi_trendPeriod              ,// 20;
                                 tdfi_lvl_up_1                ,// 0.05; 
                                 tdfi_lvl_dn_1              ,// -0.05; 
                                 tdfi_MaMethod                 ,// 19;
                                 tdfi_MaPeriod                 ,// 8; 
                                 tdfi_ColorChangeOnZeroCross   ,// false;
                                 tdfi_alertsOn                 ,// false;
                                 tdfi_alertsOnCurrentBar       ,// false;
                                 tdfi_alertsMessage            ,// false;
                                 tdfi_alertsSound              ,// false;
                                 tdfi_alertsEmail              ,// false;
                                 tdfi_alertsNotify             ,// false;
                                 tdfi_Interpolate              ,// true;
                                 
                                 mode,shift
                                 );
      return val;                           
   }
   
   int FractFactor(){
      if (_Digits == 5 || _Digits == 3) return 10;
      return 1;
   }
   
   double Pip(string symbol){
      return SymbolInfoDouble(symbol,SYMBOL_POINT) * FractFactor();
   }
   
   string ToString(ENUM_TIMEFRAMES value){
      string   val   = value == PERIOD_CURRENT ? EnumToString((ENUM_TIMEFRAMES)_Period) : EnumToString(value);
      StringReplace(val,"PERIOD_","");
      return val;
   }
   
   string ToString(color value){
      return (string)value;
   }
   
   string ToString(int value){
      return (string)value;
   }
   
   string ToString(uint value){
      return (string)value;
   }
   
   string ToString(bool value){
      return (string)value;
   }
   
   string ToString(double value,int digits = -1){
      digits = (digits == -1) ? _Digits : digits;
      string msg = value == EMPTY_VALUE ? "E_VAL" : value == SEP ? " | " : DoubleToString(value, value ? digits : 0);
      return msg;
   }
   
   
   string ToString(string value){
      return value == "" ? "Null_String" : value;
   }
   
   string ToString(datetime value){
      return value ? TimeToStr(value,TIME_DATE|TIME_SECONDS) : "Null_Time";
   }
   
   template<typename T1,typename T2> 
   void AddInArray(T1 &array[], T2 val){
      ArrayResize(array,ArrayRange(array,0)+1);
      array[ArrayRange(array,0)-1] = val;
   }
   
   
   
   
   
   void ParseStringToArray(string source,double &destination[],string sep = ", "){
      string support[];
      StringSplit(source,StringGetCharacter(sep,0),support);
      ArrayResize(destination,ArrayRange(support,0));
      for (int i = 0;i < ArrayRange(support,0);i++){
         destination[i] = StrToDouble(support[i]);
      }
   }
   
   void ParseStringToArray(string source,int &destination[],string sep = ", "){
      string support[];
      StringSplit(source,StringGetCharacter(sep,0),support);
      ArrayResize(destination,ArrayRange(support,0));
      for (int i = 0;i < ArrayRange(support,0);i++){
         destination[i] = (int)(support[i]);
      }
   }
   
   void ParseStringToArray(string source,string &destination[],string sep = ","){
      string support[];
      StringSplit(source,StringGetCharacter(sep,0),support);
      ArrayResize(destination,ArrayRange(support,0));
      for (int i = 0;i < ArrayRange(support,0);i++){
         destination[i] = support[i];
      }
   }
   
   int GetPeriodReal(ENUM_TIMEFRAMES tf, int period){
      int   val      = 0;
      
      bool  isLower  = tf < _Period;
      
      val   = isLower ? period / (_Period / tf) : period;
      
      return   val;
   }
   
   double GetIndicator_MA_50(ENUM_TIMEFRAMES tf, ENUM_TIMEFRAMES &tfReal, int &periodReal, int shift){
   
      tfReal      = tf < _Period ? (ENUM_TIMEFRAMES)_Period : tf;
      periodReal  = GetPeriodReal(tf, ma_50_period);
   
      double val = iMA(Symbol(),
                                          tfReal,
      
                                          periodReal,
                                          ma_50_shift,
                                          ma_50_method,
                                          ma_50_applied_price,
                                          
                                          shift
                                          );
      return val;                           
   }
   
   double GetIndicator_MA_100(ENUM_TIMEFRAMES tf, ENUM_TIMEFRAMES &tfReal, int &periodReal, int shift){
      tfReal      = tf < _Period ? (ENUM_TIMEFRAMES)_Period : tf;
      periodReal  = GetPeriodReal(tf, ma_100_period);
   
      double val = iMA(Symbol(),
                                          tfReal,
      
                                          periodReal,
                                          ma_100_shift,
                                          ma_100_method,
                                          ma_100_applied_price,
                                          
                                          shift
                                          );
      return val;                           
   }
   
   
   int GetIndicatorSubWindow(){
      int   val   = 0;
      
      int   subWindows  = (int)ChartGetInteger(0,CHART_WINDOWS_TOTAL);
      
      for (int i = 0; i < subWindows; i++){
         
         int   indicators  = ChartIndicatorsTotal(0,i);
         
         for (int y = 0; y < indicators; y++){
            string   indiName = ChartIndicatorName(0,i,y);
            
            if (indiName == prefix){
               val   = i;
               break;
            }
         }
      }
      
      return   val;
   }
   
   datetime StrToTimeModified(string str_time, int shift){
      StructDateTime dt;
      dt.PrepairTimeByString(str_time, shift);
      return dt.trTime;
   }
   
   template<typename T1> 
   bool IsInArray(T1 val,T1 &array[]){
      bool result = false;
      for (int i = 0;i < ArrayRange(array,0);i++){
         if (val == array[i]){
            result = true;
            break;
         }
      }
      return result;
   }
   
};
TradingManager* TM;