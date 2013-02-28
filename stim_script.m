% To make stimuli: 
%   Generate images from parameters 
%   Generate animal subspace
%   Make images from points in grid in subspace

%% Testing make_animal

global surface_colour;
surface_colour = [.5 .5 .5];

sheep_params = open('sheep.mat');
sheep_params = sheep_params.shape_params;

make_animal(sheep_params);

%% Grab image from plot

imres = [500, 500];
% 
% set(1, 'position', [100, 100, imres]);
% set(gca, 'position', [0, 0, 1, 1]);
% axis off
% im = frame2im(getframe(1));

im = grab_animal_im(imres);

%%
figure(2)
set(2, 'position', [100, 100, imres]);
axes; 
axis off;

set(gca, 'position', [0 0 1 1]);

image(im)

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
    ims{lambdas==lambda} = grab_animal_im(tile_res, biggest_axis);
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


