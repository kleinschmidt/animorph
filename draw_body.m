% /*
%   BODY is two ellipsoids: chest and abdomen.
%   */
function entire_body = draw_body

global shape_params

animal_size = shape_params(find(strcmp({shape_params.name},'size'))).value;
abdomen_length = shape_params(find(strcmp({shape_params.name},'abd length'))).value;
abdomen_ecc = shape_params(find(strcmp({shape_params.name},'abd ecc'))).value;
chest_length = shape_params(find(strcmp({shape_params.name},'chest length'))).value;
chest_abdomen_angle = pi/180*shape_params(find(strcmp({shape_params.name},'chest abd ang'))).value;
chest_ecc = shape_params(find(strcmp({shape_params.name},'chest ecc'))).value;
alpha = shape_params(find(strcmp({shape_params.name},'alpha'))).value;

r_abd = animal_size * chest_length*abdomen_ecc;
r_chest = animal_size * chest_length*chest_ecc;
bulge_or_waist_factor = 0.2*abs(alpha - 0.5)/0.5;

chest_object1 = draw_sph_pure_matlab(animal_size * chest_length * chest_ecc);
chest_object2 = draw_geon_pure_matlab(2, r_chest*0.99, r_abd, bulge_or_waist_factor, animal_size*chest_length*1.05);

abdomen = draw_geon_pure_matlab(1, r_abd, r_abd, bulge_or_waist_factor, animal_size*abdomen_length);
translation_matrix = makehgtform('translate', [ animal_size*chest_length, 0, 0 ]);
rotation_matrix = makehgtform('zrotate', chest_abdomen_angle);
set(abdomen,'Matrix',translation_matrix*rotation_matrix);

body_object = draw_sph_pure_matlab(r_abd);
body_translation = animal_size*chest_length*[1 0 0] + ...
    animal_size*abdomen_length * [cos(chest_abdomen_angle) sin(chest_abdomen_angle) 0];
translation_matrix = makehgtform('translate', body_translation);
set(body_object,'Matrix',translation_matrix);

%%% Group all the body surfaces together into a single object
entire_body = hgtransform;
set([chest_object1 chest_object2 abdomen body_object],'Parent',entire_body);