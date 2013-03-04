function im = grab_animal_im(imres, axis_limits, trim_pixels)

if (nargin < 1) 
    imres = [500 500];
end

if nargin < 3
    trim_pixels = 20;
end

imres_adj = imres + 2*trim_pixels;

set(1, 'position', [100, 100, imres_adj]);
set(gca, 'position', [0, 0, 1, 1]);
if (nargin > 1)
    axis(axis_limits);
end
axis off
im = frame2im(getframe(1));

im = im((1:imres(1)) + trim_pixels, (1:imres(2)) + trim_pixels, :);

end