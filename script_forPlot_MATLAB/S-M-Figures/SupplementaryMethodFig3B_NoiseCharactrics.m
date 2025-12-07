function SupplementaryMethodFig3B_NoiseCharactrics


    figure('Position', [30 100 1800 850]);
    hold on

    %% Experimental Data

    global folder_data;
    rpwd = pwd;
    cd(Folder_name.data_to_analyse(folder_data));
    cd(#24');
    cd('Control');
    load('ch2_20uA_11pulse_100Hz__width200us_wait0us');
    cd(rpwd);


    experimental_noiseData = data(:,:,31:230);
    std_experiment = std(reshape(experimental_noiseData,[1 (size(data,1)*size(data,2)*200)]));

    %% Noise Data

    rpwd = pwd;
    cd('Test_data')
    load(['FilterForNoise.mat'])
    cd(rpwd);

    filter_forConv = zeros([size(data,1) size(data,2)]);
    for forEach_x = 1:size(data,1)
        for forEach_y = 1:size(data,2)
            now_r = sqrt((forEach_x-information.electrode_on_oneDim)^2+(forEach_y-information.electrode_on_twoDim)^2);
            filter_forConv(forEach_x,forEach_y) = feval(fit_model,now_r);
        end
    end

    noise_data = experimental_noiseData*0;
    for forEach_data = 1:1
        for forEach_time = 1:200
            rand_data = 2*(rand(size(data,1)*2+1,size(data,2)*2+1)-0.5);
            noise_data(:,:,forEach_time) = noise_data(:,:,forEach_time)+conv2(filter_forConv,rand_data(:,:),'same');
        end
    end
    
    std_noise = std(reshape(noise_data,[1 (size(data,1)*size(data,2)*200)]));
    noise_data = reshape(noise_data,size(data(:,:,31:230)));
    noise_data = noise_data * std_experiment / std_noise;

    %% noise charactrics in long spatial axis 
    exp_fft_list = [];
    exp_corr_list = [];
    noise_fft_list = [];
    noise_corr_list = [];

    for forEach_x = 1:size(data,1)
        for forEach_time = 1:200
            Ts = (0.82/64);
            now_data = reshape(data(forEach_x,:,30+forEach_time),[1 size(data,2)]);
            now_fft = abs(fft(now_data-mean(now_data)));
            fs = 1/Ts;
            f = (0:length(now_fft)-1)*fs/length(now_fft);
            f = f(2:max(size(f)/2));
            now_fft = now_fft(2:max(size(now_fft)/2));
            exp_fft_list = [exp_fft_list; now_fft];

            [r,lags] = xcorr(now_data-mean(now_data),'unbiased');
            lags = lags(fix(max(size(lags)+1)/2):end);
            r = r(fix(max(size(r))/2+1):end);
            exp_corr_list = [exp_corr_list; r/r(1)];


            now_data = reshape(noise_data(forEach_x,:,forEach_time),[1 size(data,2)]);
            now_fft = abs(fft(now_data-mean(now_data)));
            now_fft = now_fft(2:max(size(now_fft)/2));
            noise_fft_list = [noise_fft_list; now_fft];

            [r,lags] = xcorr(now_data-mean(now_data),'unbiased');
            lags = lags(fix(max(size(lags)+1)/2):end);
            r = r(fix(max(size(r))/2+1):end);
            noise_corr_list = [noise_corr_list; r/r(1)];
        end
    end

    subplot(2,3,1)
    f(1) = f(2)/10;
    set(gca, 'XScale', 'log')
    xlim([(f(1)*0.8) (f(end)*1.2)])

    Func_Errorbar_VerAreaImaging(f,mean(exp_fft_list,1),std(exp_fft_list ,1),'k');
    Func_Errorbar_VerAreaImaging(f,mean(noise_fft_list,1),std(noise_fft_list ,1),'r');
    xlim([(f(1)*0.8) (f(end)*1.2)])
    ylim([-0.1 1]*20)
    xlabel('frequency [1/mm]')
    ylabel(['|P(frequency)|'])
    grid on

    subplot(2,3,2)
    xlim([-5 70])
    ylim([-1.2 1.2])
    Func_Errorbar_VerAreaImaging(lags,mean(exp_corr_list,1),std(exp_corr_list,1),'k');
    Func_Errorbar_VerAreaImaging(lags,mean(noise_corr_list,1),std(noise_corr_list,1),'r');
    xlabel('lag [pixel]')
    ylabel('Correlation')
    grid on

    subplot(2,3,3)
    xlim([-0.5 10.5])
    ylim([-0.3 1.2])
    Func_Errorbar_VerAreaImaging(lags,mean(exp_corr_list,1),std(exp_corr_list,1),'k');
    Func_Errorbar_VerAreaImaging(lags,mean(noise_corr_list,1),std(noise_corr_list,1),'r');
    xlabel('lag [pixel]')
    ylabel('Correlation')
    grid on


    %% noise charactrics in temporal axis
    exp_fft_list = [];
    exp_corr_list = [];
    noise_fft_list = [];
    noise_corr_list = [];

        for forEach_x = 1:size(data,1)
            for forEach_y = 1:size(data,2)
                Ts = 1/1000;
                now_data = reshape(data(forEach_x,forEach_y,31:230),[1 200]);
                now_fft = abs(fft(now_data-mean(now_data)));
                fs = 1/Ts;
                f = (0:length(now_fft)-1)*fs/length(now_fft);
                f = f(2:max(size(f)/2)); 
                exp_fft_list = [exp_fft_list; now_fft(2:max(size(now_fft)/2))];
            
                
                [r,lags] = xcorr(now_data-mean(now_data),'unbiased');
                lags = lags(fix(max(size(lags)+1)/2):end);
                r = r(fix(max(size(r))/2+1):end);
                exp_corr_list = [exp_corr_list; r/r(1)];

                now_data = reshape(noise_data(forEach_x,forEach_y,:),[1 200]);
                now_fft = abs(fft(now_data-mean(now_data)));
                now_fft = now_fft(2:max(size(now_fft)/2));
                noise_fft_list = [noise_fft_list; now_fft];
    
                [r,lags] = xcorr(now_data-mean(now_data),'unbiased');
                lags = lags(fix(max(size(lags)+1)/2):end);
                r = r(fix(max(size(r))/2+1):end);
                noise_corr_list = [noise_corr_list; r/r(1)];
            end
        end



    subplot(2,3,4)
    f(1) = f(2)/10;
    set(gca, 'XScale', 'log')
    xlim([(f(1)*0.8) (f(end)*1.2)])
    ylim([-0.1 1]*35)
    Func_Errorbar_VerAreaImaging(f,mean(exp_fft_list,1),std(exp_fft_list ,1),'k');
    Func_Errorbar_VerAreaImaging(f,mean(noise_fft_list,1),std(noise_fft_list ,1),'r');
    xlabel('frequency [1/sec]')
    ylabel('|P(frequency)|')
    grid on
    
    subplot(2,3,5)
    xlim([-10 210])
    ylim([-1.2 1.2])
    Func_Errorbar_VerAreaImaging(lags,mean(exp_corr_list,1),std(exp_corr_list,1),'k');
    Func_Errorbar_VerAreaImaging(lags,mean(noise_corr_list,1),std(noise_corr_list,1),'r');
    xlabel('lag [frame]')
    ylabel('Correlation')
    grid on

    subplot(2,3,6)
    xlim([-0.5 10.5])
    ylim([-0.2 1.2])
    Func_Errorbar_VerAreaImaging(lags,mean(exp_corr_list,1),std(exp_corr_list,1),'k');
    Func_Errorbar_VerAreaImaging(lags,mean(noise_corr_list,1),std(noise_corr_list,1),'r');
    xlabel('lag [frame]')
    ylabel('Correlation')
    grid on
end