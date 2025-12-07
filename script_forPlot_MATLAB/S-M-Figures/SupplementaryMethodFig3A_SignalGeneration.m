function SupplementaryMethodFig3A_SignalGeneration


    rpwd = pwd;
    cd('Test_data')
    load(['Input_NoiseFreeSignal.mat'])
    cd(rpwd);


    tissueSlice_list = DataList_forFig34;
    sum_data = 0;
    [range_oneDim,range_twoDim] = Func_FindAverageArea(tissueSlice_list,'Control','ch2_20uA_11pulse_100Hz__width200us_wait0us');
    for forEach_slice = 1:max(size(tissueSlice_list))
        [data,information] = Func_data_loader(tissueSlice_list(forEach_slice),'Control','ch2_20uA_11pulse_100Hz__width200us_wait0us');
        data_forNrm = data(information.electrode_on_oneDim+range_oneDim,information.electrode_on_twoDim+range_twoDim,information.stimIn+(1:100));
        data_forNrm = mean(mean(mean(data_forNrm)));
        data = data / data_forNrm;
        sum_data = sum_data + data;
    end 
    data = sum_data/max(size(tissueSlice_list));

    nrm_value_data = mean(mean(mean(APs_data(6+(-2:2),32+(-2:2),2:7),1),2),3) ...
        /mean(mean(mean(data(information.electrode_on_oneDim+(-2:2),information.electrode_on_twoDim+(-2:2),301:306),1),2),3);
    
    data = (data*nrm_value_data);

    experimental_noiseData = data(:,:,31:230);
    std_experiment = std(reshape(experimental_noiseData,[1 (size(data,1)*size(data,2)*200)]));
    
    NoiseTestList = zeros([6 11 63 200]);
    for forEach_idx = 1:6
        NoiseTestList(forEach_idx,:,:,:) = reshape(Func_generateNoise(200),size(NoiseTestList(1,:,:,:)));
    end
    
    NoiseTestList = mean(NoiseTestList,1);
    std_noise = std(reshape(NoiseTestList,[1 (size(NoiseTestList,2)*size(NoiseTestList,3)*size(NoiseTestList,4))]));

    
    forEach_gnrt = 1;

    while forEach_gnrt <= 1000
        APs_dataWithNoise = zeros([6 11 63 10]);
        NoiseOnly = zeros([6 11 63 10]);
        for forEach_idx = 1:6
            noise_data = Func_generateNoise(10)*(std_experiment/std_noise);
            APs_dataWithNoise(forEach_idx,:,:,:) = reshape(APs_data+noise_data,size(APs_dataWithNoise(1,:,:,:)));
            NoiseOnly(forEach_idx,:,:,:)  = reshape(noise_data,size(APs_dataWithNoise(1,:,:,:)));
        end
        APs_dataWithNoiseMean = mean(APs_dataWithNoise,1);
        NoiseOnly = mean(NoiseOnly,1);
    
        cd('Test_data')
        save(['NoiseData_1018_no' num2str(forEach_gnrt)],'APs_dataWithNoise' )
        cd(rpwd);
        forEach_gnrt = forEach_gnrt + 1;
    end
end

function noise_data = Func_generateNoise(time_index)
    rpwd = pwd;
    cd('Test_data')
    load('FilterForNoise.mat')
    cd(rpwd);
    
    filter_forConv = zeros([11 63]);
    for forEach_x = 1:size(filter_forConv,1)
        for forEach_y = 1:size(filter_forConv,2)
            now_r = sqrt((forEach_x-6)^2+(forEach_y-32)^2);
            filter_forConv(forEach_x,forEach_y) = feval(fit_model,now_r);
        end
    end
    
    noise_data = filter_forConv*0;
    for forEach_time = 1:time_index
        rand_data = 2*(rand(size(filter_forConv,1)*2+1,size(filter_forConv,2)*2+1)-0.5);
        noise_data(:,:,forEach_time) = conv2(filter_forConv,rand_data(:,:),'same');
    end
    
    noise_data = reshape(noise_data,[size(filter_forConv) time_index]);
end