% loading the VSD signal and applies Gaussian filtering (Preprocessing Step 5).
% slice_label : tissue slice label (slice #1, #2)
% condition   : measurement or subtraction condition (e.g.,  'Control', 'DAP5_DNQX', 'Control-DAP5_DNQX')
% stimulation : name of the applied stimulation

function [data,information] = Func_data_loader(slice_label,condition,stimulation)

    global folder_data;
    rpwd = pwd;
    
    cd(Folder_name.data_to_analyse(folder_data));
    cd(char(slice_label));
    cd(char(condition));
    load([stimulation '.mat']);
    [data,information] = gauss_filtering(data,information,5); % Step 5 of pre-processing : filtering
    cd(rpwd);

end

