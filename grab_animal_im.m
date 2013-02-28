function im = grab_animal_im(imres, axis_limits)

if (nargin < 1) 
    imres = [500 500];
end

set(1, 'position', [100, 100, imres]);
set(gca, 'position', [0, 0, 1, 1]);
if (nargin > 1)
    axis(axis_limits);
end
axis off
im = frame2im(getframe(1));

end