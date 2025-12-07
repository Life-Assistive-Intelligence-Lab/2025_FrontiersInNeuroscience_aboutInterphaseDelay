function Result_Fig2GIK_control_compareSummationPlot

    rpwd = pwd;
    Func_plot_EachRow(1,1:3)
    Func_plot_EachRow(2,4:10)
    Func_plot_EachRow(3,11:40)
   
    cd(rpwd)
end

function Func_plot_EachRow(figIdx,bin_range)

    rpwd = pwd;
    tissueSlice_list = DataList_forFig2;
    ipd_labelList = {'10uA_IPD0usec','10uA_IPD200usec','10uA_IPD400usec','10uA_IPD600usec','10uA_IPD800usec','10uA_IPD1000usec','10uA_Cathode'};
    ipd_labelList_forTest = {'IPDis___0','IPDis_200','IPDis_400','IPDis_600','IPDis_800','IPDis1000','Cathodic_'};


    figure('Position', [30 100 1800 850]);
    hold on
    plot([-100 100],[0 0],'k-')

    data_forStatistical = [];
    dataName_forStatistical = {};

    for forEach_stim = 1:max(size(ipd_labelList))

            stim_name = char(ipd_labelList(forEach_stim));
            [data_list] = func_make_data(tissueSlice_list,stim_name,'10uA_Cathode',bin_range);
            
            if forEach_stim <= 6
                color_num = (forEach_stim-1)/5;
                color_code = [color_num 0 (1-color_num)];
            else
                color_code = [0 0 0];
            end

            Func_BarPlot_forManySample(forEach_stim,data_list,0.6,color_code,60)

            data_forStatistical = [data_forStatistical; data_list];
            dataName_forStatistical(end+1) = {char(ipd_labelList_forTest(forEach_stim))};
    end

    xlim([1 8] + [-1 1]*5.2);
    ylim([-0.3 1.2]*(10/6));
    
    data_forStatistical = data_forStatistical.';
    panel_idx = {'G','I','K'};
    Func_saveData_toCSV(data_forStatistical, dataName_forStatistical,['Fig2' char(panel_idx(figIdx)) '_control_CompareSummation_for' num2str(bin_range(1)-1) 'to' num2str(bin_range(end)) 'msec'])


    cd(rpwd)
end


function data_list = func_make_data(tissueSlice_list,stim_name,base_name,bin_range)


    [range_oneDim,range_twoDim] = Func_FindAverageArea(tissueSlice_list,'Control',stim_name);
    
    data_list = [];
    
    for forEach_slice = 1:max(size(tissueSlice_list))
        [data, information] = Func_data_loader(tissueSlice_list(forEach_slice),'Control',stim_name);
        data = data(information.electrode_on_oneDim+range_oneDim,information.electrode_on_twoDim+range_twoDim,:);

        [data_forNrm, ~] = Func_data_loader(tissueSlice_list(forEach_slice),'Control',base_name);
        data_forNrm = data_forNrm(information.electrode_on_oneDim+range_oneDim,information.electrode_on_twoDim+range_twoDim,:);
        nrmValue = mean(mean(mean(data_forNrm(:,:,information.stimIn+(0:100)))));


        data = data / nrmValue;
        lineprofile = sum(sum(data(:,:,300+bin_range),1),3);
        lineprofile = reshape(lineprofile,[1 size(lineprofile,2)]);

        data_forNrm = data_forNrm / nrmValue;
        lineprofile_forNrm = sum(sum(data_forNrm(:,:,300+bin_range),1),3);
        lineprofile_forNrm = reshape(lineprofile_forNrm,[1 size(lineprofile_forNrm,2)]);
    

        data_list = [data_list sum(lineprofile,2)/sum(lineprofile_forNrm,2)];
    end

end