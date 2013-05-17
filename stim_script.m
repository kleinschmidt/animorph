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

origin = mean_animal;

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

tile_res = [200 200];

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

animal_array = assemble_tiles(tiles, 3, 2);


%% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Make an array of animals specifying limits in polar coordinates but
% plotting in euclidean grid

angle_lambda_range = [0, pi/2];

dist_lambda_range = [-0.75 0.75];

[X, Y] = meshgrid(-1:.1:1, -1:.1:1);

plot(X(:), Y(:), 'o')

circ = sqrt(X(:).^2 + Y(:).^2) <= 1;
plot(X(circ), Y(circ), 'o')

theta_lims = [0, 2*pi];

thlim = mod(theta_lims, 2*pi);

thxy = acos(X(:) ./ sqrt(X(:).^2 + Y(:).^2)) .* (1 - 2*(Y(:)<0));

%slice = (X(:)==0) & (Y(:)==0) | (prod([theta_lims(1) - thxy theta_lims(2) - thxy]')' <= 0);
slice = (X(:)==0) & (Y(:)==0) | mod(thxy(:)-thlim(1), 2*pi) <= mod(diff(thlim), 2*pi);


plot(X(:), Y(:), 'go')
hold on;
plot(X(slice), Y(slice), 'o')
hold off;

%% 

ntiles = 5;
tile_res = [200 200];

x = -1:1/(ntiles-1):1;
y = -1:1/(ntiles-1):1;

[X Y] = meshgrid(x, y);

origin = mean_animal;
dir1 = animal_params(1, :) - origin;
dir2 = animal_params(6, :) - origin;

max_dist = 1;
tile_mask = sqrt(X.^2 + Y.^2) <= max_dist;


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
%%
assemble_tiles(tiles);

%% create ten 2D animal spaces centered at the mean animal w/ random axes
%[tiles, tiles_cdata] = make_animal_disc(origin, dir1, dir2, tile_res,
%                                        ntiles, max_dist)

ndiscs = 10;

for i = 1:ndiscs
    fn = ['animals/animal_disc_' num2str(i)];
    fprintf([fn '\n']);
    
    origin = mean_animal;
    origin_n = param_vector_to_normalized_vector(origin);
    
    dir1_n = rand(1, length(shape_params)) - 0.5;
    dir1_n = dir1_n / sqrt(sum(dir1_n.^2));
    dir1 = origin - normalized_param_vector_to_vector(dir1_n + origin_n);
    
    dir2_n = rand(1, length(shape_params)) - 0.5;
    dir2_n = dir2_n / sqrt(sum(dir2_n.^2));
    dir2 = origin - normalized_param_vector_to_vector(dir2_n + origin_n);
    
    
    %dir1 = normalized_param_vector_to_vector(rand(1, length(shape_params))-.5);
    %dir2 = normalized_param_vector_to_vector(rand(1, length(shape_params))-.5);

    [tiles, tiles_cdata] = make_animal_disc(mean_animal, dir1, dir2, ...
        [200 200], 6, 0.25);
    
    imwrite(tiles_cdata/256, [fn '.png']);
    save([fn '.mat'], 'dir1', 'dir2', 'tiles', 'tiles_cdata');
end

%% Actual stimulus generation:

inner_dist = 0.0625;

% Regenerate first set with factored-out stimulus generating code
make_stimuli('animals/animal_disc_8.mat', 'stimuli/animal_disc_8_stimuli_2to1', 2*inner_dist, inner_dist, 8, 4, [0.125, 0]);

% Generate easier stimuli (outer:inner distance ratio of 3:1)
make_stimuli('animals/animal_disc_8.mat', 'stimuli/animal_disc_8_stimuli_3to1', 3*inner_dist, inner_dist, 8, 4, [0.125, 0]);
make_stimuli('animals/animal_disc_8.mat', 'stimuli/animal_disc_8_stimuli_4to1', 4*inner_dist, inner_dist, 8, 4, [0.125, 0]);

%% Control foot size

disc = open('animals/animal_disc_8.mat');

dir1s = param_vector_to_struct(disc.dir1);
dir2s = param_vector_to_struct(disc.dir2);

%%
getp(dir1s, 'foot length')
getp(dir2s, 'foot length')

getp(dir1s, 'hand length')
getp(dir2s, 'hand length')

dir1s = setp(dir1s, 'foot length', 0);
dir1s = setp(dir1s, 'hand length', 0);

dir2s = setp(dir2s, 'foot length', 0);
dir2s = setp(dir2s, 'hand length', 0);

dir1 = param_struct_to_vector(dir1s);
dir2 = param_struct_to_vector(dir2s);

load('animals/average.mat');
origin = param_struct_to_vector(orig_s);

%%
[tiles tiles_cdata] = make_animal_disc(origin, dir1, dir2, ...
    [200 200], 8, 0.4);
%%
fn = 'animal-morph/animals/animal_disc_8_0foot';
imwrite(tiles_cdata/256, [fn '.png']);
save([fn '.mat'], 'dir1', 'dir2', 'tiles', 'tiles_cdata');

%% generate updated stimuli after fixing feet

make_stimuli('animals/animal_disc_8_0foot.mat', 'stimuli/animal_disc_8_0foot_stimuli_2to1', 2*inner_dist, inner_dist, 8, 4, [0.125, 0]);

% Generate easier stimuli (outer:inner distance ratio of 3:1)
make_stimuli('animals/animal_disc_8_0foot.mat', 'stimuli/animal_disc_8_0foot_stimuli_3to1', 3*inner_dist, inner_dist, 8, 4, [0.125, 0]);
make_stimuli('animals/animal_disc_8_0foot.mat', 'stimuli/animal_disc_8_0foot_stimuli_4to1', 4*inner_dist, inner_dist, 8, 4, [0.125, 0]);


%% generate generalization stimuli

% generalization stimuli along an "X"
gen1_dir = [1 1] * sqrt(2);
gen2_dir = [-1, 1] * sqrt(2);

% dist_in is half the outer distance. generalization stimuli at inner ring,
% halfway to outer, and then beyond outer by half inner-outer distance
gen_dist = [-2.5, -1.5, -1, 1, 1.5, 2.5] * dist_in;

xy_proto = subsp_origin;
xy_gen1 = gen1_dir' * gen_dist + repmat(subsp_origin', [1, length(gen_dist)]);
xy_gen2 = gen2_dir' * gen_dist + repmat(subsp_origin', [1, length(gen_dist)]);


