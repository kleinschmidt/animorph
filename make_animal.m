% /* The whole IGUANA */
function make_animal(params, color)

global surface_colour
if (~ exist('surface_colour')) 
    surface_colour = [1 0.65 0.1];
end

global shape_params


if (nargin > 1) 
    old_surface_colour = surface_colour;
    surface_colour = color;
end

if (nargin > 0) 
    if (exist('shape_params')) 
        old_shape_params = shape_params;
    end
    shape_params = params;
end



shape_params(find(strcmp({shape_params.name},'alpha'))).value = 1; % The variable called alpha
alpha = shape_params(find(strcmp({shape_params.name},'alpha'))).value;

figure(1);
clf;
axis('equal');
%%%%%%%%%%%%%% Set up the lighting and view angle for the whole scene
lightangle(-145,40);
view(-145,20);
xlabel('x-axis');
ylabel('y-axis');
zlabel('z-axis');
grid on;

%%% The head is centered at [0,0,0].
%%% Everything is is positioned with respect to the head.
entire_head = draw_head;

neck = draw_neck;
%%%% Get the coords of where the neck ends
animal_size = shape_params(find(strcmp({shape_params.name},'size'))).value;
head_neck_angle = shape_params(find(strcmp({shape_params.name},'head neck ang'))).value;
neck_length = shape_params(find(strcmp({shape_params.name},'neck length'))).value;

mid_base_of_neck_x = animal_size*neck_length * cos(pi/180*head_neck_angle);
mid_base_of_neck_y = animal_size*neck_length * -sin(pi/180*head_neck_angle);

%%% Draw the body, and translate it down to meet the end of the neck
entire_body = draw_body;
translation_matrix = makehgtform('translate', ...
   [mid_base_of_neck_x, mid_base_of_neck_y, 0]);
set(entire_body,'Matrix',translation_matrix);

%%% Make a note of the locations of the hips and shoulders
shoulders_xyz_location = ...
   [ mid_base_of_neck_x, mid_base_of_neck_y, 0 ];

abdomen_length = shape_params(find(strcmp({shape_params.name},'abd length'))).value;
abdomen_ecc = shape_params(find(strcmp({shape_params.name},'abd ecc'))).value;

chest_length = shape_params(find(strcmp({shape_params.name},'chest length'))).value;
abdomen_length = shape_params(find(strcmp({shape_params.name},'abd length'))).value;
chest_abdomen_angle = pi/180*shape_params(find(strcmp({shape_params.name},'chest abd ang'))).value;

hips_xyz_location = shoulders_xyz_location + ...
   animal_size*chest_length*[1 0 0] + ...
   animal_size*abdomen_length * [ cos(chest_abdomen_angle) sin(chest_abdomen_angle) 0 ];
  
%%% Draw the hind legs, and translate them to meet the hips
left_hind_leg = draw_hind_leg;
leg_offset = shape_params(find(strcmp({shape_params.name},'leg offset'))).value;

hind_legs_offset = animal_size * abdomen_length * abdomen_ecc * leg_offset;
translation_matrix = makehgtform('translate', hips_xyz_location + [ 0 0 hind_legs_offset ]);
set(left_hind_leg,'Matrix',translation_matrix);

right_hind_leg = draw_hind_leg;
translation_matrix = makehgtform('translate', hips_xyz_location + [ 0 0 -hind_legs_offset ]);
set(right_hind_leg,'Matrix',translation_matrix);

%%% Draw the fore-legs, and translate them to meet the chest
left_foreleg = draw_foreleg;
fore_legs_offset = animal_size * abdomen_length * abdomen_ecc * leg_offset;
translation_matrix = makehgtform('translate', ...
   shoulders_xyz_location + [ 0 0 fore_legs_offset ]);
set(left_foreleg,'Matrix',translation_matrix);

right_foreleg = draw_foreleg;
translation_matrix = makehgtform('translate', ...
   shoulders_xyz_location + [ 0 0 -fore_legs_offset ]);
set(right_foreleg,'Matrix',translation_matrix);

%%%%% Finally, draw the tail
tail_object = draw_tail;
tail_angle = pi/180 * shape_params(find(strcmp({shape_params.name},'tail ang'))).value;
translation_matrix = makehgtform('translate', hips_xyz_location);
rotation_matrix = makehgtform('zrotate', -tail_angle);
set(tail_object,'Matrix',translation_matrix*rotation_matrix);

%%%% Group all of the animal parts into a single object
entire_animal = hgtransform;
set([entire_head entire_body neck left_hind_leg left_foreleg ...
     right_hind_leg right_foreleg tail_object],'Parent',entire_animal);
%%%% Orient the animal such that the z-axis is up-down
rotation_matrix = makehgtform('xrotate', pi/2);
set(entire_animal,'Matrix',rotation_matrix);

lighting gouraud;
material dull;
%rotate3d on;

if (exist('old_shape_params'))
    shape_params = old_shape_params;
end

if (exist('old_surface_colour'))
    surface_colour = old_surface_colour;
end


