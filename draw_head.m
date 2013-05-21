%%%%%%%%%%%%%%/* HEAD: */
function entire_head = draw_head

global shape_params

animal_size = shape_params(find(strcmp({shape_params.name},'size'))).value;
head_length = shape_params(find(strcmp({shape_params.name},'head length'))).value;
head_eccentricity_1 = shape_params(find(strcmp({shape_params.name},'head ecc1'))).value;
head_eccentricity_2 = shape_params(find(strcmp({shape_params.name},'head ecc2'))).value;
snout_length = shape_params(find(strcmp({shape_params.name},'snout length'))).value;
snout_inset = shape_params(find(strcmp({shape_params.name},'snout inset'))).value;
snout_angle = pi/180 * shape_params(find(strcmp({shape_params.name},'snout ang'))).value;
snout_inset = shape_params(find(strcmp({shape_params.name},'snout inset'))).value;
snout_eccentricity_1 = shape_params(find(strcmp({shape_params.name},'snout ecc1'))).value;
snout_eccentricity_2 = shape_params(find(strcmp({shape_params.name},'snout ecc2'))).value;
ear_length = shape_params(find(strcmp({shape_params.name},'ear length'))).value;
ear_eccentricity_1 = shape_params(find(strcmp({shape_params.name},'ear ecc1'))).value;
ear_eccentricity_2 = shape_params(find(strcmp({shape_params.name},'ear ecc2'))).value;
ear_angle_1 = pi/180 * shape_params(find(strcmp({shape_params.name},'ear ang1'))).value;
ear_angle_2 = pi/180 * shape_params(find(strcmp({shape_params.name},'ear ang2'))).value;
eye_size = shape_params(find(strcmp({shape_params.name},'eye size'))).value;
eye_theta = pi/180 * shape_params(find(strcmp({shape_params.name},'eye theta'))).value;
eye_phi = pi/180 * shape_params(find(strcmp({shape_params.name},'eye phi'))).value;

head_size = animal_size * head_length;
s2 = sqrt(2)/2;
%  /* head */

head_object = draw_sph_pure_matlab(animal_size * head_length);
scaling_matrix = makehgtform('scale',[1, head_eccentricity_1, head_eccentricity_2]);
set(head_object,'Matrix',scaling_matrix);
%  /* snout */
snout = draw_sph_pure_matlab(animal_size * snout_length);
snout_translation_matrix = makehgtform('translate', ...
   [ snout_inset*animal_size * head_length*cos(snout_angle), ...
     -snout_inset*animal_size * head_length*sin(snout_angle), 0 ]);
snout_rotation_matrix = makehgtform('zrotate',-snout_angle);
snout_scaling_matrix = makehgtform('scale',[1, snout_eccentricity_1, snout_eccentricity_2]);
Tsnout = snout_translation_matrix * snout_rotation_matrix * snout_scaling_matrix;
set(snout,'Matrix', Tsnout );
%  /* ears */
left_ear = draw_sph_pure_matlab(animal_size * ear_length);
rotation_matrix_1 = makehgtform('zrotate',ear_angle_1);
rotation_matrix_2 = makehgtform('xrotate',ear_angle_2);
translation_matrix = makehgtform('translate', ...
   [0.35*animal_size*head_length, s2*animal_size*head_length*head_eccentricity_1, s2*animal_size*head_length*head_eccentricity_2 ]);
scaling_matrix = makehgtform('scale',[1, ear_eccentricity_1, ear_eccentricity_2]);
set(left_ear,'Matrix',rotation_matrix_2*rotation_matrix_1*translation_matrix*scaling_matrix);
right_ear = draw_sph_pure_matlab(animal_size * ear_length);
rotation_matrix_2 = makehgtform('xrotate',-ear_angle_2);
translation_matrix = makehgtform('translate', ...
   [0.35*animal_size*head_length, s2*animal_size*head_length*head_eccentricity_1, -s2*animal_size*head_length*head_eccentricity_2 ]);
set(right_ear,'Matrix',rotation_matrix_2*rotation_matrix_1*translation_matrix*scaling_matrix);

%  /* eyes */

% adjust eye location based on snout %%%%%%%%%%%%%%%%%%%%%%%%%%
% get coordinates of eye location in snout frame (adjusting for
% translation, rotation, and scaling, so snout appears as a sphere with
% radius animal_size * snout_length)
function new_location = fix_eyes_snout(eye_location)
    xyz_snout_frame = Tsnout^-1 * [eye_location, 1]';
    xyz_snout_dist = sqrt(sum((xyz_snout_frame(1:3)).^2));
    if xyz_snout_dist < animal_size * snout_length
        % eye is inside snout, so move in y direction (towards top of snout)
        xyz_snout_frame(2) = ...
            sqrt((animal_size * snout_length)^2 - ...
            xyz_snout_frame(1)^2 - xyz_snout_frame(3)^2);
        new_location = Tsnout * xyz_snout_frame;
        new_location = new_location(1:3);
    else
        new_location = eye_location;
    end 
end

% left eye
[X,Y,Z] = sphere;
left_eye_sphere = surf(X, Y, Z);
set(left_eye_sphere,'EdgeAlpha', 0, 'FaceColor', [0 0 0]);
left_eye = hgtransform;
set(left_eye_sphere,'Parent',left_eye);

left_eye_location = fix_eyes_snout(...
    [ head_size*cos(eye_theta)*sin(eye_phi), ...
    head_eccentricity_1*head_size*cos(eye_theta)*cos(eye_phi), ...
    head_eccentricity_2*head_size*sin(eye_theta) ]);
translation_matrix = makehgtform('translate', left_eye_location);

scaling_matrix = makehgtform('scale',(animal_size * eye_size)*[1 1 1]);
set(left_eye,'Matrix',translation_matrix*scaling_matrix);

% right eye
right_eye_sphere = surf(X, Y, Z);
set(right_eye_sphere,'EdgeAlpha', 0, 'FaceColor', [0 0 0]);
right_eye = hgtransform;
set(right_eye_sphere,'Parent',right_eye);

right_eye_location = fix_eyes_snout(...
    [ head_size*cos(eye_theta)*sin(eye_phi), ...
    head_eccentricity_1*head_size*cos(eye_theta)*cos(eye_phi), ...
    -head_eccentricity_2*head_size*sin(eye_theta) ]);

translation_matrix = makehgtform('translate', right_eye_location);
set(right_eye,'Matrix',translation_matrix*scaling_matrix); 

%%% Group all the head surfaces together into a single object
entire_head = hgtransform;
set([head_object left_eye right_eye left_ear right_ear snout],'Parent',entire_head);

%%% Rotate the whole head by 180deg
%glRotatef(180.0, 0.0, 0.0, 1.0);
rotation_matrix = makehgtform('yrotate',pi);
set(entire_head,'Matrix',rotation_matrix);

end