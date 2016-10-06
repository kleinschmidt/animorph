function sphere_object = draw_sph_pure_matlab(radius)
import animorph.*;

global surface_colour;

hold on;
[ X, Y, Z ] = sphere;
surf_handle = surf(radius*X, radius*Y, radius*Z);
sphere_object = hgtransform;
set(surf_handle,'Parent',sphere_object);

set(surf_handle,'EdgeAlpha', 0, 'FaceColor', surface_colour);