% a third, orthogonal generalization direction (supply as dir2 to xy_to_...
gendirs = load('animals/animal_disc_9.mat');
dir3 = gendirs.dir1;

xy_gen3 = [gen_dist * 0; gen_dist];


%%

gen_tiles = cell(length(gen_dist)+1, 3);

for (i = 1:length(gen_dist)) 
    if i > length(gen_dist)/2
        j = i + 1;
    else
        j = i;
    end
    gen_tiles{j, 1} = xy_to_animal_image(xy_gen1(:,i), origin, dir1, dir2, [500 500]);
    gen_tiles{j, 2} = xy_to_animal_image(xy_gen2(:,i), origin, dir1, dir2, [500 500]);
    gen_tiles{j, 3} = xy_to_animal_image(xy_gen3(:,i), origin, dir1, dir3, [500 500]);
end

gen_tiles{length(gen_dist)/2 + 1, 2} = xy_to_animal_image(xy_proto, origin, dir1, dir2, [500 500]);

gen_cdata = assemble_tiles(gen_tiles);

%%
save('stimuli/animal_disc_8_9_generalization.mat', ...
    'origin', 'dir1', 'dir2', 'dir3', ...
    'gen1_dir', 'gen2_dir', 'gen_dist', ...
    'xy_gen1', 'xy_gen2', 'xy_gen3', 'xy_proto', 'subsp_origin');

imwrite(gen_cdata/256, 'stimuli/animal_disc_8_9_generalization.png');