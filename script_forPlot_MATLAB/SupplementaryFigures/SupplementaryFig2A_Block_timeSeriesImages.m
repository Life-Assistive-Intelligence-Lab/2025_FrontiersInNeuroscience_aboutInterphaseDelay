function SupplementaryFig2A_Block_timeSeriesImages

    cmap_color = 'parula';
    cmap_range = [-1.2 4.32]; 


    rpwd = pwd;
    tissueSlice_list = DataList_forFig2;
    tissueSlice_list = tissueSlice_list(7:12); % Only data obtained under synaptic blockade condition 

    stim_labelList = {'10uA_IPD0usec','10uA_IPD200usec','10uA_IPD400usec','10uA_IPD600usec','10uA_IPD800usec','10uA_IPD1000usec','10uA_Cathode','10uA_Anode'};


    figure('Position', [30 100 1000 850]);
    hold on


    for forEach_stim = 1:max(size(stim_labelList))

            stim_name = char(stim_labelList(forEach_stim));
            [data,information] = func_make_data(tissueSlice_list,stim_name,'10uA_Cathode');

            for forEach_idx = 0:40
                subplot(41,8,(forEach_stim)+(forEach_idx*8))
                hold on
                box off
                xticks([-50 100]);
                yticks([-50 100]);
                ax = gca;
                ax.XAxis.Visible = 'off';
                ax.YAxis.Visible = 'off';
                frame_data = rot90(data(:,:,information.stimIn+forEach_idx),2);
                colormap(cmap_color);
                imagesc(frame_data,cmap_range);
            end

    end
   
    cd(rpwd)

end

function [data,information] = func_make_data(tissueSlice_list,stim_name,base_name)

    [range_oneDim,range_twoDim] = Func_FindAverageArea(tissueSlice_list,'Control',stim_name);

    data_list = zeros([max(size(tissueSlice_list)) max(size(range_oneDim)) max(size(range_twoDim)) 1500]);

    for forEach_slice = 1:max(size(tissueSlice_list))
        [data, information] = Func_data_loader(tissueSlice_list(forEach_slice),'DAP5_DNQX',stim_name);

        [data_forNrm, ~] = Func_data_loader(tissueSlice_list(forEach_slice),'Control',base_name);
        data_forNrm = data_forNrm(information.electrode_on_oneDim+range_oneDim,information.electrode_on_twoDim+range_twoDim,information.stimIn+(1:100));
        data_forNrm = mean(mean(mean(data_forNrm)));
        data = data / data_forNrm;
        data = data(information.electrode_on_oneDim+range_oneDim,information.electrode_on_twoDim+range_twoDim,:);

        data_list(forEach_slice,:,:,:) = data;
    end 

    data = reshape(mean(data_list,1),size(data_list,[2 3 4]));
end