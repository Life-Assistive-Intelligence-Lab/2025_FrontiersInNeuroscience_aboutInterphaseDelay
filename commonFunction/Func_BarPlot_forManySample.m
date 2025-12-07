% Plot individual values, mean, and s.d. used for statistical analysis. 
% Note: This function was used exclusively for Figure 2.
function Func_BarPlot_forManySample(x,y,x_size,color_code,marker_size)
    
    % Bar - the mean
    bar_x_list = [(x-(x_size/2)) (x-(x_size/2)) (x+(x_size/2)) (x+(x_size/2))];
    bar_y_list = [0              mean(y)        mean(y)        0             ];
    pgon = polyshape(bar_x_list,bar_y_list);
    plot(pgon,'FaceColor',color_code,'FaceAlpha',0.5,'EdgeColor','none')


    % Marker - Each value
    marker_list = {'diamond','pentagram','hexagram','*','x','+','o','v','^','<','>','square'};
    marker_Fixsize = [1 1 1 1 1 1 1.25 1 1 1 1 1.7];

    for forEach_idx = 1:max(size(y))
        modulatedX = x + (forEach_idx-1-(max(size(y))-1)/2) * x_size /12;
        scatter_data = scatter(modulatedX,y(forEach_idx),marker_size*marker_Fixsize(forEach_idx),char(marker_list(forEach_idx)));
        scatter_data.MarkerFaceColor = '#FFFFFF';
        scatter_data.MarkerFaceAlpha = 1;
        scatter_data.MarkerEdgeColor = color_code;
        scatter_data.LineWidth = 1;
    end

    % Errobar - standard error of the mean（SEM）
    y_sem = std(y);
    x_sem_length = (x_size/2)/2;
    x_top = [(x) (x-x_sem_length) (x+x_sem_length) (x)];
    x_btm = [(x) (x-x_sem_length) (x+x_sem_length) (x) ];
    y_top = [1 1 1 1]*(mean(y)+y_sem);
    y_btm = [1 1 1 1]*(mean(y)-y_sem);
    plot([x_top x_btm],[y_top y_btm],'-','Color','k','LineWidth',1.5)
end