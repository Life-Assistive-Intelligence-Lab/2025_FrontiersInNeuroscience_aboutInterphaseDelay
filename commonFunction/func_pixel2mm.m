% converting distance from pixel to mm.
function distance = func_pixel2mm(pixel,information)
    distance = pixel * information.length_on_one_pixel;
end