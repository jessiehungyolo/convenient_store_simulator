////////////////////////////////////////////////////////////////////////////////
// o_customer_manager.Draw GUI  （可刪除）
// 顯示倒 Y 的錨點與服務點，方便檢查佈局
////////////////////////////////////////////////////////////////////////////////
draw_set_alpha(0.6);

// 中央錨點
draw_set_color(c_aqua);
draw_circle(center_x, center_y, 4, false);

// 兩個服務點
draw_set_color(c_yellow);
for (var i = 0; i < array_length(front_pos); i++) {
    draw_circle(front_pos[i].x, front_pos[i].y, 4, false);
}

// 註記文字
draw_set_alpha(1);
draw_set_color(c_white);
draw_text(center_x + 8, center_y - 14, "Queue Anchor");
draw_text(front_pos[0].x + 8, front_pos[0].y - 14, "Register L");
draw_text(front_pos[1].x + 8, front_pos[1].y - 14, "Register R");
