function fore_leg = draw_foreleg
import animorph.*;

global shape_params

animal_size = shape_params(find(strcmp({shape_params.name},'size'))).value;
upper_foreleg_length = shape_params(find(strcmp({shape_params.name},'up fr leg length'))).value;
chest_upper_foreleg_angle = -pi/180*shape_params(find(strcmp({shape_params.name},'chest leg ang'))).value;
knee_angle = pi/180*shape_params(find(strcmp({shape_params.name},'front knee ang'))).value;
lower_foreleg_radius = shape_params(find(strcmp({shape_params.name},'lo fr leg radius'))).value;
lower_foreleg_length = shape_params(find(strcmp({shape_params.name},'lo fr leg length'))).value;
hand_length = shape_params(find(strcmp({shape_params.name},'hand length'))).value;
hand_eccentricity_1 = shape_params(find(strcmp({shape_params.name},'hand ecc1'))).value;
hand_eccentricity_2 = shape_params(find(strcmp({shape_params.name},'hand ecc2'))).value;

%/* Make proximal segment: */
upper_foreleg = draw_upper_foreleg;
rotation_matrix = makehgtform('zrotate', chest_upper_foreleg_angle);
set(upper_foreleg,'Matrix',rotation_matrix);
scaled_upper_foreleg_length = animal_size * upper_foreleg_length; 

%  /* Make distal segment: */
lower_leg = draw_lower_foreleg;
lower_leg_translation_matrix = makehgtform('translate', ...
   0.85*scaled_upper_foreleg_length* ...
   [ cos(chest_upper_foreleg_angle) sin(chest_upper_foreleg_angle) 0 ]);
lower_leg_angle = chest_upper_foreleg_angle - knee_angle;

rotation_matrix = makehgtform('zrotate', lower_leg_angle);
set(lower_leg,'Matrix',lower_leg_translation_matrix*rotation_matrix);

hand_object = draw_hand;
hand_shape_scaling_matrix = makehgtform('scale',[1, hand_eccentricity_2, hand_eccentricity_1]);
%hand_size_scaling_matrix = makehgtform('scale',animal_size*lower_foreleg_radius*[1 1 1]);
scaled_lower_leg_length = animal_size * lower_foreleg_length; 
translation_along_lower_leg = makehgtform('translate', ...
   scaled_lower_leg_length*[ cos(lower_leg_angle) sin(lower_leg_angle) 0 ]);
translate_forward_part_of_hand_length = makehgtform('translate', ...
   [ -0.3*animal_size*hand_length*hand_eccentricity_1 0 0 ]);

hand_translation_matrix = lower_leg_translation_matrix * ...
                          translation_along_lower_leg * ...
                          translate_forward_part_of_hand_length;
%set(hand_object,'Matrix',hand_translation_matrix*hand_shape_scaling_matrix*hand_size_scaling_matrix);
set(hand_object,'Matrix',hand_translation_matrix*hand_shape_scaling_matrix);


%%% Group the three fore-leg objects together into a single object
fore_leg = hgtransform;
set([upper_foreleg lower_leg hand_object],'Parent',fore_leg);
