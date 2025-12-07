function Result_Fig4CEF_Block_Summation10uA


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


    figure('Position', [30 100 1800 850]);
    hold on

    subplot(3,1,2)
    hold on
    plot([-100 100],[0 0],'k-')

    subplot(3,1,3)
    hold on
    plot([-100 100],[0 0],'k-')


    dataBefore_forStatistical = [];
    dataAfter_forStatistical = [];
    dataName_forStatistical = {};

    [~,y] = func_make_data(tissueSlice_list,char(stim_list(end)),char(stim_list(end)));
    nrmValue_forAll = max(mean(y,1));

    rangeBefore = 11+(1:6);
    nrmValue_forBefore = sum(y(:,rangeBefore),2);

    rangeAfter = 11+(7:11);
    nrmValue_forAfter = sum(y(:,rangeAfter),2);

    for forEach_stim = 1:max(size(stim_list))
        stim_name = char(stim_list(forEach_stim));
        [x,y] = func_make_data(tissueSlice_list,stim_name,char(stim_list(end)));

        if forEach_stim <= 9
            color_num = (forEach_stim-1)/8;
            color_code = [color_num 0 (1-color_num)];
        else
            color_code = [0 0 0];
        end
        
        subplot(3,10,forEach_stim)
        hold on
        plot([0 0],[-1 1]*10000,'k:')
        plot([-100 200],[0 0],'k:')
        plot([-100 200],[1 1]*nrmValue_forAll,'k:')
        Func_Errorbar_VerAreaImaging(x,mean(y,1),Func_calculate_sem(y),color_code);
        xlim([-50 100])
        ylim([-0.3 1.5]*nrmValue_forAll)
        yticks([0 round(nrmValue_forAll,-2)])


        subplot(3,1,2)
        data_list = sum(y(:,rangeBefore),2).'./nrmValue_forBefore.';
        Func_BarPlot_forFewSample(forEach_stim,data_list,0.7,color_code,50)
        xlim([1 10] + [-1 1]*14);
        ylim([-0.1 1]*2);
        dataBefore_forStatistical = [dataBefore_forStatistical; data_list];

        subplot(3,1,3)
        data_list = sum(y(:,rangeAfter),2).'./nrmValue_forAfter.';
        Func_BarPlot_forFewSample(forEach_stim,data_list,0.7,color_code,50)
        xlim([1 10] + [-1 1]*14);
        ylim([-0.1 1]*2);
        dataAfter_forStatistical = [dataAfter_forStatistical; data_list];

        dataName_forStatistical(end+1) = {char(stim_valueList(forEach_stim))};
    end



    dataBefore_forStatistical = dataBefore_forStatistical.';
    Func_saveData_toCSV(dataBefore_forStatistical, dataName_forStatistical,'Fig4E_Block_Summation_10uABefore')

    dataAfter_forStatistical = dataAfter_forStatistical.';
    Func_saveData_toCSV(dataAfter_forStatistical, dataName_forStatistical,'Fig4F_Block_Summation_10uAAfter')


    cd(rpwd)
end


function [indx_list,data_list] = func_make_data(tissueSlice_list,stim_name,base_name)

    [range_oneDim,range_twoDim] = Func_FindAverageArea(tissueSlice_list,'Control',stim_name);
    data_list = [];
    
    for forEach_slice = 1:max(size(tissueSlice_list))
        [data, information] = Func_data_loader(tissueSlice_list(forEach_slice),'DAP5_DNQX',stim_name);

        [data_forNrm, ~] = Func_data_loader(tissueSlice_list(forEach_slice),'Control',base_name);
        data_forNrm = data_forNrm(information.electrode_on_oneDim+range_oneDim,information.electrode_on_twoDim+range_twoDim,information.stimIn+(1:100));
        data_forNrm = mean(mean(mean(data_forNrm)));
        data = data / data_forNrm;
        data = data(information.electrode_on_oneDim+range_oneDim,information.electrode_on_twoDim+range_twoDim,:);
        
        value_list = [];
        indx_list = [];
        for forEach_time = -100:10:110
            now_timeRange = information.stimIn+forEach_time + (-9:0);
            
            responded_value = sum(sum(sum(data(:,:,now_timeRange),1),2),3);
            
            value_list = [value_list responded_value];
            indx_list = [indx_list forEach_time];
        end
        
        data_list = [data_list;  value_list];
    end 
end
