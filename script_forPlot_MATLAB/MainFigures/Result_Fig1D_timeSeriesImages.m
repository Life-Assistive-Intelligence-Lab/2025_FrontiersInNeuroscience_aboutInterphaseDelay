function Result_Fig1D_timeSeriesImages

    cmap_color = 'parula';
    cmap_range = [-1.2 6.4];

    rpwd = pwd;
    tissueSlice_list = DataList_forFig1;

    pd_labelList = {'ch2_50uA_11pulse_100Hz__width40us', ...
               'ch2_20uA_11pulse_100Hz__width100us', ...
               'ch2_10uA_11pulse_100Hz__width200us', ...
               'ch2_05uA_11pulse_100Hz__width400us', ...
              };

    ipd_labelList = {'_wait0us','_wait300us'};

    figure('Position', [30 100 1800 650]);
    hold on

    for forEach_pd = 1:max(size(pd_labelList))
        for forEach_ipd = 1:max(size(ipd_labelList))

            stim_name = [char(pd_labelList(forEach_pd)) char(ipd_labelList(forEach_ipd))];
            [data,information] = func_make_data(tissueSlice_list,stim_name,'ch2_10uA_11pulse_100Hz__width200us_wait0us');

            for forEach_idx = 0:10
                subplot(11,8,((forEach_ipd-1)*4+forEach_pd)+(forEach_idx*8))
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
    end

    cd(rpwd)

end


function [data,information] = func_make_data(tissueSlice_list,stim_name,base_name)

    [range_oneDim,range_twoDim] = Func_FindAverageArea(tissueSlice_list,'Control',stim_name);
    data_list = zeros([max(size(tissueSlice_list)) max(size(range_oneDim)) max(size(range_twoDim)) 1500]);

    for forEach_slice = 1:max(size(tissueSlice_list))
        [data, information] = Func_data_loader(tissueSlice_list(forEach_slice),'Control',stim_name);

        [data_forNrm, ~] = Func_data_loader(tissueSlice_list(forEach_slice),'Control',base_name);
        data_forNrm = data_forNrm(information.electrode_on_oneDim+range_oneDim,information.electrode_on_twoDim+range_twoDim,information.stimIn+(1:10));
        data_forNrm = mean(mean(mean(data_forNrm)));
        data = data / data_forNrm;
        data = data(information.electrode_on_oneDim+range_oneDim,information.electrode_on_twoDim+range_twoDim,:);

        data_list(forEach_slice,:,:,:) = data;
    end 

      data = reshape(mean(data_list,1),size(data_list,[2 3 4]));
end