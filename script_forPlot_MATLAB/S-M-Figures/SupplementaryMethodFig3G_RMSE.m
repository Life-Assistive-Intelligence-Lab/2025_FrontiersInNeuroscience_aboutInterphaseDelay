function SupplementaryMethodFig3G_RMSE
    
spatialFilterList = [1 3 5 7 9 11];
pixel_list = 0:4:12;

FilterSize_SSIMCompare = 5;

rpwd = pwd;
cd('Test_data')
load(['Input_NoiseFreeSignal.mat'])
cd(rpwd);


figure('Position', [30 100 1800 850]);
hold on

color_list = {'#DD0000','#DD8800','#00DD00','#0000DD'};

for forEach_pixel = pixel_list
    forEach_pixel

    corr_list = [];
    rmse_list = [];

    
    for spatialFilterSize = spatialFilterList
            now_corr_list = [];
            now_rmse_list = [];
    
            for forEach_no = 1:1000

                    cd('Test_data')
                    load(['NoiseData_1018_no' num2str(forEach_no) '.mat'])
                    cd(rpwd);
        
                    APs_dataWithNoiseListFiltered = APs_dataWithNoise;
                    for forEach_idx = 1:6
                        APs_dataWithNoiseListFiltered(forEach_idx,:,:,:) = gaussianFilter_2d(reshape(APs_dataWithNoise(forEach_idx,:,:,:), size(APs_dataWithNoise,[2 3 4])),spatialFilterSize);
                    end
                APs_dataWithNoiseFiltered = mean(APs_dataWithNoiseListFiltered,1);
                APs_dataWithNoiseFiltered = reshape(APs_dataWithNoiseFiltered,size(APs_dataWithNoiseFiltered,[2 3 4]));
        
        
                AP_timecourse = reshape(APs_data(6,forEach_pixel+32,:),[1 size(APs_data,3)]);
                APs_timecourseWithNoiseFiltered = reshape(APs_dataWithNoiseFiltered(6,forEach_pixel+32,:),[1 size(APs_dataWithNoiseFiltered,3)]);
                %now_corr_list = [now_corr_list corr2(AP_timecourse,APs_timecourseWithNoiseFiltered)];
                now_corr_list = [now_corr_list mean((AP_timecourse-APs_timecourseWithNoiseFiltered).^2)];
                now_rmse_list = [now_rmse_list sqrt(mean((AP_timecourse-APs_timecourseWithNoiseFiltered).^2))];


            end
    
   
            corr_list = [corr_list;now_corr_list];
            rmse_list = [rmse_list;now_rmse_list];
    

            subplot(1,1,1)
            hold on
            func_plot_sem_bar(spatialFilterSize+((forEach_pixel-8)/24),mean(now_rmse_list),std(now_rmse_list),1.5,char(color_list((forEach_pixel/4)+1)),0.3)
    end
    
    

    hold on
    plot([0 (spatialFilterList(end)+1)],[0 0],'k:')
  
    plot(spatialFilterList+((forEach_pixel-8)/24),mean(rmse_list,2),'o-','Color',char(color_list((forEach_pixel/4)+1)),'MarkerSize',10)
    xlabel('gaussian filter size','FontSize',20)
    xlim([0 (spatialFilterList(end)+1)])
    ylabel('root-mean-square error','FontSize',20)
    ylim([-0.1 1])

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



function filteredData = gaussianFilter_2d(data,spatialFilterSize)
    filteredData = zeros(size(data),class(data));
    F1 = diag(fliplr(pascal(spatialFilterSize)))/sum(diag(fliplr(pascal(spatialFilterSize)))); 
    F2 = repmat(F1,[1,spatialFilterSize]).*(repmat(F1,[1,spatialFilterSize]))'; 
    for ii=1:size(data,3)
        modifiedData=symmetricExpansion2(data(:,:,ii),spatialFilterSize);
        filteredData(:,:,ii) = filter2(F2,modifiedData,'valid');
    end


    function modifiedData=symmetricExpansion2(data,filterSize)
        expansionSize=filterSize/2-0.5;

        ll = fliplr(data(1:end,1:expansionSize)); 
        rr = fliplr(data(1:end,end-expansionSize+1:end)); 
        uu = flipud(data(1:expansionSize,1:end)); 
        dd = flipud(data(end-expansionSize+1:end,1:end)); 
        lu = flipud(ll(1:expansionSize,1:end)); 
        ru = flipud(rr(1:expansionSize,1:end));
        ld = flipud(ll(end-expansionSize+1:end,1:end));
        rd = flipud(rr(end-expansionSize+1:end,1:end));
        modifiedData = [lu,uu,ru;ll,data,rr;ld,dd,rd];
        clear expansionSize lu uu ru ll Data rr ld dd rd
    end

end