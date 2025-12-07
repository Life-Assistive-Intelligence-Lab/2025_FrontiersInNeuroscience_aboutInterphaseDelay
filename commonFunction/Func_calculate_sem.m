% Calculate s.e.m.
function result_sem = Func_calculate_sem(list)
    result_sem = std(list,0,1)/sqrt(size(list,1));
end