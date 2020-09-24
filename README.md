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
Credit to [D.G.Dansereau](https://dgd.vision/) for supervising this project.

## Citing
Please cite the following article if you find this source code useful:

```bibtex
@article{wang2020multiplexed_arxiv,
  title = {Multiplexed Illumination for Classifying Visually Similar Objects},
  author = {Taihua Wang and Donald G. Dansereau},
  journal = {arXiv preprint arXiv:2009.11084},
  year = {2020},
  month = sep
}




