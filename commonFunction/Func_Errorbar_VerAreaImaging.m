% Plot a shaded region representing error bars (s.d. or s.e.m.).
function plotData = Func_Errorbar_VerAreaImaging(x_list,y_list,sem_list,color_code)
    upper_y_list = y_list + sem_list;
    bottm_y_list = y_list - sem_list;
    hold on
    fill([x_list x_list(end:-1:1)],[upper_y_list bottm_y_list(end:-1:1)],color_code,'EdgeColor','none','FaceAlpha',0.3)
    plotData = plot(x_list,y_list,'-','Color',color_code,'LineWidth',1.5);

end