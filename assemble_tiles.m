function cdata = assemble_tiles(tiles, hfig, scale_factor)
% cdata = assemble_tiles(tiles, [hfig, scale_factor])
% assemble a cell array of individual images into a single image, and plot


if nargin < 2
    hfig = 3;
end

if nargin < 3
    scale_factor = 3;
end

ntiles = size(tiles);

% get tile resolution, by finding first tile which is non-empty
i = 1;
tile_res = [0 0];
while(all(tile_res==0))
    tile_res = [size(tiles{i}, 2), size(tiles{i}, 1)];
    i = i+1;
end

% pre-allocate whole image result
cdata = zeros(tile_res(2) * ntiles(2), tile_res(1) * ntiles(1), 3);

% write all tiles into image
for i = 1:ntiles(1)
    for j = 1:ntiles(2)
        if ~isempty(tiles{i,j})
            cdata((1:tile_res(2)) + (j-1)*tile_res(2), (1:tile_res(1)) + (i-1)*tile_res(1), :) = ...
                tiles{i,j};
        end
    end
end

% display
figure(hfig);
set(gcf, 'position', [100, 100, size(cdata,2)/scale_factor, size(cdata,1)/scale_factor]);
set(gca, 'position', [0 0 1 1])

image(cdata / 256);

end