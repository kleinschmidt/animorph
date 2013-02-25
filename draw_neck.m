function neck_object = draw_neck

global shape_params

animal_size = shape_params(find(strcmp({shape_params.name},'size'))).value;
neck_length = shape_params(find(strcmp({shape_params.name},'neck length'))).value;
neck_radius = shape_params(find(strcmp({shape_params.name},'neck radius'))).value;
neck_taper = shape_params(find(strcmp({shape_params.name},'neck taper'))).value;
head_neck_angle = pi/180*shape_params(find(strcmp({shape_params.name},'head neck ang'))).value;


neck_object = draw_x_cyl_tapered(animal_size*neck_radius*neck_taper, ...
                                 animal_size*neck_radius, animal_size*neck_length);
rotation_matrix = makehgtform('zrotate',-head_neck_angle + pi);
translation_matrix = makehgtform('translate',[ -animal_size*neck_length, 0, 0 ]);
set(neck_object,'Matrix',rotation_matrix*translation_matrix);
