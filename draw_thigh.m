% THIGH
function thigh = draw_thigh

global shape_params

animal_size = shape_params(find(strcmp({shape_params.name},'size'))).value;
thigh_length = shape_params(find(strcmp({shape_params.name},'thigh length'))).value;
thigh_radius = shape_params(find(strcmp({shape_params.name},'thigh radius'))).value;
thigh_taper = shape_params(find(strcmp({shape_params.name},'thigh taper'))).value;
alpha = shape_params(find(strcmp({shape_params.name},'alpha'))).value;

scaled_thigh_length = animal_size * thigh_length; 
r1 = animal_size * thigh_radius; 
r2 = animal_size * thigh_radius * thigh_taper;
bulge_or_waist_factor = 0.2*abs(alpha - 0.5)/0.5;

thigh_sphere = draw_sph_pure_matlab(r1);

thigh_geon = draw_geon_pure_matlab(2, r1, r2, bulge_or_waist_factor, scaled_thigh_length);

%%% Group the two thigh objects together into a single object
thigh = hgtransform;
set([thigh_geon thigh_sphere],'Parent',thigh);
