% Calculate half-energy width from lineprofile 
function [result_r] = func_calculate_hew_from_lineprofile(lineprofile,information)

    stimPoint = information.electrode_on_twoDim;

    for idx = 1:max(size(lineprofile))
        if (lineprofile(idx)) < 0
            lineprofile(idx) = 0;
        end
    end

    q = 0.5;    
    
    all_AreaSize = lineprofile(information.electrode_on_twoDim);
    for idx = 1:(max(size(lineprofile)-2)/2)
        now_AreaSize = lineprofile(information.electrode_on_twoDim+idx) + lineprofile(information.electrode_on_twoDim-idx);
        all_AreaSize = all_AreaSize+now_AreaSize;
    end

    q_AreaSize  = q*all_AreaSize;

    now_AreaSize = lineprofile(stimPoint);

    for idx = 1:(max(size(lineprofile)-2)/2)
        next_AreaSize =  lineprofile(stimPoint+idx) + lineprofile(stimPoint-idx);

        if (next_AreaSize + now_AreaSize) < q_AreaSize 
            now_AreaSize = next_AreaSize + now_AreaSize;
        else

            ans_NextAreaSize = q_AreaSize - now_AreaSize;

            next_idx = ans_NextAreaSize / (lineprofile(stimPoint+idx) + lineprofile(stimPoint-idx));

            result_r = 2 * (idx + next_idx-1);
            break
        end
    end
    
end
