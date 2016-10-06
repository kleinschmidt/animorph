# Animal Morph

This provides matlab functions to generate 3D renderings of "animals" based on a
parametric model of body part size, location, and orientation.

## Installation

Clone this repository and add it to your Matlab path. Then import the [package
namespace](https://www.mathworks.com/help/matlab/matlab_oop/scoping-classes-with-packages.html) 
where you want to use the package, or use qualified names:

```matlab
cd ~/code                       % for example
!git clone https://github.com/kleinschmidt/animorph.git
cd animorph

% optionally, add to path:
addpath(pwd);

load('examples/dog.mat');

% with namespace reference:
animorph.make_animal(shape_params);

% with import:
import animorph.*;
make_animal(shape_params)
```

## Documentation

Help is available through the standard matlab `help`. To view a summary of all
the documented functions that are provided by the package:

```matlab
help animorph
```
```
Contents of animorph:

animal_parameter_sliders_gui   - Launch GUI to generate animals based on parameter values set via sliders
assemble_tiles                 - Assemble a cell array of individual images into a single image, and plot
draw_geon_pure_matlab          - Draw a generalized cylinder
grab_animal_im                 - Capture contents of figure as image CDATA.
make_animal                    - Draw an animal based on parameters and (optionally) view factors
make_animal_array              - Visualize 2D array of animals, specifying origin and two directions.
morph_between_two_animals_gui  - GUI for morphing between two animals, from parameter structs loaded from
normalized_param_vector_to_struct - Convert param values in [0,1] to struct with actual ranges.
normalized_param_vector_to_vector - Convert param values in [0,1] to vector with actual ranges.
opengl_cdata                   - Get CDATA from hardcopy using opengl
param_struct_to_vector         - Extract parameter values, names, and ranges from struct
param_vector_to_normalized_vector - Convert parameters to normalized values in [0,1] based on range
param_vector_to_struct         - Convert vector of params to struct (suitable for drawing)
xy_to_animal_image             - Generate image for animal based on cartesian coordinates in animal space
```

To get the documentation for an individual function:

```matlab
help animorph.make_animal
```
```
  Draw an animal based on parameters and (optionally) view factors
  
  function make_animal(params, color, fig_h, rotation, zoom_factor)
  
  Input:
    params: A parameter struct (see shape_params_struct_def.m).
    color: RGB vector in [0,1] (optional, defaults to global value, then
      [1 0.65 0.1]).
    fig_h: Handle of figure to draw to (optional, defaults to 1)
    rotation: Rotation about z and y axes. (Optional, defaults to 0)
    zoom_factor: Optional, default is 1.8 (trims off dead space around animal
      in default view).
  Output:
    none.
  Side effect: 
    Image is drawn to fig_h. Use grab_animal_im to capture image in CDATA array.
```

## Interface

Animals are defined by a parameter struct, which can be passed to most functions
or set as a global variable (`shape_params`). This is defined in
`shape_params_struct_def.m`, or see the files in `examples/` for examples.

The main functions are `make_animal`, which draws a param struct to a Matlab
figure, and `grab_animal_im` which capturse the image as a CDATA array of RGB
values. 

If you want to interpolate between animals in a linear subspace, you can use
`xy_to_animal_image`. This function takes cartesian coordinates, origin
parameters, and basis vectors (in terms of offsets from the origin), draws the
animal from the resulting parameters, and grabs the image.

To interpolate between parameters manually, you should convert the structs to a
numeric vector using `param_struct_to_vector()`, do the interpolation, and
convert back to a struct with `param_vector_to_struct()`.

## Low-level drawing

The drawing commands place individual body parts in a hierarchical way, starting
from `make_animal`. The lowest level functions
(`draw_(geon|sphere)_pure_matlab`) produce spheres and (tapered) cylinders,
which are transformed to change their shape, size, and orientation by the higher
level functions. 

These all (except the sphere/geon functions) use the __global__ `shape_params`
variable, so be sure this is set the way you want if you're going to use
lower-level drawing functions directly.

# Contributors

* [Shimon Edelman](http://kybele.psych.cornell.edu/~edelman/) wrote the original OpenGL code
* [Rajeev Raizada](http://raizadalab.org/) initially adapted for Matlab. 
* [Dave Kleinschmidt](http://github.com/kleinschmidt) further adapted and wrote the high-level interfaces.
