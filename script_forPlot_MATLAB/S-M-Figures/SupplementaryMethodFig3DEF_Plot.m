function SupplementaryMethodFig3DEF_Plot

    global folder_data
    cmap_color = 'parula';
    colormap_scale = [-2 3];
    
    rpwd = pwd;
    cd('Test_data')
    load(['Input_NoiseFreeSignal.mat'])
    cd(rpwd);
    
    tissueSlice_list = DataList_forFig34;
    sum_data = 0;
    [range_oneDim,range_twoDim] = Func_FindAverageArea(tissueSlice_list,'Control','ch2_20uA_11pulse_100Hz__width200us_wait0us');
    for forEach_slice = 1:max(size(tissueSlice_list))
    
        cd(Folder_name.data_to_analyse(folder_data));
        cd(char(tissueSlice_list(forEach_slice)));
        cd('Control');
        load('ch2_20uA_11pulse_100Hz__width200us_wait0us');
        cd(rpwd);
    
        data_forNrm = data(information.electrode_on_oneDim+range_oneDim,information.electrode_on_twoDim+range_twoDim,information.stimIn+(1:100));
        data_forNrm = mean(mean(mean(data_forNrm)));
        data = data / data_forNrm;
        sum_data = sum_data + data;
    end 
    data = sum_data/max(size(tissueSlice_list));
    
    
    nrm_value_data = mean(mean(mean(APs_data(6+(-2:2),32+(-2:2),2:7),1),2),3) ...
        /mean(mean(mean(data(information.electrode_on_oneDim+(-2:2),information.electrode_on_twoDim+(-2:2),301:306),1),2),3);
    
    
    cd('Test_data')
    load('NoiseData_1018_no3.mat') % Generatied Signal
    cd(rpwd);
    
    
    spatialFilterList = [1 3 5 7 9 11];


%% Supplementary Figure 3D - Experimental, Time-series iamges
figure('Position', [30 100 1800 850]);
hold on
for spatialFilterSize = spatialFilterList
    tissueSlice_list = DataList_forFig34;
    sum_data = 0;
    [range_oneDim,range_twoDim] = Func_FindAverageArea(tissueSlice_list,'Control','ch2_20uA_11pulse_100Hz__width200us_wait0us');
    for forEach_slice = 1:max(size(tissueSlice_list))    
        
        cd(Folder_name.data_to_analyse(folder_data));
        cd(char(tissueSlice_list(forEach_slice)));
        cd('Control');
        load('ch2_20uA_11pulse_100Hz__width200us_wait0us');
        cd(rpwd);

        data_forNrm = data(information.electrode_on_oneDim+range_oneDim,information.electrode_on_twoDim+range_twoDim,information.stimIn+(1:100));
        data_forNrm = mean(mean(mean(data_forNrm)));
        [data,information] = Func_gauss_filtering(data,information,spatialFilterSize);
        data = data / data_forNrm;
        sum_data = sum_data + data;
    end 
    data = sum_data/max(size(tissueSlice_list));

    data = data*nrm_value_data;

    for forEach_idx = 1:10
        subplot(10,max(size(spatialFilterList))+1, (forEach_idx-1)*(max(size(spatialFilterList))+1)+1+(1+spatialFilterSize)/2)
        hold on
        box off
        xticks([-50 100]);
        yticks([-50 100]);
        ax = gca;
        ax.XAxis.Visible = 'off';
        ax.YAxis.Visible = 'off';
        colormap(cmap_color);
        imagesc(data(:,:,forEach_idx+299),colormap_scale);
        xlim([-inf inf])
        ylim([-inf inf])
    end
end

%% Supplementary Figure 3E - Generated signal, Time-series iamges
figure('Position', [30 100 1800 850]);
hold on

for forEach_idx = 1:10
    subplot(10,max(size(spatialFilterList))+1, (forEach_idx-1)*(max(size(spatialFilterList))+1)+1)
    hold on
    box off
    xticks([-50 100]);
    yticks([-50 100]);
    ax = gca;
    ax.XAxis.Visible = 'off';
    ax.YAxis.Visible = 'off';
    colormap(cmap_color);
    imagesc(APs_data(:,:,forEach_idx),colormap_scale);
    xlim([-inf inf])
    ylim([-inf inf])
end

