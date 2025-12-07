function SupplementaryMethodFig3A_Making_NoiseFilter

    figure('Position', [30 100 1800 850]);
    hold on

    % load data
    global folder_data;
    rpwd = pwd;
    cd(Folder_name.data_to_analyse(folder_data));
    cd(#24');
    cd('Control');
    load('ch2_20uA_11pulse_100Hz__width200us_wait0us');
    cd(rpwd);

    % calculate auto correlation
    autoCorr_list = [];
    for forEach_x = 1:12
        for forEach_time = 1:200
            now_data = reshape(data(forEach_x,:,forEach_time+30),[1 64]);

            [r,lags] = xcorr(now_data,'unbiased');
            autoCorr_list = [autoCorr_list; r/r((1+end)/2)];
        end
    end
    autoCorrelation = mean(autoCorr_list,1);
    optionOfFitMethod = fitoptions('Method','NonlinearLeastSquares','StartPoint',[1.1 2 4 0.02]);
    fit_model = fit(lags.',autoCorrelation.','a*exp(-(1/2)*(x/b)^2) + (1-a)*exp(-(1/2)*(x/c)^2)+d',optionOfFitMethod);
    
    % plot
    hold on
    xlim([-0.5 5.5])
    ylim([-0.2 1.2])
    plot(lags(:,((1+max(size(autoCorrelation)))/2)+(0:5)),mean(autoCorrelation(:,((1+max(size(autoCorrelation)))/2)+(0:5)),1),'ko-')
    x_range = 0:0.001:5;
    plot(x_range,feval(fit_model,x_range),'r-')
    xlabel('lag [pixel]')
    ylabel('Correlation')
    grid on

    rpwd = pwd;
    cd('Test_data');
    save('FilterForNoise','fit_model');
    cd(rpwd);

end