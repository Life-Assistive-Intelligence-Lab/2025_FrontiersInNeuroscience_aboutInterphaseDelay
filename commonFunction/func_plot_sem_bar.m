% ploting errorbar
function func_plot_sem_bar(x,y,sem,barLength,color,semLength)
    x_top = [(x) (x-semLength/2) (x+semLength/2) (x)];
    y_top = [1 1 1 1]*(y+sem);
    x_btm = [(x) (x-semLength/2) (x+semLength/2) (x) ];
    y_btm = [1 1 1 1]*(y-sem);

    plot([x_top x_btm],[y_top y_btm],'-','Color',color,'LineWidth',barLength)
end