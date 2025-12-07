% Define time array for VSD data; 
% frames in the 0-1 msec window are treated as 0 msec.
function time_array = func_make_time_array(information)
        stimIntime = double(information.stimIn);
        fps_num = double(information.fps);
        time_array = ((1:information.numberOfFrames) - stimIntime)/fps_num * 1000;    
end