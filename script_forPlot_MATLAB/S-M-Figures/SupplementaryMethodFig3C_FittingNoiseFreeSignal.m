function SupplementaryMethodFig3C_FittingNoiseFreeSignal

    global folder_data;
    rpwd = pwd;
    tissueSlice_list = DataList_forFig34;
    stim_list = {'ch2_20uA_1pulse','ch2_20uA_11pulse_100Hz__width200us_wait0us','ch2_20uA_11pulse_100Hz__width200us_wait100us','ch2_20uA_11pulse_100Hz__width200us_wait200us'};

    ave_data = zeros([12 64 1000]);
    now_max_point = 32;

    for forEach_slice = 1:max(size(tissueSlice_list))
        sum_data = 0;
        now_num = 0;
        for forEach_stim = 1:max(size(stim_list))

            cd(Folder_name.data_to_analyse(folder_data));
            cd(char(tissueSlice_list(forEach_slice)));
            cd('Control');
            load([char(stim_list(forEach_stim)) '.mat']);
            cd(rpwd);

            now_num = now_num + 1;
            sum_data = sum_data + data(:,:,1:1000);
        end


        data = sum_data/now_num;

        for forEach_idx = 1:100
            try
                data(:,information.electrode_on_twoDim-forEach_idx,:);
                ave_data(:,now_max_point-forEach_idx,:);
            catch
                break
            end
                uppr_lngth = -forEach_idx;
        end

        for forEach_idx = 1:100
            try
                data(:,information.electrode_on_twoDim+forEach_idx,:);
                ave_data(:,now_max_point+forEach_idx,:);
            catch
                break
            end
                bttm_lngth = forEach_idx;
        end

        ave_data = ave_data(:,now_max_point+(uppr_lngth:bttm_lngth),:) + data(:,information.electrode_on_twoDim+(uppr_lngth:bttm_lngth),:);
        now_max_point = (-uppr_lngth) +1;
    end

    APs_data = 0*data(1:11,1:63,1:10);
    x_APs = (-5:5)*information.length_on_one_pixel;
    y_APs = (-31:31)*information.length_on_one_pixel;
    
    figure('Position',[30 100 1800 850])
    hold on

    for forEach_time = [3 2 4:10]
        lineprofile = mean(ave_data(:,:,information.stimIn + forEach_time-1),1);
        lineprofile = reshape(lineprofile,[1 max(size(lineprofile))]);
        distance_data =  (uppr_lngth:bttm_lngth) * information.length_on_one_pixel;

        weight_list = lineprofile*0 + 1;
        weight_list(now_max_point+(-1:1)) = 20;

        fit_type =Func_fitOneFunction_Lorentz(lineprofile,distance_data,weight_list);

        
        if forEach_time == 3
            nrmValue = max(feval(fit_type,-0.4:0.001:0.4));
        end

        for forEach_x = 1:max(size(x_APs))
            for forEach_y = 1:max(size(y_APs))
                now_r = sqrt(x_APs(forEach_x)^2+y_APs(forEach_y)^2);
                APs_data(forEach_x,forEach_y,forEach_time) = feval(fit_type,now_r)/nrmValue;
            end
        end

        subplot(2,5,forEach_time-1)
        hold on
        plot(distance_data,lineprofile/nrmValue,'ko--')
        plot(-0.4:0.001:0.4,feval(fit_type,-0.4:0.001:0.4)/nrmValue,'r-')
        xlim(distance_data([1 end]))
        ylim([-0.5 1.4])
    end

    cd('Test_data\');
    x = y_APs;
    save('Input_NoiseFreeSignal','APs_data','x');
    cd(rpwd);
end

function fit_type = Func_fitOneFunction_Lorentz(lp,lpx,weight_list)
    optionOfFitMethod = fitoptions('Method','NonlinearLeastSquares','Weights',weight_list);
    fit_type = fit(lpx.',lp.','gauss1',optionOfFitMethod);
end