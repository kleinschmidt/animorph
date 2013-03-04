function [continuum, tiles, param_mat] = make_animal_continuum_tiles(animal_1, animal_2, tile_res, ntiles, axis_limits, lambda_range)

if nargin < 2
    error('Require two animal parameter vectors');
end

if nargin < 3
    tile_res = [200, 200];
end

if nargin < 4
    ntiles = 10;
end

% fix axis limits if not specified
if nargin < 5
    % find endpoint axis limits and volume
    make_animal(param_vector_to_struct(animal_1));
    axis1 = axis();
    axis1vol = prod(axis1([2 4 6]) - axis1([1 3 5]));

    make_animal(param_vector_to_struct(animal_2));
    axis2 = axis();
    axis2vol = prod(axis2([2 4 6]) - axis2([1 3 5]));

    if axis1vol > axis2vol
        axis_limits = axis1;
    else
        axis_limits = axis2;
    end
end

if nargin < 6
    lambda_range = [0 1];
end

lambdas = (0:1/(ntiles-1):1) * diff(lambda_range) + lambda_range(1);
tiles = cell(ntiles, 1);

param_mat = (1-lambdas)' * animal_1 + lambdas' * animal_2;

for lambda = lambdas
    mix_params = param_vector_to_struct(param_mat(lambdas==lambda, :));
    make_animal(mix_params, [.5 .5 .5]);
    tiles{lambdas==lambda} = grab_animal_im(tile_res, axis_limits);
end


%% assemble tiles
continuum = zeros(tile_res(2), ntiles * tile_res(1), 3);

for i = 1:ntiles
    continuum(:, (1:tile_res(1)) + tile_res(1)*(i-1), :) = tiles{i};
end

figure(2);
set(gcf, 'position', [100, 100, size(continuum, 2), size(continuum,1)]);
set(gca, 'position', [0, 0, 1, 1]);

image(continuum/256)


end