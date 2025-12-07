function SupplementaryMethodFig5_WaveformOfDataList_forFig34_20uA

    rpwd = pwd;
    tissueSlice_list = DataList_forFig34;


    stim_labelList = {'ch2_20uA_11pulse_100Hz__width200us_wait0us', ...
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

    stim_labelList_forTest = {'IPDis___0', ...
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


    pulse_onsetList = [246 259 311 294 294 294 ; ...
                     249 266 310 296 295 286 ; ...
                     258 259 317 297 296 296 ; ...
                     260 254 304 299 297 294 ; ...
                     250 257 313 297 293 296 ; ...
                     255 264 305 294 296 294 ; ...
                     256 253 304 294 294 294 ; ...
                     251 268 305 293 294 296 ; ...
                     243 251 320 294 294 294 ; ...
                     252 257 302 295 295 295 ; ...
                     ];


    pulse_offsetList = [448 459 515 506 506 505 ; ...
                     453 475 514 521 517 521 ; ...
                     465 466 528 519 519 519 ; ...
                     464 464 509 519 519 520 ; ...
                     457 464 526 519 516 519 ; ...
                     467 469 511 517 519 517 ; ...
                     460 460 510 513 520 522 ; ...
                     468 474 518 520 516 520 ; ...
                     447 459 525 519 518 518 ; ...
                     457 470 513 518 517 520 ; ...
    ];

    max_scale = 4.6;


    figure('Position', [30 100 1800 850]);
    hold on
    data_forStatistical = [];
    dataName_forStatistical = {};


    subplot(2,2,2)
    hold on
    plot([-100 100],[0 0],'k-')
    grid on 

    for forEach_stim = 1:max(size(stim_labelList))
        
        subplot(10,2,(forEach_stim-1)*2+1)
        hold on
        plot([-100 100],[0 0],'k-')

        stim_name = char(stim_labelList(forEach_stim));
        [x,y,sem,chrg_list] = func_calc_waveformSEM(tissueSlice_list, pulse_onsetList(forEach_stim,:), pulse_offsetList(forEach_stim,:), stim_name);
        

        if forEach_stim <= 9
            color_num = (forEach_stim-1)/8;
            color_code = [color_num 0 (1-color_num)];
        else
            color_code = [0 0 0];
        end

        Func_Errorbar_VerAreaImaging(x,y,sem,color_code);
        xlim([-0.2 1.6])
        ylim([-1 1]*23)

        subplot(2,2,2)
        hold on
        plot([-100 100],[0 0],'k-')
        func_plot_sem_bar(forEach_stim,mean(chrg_list),std(chrg_list.'),1.5,color_code,0.4)
        scatter_data = scatter(forEach_stim,mean(chrg_list),60,'o');
        scatter_data.MarkerFaceColor = '#FFFFFF';
        scatter_data.MarkerEdgeColor = color_code;
        scatter_data.LineWidth = 1.5;
        xlim([0 11]);
        ylim([-0.1 1]*max_scale);

        data_forStatistical = [data_forStatistical; chrg_list];
        dataName_forStatistical(end+1) = {char(stim_labelList_forTest(forEach_stim))};

    end




    data_forStatistical = data_forStatistical.';
    Func_saveData_toCSV(data_forStatistical, dataName_forStatistical,'SupplementaryMethodFig5_WaveformOfDataList_forFig34_20uA')


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


        [num,den,~] = Func_digitalbesselfilter(5,1e6,25*1e3);
        dataFiltered = filter(num,den,data);
        
        time_rangeForPlot = timming_start(forEach_slice) + (-200:1800);
        y_list = [y_list; dataFiltered(time_rangeForPlot)];
        x = information.time_list(time_rangeForPlot) - information.time_list(timming_start(forEach_slice));

        time_range_forCharge = timming_start(forEach_slice):timming___end(forEach_slice);
        chrg_list = [chrg_list (-sum(data(time_range_forCharge))/1000)];

    end

    y = mean(y_list,1);
    sem = Func_calculate_sem(y_list);

end