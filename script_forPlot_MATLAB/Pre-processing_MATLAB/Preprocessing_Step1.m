% Pre-processing - Step 1
% Step 1: convert time-series value into Δ𝑇(𝑡𝑛)/𝑇0 at each pixel
function [data,information] = Preprocessing_Step1(data,information)
    information.RLI = mean(data(:,:,information.stimIn-21:information.stimIn-10),3);
    for i=1:information.numberOfFrames
        data(:,:,i)=(information.RLI-data(:,:,i))./information.RLI*1000;
    end
end