% To make stimuli: 
%   Generate images from parameters 
%   Generate animal subspace
%   Make images from points in grid in subspace

%% Testing make_animal

sheep_params = open('sheep.mat');
sheep_params = sheep_params.shape_params;

make_animal(sheep_params, [.5, .5, .5]);

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
shape_params = sheep_params;

dog_params = open('dog.mat');
dog_params = dog_params.shape_params;

dog = param_struct_to_vector(dog_params);
sheep = param_struct_to_vector(sheep_params);


ntiles = 10;
lambdas = 0:1/(ntiles-1):1;

tile_res = [100, 100];

ims = cell(ntiles);

for lambda = lambdas
    mix_vec = dog*lambda + sheep*(1-lambda);
    mix_params = param_vector_to_struct(mix_vec);
    make_animal(mix_params, [.5 .5 .5]);
    ims{lambdas==lambda} = grab_animal_im(tile_res);
end

