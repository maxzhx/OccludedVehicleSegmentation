Occluded Vehicle Detection and Segmentation Algorithm Based on Morphological Operator
======================

The rapid development of modern automobile industry promoted the development of road traffic and increased the number of cars. A large variety of road traffic problems occurred result in the explode of car’s number, which promote the birth of ITS (Intelligent Transportation Systems). Video vehicle detection is an important research of ITS. In actual traffic surveillance video, since the angle between the optical axis of the camera and road surface is small, captured vehicles tend to overlap each othes, which will casue adhesion in detected image. Therefore, occluded vehicle detection and segmentation is an important part of the video vehicle detection research. 


Occluded vehicle detection and segmentation algorithm research can be divided into three directions basically: first, based on the video stream; second,  based on image morphology; third, based on vehicle and scenario modeling. Therein, the algorithm based on morphology has become the focus of research at both domestic and abroad in recent years, due to its relatively high accuracy and efficiency. This paper’s main direction will also be the algorithm based on morphology.


The main work of this paper:

 1. Dividing the concavity image into several connected regions, by corrosion;

 2. Determining each connected region, and detect adhesion;

 3. Find the dividing line by morphological methods.


This algorithm is tested in Matlab environment by all types of adhesions images extracted from the actual surveillance video. The results prove that this algorithm has high robustness, and has a high detection efficiency against various adhesions.	


In the following work, the main problems to be solved include: complete adhesion vehicles that have no concavity; self-concavity vehicles; retain vehicle integrity after segmentation.


Key words: **Occluded Vehicle**; **Morphological Operator**; **Corrosion**

