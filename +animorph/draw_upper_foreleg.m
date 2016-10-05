function upper_foreleg = draw_upper_foreleg
import animorph.*;

global shape_params

animal_size = shape_params(find(strcmp({shape_params.name},'size'))).value;
upper_foreleg_radius = shape_params(find(strcmp({shape_params.name},'up fr leg radius'))).value;
upper_foreleg_length = shape_params(find(strcmp({shape_params.name},'up fr leg length'))).value;
upper_foreleg_taper = shape_params(find(strcmp({shape_params.name},'up fr leg taper'))).value;
alpha = shape_params(find(strcmp({shape_params.name},'alpha'))).value;

scaled_upper_foreleg_length = animal_size * upper_foreleg_length; 
r1 = animal_size * upper_foreleg_radius; 
r2 = animal_size * upper_foreleg_radius * upper_foreleg_taper;
bulge_or_waist_factor = 0.25*abs(alpha - 0.5)/0.5;

shoulder_sphere = draw_sph_pure_matlab(r1);

upper_foreleg_geon = draw_geon_pure_matlab(2, r1, r2, bulge_or_waist_factor, scaled_upper_foreleg_length);

%%% Group the two foreleg objects together into a single object
upper_foreleg = hgtransform;
set([shoulder_sphere upper_foreleg_geon],'Parent',upper_foreleg);
