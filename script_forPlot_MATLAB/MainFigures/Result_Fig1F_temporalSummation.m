function Result_Fig1F_temporalSummation

    rpwd = pwd;
    tissueSlice_list = DataList_forFig1;

    pd_labelList = {'ch2_50uA_11pulse_100Hz__width40us', ...
                 'ch2_20uA_11pulse_100Hz__width100us', ...
                 'ch2_10uA_11pulse_100Hz__width200us', ...
                 'ch2_05uA_11pulse_100Hz__width400us', ...
                };

    ipd_labelList = {'_wait0us','_wait300us'};
    ipd_colorLabel = {'b','r'};

    figure('Position', [30 100 1800 650]);
    hold on

    for forEach_idx = 1:4
        subplot(1,4,forEach_idx)
        hold on
        plot([-100 100],[0 0],'k:')
        plot([0 0],[-5000 5000],'k:')
    end

    for forEach_stim = 1:max(size(pd_labelList))
        for forEach_ipd = 1:max(size(ipd_labelList))

            stim_name = [char(pd_labelList(forEach_stim)) char(ipd_labelList(forEach_ipd))];
            [x,y,sem] = func_make_data(tissueSlice_list,stim_name,'ch2_10uA_11pulse_100Hz__width200us_wait0us');

            subplot(1,4,forEach_stim)
            hold on
            Func_Errorbar_VerAreaImaging(-x,y,sem,char(ipd_colorLabel(forEach_ipd)));

            xlim(-x([end 1]));
            ylim([-300 800]);
                
        end
    end



    cd(rpwd)

end


function [x,y,sem] = func_make_data(tissueSlice_list,stim_name,base_name)

    [range_oneDim,range_twoDim] = Func_FindAverageArea(tissueSlice_list,'Control',stim_name);

    data_list = [];
    
    for forEach_slice = 1:max(size(tissueSlice_list))
        [data, information] = Func_data_loader(tissueSlice_list(forEach_slice),'Control',stim_name);

        [data_forNrm, ~] = Func_data_loader(tissueSlice_list(forEach_slice),'Control',base_name);
        data_forNrm = data_forNrm(information.electrode_on_oneDim+range_oneDim,information.electrode_on_twoDim+range_twoDim,information.stimIn+(1:10));
        data_forNrm = mean(mean(mean(data_forNrm)));
        data = data / data_forNrm;
        data = data(information.electrode_on_oneDim+range_oneDim,information.electrode_on_twoDim+range_twoDim,:);

        lineprofile = sum(sum(data(:,:,301:310),1),3);
        lineprofile = reshape(lineprofile,[1 size(data,2)]);
        data_list = [data_list;  lineprofile];
    end 

    x = func_pixel2mm(range_twoDim,information);

    y = mean(data_list,1);
    sem = Func_calculate_sem(data_list); 
end