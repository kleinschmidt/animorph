% %/*
%   TAPERED CYLINDER
%   A quadrilateral-strip linearly-tapered cylinder that
%   starts at (0,0,0) with radius r1, ends at (geon_length,0,0) with
%   radius r2.
%   */

%%% Note: Shimon's cylinder function draws in the direction of the x-axis,
%%% but the built-in Matlab cylinder function draws along the z-axis.
%%% Therefore, we need to rotate this cylinder, to make it compatible
%%% with all the other functions that use it (leg-drawing, etc.)

function tapered_cylinder = draw_x_cyl_tapered(radius_1, radius_2, geon_length)
import animorph.*;

global surface_colour;

hold on;

%/* Draw the front lid: */
if (radius_1 > 0),
   [X Y Z] = sphere;
   front_lid = surf(zeros(size(X)), radius_1*Y, radius_1*Z);
   set(front_lid,'EdgeAlpha', 0, 'FaceColor', surface_colour);
end;

%/* Draw the cylinder */
profile_line = [ radius_1 radius_2 ];
[ X Y Z ] = cylinder(profile_line);
%%% We swap the Z and X directions, to be consistent with Shimon's cylinder
%%% direction.
main_cylinder = surf(geon_length*Z,Y,X);
set(main_cylinder,'EdgeAlpha', 0, 'FaceColor', surface_colour);
 
%/* Draw the back lid: */
if (radius_2 > 0),
   [X Y Z] = sphere;
   back_lid = surf(geon_length*ones(size(X)), radius_2*Y, radius_2*Z);
   set(back_lid,'EdgeAlpha', 0, 'FaceColor', surface_colour);
end;

%%% Group the three surfaces together into a single object
tapered_cylinder = hgtransform;
set([front_lid main_cylinder back_lid],'Parent',tapered_cylinder);
   

