function result_array = func_make_distance_array(information)

    result_array = (1-information.electrode_on_twoDim):(information.pixel(2)-information.electrode_on_twoDim);
    result_array = func_pixel2mm(result_array,information);

end