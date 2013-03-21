function animal_parameter_sliders_gui

global surface_colour
global shape_params
global gui_params

%%% Close all figures
close all;
%%% Read in a set of saved animal parameters
figure(1);
set(gcf,'Position',[50 500 560 420]);
cameratoolbar('Show');
shape_params_struct_def;
gui_params_struct_def;
load animals/dog.mat  %%% Start off with the dog loaded
%make_animal_using_global_params;
make_animal(shape_params);

fig2 = figure(2);
set(gcf,'Position',[650 500 560 420]);

num_sliders = length(shape_params)-1;
slider_handles = zeros(num_sliders,1);
textlabel_handles = zeros(num_sliders,1);
num_rows = 18;
num_cols = 3;

col_to_col_gap = gui_params.intercol_gap + gui_params.slider_length;

for slider_num = 1:num_sliders,
   col_num = ceil(slider_num/num_rows);
   row_num = mod((slider_num-1),num_rows) + 1;

   slider_rect = [ gui_params.left_col_left 0 0 0 ] + ...
      [ 0 0 gui_params.slider_length gui_params.slider_height ] + ...
      [ (col_num-1)*col_to_col_gap 0 0 0 ] + ...
      [ 0 gui_params.top_slider_y 0 0 ] - ...
      [ 0 (row_num-1)*gui_params.interslider_vertical_gap 0 0 ];

   textlabel_rect = slider_rect - ...
      [ 0 0 gui_params.slider_length gui_params.slider_height ] + ...
      [ 0 gui_params.slider_height gui_params.textbox_length gui_params.textbox_height ];

   slider_handles(slider_num) = uicontrol('Parent',fig2,'Style','slider', ...
      'Units','Normalized','Position',slider_rect, ...
      'Min',shape_params(slider_num).range(1),'Max',shape_params(slider_num).range(2), ...
      'SliderStep',[0.05 0.1], 'Tag', shape_params(slider_num).name, ...
      'Value', shape_params(slider_num).value, ...
      'Callback',@get_value);

   textlabel_handles(slider_num) = uicontrol('Parent',fig2,'Style','text', ...
      'Units','Normalized','Position',textlabel_rect,'FontSize',8, ...
      'String',shape_params(slider_num).name);

   update_slider_value_text(slider_num);
end;

%%%% Draw the load and save buttons
load_button = uicontrol('Parent',fig2,'Style','pushbutton', ...
   'Units','Normalized','Position',[0.9 0.6 0.07 0.05], ...
   'String', 'Load', ...
   'Callback',@load_params);

save_button = uicontrol('Parent',fig2,'Style','pushbutton', ...
   'Units','Normalized','Position',[0.9 0.5 0.07 0.05], ...
   'String', 'Save', ...
   'Callback',@save_params);

end


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function update_slider_value_text(slider_num)
global shape_params gui_params

num_sliders = length(shape_params)-1;
valuetext_handles = zeros(num_sliders,1);
num_rows = 18;
num_cols = 3;

col_num = ceil(slider_num/num_rows);
row_num = mod((slider_num-1),num_rows) + 1;
col_to_col_gap = gui_params.intercol_gap + gui_params.slider_length;

slider_rect = [ gui_params.left_col_left 0 0 0 ] + ...
   [ 0 0 gui_params.slider_length gui_params.slider_height ] + ...
   [ (col_num-1)*col_to_col_gap 0 0 0 ] + ...
   [ 0 gui_params.top_slider_y 0 0 ] - ...
   [ 0 (row_num-1)*gui_params.interslider_vertical_gap 0 0 ];

textlabel_rect = slider_rect - ...
   [ 0 0 gui_params.slider_length gui_params.slider_height ] + ...
   [ 0 gui_params.slider_height gui_params.textbox_length gui_params.textbox_height ];

valuetext_rect = textlabel_rect + [ gui_params.textbox_length 0 0 0 ];

valuetext_handles(slider_num) = uicontrol('Style','text', ...
   'Units','Normalized','Position', valuetext_rect, 'FontSize',8, ...
   'String',num2str(shape_params(slider_num).value));

end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function get_value(src,eventdata)
global shape_params gui_params
val = get(src,'Value');
tag = get(src,'Tag');

num_sliders = length(shape_params)-1;

for slider_num = 1:num_sliders,
   if strcmp(tag,shape_params(slider_num).name),
      shape_params(slider_num).value = val;
      update_slider_value_text(slider_num);
   end;
end;

%make_animal_using_global_params;
make_animal(shape_params);

end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function save_params(src,eventdata)
global shape_params
file_name_cell = inputdlg('Filename of shape params file to save');
file_name_string = file_name_cell{1};
save(file_name_string,'shape_params');
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function load_params(src,eventdata)
global shape_params
[filename,pathname] = uigetfile('*.mat','Select the shape params file to load');
load([pathname filename]);
%make_animal_using_global_params;
make_animal(shape_params);
end

