draw_self();

if (carry_coffee) {
    // 用你自己的咖啡 sprite 名稱替換 spr_coffee
    var offset_y = 40; // 咖啡距離頭頂的高度
    draw_sprite(spr_coffee, 0, x, y - offset_y);
}
