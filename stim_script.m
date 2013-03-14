% To make stimuli: 
%   Generate images from parameters 
%   Generate animal subspace
%   Make images from points in grid in subspace

%% Initialization
cd ~/code/animal-morph

global surface_colour;
surface_colour = [.5 .5 .5];

global shape_params;
sheep_params = open('animals/sheep.mat');
shape_params = sheep_params.shape_params;

%% Testing make_animal

sheep_params = sheep_params.shape_params;

make_animal(sheep_params);

%% Grab image from plot

imres = [500, 500];
im = grab_animal_im(imres);

figure(2)
set(2, 'position', [100, 100, imres]);
axes; 
axis off;

set(gca, 'position', [0 0 1 1]);

image(im)

%% try invisible figure for animal

h_invis = figure('Visible', 'off');
set(h_invis, 'Position', [100 100 imres+40]);

profile on
make_animal(sheep_params, surface_colour, h_invis);
im2 = grab_animal_im(imres, h_invis);
profile off


figure(3)
set(3, 'position', [100, 100, imres]);
axes; 
axis off;

set(gca, 'position', [0 0 1 1]);

image(im2)
profile viewer

%% Make grid of images interpolating between two animals

global shape_params


sheep_params = open('sheep.mat');
sheep_params = sheep_params.shape_params;


shape_params = sheep_params;


dog_params = open('dog.mat');
dog_params = dog_params.shape_params;

mouse_params = open('mouse.mat');
mouse_params = mouse_params.shape_params;

dog = param_struct_to_vector(dog_params);
big_dog = dog;
big_dog(1) = dog(1) * 2;
sheep = param_struct_to_vector(sheep_params);
mouse = param_struct_to_vector(mouse_params);


ntiles = 10;
lambdas = 0:1/(ntiles-1):1;

tile_res = [200, 200];

ims = cell(ntiles, 1);
axises = zeros(ntiles, 6);
view_angles = zeros(ntiles, 1);

animal_1 = dog;
animal_2 = big_dog;

% find endpoint axis limits and volume
make_animal(param_vector_to_struct(animal_1));
axis1 = axis();
axis1vol = prod(axis1([2 4 6]) - axis1([1 3 5]));

make_animal(param_vector_to_struct(animal_2));
axis2 = axis();
axis2vol = prod(axis2([2 4 6]) - axis2([1 3 5]));

if axis1vol > axis2vol
    biggest_axis = axis1;
else
    biggest_axis = axis2;
end

for lambda = lambdas
    mix_vec = animal_1*lambda + animal_2*(1-lambda);
    mix_params = param_vector_to_struct(mix_vec);
    make_animal(mix_params, [.5 .5 .5]);
    axises(lambdas==lambda, :) = axis();
    view_angles(lambdas==lambda) = get(gca, 'CameraViewAngle');
    ims{lambdas==lambda} = grab_animal_im(tile_res, 1, biggest_axis);
end


%% assemble tiles
tiles = zeros(tile_res(2), ntiles * tile_res(1), 3);

for i = 1:ntiles
    tiles(:, (1:tile_res(1)) + tile_res(1)*(i-1), :) = ims{i};
end

figure(2);
set(gcf, 'position', [100, 100, size(tiles, 2), size(tiles,1)]);
set(gca, 'position', [0, 0, 1, 1]);

image(tiles/256)


%% read in all animals and compute average vector

animals = {'dog', 'hippo', 'horse', 'monkey', 'mouse', 'sheep', 'tiger'};

animal_params = [];
for i = 1:length(animals)
    params = open(['animals/' animals{i} '.mat']);
    animal_params(i, :) = param_struct_to_vector(params.shape_params);
end

mean_animal = mean(animal_params);
make_animal(param_vector_to_struct(mean_animal));

%% tiles of all animals from mean animal

ntiles = 5;
tileres = [200 200];

all_tiles = zeros(length(animals) * tileres(2), ntiles * tileres(1), 3);

make_animal(param_vector_to_struct(mean_animal));
axis_lims = axis();

for i = 1:length(animals)
    [cont, tiles, params_mat] = make_animal_continuum_tiles(mean_animal, animal_params(i, :), tileres, ntiles, axis_lims, [-.25 1]);
    all_tiles((1:tileres(2)) + (i-1)*tileres(2), :, :) = cont;
end

%%
figure(3)
set(gcf, 'position', [100, 100, size(all_tiles, 2)/2, size(all_tiles, 1)/2]);
set(gca, 'position', [0 0 1 1]);

image(all_tiles / 256)

%imwrite(all_tiles/256, 'animals-from-average.png');

%% two-dimensional animal space


%dir1 = animal_1 - origin;
%dir2 = animal_2 - origin;

% make the two directions chest/abdomen length vs. size
[~, dir1] = feature_to_param_vector({'chest length', 'abd length'});
dir1 = dir1 / 4;
[~, dir2] = feature_to_param_vector({'chest ecc', 'abd ecc'});
dir2 = dir2 / 4;

dir1 = dir1 - dir2;
animal_1 = origin + dir1;
animal_2 = origin + dir2;

%%
ntiles = [9 9];

if length(ntiles)==1
    ntiles = [1 1] * ntiles;
end

angle_lambda_range = [0 pi/2];

dist_lambda_range = [-0.75 0.75];

% fix axis limits if not specified
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

%%

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

%%

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