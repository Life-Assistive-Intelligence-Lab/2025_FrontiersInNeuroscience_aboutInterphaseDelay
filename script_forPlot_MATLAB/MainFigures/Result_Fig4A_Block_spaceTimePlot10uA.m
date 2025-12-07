function Result_Fig4A_Block_spaceTimePlot10uA

    cmap_color = 'parula';
    cmap_range = [-0.2 1.9];

    rpwd = pwd;
    tissueSlice_list = DataList_forFig34;

    stim_list = {'ch2_10uA_11pulse_100Hz__width200us_wait0us', ...
                 'ch2_10uA_11pulse_100Hz__width200us_wait100us', ...
                 'ch2_10uA_11pulse_100Hz__width200us_wait200us', ...
                 'ch2_10uA_11pulse_100Hz__width200us_wait300us', ...
                 'ch2_10uA_11pulse_100Hz__width200us_wait400us', ...
                 'ch2_10uA_11pulse_100Hz__width200us_wait500us', ...
                 'ch2_10uA_11pulse_100Hz__width200us_wait600us', ...
                 'ch2_10uA_11pulse_100Hz__width200us_wait800us', ...
                 'ch2_10uA_11pulse_100Hz__width200us_wait1000us', ...
                 'ch2_10uA_11pulse_100Hz__width200us_waitINF', ...
                };

    stim_valueList = {'IPDis___0', ...
                      'IPDis_100', ...
                      'IPDis_200', ...
                      'IPDis_300', ...
                      'IPDis_400', ...
                      'IPDis_500', ...
                      'IPDis_600', ...
                      'IPDis_800', ...
                      'IPDis1000', ...
                      'Cathodic_', ...
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
        [data, information] = Func_data_loader(tissueSlice_list(forEach_slice),'DAP5_DNQX',stim_name);

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