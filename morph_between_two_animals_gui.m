function morph_between_two_animals_gui

global surface_colour
global shape_params params1 animal1_name params2 animal2_name lambda
global gui_params

%%% Close all figures
close all;
%%% Read in a set of saved animal parameters
figure(1);
set(gcf,'Position',[50 500 560 420]);
cameratoolbar('Show');
shape_params_struct_def;
gui_params_struct_def;
%%% Start off with the dog and the monkey as animals 1 and 2
animal1_name = 'dog';
load dog.mat  
params1 = shape_params;
animal2_name = 'monkey';
load monkey.mat
params2 = shape_params;

%%% Start off with pure animal 1
lambda = 0;
for param_num = 1:length(shape_params);
   shape_params(param_num).value = ...
      (1-lambda)*params1(param_num).value + lambda*params2(param_num).value;
end;
make_animal(shape_params);

fig2 = figure(2);
set(gcf,'Position',[650 500 560 420]);

slider_handle = uicontrol('Parent',fig2,'Style','slider', ...
      'Units','Normalized','Position',[ 0.1 0.5 0.8 0.05 ], ...
      'Min',0,'Max',1, ...
      'SliderStep',[0.05 0.1], ...
      'Value', 0, ...
      'Callback',@get_value);

textlabel_handle1 = uicontrol('Parent',fig2,'Style','text', ...
      'Units','Normalized','Position',[0.1 0.55 0.2 0.05], ...
      'String',animal1_name);
   
textlabel_handle2 = uicontrol('Parent',fig2,'Style','text', ...
      'Units','Normalized','Position',[0.7 0.55 0.2 0.05], ...
      'String',animal2_name);   
   
%%%% Draw the load and save buttons
load_button1 = uicontrol('Parent',fig2,'Style','pushbutton', ...
   'Units','Normalized','Position',[0.1 0.45 0.2 0.05], ...
   'String', 'Load animal 1', ...
   'Callback',@load_animal1);

load_button2 = uicontrol('Parent',fig2,'Style','pushbutton', ...
   'Units','Normalized','Position',[0.7 0.45 0.2 0.05], ...
   'String', 'Load animal 2', ...
   'Callback',@load_animal2);

save_button = uicontrol('Parent',fig2,'Style','pushbutton', ...
   'Units','Normalized','Position',[0.46 0.2 0.07 0.05], ...
   'String', 'Save', ...
   'Callback',@save_params);

end


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function get_value(src,eventdata)
global shape_params params1 params2 lambda
lambda = get(src,'Value');
tag = get(src,'Tag');

for param_num = 1:length(shape_params);
   shape_params(param_num).value = ...
      (1-lambda)*params1(param_num).value + lambda*params2(param_num).value;
end;
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
function load_animal1(src,eventdata)
global shape_params params1 params2 animal1_name lambda
[animal1_name,pathname] = uigetfile('*.mat','Select the shape params file to load');
load(animal1_name);
params1 = shape_params;
update_text_labels;
for param_num = 1:length(shape_params);
   shape_params(param_num).value = ...
      (1-lambda)*params1(param_num).value + lambda*params2(param_num).value;
end;
make_animal(shape_params);
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function load_animal2(src,eventdata)
global shape_params params1 params2 animal2_name lambda
[animal2_name,pathname] = uigetfile('*.mat','Select the shape params file to load');
load(animal2_name);
update_text_labels;
params2 = shape_params;
for param_num = 1:length(shape_params);
   shape_params(param_num).value = ...
      (1-lambda)*params1(param_num).value + lambda*params2(param_num).value;
end;
make_animal(shape_params);
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function update_text_labels
global animal1_name animal2_name

textlabel_handle1 = uicontrol('Style','text', ...
      'Units','Normalized','Position',[0.1 0.55 0.2 0.05], ...
      'String',animal1_name);
   
textlabel_handle2 = uicontrol('Style','text', ...
      'Units','Normalized','Position',[0.7 0.55 0.2 0.05], ...
      'String',animal2_name);  

end