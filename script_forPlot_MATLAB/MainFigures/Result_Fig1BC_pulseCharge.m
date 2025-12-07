function Result_Fig1BC_pulseCharge
    pd_labelList = {'ch2_50uA_11pulse_100Hz__width40us', ...
               'ch2_20uA_11pulse_100Hz__width100us', ...
               'ch2_10uA_11pulse_100Hz__width200us', ...
               'ch2_05uA_11pulse_100Hz__width400us', ...
              };

    stim_label = {'PDis_40','PDis100','PDis200','PDis400'};
    amplitude_valueList = [50 20 10 5];

    ipd_labelList = {'_wait0us','_wait300us'};
    ipd_labelForTest = {'IPDis__0','IPDis300'};
    ipd_colorLabel = {'b','r'};
    ipd_markerLabel = {'square','o'};
    ipd_markerSizeList = [1.7 1.25];

    pulse_onsetList = [1046 1050 380 250 255 293; ...
                       1052 1046 363 251 240 293; ...
                       1049 1064 377 256 240 293; ...
                       1056 1066 377 252 242 294; ...
                       1046 1046 370 252 247 294; ...
                       1046 1059 368 252 247 294; ...
                       1052 1053 378 246 243 294; ...
                       1046 1059 368 252 247 294; ...
                       ];
 
    pulse_offsetList = [1087 1090 418 292 295 343; ...
                        1094 1089 408 293 285 355; ...
                        1149 1164 476 356 342 403; ...
                        1157 1166 481 352 343 414; ...
                        1246 1246 568 452 448 502; ...
                        1246 1260 566 452 449 513; ...
                        1452 1452 776 646 646 707; ...
                        1446 1460 966 652 649 713; ...
                        ];

    rpwd = pwd;
    tissueSlice_list = DataList_forFig1;

    figure('Position', [30 100 1200 850]);
    subplot(1,2,2)
    hold on
    plot([-100 100],[0 0],'k:')
    grid on 

    data_forStatistical = [];
    dataName_forStatistical = {};

    for forEach_stim = 1:max(size(pd_labelList))
        subplot(4,2,(forEach_stim-1)*2+1)
        hold on
        plot([-100 100],[0 0],'k:')

        for forEach_ipd = 1:max(size(ipd_labelList))
            nowIdx = forEach_ipd + (forEach_stim-1)*2;
            stim_name = [char(pd_labelList(forEach_stim)) char(ipd_labelList(forEach_ipd))];
            [x,y,chrg_list] = func_calculate_waveform(tissueSlice_list, pulse_onsetList(nowIdx,:), pulse_offsetList(nowIdx,:), stim_name);

            % plot for waveform
            subplot(4,2,(forEach_stim-1)*2+1)
            plot(x,y,'-','Color',char(ipd_colorLabel(forEach_ipd)),'LineWidth',1.5);
            xlim([-0.2 1.3])
            ylim([-1 1]*(amplitude_valueList(forEach_stim)+6))

            % plot for pulse-charge
            subplot(1,2,2)
            func_plot_sem_bar(forEach_stim+(forEach_ipd-1.5)*2*0.15,mean(chrg_list),Func_calculate_sem(chrg_list.'),1.5,char(ipd_colorLabel(forEach_ipd)),0.2)
            scatter_data = scatter(forEach_stim+(forEach_ipd-1.5)*2*0.15,mean(chrg_list),60*ipd_markerSizeList(forEach_ipd),char(ipd_markerLabel(forEach_ipd)));
            scatter_data.MarkerFaceColor = '#FFFFFF';
            scatter_data.MarkerEdgeColor = char(ipd_colorLabel(forEach_ipd));
            scatter_data.LineWidth = 1.5;
            xlim([0 5]);
            ylim([-0.1 1]*2.5);
            
            data_forStatistical = [data_forStatistical; chrg_list];
            dataName_forStatistical(end+1) = {[char(stim_label(forEach_stim)) '-' char(ipd_labelForTest(forEach_ipd))]};
        end
    end

    data_forStatistical = data_forStatistical.';
    Func_saveData_toCSV(data_forStatistical, dataName_forStatistical,'NoFigure_pulseCharge_forFigure1C')
    cd(rpwd)

end



function [x,y,chrg_list] = func_calculate_waveform(tissueSlice_list, timming_start,timming___end,stim_name)
    
    global folder_data;
    rpwd = pwd;
    y_list = [];
    chrg_list = [];

    for forEach_slice = 1:max(size(tissueSlice_list))
        cd(Folder_name.data_to_analyse(folder_data));
        cd(char(tissueSlice_list(forEach_slice)));
        cd('Waveform');
        load([stim_name '.mat']);
        cd(rpwd);
        data = data-mean(data);
        
        timeRange_ForPlot = timming_start(forEach_slice) + (-200:1430);
        timeRange_forCharge = timming_start(forEach_slice):timming___end(forEach_slice);

        [num,den,~] = Func_digitalbesselfilter(5,1e6,25*1e3);
        dataFiltered = filter(num,den,data);
        chrg_list = [chrg_list (-sum(data(timeRange_forCharge))/1000)];

        if forEach_slice == 6
            y = data(timeRange_ForPlot);
            x = information.time_list(timeRange_ForPlot) - information.time_list(timming_start(forEach_slice));
        end

    end
end
