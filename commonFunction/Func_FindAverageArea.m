% Determine the common spatial range valid across all tissue slices when centered on the stimulation electrode.
function [range_oneDim,range_twoDim] = Func_FindAverageArea(day_list,condition_name,stim_name)

    rpwd = pwd;

    %% First slice tissue 

    [data,info] = Func_data_loader(day_list(1),condition_name,stim_name);
    cd(rpwd);

    if max(size(day_list)) == 1
        % info = info
        return ;
    end

    data_forCompare = data;
    info_forCompare = info;


    %% Second, Third, Fourth ...
    for forEach_data = 2:size(day_list,1)

        [data,info] = Func_data_loader(day_list(forEach_data),condition_name,stim_name);
        cd(rpwd);

        [range_oneDim, range_twoDim] = func_finding_merge_range(data, data_forCompare, info, info_forCompare);

        if info.numberOfFrames < info_forCompare.numberOfFrames
            info_forCompare.numberOfFrames = info.numberOfFrames;
        end

        data_forCompare = data_forCompare(info_forCompare.electrode_on_oneDim+range_oneDim,info_forCompare.electrode_on_twoDim+range_twoDim,1:info_forCompare.numberOfFrames);


        info_forCompare.electrode_on_oneDim = (-range_oneDim(1)) + 1;
        info_forCompare.electrode_on_twoDim = (-range_twoDim(1)) + 1;


        info_forCompare.pixel(1) = max(size(range_oneDim));
        info_forCompare.pixel(2) = max(size(range_twoDim));

    end
    range_oneDim = (1:info_forCompare.pixel(1)) - info_forCompare.electrode_on_oneDim;
    range_twoDim = (1:info_forCompare.pixel(2)) - info_forCompare.electrode_on_twoDim;


end

function [range_oneDim, range_twoDim] = func_finding_merge_range(data, data_forCompare, info, info_forCompare)
    
    lowRange_oneDim = 0;
    while 1 
        try
            data(info.electrode_on_oneDim+lowRange_oneDim-1,:,:);
            data_forCompare(info_forCompare.electrode_on_oneDim+lowRange_oneDim-1,:,:);
        catch
            break;
        end
        lowRange_oneDim = lowRange_oneDim - 1;
    end

    highRange_oneDim = 0;
    while 1 
        try
            data(info.electrode_on_oneDim+highRange_oneDim+1,:,:);
            data_forCompare(info_forCompare.electrode_on_oneDim+highRange_oneDim+1,:,:);
        catch
            break;
        end
        highRange_oneDim = highRange_oneDim + 1;
    end

    lowRange_twoDim = 0;
    while 1 
        try
            data(:,info.electrode_on_twoDim+lowRange_twoDim-1,:);
            data_forCompare(:,info_forCompare.electrode_on_twoDim+lowRange_twoDim-1,:);
        catch
            break;
        end
        lowRange_twoDim = lowRange_twoDim - 1;
    end

    highRange_twoDim = 0;
    while 1 
        try
            data(:,info.electrode_on_twoDim+highRange_twoDim+1,:);
            data_forCompare(:,info_forCompare.electrode_on_twoDim+highRange_twoDim+1,:);
        catch
            break;
        end
        highRange_twoDim = highRange_twoDim + 1;
    end

    range_oneDim = lowRange_oneDim:highRange_oneDim;
    range_twoDim = lowRange_twoDim:highRange_twoDim;

end
