function Result_Fig4JL_Block_hew20uA


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


    figure('Position', [30 100 1800 850]);
    hold on

    subplot(2,1,2)
    hold on
    plot([-100 100],[0 0],'k-')

    data_forStatistical = [];
    dataName_forStatistical = {};

    [~,y,~] = func_make_data(tissueSlice_list,char(stim_list(end)),char(stim_list(end)));
    nrmValue = max(mean(y,1));

    for forEach_stim = 1:max(size(stim_list))
        stim_name = char(stim_list(forEach_stim));
        [x,y,hew_list] = func_make_data(tissueSlice_list,stim_name,char(stim_list(end)));

        if forEach_stim <= 9
            color_num = (forEach_stim-1)/8;
            color_code = [color_num 0 (1-color_num)];
        else
            color_code = [0 0 0];
        end
        
        subplot(2,10,forEach_stim)
        hold on
        plot([0 0],[-1 1]*10000,'k:')
        plot([-100 200],[0 0],'k:')
        plot([-100 200],[1 1]*nrmValue,'k:')
        Func_Errorbar_VerAreaImaging(-x,mean(y,1),Func_calculate_sem(y),color_code);
        xlim(-x([end 1]))
        ylim([-0.4 1.6]*nrmValue)
        yticks([0 round(nrmValue,0)])

        subplot(2,1,2)
        Func_BarPlot_forFewSample(forEach_stim,hew_list,0.7,color_code,50)
        xlim([1 10] + [-1 1]*4);
        ylim([-0.1 1]*0.45);

        data_forStatistical = [data_forStatistical; hew_list];
        dataName_forStatistical(end+1) = {char(stim_valueList(forEach_stim))};
    end
    data_forStatistical = data_forStatistical.';
    Func_saveData_toCSV(data_forStatistical, dataName_forStatistical,'Fig4L_Block_hew_20uA')

    cd(rpwd)
end


function [x,data_list,hew_list] = func_make_data(tissueSlice_list,stim_name,base_name)

    [range_oneDim,range_twoDim] = Func_FindAverageArea(tissueSlice_list,'Control',stim_name);
    data_list = [];
    hew_list = [];
    
    for forEach_slice = 1:max(size(tissueSlice_list))
        [data, information] = Func_data_loader(tissueSlice_list(forEach_slice),'DAP5_DNQX',stim_name);

        [data_forNrm, ~] = Func_data_loader(tissueSlice_list(forEach_slice),'Control',base_name);
        data_forNrm = data_forNrm(information.electrode_on_oneDim+range_oneDim,information.electrode_on_twoDim+range_twoDim,information.stimIn+(1:100));
        data_forNrm = mean(mean(mean(data_forNrm)));

        data = data / data_forNrm;
        data = data(information.electrode_on_oneDim+range_oneDim,information.electrode_on_twoDim+range_twoDim,:);
        lineprofile = sum(sum(data(:,:,information.stimIn + (1:110)),1),3);
        lineprofile = reshape(lineprofile,[1 size(data,2)]);

        hew_list = [hew_list func_pixel2mm(func_calculate_hew_from_lineprofile(lineprofile,information),information)];
        data_list = [data_list;  lineprofile];
    end 

    x = func_pixel2mm(range_twoDim,information);
end
