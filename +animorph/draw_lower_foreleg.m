%%%%%%%% LOWER_FORELEG
function lower_foreleg = draw_lower_foreleg
import animorph.*;

global shape_params

animal_size = shape_params(find(strcmp({shape_params.name},'size'))).value;
lower_foreleg_radius = shape_params(find(strcmp({shape_params.name},'lo fr leg radius'))).value;
lower_foreleg_length = shape_params(find(strcmp({shape_params.name},'lo fr leg length'))).value;
lower_foreleg_taper = shape_params(find(strcmp({shape_params.name},'lo fr leg taper'))).value;
alpha = shape_params(find(strcmp({shape_params.name},'alpha'))).value;

scaled_lower_foreleg_length = animal_size * lower_foreleg_length; 
r1 = animal_size * lower_foreleg_radius; 
r2 = animal_size * lower_foreleg_radius * lower_foreleg_taper;
bulge_or_waist_factor = 0.25*abs(alpha - 0.5)/0.5;

sphere_object = draw_sph_pure_matlab(r1);

tapered_cylinder = draw_x_cyl_tapered(r1, r2, scaled_lower_foreleg_length);

%%% Group the two leg objects together into a single object
lower_foreleg = hgtransform;
set([sphere_object tapered_cylinder],'Parent',lower_foreleg);
 

