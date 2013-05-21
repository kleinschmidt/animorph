function cdata = xy_to_animal_image_old(xy, origin, dir1, dir2, resolution, hfig)

if nargin < 5
    resolution = [200 200];
end

if length(resolution) == 1
    resolution = [1 1] * resolution;
end

if nargin < 6
    hfig = figure('visible', 'off', 'position', [100 100 resolution]);
end

param_vec = origin + xy(1)*dir1 + xy(2)*dir2;
% the third "xy" coordinate is the rotation angle
if length(xy) > 2
    make_animal(param_vector_to_struct(param_vec), [.5 .5 .5], hfig, xy(3));
else
    make_animal(param_vector_to_struct(param_vec), [.5 .5 .5], hfig);
end
cdata = grab_animal_im(resolution, hfig);


if nargin < 6
    close(hfig)
end