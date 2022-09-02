# FARESearch
Fully Automated Repeating Earthquake Search code 
FARESearch divides the area of interest into small, ‘sub-grid’ cells, downloads phase information for the events in those cells, and from that information, selects stations and data for download. Repeating earthquake (RE) detection uses our ‘multicluster detection’ strategy (Shakibay Senobari and Funning, 2019) in which families of REs are identified on the basis of pairwise similarity at common stations and through the application of  a hierarchical clustering algorithm.

In order to run the code, read and run Run_all_Main_FARESearch.m code.

For more information regarding the algorithm please read:
Shakibay Senobari, Nader, and Gareth J. Funning. 
"Widespread fault creep in the northern San Francisco Bay Area revealed by multistation cluster detection of repeating earthquakes." 
Geophysical Research Letters 46, no. 12 (2019): 6425-6434.

We gratefully acknowledge funding from NSF 2103976.
