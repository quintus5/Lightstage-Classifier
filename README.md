# Lightstage Classifier Source code for MATLAB

Copyright (c) 2020 Taihua Wang

This source code is associated with the paper "Multiplexed illumination for classifying visually similar objects". 
It includes functions needed for optimising multipelxed lighting patterns for optimum classification result. 

For associated work and datasets, visit: [here](https://roboticimaging.org/Projects/LSClassifier/)

## Function list

*PatterSelection.m* includes training loop for optimizing multiplexing patterns.

*FeatExtract.m* sort extracted feature from multiplexed image.

*ImageLoader.m* loads images from file.

*Column_permutation.m* creates a struct containing every possible permutation of input vector.

*addnoise.m* adds artificial noise to the image based on simulated camera settings.

## Compatibility

**Matlab**: The code was written in MATLAB 2019a, but should be compatible with earlier versions.

**File Formats**: The code works with ".tiff" images, although can be changed to work with any others.

## Contributing / Feedback
For enquiries, please email twan8752 {at} uni dot sydney dot edu dot au

## Acknowledgements
Credit to D.G.Dansereau at [Robotic Imaging at the University of Sydney](https://roboticimaging.org/) for supervising this project.

## Citing
Please cite the following article if you find this source code useful:

```bibtex
@article{wang2021multiplexed,
  title={Multiplexed Illumination for Classifying Visually Similar Objects},
  author={Taihua Wang and Donald G. Dansereau},
  journal={Applied Optics},
  URL = {https://roboticimaging.org/Papers/wang2021multiplexed.pdf},  
  year={2021},
  month = {Apr},
  volume = {60},
  number = {10},
  pages = {B23--B31},
  publisher={OSA}
}





