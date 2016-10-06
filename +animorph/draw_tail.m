function tail_object = draw_tail
import animorph.*;

global shape_params

animal_size = shape_params(find(strcmp({shape_params.name},'size'))).value;
tail_radius = shape_params(find(strcmp({shape_params.name},'tail radius'))).value;
tail_length = shape_params(find(strcmp({shape_params.name},'tail length'))).value;
tail_taper = shape_params(find(strcmp({shape_params.name},'tail taper'))).value;

tail_object = draw_x_cyl_tapered(animal_size*tail_radius, ...
                                 animal_size*tail_radius*tail_taper, ...
                                 animal_size*tail_length);
