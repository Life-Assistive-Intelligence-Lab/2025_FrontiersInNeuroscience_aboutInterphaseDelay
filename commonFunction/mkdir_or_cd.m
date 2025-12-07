function rpwd = mkdir_or_cd(next_dir)
    try
        rpwd = cd(next_dir);  
    catch 
        mkdir(next_dir);
        rpwd = cd(next_dir); 
    end
end