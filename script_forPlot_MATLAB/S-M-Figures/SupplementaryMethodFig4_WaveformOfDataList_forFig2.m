function SupplementaryMethodFig4_WaveformOfDataList_forFig2


    rpwd = pwd;
    tissueSlice_list = DataList_forFig2;

    stim_labelList = {'10uA_IPD0usec','10uA_IPD200usec','10uA_IPD400usec','10uA_IPD600usec','10uA_IPD800usec','10uA_IPD1000usec','10uA_Cathode','10uA_Anode'};

    stim_labelList_forTest = {'IPDis___0', ...
                      'IPDis_200', ...
                      'IPDis_400', ...
                      'IPDis_600', ...
                      'IPDis_800', ...
                      'IPDis1000', ...
                      'Cathodic_', ...
                      'Anodic___', ...
                      };
    max_scale = 2.2;


    figure('Position', [30 100 1800 850]);
    hold on
    data_forStatistical = [];
    dataName_forStatistical = {};

    pulse_onsetList = [148 148 147 139 139 148 133 118 116 257 257 258; ...
                     147 148 146 139 137 148 132 117 117 259 257 257; ...
                     148 148 146 139 138 149 133 118 118 259 256 258; ...
                     148 148 146 139 139 149 133 118 116 259 257 257; ...
                     148 148 147 138 139 149 133 118 117 258 257 257; ...
                     147 147 145 140 138 149 132 118 116 258 257 257; ...
                     148 146 146 139 138 148 132 118 116 256 257 258; ...
                     148 148 147 139 138 149 133 116 116 258 257 258; ...
                     ];


    pulse_offsetList = [255 255 253 245 245 255 243 228 228 369 369 368; ...
                     261 260 259 251 251 261 244 230 229 370 370 370; ...
                     261 260 259 252 251 261 244 230 230 370 370 371; ...
                     262 260 259 252 251 261 244 230 230 370 370 371; ...
                     261 260 259 251 251 261 244 229 230 370 370 371; ...
                     261 260 259 251 251 261 245 229 230 371 370 369; ...
                     261 260 259 251 251 261 244 230 230 371 370 370; ...
                     262 260 259 251 251 261 244 230 229 370 371 370; ...
                     ];


    subplot(2,2,2)
    hold on
    plot([-100 100],[0 0],'k-')
    grid on 

    for forEach_stim = 1:max(size(stim_labelList))
            subplot(8,2,(forEach_stim-1)*2+1)
            hold on
            plot([-100 100],[0 0],'k-')

            stim_name = char(stim_labelList(forEach_stim));
            [x,y,sem,chrg_list] = func_calc_waveformSEM(tissueSlice_list, pulse_onsetList(forEach_stim,:), pulse_offsetList(forEach_stim,:), stim_name);
            

            if forEach_stim <= 6
                color_num = (forEach_stim-1)/5;
                color_code = [color_num 0 (1-color_num)];
            else
                color_code = [0 0 0];
            end

            Func_Errorbar_VerAreaImaging(x,y,sem,color_code);
            xlim([-0.2 1.6])
            ylim([-1 1]*13)

            subplot(2,2,2)
            hold on
            plot([-100 100],[0 0],'k-')
            func_plot_sem_bar(forEach_stim,mean(chrg_list),std(chrg_list.'),1.5,color_code,0.4)
            scatter_data = scatter(forEach_stim,mean(chrg_list),60,'o');
            scatter_data.MarkerFaceColor = '#FFFFFF';
            scatter_data.MarkerEdgeColor = color_code;
            scatter_data.LineWidth = 1.5;
            xlim([0 9]);
            ylim([-0.1 1]*max_scale);


            data_forStatistical = [data_forStatistical; chrg_list];
            dataName_forStatistical(end+1) = {char(stim_labelList_forTest(forEach_stim))};

    end

    data_forStatistical = data_forStatistical.';
    Func_saveData_toCSV(data_forStatistical, dataName_forStatistical,'SupplementaryMethodFig4B_WaveformOfDataList_forFig2')


    cd(rpwd)

end

function [x,y,sem,chrg_list] = func_calc_waveformSEM(tissueSlice_list, timming_start,timming___end,stim_name)
    
    rpwd = pwd;
    y_list = [];
    chrg_list = [];

    global folder_data;

    for forEach_slice = 1:max(size(tissueSlice_list))
        cd(Folder_name.data_to_analyse(folder_data));
        cd(char(tissueSlice_list(forEach_slice)));
        cd('Waveform');
        load([stim_name '.mat']);
        cd(rpwd);

        if forEach_slice >= 7
            data = (data(1:2:end)+data(2:2:end))/2;
            information.time_list = information.time_list(1:2:end);
        end

        [num,den,~] = Func_digitalbesselfilter(5,1e6,25*1e3);
        dataFiltered = filter(num,den,data);
        
        time_rangeForPlot = timming_start(forEach_slice) + (-100:800);
        y_list = [y_list; dataFiltered(time_rangeForPlot)];
        x = information.time_list(time_rangeForPlot) - information.time_list(timming_start(forEach_slice));

        time_range_forCharge = timming_start(forEach_slice):timming___end(forEach_slice);
        chrg_list = [chrg_list (-sum(data(time_range_forCharge))*2/1000)];
    end

    y = mean(y_list,1);
    sem = std(y_list);
    chrg_list = abs(chrg_list);
end