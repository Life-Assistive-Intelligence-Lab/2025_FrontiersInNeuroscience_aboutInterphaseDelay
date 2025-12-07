function Result_Fig3B_control_spaceTimePlot20uA

    cmap_color = 'parula';
    cmap_range = [-0.2 2.8]; 

    rpwd = pwd;
    tissueSlice_list = DataList_forFig34;

    stim_list = {'ch2_20uA_11pulse_100Hz__width200us_wait0us', ...
                 'ch2_20uA_11pulse_100Hz__width200us_wait100us', ...
                 'ch2_20uA_11pulse_100Hz__width200us_wait200us', ...
                 'ch2_20uA_11pulse_100Hz__width200us_wait300us', ...
                 'ch2_20uA_11pulse_100Hz__width200us_wait400us', ...
                 'ch2_20uA_11pulse_100Hz__width200us_wait500us', ...
                 'ch2_20uA_11pulse_100Hz__width200us_wait600us', ...
                 'ch2_20uA_11pulse_100Hz__width200us_wait800us', ...
                 'ch2_20uA_11pulse_100Hz__width200us_wait1000us', ...
                 'ch2_20uA_11pulse_100Hz__width200us_waitINF', ...
                };

    figure('Position', [30 100 1800 450]);
    hold on


    for forEach_stim = 1:max(size(stim_list))
        stim_name = char(stim_list(forEach_stim));
        [x,data,information] = func_make_data(tissueSlice_list,stim_name,char(stim_list(end)));
            
        subplot(1,10,forEach_stim)
        hold on
        box off
        colormap(cmap_color)
        y = func_make_time_array(information);     
        imagesc(-x,y,data.',cmap_range);
        ylim([-10 110])
        xlim(-x([end 1]))
        ax = gca;
        ax.YDir = 'reverse';
    end

    cd(rpwd)

end


function [x,data,information] = func_make_data(tissueSlice_list,stim_name,base_name)
    
    [range_oneDim,range_twoDim] = Func_FindAverageArea(tissueSlice_list,'Control',stim_name);
    data_list = [];

    for forEach_slice = 1:max(size(tissueSlice_list))
        [data, information] = Func_data_loader(tissueSlice_list(forEach_slice),'Control',stim_name);

        [data_forNrm, ~] = Func_data_loader(tissueSlice_list(forEach_slice),'Control',base_name);
        data_forNrm = data_forNrm(information.electrode_on_oneDim+range_oneDim,information.electrode_on_twoDim+range_twoDim,information.stimIn+(1:100));
        data_forNrm = mean(mean(mean(data_forNrm)));
        data = data / data_forNrm;
        data = data(information.electrode_on_oneDim+range_oneDim,information.electrode_on_twoDim+range_twoDim,:);
        
        spacetimeData = mean(data,1);
        data_list = [data_list;  spacetimeData];
    end 
    
    data = reshape(mean(data_list,1),size(data_list,[2 3]));
    x = func_pixel2mm(range_twoDim,information);
end