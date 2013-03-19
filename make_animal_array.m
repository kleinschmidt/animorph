% make 2D array of animals by specifying origin and two directions.
function [animal_array, tiles, params] = make_animal_array_polar(origin, animal_1, animal_2, ...
    tile_res, ntiles, axis_limits, dist_lambda_range, angle_lambda_range)


dir1 = animal_1 - origin;
dir2 = animal_2 - origin;

if length(ntiles)==1
    ntiles = [1 1] * ntiles;
end

if nargin < 8
    angle_lambda_range = [0 pi/2];
end

if nargin < 7
    dist_lambda_range = [0 1];
end


% fix axis limits if not specified
if nargin < 6
    % find endpoint axis limits and volume
    make_animal(param_vector_to_struct(animal_1));
    axis1 = axis();
    axis1vol = prod(axis1([2 4 6]) - axis1([1 3 5]));

    make_animal(param_vector_to_struct(animal_2));
    axis2 = axis();
    axis2vol = prod(axis2([2 4 6]) - axis2([1 3 5]));

    make_animal(param_vector_to_struct(origin));
    axis3 = axis();
    axis3vol = prod(axis3([2 4 6]) - axis3([1 3 5]));

    all_axis = [axis1; axis2; axis3];
    all_vols = [axis1vol, axis2vol, axis3vol];
    axis_limits = all_axis(all_vols==max(all_vols), :);
end


angle_lambdas = (0:1/(ntiles(1)-1):1) * diff(angle_lambda_range) + angle_lambda_range(1);
dist_lambdas = (0:1/(ntiles(2)-1):1) * diff(dist_lambda_range) + dist_lambda_range(1);

tiles = cell(ntiles(1), ntiles(2));
animal_array = zeros(tile_res(2) * ntiles(2), tile_res(1) * ntiles(1), 3);

for dist = dist_lambdas
    for angle = angle_lambdas
        direction = (cos(angle) * dir1 + sin(angle) * dir2) * dist;
        params = origin + direction;
        make_animal(param_vector_to_struct(params), [.5 .5 .5]);
        tiles{angle_lambdas==angle, dist_lambdas==dist} = grab_animal_im(tile_res, 1, axis_limits, 20);
    end
end


for i = 1:ntiles(1)
    for j = 1:ntiles(2)
        animal_array((1:tile_res(2)) + (j-1)*tile_res(2), (1:tile_res(1)) + (i-1)*tile_res(1), :) = ...
            tiles{i,j};
    end
end


figure(3);
set(gcf, 'position', [100, 100, size(animal_array,2)/3, size(animal_array,1)/3]);
set(gca, 'position', [0 0 1 1])

image(animal_array / 256);