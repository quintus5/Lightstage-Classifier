# Lightstage Classifier Toolbox for MATLAB

Copyright (c) 2020 Taihua Wang

This toolbox is associated with the paper "Multiplexed illumination for classifying visually similar objects"
The toolbox includes functions need for optimising lighting patterns for optimum classification result. 

For associated datasets, visit: [here](https://google.com)
For associated work, visit: [here](https://google.com)
## Function list

*PatterSelection.m* includes training loop for optimizing multiplexing patterns.

*FeatExtract.m* sort extracted feature from multiplexed image.

*ImageLoader.m* loads images and convert to 10bit format.

*Column_permutation.m* creates a struct containing every possible permutation of input vector.

*addnoise.m* adds artificial noise to the image based on simulated camera settings.

## Compatibility

**Matlab**: The toolbox was written in MATLAB 2019a, but should be compatible with earlier versions.

**File Formats**: The toolbox works with ".tiff" images, although can be changed to work with any others.

## Contributing / Feedback
For enquiries, please email twan8752 {at} uni dot sydney dot edu dot au

## Acknowledgements
Credit to MATLAB team for build-in functions

## Citing
The appropriate citation is:

<pre>@article{wang2020multiplexed,
  title={Multiplexed Illumination for Classifying Visually Similar Objects},
  author={Taihua Wang and Donald G. Dansereau},
  journal={under review, Computer Vision and Image Understanding ({CVIU})},
  year={2020},
  publisher={Elsevier}
}</pre>


