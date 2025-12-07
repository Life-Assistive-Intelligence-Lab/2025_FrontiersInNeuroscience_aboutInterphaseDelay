% Exporting analysed data to CSV for statistical analysis in Python.

function Func_saveData_toCSV(data, dataName,fileName)
    CSVdata = cell(size(data,2),size(data,1)+1);
    for forEach_idx = 1:max(size(dataName))
        CSVdata(forEach_idx,1) = dataName(forEach_idx);
        for forEach_sample = 1:size(data,1)
            CSVdata(:,2:end) = num2cell(data).';
        end
    end

    rpwd = pwd;
    cd('ForStatisticalTest')
    writecell(CSVdata,[fileName '.csv'])
    cd(rpwd)

end