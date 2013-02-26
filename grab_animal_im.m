function im = grab_animal_im(imres)

if (nargin < 1) 
    imres = [500 500];
end

set(1, 'position', [100, 100, imres]);
set(gca, 'position', [0, 0, 1, 1]);
axis on
im = frame2im(getframe(1));

end