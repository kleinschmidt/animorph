% /* HAND, i.e. front foot */
function hand_object = draw_hand

global surface_colour
global shape_params

animal_size = shape_params(find(strcmp({shape_params.name},'size'))).value;
hand_length = shape_params(find(strcmp({shape_params.name},'hand length'))).value;

hand_object = draw_sph_pure_matlab(animal_size * hand_length);


