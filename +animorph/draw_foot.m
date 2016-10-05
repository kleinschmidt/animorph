% /* FOOT */
function foot_object = draw_foot
import animorph.*;

global surface_colour
global shape_params

animal_size = shape_params(find(strcmp({shape_params.name},'size'))).value;
foot_length = shape_params(find(strcmp({shape_params.name},'foot length'))).value;

foot_object = draw_sph_pure_matlab(animal_size * foot_length);


