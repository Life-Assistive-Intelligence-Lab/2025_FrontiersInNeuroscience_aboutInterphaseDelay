function Result_Fig2B_control_ExpandedImages

    cmap_color = 'parula';
    cmap_range = [-1 4.12];

    binnedpixel = 10;

    rpwd = pwd;
    tissueSlice_list = DataList_forFig2;

    ipd_labelList = {'10uA_IPD0usec','10uA_IPD200usec','10uA_IPD400usec','10uA_IPD600usec','10uA_IPD800usec','10uA_IPD1000usec','10uA_Cathode','10uA_Anode'};

    figure('Position', [30 100 1000 850]);
    hold on


    for forEach_stim = 1:max(size(ipd_labelList))

            stim_name = char(ipd_labelList(forEach_stim));
            [data,information] = func_make_data(tissueSlice_list,stim_name,'10uA_Cathode');
            
            for forEach_idx = 0:4
                subplot(5,8,(forEach_stim)+(forEach_idx*8))
                hold on
                box off
                xticks([-50 100]);
                yticks([-50 100]);
                ax = gca;
                ax.XAxis.Visible = 'off';
                ax.YAxis.Visible = 'off';
                frame_data = rot90(data(:,information.electrode_on_twoDim+(-binnedpixel:binnedpixel),information.stimIn+forEach_idx),2);
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
        [data, information] = Func_data_loader(tissueSlice_list(forEach_slice),'Control',stim_name);

        [data_forNrm, ~] = Func_data_loader(tissueSlice_list(forEach_slice),'Control',base_name);
        data_forNrm = data_forNrm(information.electrode_on_oneDim+range_oneDim,information.electrode_on_twoDim+range_twoDim,information.stimIn+(1:100));
        data_forNrm = mean(mean(mean(data_forNrm)));
        data = data / data_forNrm;
        data = data(information.electrode_on_oneDim+range_oneDim,information.electrode_on_twoDim+range_twoDim,:);

        data_list(forEach_slice,:,:,:) = data;
    end 

    data = reshape(mean(data_list,1),size(data_list,[2 3 4]));
end