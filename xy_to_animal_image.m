function cdata = xy_to_animal_image(xy, origin, dirs, resolution, hfig, trim_pixels)
% cdata = xy_to_animal_image(xy, origin, dirs, resolution, hfig)
%   Generate an image from xy coordinates, and an origin and directions of
% variation in parameter space.  XY coordinates can be of arbitrary
% dimension so long as enough directions are specified.  Returns a "cdata"
% array, a width x height x 3 RGB array with values from 0 to 256.
%
% dirs is a nfeat X ndir matrix, and xy is a vector of length ndir
% or ndir+1 (if ndir+1, last entry specifies the rotation)

% check that dimensions line up okay.
[nfeat, ndir] = size(dirs);
if (length(xy) < ndir || length(xy) > ndir+2) 
    error(sprintf('Mismatching length of xy vector (%d) and number of directions (%d)', ...
        length(xy), ndir));
end


% default parameter values
if nargin < 4
    resolution = [200 200];
end

if length(resolution) == 1
    resolution = [1 1] * resolution;
end

if nargin < 5
    hfig = figure('visible', 'off', 'position', [100 100 resolution]);
end

if nargin < 6
    trim_pixels = 20;
end

% make sure origin has the right dimensions

param_vec = reshape(origin, [nfeat, 1]) + dirs * reshape(xy(1:ndir), [ndir 1]);
% the ndir+1th "xy" coordinate is the rotation angle
if length(xy) > ndir
    make_animal(param_vector_to_struct(param_vec), [.5 .5 .5], hfig, xy(ndir+1:end));
else
    make_animal(param_vector_to_struct(param_vec), [.5 .5 .5], hfig);
end
% grab image, passing axis_limits = 0 as "missing" value.
cdata = grab_animal_im(resolution, hfig, 0, trim_pixels);


if nargin < 6
    close(hfig)
end