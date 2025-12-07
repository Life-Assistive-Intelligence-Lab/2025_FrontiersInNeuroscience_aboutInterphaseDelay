
classdef Folder_name
    properties
        name_parent;
        name_data; 
        name_data_analyse; 
    end

    methods(Static)
    
    function obj = set_formal()
        % parent directory
        obj.name_parent = [sprintf('%s\\My Documents', getenv('USERPROFILE')) '\Animal_Experiment_data'];
        
        % ORIGINAL VSD signal data for each tissue slice
        obj.name_data  = 'slice_data';
        
        % data of VSD response to each stimulation for each tissue slice 
        % - after Step3, subtracting the trial-averaged data w/o stimulation from those w/ stimulation. 
        obj.name_data_analyse = 'slice_data_to_analyse'; 
    end
    
    function output = data(obj)
        output = [obj.name_parent '\' obj.name_data];
    end
    
    function output = data_to_analyse(obj)
        output = [obj.name_parent '\' obj.name_data_analyse];
    end
    
    end
end