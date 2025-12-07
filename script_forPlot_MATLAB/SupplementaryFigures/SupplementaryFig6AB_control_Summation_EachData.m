function SupplementaryFig6AB_control_Summation_EachData


    tissueSlice_list = DataList_forFig34;
    stim_labelList = {'ch2_10uA_11pulse_100Hz__width200us_wait0us', ...
                 'ch2_10uA_11pulse_100Hz__width200us_wait100us', ...
                 'ch2_10uA_11pulse_100Hz__width200us_wait200us', ...
                 'ch2_10uA_11pulse_100Hz__width200us_wait300us', ...
                 'ch2_10uA_11pulse_100Hz__width200us_wait400us', ...
                 'ch2_10uA_11pulse_100Hz__width200us_wait500us', ...
                 'ch2_10uA_11pulse_100Hz__width200us_wait600us', ...
                 'ch2_10uA_11pulse_100Hz__width200us_wait800us', ...
                 'ch2_10uA_11pulse_100Hz__width200us_wait1000us', ...
                 'ch2_10uA_11pulse_100Hz__width200us_waitINF', ...
                 'ch2_20uA_11pulse_100Hz__width200us_wait0us', ...
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


    condition = 'Control';

    [range_oneDim,range_twoDim] = Func_FindAverageArea(tissueSlice_list,'Control','ch2_10uA_11pulse_100Hz__width200us_waitINF');

    figure('Position', [30 100 1800 850]);
    hold on

    for forEach_slice = 1:max(size(tissueSlice_list))

        for forEach_amp = 1:2
            [~,y] = func_make_data(tissueSlice_list(forEach_slice),char(stim_labelList(forEach_amp/2*max(size(stim_labelList)))),range_oneDim,range_twoDim,condition);
            maxValue_cathode = max(y(12:end));
    
            for forEach_stim = 1:(max(size(stim_labelList))/2)
                now_idx = (forEach_amp-1)/2 * max(size(stim_labelList)) + forEach_stim;
                [x,y] = func_make_data(tissueSlice_list(forEach_slice),char(stim_labelList(now_idx)),range_oneDim,range_twoDim,condition);
    
                if forEach_stim <= 9
                    color_num = (forEach_stim-1)/8;
                    color_code = [color_num 0 (1-color_num)];
                else
                    color_code = [0 0 0];
                end
            
                
                subplot(max(size(tissueSlice_list)),max(size(stim_labelList)),max(size(stim_labelList))*(forEach_slice-1)+now_idx)
                hold on
                plot([0 0],[-1 1]*10000,'k:')
                plot([-100 100],[0 0],'k:')
                plot([-100 100],[1 1]*maxValue_cathode,'k:')
                plot(x,y,'-','LineWidth',1.5,'Color',color_code)
                xlim([-50 100])
                ylim([-0.2 1.6]*maxValue_cathode)
                yticks([0 round(maxValue_cathode,-1)])
    
            end
        end


    end

end

function [indx_list,value_list] = func_make_data(tissueSlice_list,stim_name,range_oneDim,range_twoDim,condition)


    [data, information] = Func_data_loader(tissueSlice_list,condition,stim_name);
    binned_data = data(information.electrode_on_oneDim+range_oneDim,information.electrode_on_twoDim+range_twoDim,:);
    value_list = [];
    indx_list = [];

    for forEach_time = -100:10:110
        now_timeRange = information.stimIn+forEach_time + (-9:0);
        
        responded_value = sum(sum(sum(binned_data(:,:,now_timeRange),1),2),3);
        
        value_list = [value_list responded_value];
        indx_list = [indx_list forEach_time];
    end
end