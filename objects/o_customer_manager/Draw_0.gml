draw_set_color(c_white);
draw_text(16, 16,
    "L busy=" + string(regs[0].busy) + " slot=" + string(regs[0].slot_taken) + "\n" +
    "R busy=" + string(regs[1].busy) + " slot=" + string(regs[1].slot_taken) + "\n" +
    "queue=" + string(array_length(queue))
);