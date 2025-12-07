function SupplementaryFig3A4A5A_control_TemporalSummation_EachData


    tissueSlice_list = DataList_forFig2;
    stim_labelList = {'10uA_IPD0usec','10uA_IPD200usec','10uA_IPD400usec','10uA_IPD600usec','10uA_IPD800usec','10uA_IPD1000usec','10uA_Cathode','10uA_Anode'};


    condition = 'Control';

    [range_oneDim,range_twoDim] = Func_FindAverageArea(tissueSlice_list,'Control','10uA_Cathode');


    for forEach_time = 1:3  
        
        figure('Position', [30 100 1800 850]);
        hold on

        if forEach_time == 1
            time_range = 1:3;
        elseif forEach_time == 2
            time_range = 4:10;
        elseif forEach_time == 3
            time_range = 11:40;
        end

        
        for forEach_slice = 1:max(size(tissueSlice_list))

            [~,lineprofile] = func_make_data(tissueSlice_list(forEach_slice),'10uA_Cathode',range_oneDim,range_twoDim,condition,time_range);
            maxValue_cathode = max(lineprofile);
    
            for forEach_stim = 1:(max(size(stim_labelList)))
                
                [x,lineprofile] = func_make_data(tissueSlice_list(forEach_slice),char(stim_labelList(forEach_stim)),range_oneDim,range_twoDim,condition,time_range);
    
                if forEach_stim <= 6
                    color_num = (forEach_stim-1)/5;
                    color_code = [color_num 0 (1-color_num)];
                else
                    color_code = [0 0 0];
                end

                if forEach_slice <= 6    
                    now_idx = (forEach_slice-1) * (max(size(stim_labelList))*2) + forEach_stim;
                else
                    now_idx = (forEach_slice-1-6) * (max(size(stim_labelList))*2) + forEach_stim + max(size(stim_labelList));
                end
            
                subplot(max(size(tissueSlice_list))/2,max(size(stim_labelList))*2,now_idx)
                hold on
                plot([0 0],[-1 1]*10000,'k:')
                plot([-10 10],[0 0],'k:')
                plot([-10 10],[1 1]*maxValue_cathode,'k:')
                plot(-x,lineprofile,'-','LineWidth',1.5,'Color',color_code)
                xlim(-x([end 1]))
                ylim([-0.6 1.4]*maxValue_cathode)
                yticks([0 round(maxValue_cathode,1)])
    
            end
        end
    end
end



function [x,lineprofile] = func_make_data(tissueSlice_list,stim_name,range_oneDim,range_twoDim,condition,bin_range)

    [data, information] = Func_data_loader(tissueSlice_list,condition,stim_name);
    binned_data = data(information.electrode_on_oneDim+range_oneDim,information.electrode_on_twoDim+range_twoDim,:);
    lineprofile = sum(sum(binned_data(:,:,300+bin_range),1),3);
    lineprofile = reshape(lineprofile,[1 max(size(lineprofile,2))]);
    x = func_pixel2mm(range_twoDim,information);
end 
