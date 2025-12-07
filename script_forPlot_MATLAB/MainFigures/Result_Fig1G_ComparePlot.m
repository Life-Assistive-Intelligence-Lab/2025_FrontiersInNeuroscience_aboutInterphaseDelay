function Result_Fig1G_ComparePlot

    rpwd = pwd;
    tissueSlice_list = DataList_forFig1;


    pd_labelList = {'ch2_50uA_11pulse_100Hz__width40us', ...
                 'ch2_20uA_11pulse_100Hz__width100us', ...
                 'ch2_10uA_11pulse_100Hz__width200us', ...
                 'ch2_05uA_11pulse_100Hz__width400us', ...
                };

    pd_valueList_forTest = {'PDis_40','PDis100','PDis200','PDis400'};

    ipd_labelList = {'_wait0us','_wait300us'};
    ipd_labelList_forTest = {'IPDis__0','IPDis300'};

    ipd_colorLabel = {'b','r'};



    figure('Position', [30 100 1800 650]);
    hold on

    plot([-100 100],[0 0],'k-')

    data_forStatistical = [];
    dataName_forStatistical = {};

    for forEach_stim = 1:max(size(pd_labelList))
        for forEach_ipd = 1:max(size(ipd_labelList))

            stim_name = [char(pd_labelList(forEach_stim)) char(ipd_labelList(forEach_ipd))];
            [data_list] = func_make_data(tissueSlice_list,stim_name,'ch2_10uA_11pulse_100Hz__width200us_wait0us');

            Func_BarPlot_forFewSample(forEach_stim+(forEach_ipd-1.5)*2*0.15,data_list,0.2,char(ipd_colorLabel(forEach_ipd)),80)
            
            data_forStatistical = [data_forStatistical; data_list];
            dataName_forStatistical(end+1) = {[char(pd_valueList_forTest(forEach_stim)) '-' char(ipd_labelList_forTest(forEach_ipd))]};
        end

    end
    
    xlim([0 5]);
    ylim([-0.1 1]*3);
    data_forStatistical = data_forStatistical.';
    Func_saveData_toCSV(data_forStatistical, dataName_forStatistical,'Fig1G_CompareSummation')
    cd(rpwd)

end



function summation_list = func_make_data(tissueSlice_list,stim_name,base_name)

    [range_oneDim,range_twoDim] = Func_FindAverageArea(tissueSlice_list,'Control',stim_name);

    summation_list = [];
    
    for forEach_slice = 1:max(size(tissueSlice_list))
        [data, information] = Func_data_loader(tissueSlice_list(forEach_slice),'Control',stim_name);

        [data_forNrm, ~] = Func_data_loader(tissueSlice_list(forEach_slice),'Control',base_name);
        data_forNrm = data_forNrm(information.electrode_on_oneDim+range_oneDim,information.electrode_on_twoDim+range_twoDim,information.stimIn+(1:10));
        NrmValue = mean(mean(mean(data_forNrm)));
        summatin_forNrm = sum(sum(sum(data_forNrm/NrmValue)));

        data = data / NrmValue;
        data = data(information.electrode_on_oneDim+range_oneDim,information.electrode_on_twoDim+range_twoDim,:);

        summation = sum(sum(sum(data(:,:,301:310))));
        summation_list = [summation_list (summation/summatin_forNrm)];
    end

end