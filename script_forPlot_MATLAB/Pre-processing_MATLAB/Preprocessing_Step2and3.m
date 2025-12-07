% Pre-processing - Step 2&3
% Step2 : trial averaging over 15-200 repeats for each condition
% Step3 : subtracting the trial-averaged data w/o stimulation from those w/ stimulation

function Preprocessing_Step2and3

    global folder_data;
    folder_path = uigetdir(Folder_name.data(folder_data),'Select data');

    rpwd = cd(folder_path);

    folderInfo = dir;
    folderInfo = folderInfo(~ismember({folderInfo.name}, {'.', '..','SOURCE','SOURSE','0uA','SOURCE_DATA'}));
    folderlist = folderInfo([folderInfo.isdir]);
    folder_list = {folderlist.name}';
    sample_prompt = {'Start number','End number'};
    sample_answer = {'1','210'};
    title = 'Input range for Averaging';
    lines = 1;
    common_question_answer  = str2double(inputdlg(sample_prompt,title,lines,sample_answer));
    start_num = common_question_answer(1);
    end_num = common_question_answer(2);


    %% averaging VSD signal in response to no stimulation
    [non_stim_data,~] = Func_averaging_data_from_folder([folder_path '/0uA'],start_num,end_num);

    new_folder_name = [folder_path '-' num2str(start_num) '-' num2str(end_num) 'th'];
    cd ..
    mkdir_or_cd(new_folder_name);

    %% save averaged and subtracted VSD signal
    for forEach_folder = 1:size(folder_list,1)
        stim_name = char(folder_list(forEach_folder));
        [data,information,ave_num] = Func_averaging_data_from_folder([folder_path '/' stim_name],start_num,end_num);
        data = data - non_stim_data;
        save(stim_name,'data','information')
        fprintf(['save : ' stim_name ', n = ' num2str(ave_num) '\n'])
    end

    cd(rpwd);

end

%% averaging VSD signal
function [rdata,rinfo,count_num] = Func_averaging_data_from_folder(folder_name,start_num,end_num)

    rpwd = pwd;
    cd(folder_name)

    count_num = 0;
    average_data = 0;


    for forEach_file = start_num:end_num
    
        file_name = ls(['*_' num2str(forEach_file) '.mat']);
    
        if size(file_name) == 0
            continue;
        end
   
        load(file_name);
    
        information.pixel = double(information.pixel);
        information.stimIn = double(information.stimIn);
        information.numberOfFrames = double(information.numberOfFrames);
        information.rotationFrag = double(information.rotationFrag);
        information.fps = double(information.fps);
        save(file_name,'data','information')
    
        average_data = average_data + data; 
        count_num = count_num + 1;
    
    end

    rdata = average_data / count_num;
    rinfo = information;
    rinfo.average_num = count_num;
    cd(rpwd)

end