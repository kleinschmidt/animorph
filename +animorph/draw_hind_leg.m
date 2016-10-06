function hind_leg = draw_hind_leg
import animorph.*;

global surface_colour
global shape_params

animal_size = shape_params(find(strcmp({shape_params.name},'size'))).value;
foot_length = shape_params(find(strcmp({shape_params.name},'foot length'))).value;
foot_eccentricity_1 = shape_params(find(strcmp({shape_params.name},'foot ecc1'))).value; 
foot_eccentricity_2 = shape_params(find(strcmp({shape_params.name},'foot ecc2'))).value; 
lower_hind_leg_length = shape_params(find(strcmp({shape_params.name},'leg length'))).value; 
thigh_length = shape_params(find(strcmp({shape_params.name},'thigh length'))).value; 
abdomen_eccentricity = shape_params(find(strcmp({shape_params.name},'abd ecc'))).value; 
abdomen_thigh_angle = pi/180 * shape_params(find(strcmp({shape_params.name},'abd thigh ang'))).value; 
thigh_leg_angle = pi/180 * shape_params(find(strcmp({shape_params.name},'thigh leg ang'))).value; 

%/* Make proximal segment: */
thigh = draw_thigh;
rotation_matrix = makehgtform('zrotate', -abdomen_thigh_angle);
set(thigh,'Matrix',rotation_matrix);
scaled_thigh_length = animal_size * thigh_length; 

%  /* Make distal segment: */
lower_hind_leg = draw_lower_hind_leg;
lower_hind_leg_translation_matrix = makehgtform('translate', ...
   scaled_thigh_length* ...
   [ cos(-abdomen_thigh_angle) sin(-abdomen_thigh_angle) 0 ]);
lower_hind_leg_angle = -(abdomen_thigh_angle + thigh_leg_angle);
rotation_matrix = makehgtform('zrotate', lower_hind_leg_angle);
set(lower_hind_leg,'Matrix',lower_hind_leg_translation_matrix*rotation_matrix);

foot_object = draw_foot;
scaling_matrix = makehgtform('scale',[foot_eccentricity_1, foot_eccentricity_2, 1]);
scaled_lower_hind_leg_length = animal_size * lower_hind_leg_length; 
translation_along_lower_hind_leg = makehgtform('translate', ...
   scaled_lower_hind_leg_length*[ cos(lower_hind_leg_angle) sin(lower_hind_leg_angle) 0 ]);
translate_forward_half_of_foot_length = makehgtform('translate', ...
   [ -0.5*animal_size*foot_length*foot_eccentricity_1 0 0 ]);

foot_translation_matrix = lower_hind_leg_translation_matrix * ...
                          translation_along_lower_hind_leg * ...
                          translate_forward_half_of_foot_length;
set(foot_object,'Matrix',foot_translation_matrix*scaling_matrix);

%%% Group the three hind-leg objects together into a single object
hind_leg = hgtransform;
set([thigh lower_hind_leg foot_object],'Parent',hind_leg);
