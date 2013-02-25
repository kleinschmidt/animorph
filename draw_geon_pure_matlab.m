
% %/*
%   GENERALIZED CYLINDER
%   should return coordinates of endpo(determined by axis shape).
%   Parameters/values:
%   taper: taper_function, r1, r2 (if function=const, there is no taper), bulge_or_waist_factor;
%   axis: dy, dz (if both 0, the axis is straight);
%   cross-section: n_edges (if large, a circle, otherwise a polygon)
%   */

%%% Note: Shimon's cylinder function draws in the direction of the x-axis,
%%% but the built-in Matlab cylinder function draws along the z-axis.
%%% Therefore, we need to rotate this cylinder, to make it compatible
%%% with all the other functions that use it (leg-drawing, etc.)

function geon_object = ...
   draw_geon_pure_matlab(taper_function, ... %%/* 1 for const, 2 for waist, 3 for bulge */
   radius_1, ...
   radius_2, ...
   bulge_or_waist_factor, ...
   geon_length)

global surface_colour;

hold on;

%/* Draw the front lid: */
if (radius_1 > 0),
   [X Y Z] = sphere;
   front_lid = surf(zeros(size(X)), radius_1*Y, radius_1*Z);
   set(front_lid,'EdgeAlpha', 0, 'FaceColor', surface_colour);
end;

%/* Draw the cylinder */
%%% Note from Raj: the taper function seems to be back-to-front. Let's try
%%% swapping 2 and 3, for bulge vs. waist
num_steps = 20;
   switch (taper_function)
      case 1
         parabola_fit = [ radius_1 radius_2 ];
      case 3
         profile_points_to_fit = [ radius_1 (1-bulge_or_waist_factor)*mean([radius_1 radius_2]) radius_2 ];
         parabola_fit_coeffs = polyfit([1:3],profile_points_to_fit,2);
         parabola_fit = polyval(parabola_fit_coeffs,linspace(1,3,num_steps));
      case 2
         profile_points_to_fit = [ radius_1 (1+bulge_or_waist_factor)*mean([radius_1 radius_2]) radius_2 ];
         parabola_fit_coeffs = polyfit([1:3],profile_points_to_fit,2);
         parabola_fit = polyval(parabola_fit_coeffs,linspace(1,3,num_steps));
   end;
   [ X Y Z ] = cylinder(parabola_fit);
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
geon_object = hgtransform;
set([front_lid main_cylinder back_lid],'Parent',geon_object);
   

