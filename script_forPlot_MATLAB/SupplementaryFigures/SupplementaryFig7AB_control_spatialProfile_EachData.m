function SupplementaryFig7AB_control_spatialProfile_EachData

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
            [~,lineprofile] = func_make_data(tissueSlice_list(forEach_slice),char(stim_labelList(forEach_amp/2*max(size(stim_labelList)))),range_oneDim,range_twoDim,condition);
            maxValue_cathode = max(lineprofile);
    
            for forEach_stim = 1:(max(size(stim_labelList))/2)
                now_idx = (forEach_amp-1)/2 * max(size(stim_labelList)) + forEach_stim;
                [x,lineprofile] = func_make_data(tissueSlice_list(forEach_slice),char(stim_labelList(now_idx)),range_oneDim,range_twoDim,condition);
    
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
                plot(-x,lineprofile,'-','LineWidth',1.5,'Color',color_code)
                xlim(-x([end 1]))
                ylim([-0.4 1.4]*maxValue_cathode)

                if forEach_amp == 1
                    yticks([0 round(maxValue_cathode,0)])
                else
                    yticks([0 round(maxValue_cathode,-2)])
                end
    
            end
        end


    end

end


function [x,lineprofile] = func_make_data(tissueSlice_list,stim_name,range_oneDim,range_twoDim,condition)


    [data, information] = Func_data_loader(tissueSlice_list,condition,stim_name);
    binned_data = data(information.electrode_on_oneDim+range_oneDim,information.electrode_on_twoDim+range_twoDim,:);
    now_timeRange = information.stimIn+ (1:110);
    lineprofile = sum(sum(binned_data(:,:,now_timeRange),1),3);
    lineprofile = reshape(lineprofile,[1 max(size(lineprofile))]);
    x = func_pixel2mm(range_twoDim,information);
end