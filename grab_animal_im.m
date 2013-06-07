function im = grab_animal_im(imres, fig_h, axis_limits, trim_pixels)

if (nargin < 1) 
    imres = [500 500];
end

if nargin < 4
    trim_pixels = 20;
end
if length(trim_pixels) == 1
    trim_pixels = [1 1] * trim_pixels;
end

% default figure is 1, since this is the default used by make_animal
if nargin < 2
    fig_h = 1;
end

imres_adj = imres + 2*trim_pixels;

pos = get(fig_h, 'position');
set(fig_h, 'position', [pos(1), pos(2), imres_adj]);
set(gca, 'position', [0, 0, 1, 1]);
if (nargin > 2 && axis_limits ~= 0)
    axis(axis_limits);
end
axis off
%im = frame2im(getframe(fig_h));
im = opengl_cdata(fig_h);

im = im((1:imres(2)) + trim_pixels(2), (1:imres(1)) + trim_pixels(1), :);

end