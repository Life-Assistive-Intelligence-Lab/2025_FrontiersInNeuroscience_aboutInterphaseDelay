function SupplementaryFig2CDE_Block_TemporalSummation
    rpwd = pwd;
    figure('Position', [30 100 1800 850]);
    hold on

    Func_plot_EachRow(1,1:3) % Figure 2C
    Func_plot_EachRow(2,4:10) % Figure 2D
    Func_plot_EachRow(3,11:40) % Figure 2E
   
    cd(rpwd)
end

function Func_plot_EachRow(plot_row,bin_range)

    tissueSlice_list = DataList_forFig2;
    tissueSlice_list = tissueSlice_list(7:12);
    stim_list = {'10uA_IPD0usec','10uA_IPD200usec','10uA_IPD400usec','10uA_IPD600usec','10uA_IPD800usec','10uA_IPD1000usec','10uA_Cathode','10uA_Anode'};
    
   
    [~,data_list] = func_make_data(tissueSlice_list,'10uA_Cathode','10uA_Cathode',bin_range);
    maxValue_cathode = max(mean(data_list,1));

    for forEach_stim = max(size(stim_list))
    
        stim_name = char(stim_list(forEach_stim));
        [x,data_list] = func_make_data(tissueSlice_list,stim_name,'10uA_Cathode',bin_range);

        if forEach_stim <= 6
            color_num = (forEach_stim-1)/5;
            color_code = [color_num 0 (1-color_num)];
        else
            color_code = [0 0 0];
        end
    
        subplot(3,8,forEach_stim + (plot_row-1)*8)
        hold on
        plot([-10 10],[0 0],'k:')
        plot([-10 10],[1 1]*maxValue_cathode,'k:')
        Func_Errorbar_VerAreaImaging(-x,mean(data_list,1),Func_calculate_sem(data_list),color_code);
        xlim(-x([end 1]));
        ylim([-0.8 1.3]*maxValue_cathode);
        yticks([0 round(maxValue_cathode,0)])
    
    end
end


function [x,data_list] = func_make_data(tissueSlice_list,stim_name,base_name,bin_range)


    [range_oneDim,range_twoDim] = Func_FindAverageArea(tissueSlice_list,'Control',stim_name);
    data_list = [];
    
    for forEach_slice = 1:max(size(tissueSlice_list))
        [data, information] = Func_data_loader(tissueSlice_list(forEach_slice),'DAP5_DNQX',stim_name);

        [data_forNrm, ~] = Func_data_loader(tissueSlice_list(forEach_slice),'Control',base_name);
        data_forNrm = data_forNrm(information.electrode_on_oneDim+range_oneDim,information.electrode_on_twoDim+range_twoDim,information.stimIn+(0:100));
        data_forNrm = mean(mean(mean(data_forNrm)));

        data = data / data_forNrm;
        data = data(information.electrode_on_oneDim+range_oneDim,information.electrode_on_twoDim+range_twoDim,:);
        lineprofile = sum(sum(data(:,:,information.stimIn + bin_range),1),3);
        lineprofile = reshape(lineprofile,[1 size(data,2)]);
        data_list = [data_list;  lineprofile];
    end

    x = func_pixel2mm(range_twoDim,information);
end




