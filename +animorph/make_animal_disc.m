function [tiles, tiles_cdata] = make_animal_disc(origin, dir1, dir2, tile_res, ntiles, max_dist)
%[tiles, tiles_cdata] = make_animal_disc(origin, dir1, dir2, [tile_res, ...
%                                        ntiles, max_dist])
import animorph.*;

if nargin < 5
    ntiles = 5;
end

if nargin < 4
    tile_res = [200 200];
end

if nargin < 6
    max_dist = 1;
end


x = (-1:1/(ntiles-1):1) * max_dist;
y = (-1:1/(ntiles-1):1) * max_dist;

[X Y] = meshgrid(x, y);

tile_mask = sqrt(X.^2 + Y.^2) <= max_dist;

%origin = mean_animal;
%dir1 = animal_params(1, :) - origin;
%dir2 = animal_params(6, :) - origin;

tiles = cell(length(x), length(y));

% create temporary, invisible figure to draw tiles
hfig = figure('Visible', 'off', 'Position', [100 100 tile_res]);

for i = 1:length(x)
    for j = 1:length(y)
        if tile_mask(i,j)
            param_vec = origin + dir1 * x(i) + dir2 * y(j);
            make_animal(param_vector_to_struct(param_vec),  [.5 .5 .5], hfig);
            tiles{i,j} = grab_animal_im(tile_res, hfig);
        end
    end
end

close(hfig);

tiles_cdata = assemble_tiles(tiles);

end