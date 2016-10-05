# Animal Morph

This provides matlab functions to generate 3D renderings of "animals" based on a
parametric model of body part size, location, and orientation.

## Interface

Animals are defined by a parameter struct, which can be passed to most functions
or set as a global variable (`shape_params`). This is defined in
`shape_params_struct_def.m`, or see the files in `animals/` for examples.

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
