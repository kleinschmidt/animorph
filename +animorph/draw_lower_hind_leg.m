function lower_hind_leg = draw_lower_hind_leg
import animorph.*;

global shape_params

animal_size = shape_params(find(strcmp({shape_params.name},'size'))).value;
lower_hind_leg_radius = shape_params(find(strcmp({shape_params.name},'leg radius'))).value;
lower_hind_leg_length = shape_params(find(strcmp({shape_params.name},'leg length'))).value;
lower_hind_leg_taper = shape_params(find(strcmp({shape_params.name},'leg taper'))).value;


scaled_lower_hind_leg_length = animal_size * lower_hind_leg_length; 
r1 = animal_size * lower_hind_leg_radius; 
r2 = animal_size * lower_hind_leg_radius * lower_hind_leg_taper;

sphere_object = draw_sph_pure_matlab(r1);

tapered_cylinder = draw_x_cyl_tapered(r1, r2, scaled_lower_hind_leg_length);

%%% Group the two leg objects together into a single object
lower_hind_leg = hgtransform;
set([sphere_object tapered_cylinder],'Parent',lower_hind_leg);
 