for spatialFilterSize = spatialFilterList

    APs_dataWithNoiseListFiltered = APs_dataWithNoise;
    for forEach_idx = 1:6
        APs_dataWithNoiseListFiltered(forEach_idx,:,:,:) = gaussianFilter_2d(reshape(APs_dataWithNoise(forEach_idx,:,:,:), size(APs_dataWithNoise,[2 3 4])),spatialFilterSize);
    end

    APs_dataWithNoiseFiltered = mean(APs_dataWithNoiseListFiltered,1);
    APs_dataWithNoiseFiltered = reshape(APs_dataWithNoiseFiltered,size(APs_dataWithNoiseFiltered,[2 3 4]));
        
    for forEach_idx = 1:10
        subplot(10,max(size(spatialFilterList))+1, (forEach_idx-1)*(max(size(spatialFilterList))+1)+1+(1+spatialFilterSize)/2)
        hold on
        box off
        xticks([-50 100]);
        yticks([-50 100]);
        ax = gca;
        ax.XAxis.Visible = 'off';
        ax.YAxis.Visible = 'off';
        colormap(cmap_color);
        imagesc(APs_dataWithNoiseFiltered(:,:,forEach_idx),colormap_scale);
        xlim([-inf inf])
        ylim([-inf inf])
    end
end


color_list = {'k','b','g','c','y','r'};


%% Supplementary Figure 3F upper -Experiment, Timecourse
figure('Position', [30 100 1800 850]);
hold on


for spatialFilterSize = spatialFilterList
        sum_data = 0;
        for forEach_slice = 1:max(size(tissueSlice_list))
    
            cd(Folder_name.data_to_analyse(folder_data));
            cd(char(tissueSlice_list(forEach_slice)));
            cd('Control');
            load('ch2_20uA_11pulse_100Hz__width200us_wait0us');
            cd(rpwd);
    
            data_forNrm = data(information.electrode_on_oneDim+range_oneDim,information.electrode_on_twoDim+range_twoDim,information.stimIn+(1:100));
            data_forNrm = mean(mean(mean(data_forNrm)));
            [data,information] = Func_gauss_filtering(data,information,spatialFilterSize);
            data = data / data_forNrm;
            sum_data = sum_data + data;
        end
        data = sum_data/max(size(tissueSlice_list));
    
        data = data*nrm_value_data;
        size(data)

        for forEach_pixel = 0:3
            subplot(2,2,forEach_pixel+1)
            hold on
            plot(0:9,reshape(data(6,31+forEach_pixel*4,300:309),[1 10]),'-','Color',char(color_list((spatialFilterSize+1)/2)))
        xlim([-1 10])
        ylim([-2 3])
        end
end



%% Supplementary Figure 3F bottom - Generated signal, Timecourse
figure('Position', [30 100 1800 850]);
hold on

for forEach_pixel = 0:3
    subplot(2,2,forEach_pixel+1)
    hold on
    plot(0:9,reshape(APs_data(6,32+forEach_pixel*4,:),[1 10]),'m-')
end


for spatialFilterSize = spatialFilterList


        APs_dataWithNoiseListFiltered = APs_dataWithNoise;
        for forEach_idx = 1:6
            APs_dataWithNoiseListFiltered(forEach_idx,:,:,:) = gaussianFilter_2d(reshape(APs_dataWithNoise(forEach_idx,:,:,:), size(APs_dataWithNoise,[2 3 4])),spatialFilterSize);
        end

        APs_dataWithNoiseFiltered = mean(APs_dataWithNoiseListFiltered,1);
        APs_dataWithNoiseFiltered = reshape(APs_dataWithNoiseFiltered,size(APs_dataWithNoiseFiltered,[2 3 4]));

        %[data,information] = Func_average_auto_loaderVerElectrode(slice_list,'Control','ch2_20uA_11pulse_100Hz__width200us_wait0us',0,0,spatialFilterSize);
        %data = (data *nrm_value_data);
        %APs_dataWithNoiseFiltered = data(:,:,300:309);


        for forEach_pixel = 0:3
            subplot(2,2,forEach_pixel+1)
            hold on
            plot(0:9,reshape(APs_dataWithNoiseFiltered(6,31+forEach_pixel*4,:),[1 10]),'-','Color',char(color_list((spatialFilterSize+1)/2)))
        xlim([-1 10])
        ylim([-2 3])
        end
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


