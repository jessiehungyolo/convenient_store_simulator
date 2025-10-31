// 清潔判定
clean_radius   = 36;                // 玩家需在這距離內
clean_time     = room_speed * 2;    // 3 秒完成
progress       = 0;                 // 當前累積進度

// 正在清潔的玩家
current_cleaner = noone;

// 用於偵測清潔者是否「原地不動」
last_cleaner_x = 0;
last_cleaner_y = 0;
