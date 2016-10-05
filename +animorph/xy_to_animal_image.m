function cdata = xy_to_animal_image(xy, origin, dirs, resolution, hfig, trim_pixels)
% Generate image for animal based on cartesian coordinates in animal space
% 
% cdata = xy_to_animal_image(xy, origin, dirs, resolution, hfig)
%
% Input: 
%   xy: Coordinates in "animal space", corresponding to basis vectors in dirs.
%   origin: Origin of coordinate system in parameter space (see
%     param_vector_to_struct.m).
%   dirs: Each column corresponds to a basis vector in parameter space, as an
%     offset from origin. 
%   resolution: Of captured image. Default [500 500]
%   hfig: Handle of figure to use for drawing. Optional, defaults to a new,
%     hidden figure.
%   trim_pixels: Number of pixels to trim off the captured images. Default: 20.
% Output:
%   cdata: Captured image data, in a width x height x RGB array with values
%     from 0 to 256
import animorph.*;

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