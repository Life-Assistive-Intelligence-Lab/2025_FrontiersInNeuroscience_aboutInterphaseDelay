% Pre-processing - Step 4
% subtracting the data w/ D-AP5&DNQX from the control data

function Preprocessing_Step4

    rpwd = pwd;
    global folder_data;
    folder_slice_data = Folder_name.data_to_analyse(folder_data);
    Folder_Path = uigetdir(folder_slice_data,'Select data');

    cd(Folder_Path);
    Func_subtract_folder('Control','DAP5_DNQX') % As the results, the subtracted siganl is saved in 'Control-DAP5_DNQX'

    fprintf('complete\r');
    cd(rpwd)


end

function Func_subtract_folder(folder_plus_name,folder_minus_name)


    rpwd = pwd;

    fprintf(['(' folder_plus_name ')-(' folder_minus_name ') will be run\r']);
    new_folder_name = [folder_plus_name '-' folder_minus_name];

    stim_list = {'<stimulation1>','<stimulation2>','<stimulation3>','....'};

    for forEach_index = 1:size(stim_list,2)
        stim_file_name = char(stim_list(forEach_index));

        try
            cd(rpwd);
            cd(folder_plus_name);
            load(stim_file_name);
            data_sub = data;
    
            cd(rpwd);
            cd(folder_minus_name);
            load(stim_file_name);

            data = data_sub - data;

            cd('..')
            mkdir_or_cd(new_folder_name);
    
            information.condition_status = new_folder_name;

            save(stim_file_name,'data','information')

            fprintf([stim_file_name ' is saved\r']);
        catch 

        end
    end
    
    cd(rpwd);

end