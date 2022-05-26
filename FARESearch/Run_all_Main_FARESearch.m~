%Main function to Run NC RE codes. 


%Below you need to provide a polygon that includes four points parallel to 
%the fault you are targeting. Your polygon should only include four points.
%It would be best to include a large region with a few thousand or more 
%events within it, like the Hayward fault region that was used as an 
%example. The polygon corners could be located inside or outside the 
%Northern California region. The code that divides the region based on 
%seismicity simply grids the region from south to north of the chosen 
%polygon. It would be better not to pick a very wide area in the east-west 
%direction. The area south to the north does not have any effect on the 
%result, however. 
%The order of the points are important too. p1 should be the S_W point
%P2 should be the N_W point
%P3 should be the N_E point
%P4 should be the S_E pont


%example of Hayward fault polygon
Main_poly=[
    
-121.756673 37.186139     %p1

-122.551674 38.100397     %p2

-122.390768 38.172662     %p3

-121.607517 37.30622      %p4

-121.756673 37.186139     %p1

];



%create a main directory for the region specified above
Main_dir = 'Hayward_REs';
mkdir(Main_dir);

%Iris jar file path
Iris_jar_dir = './IRIS-WS-2.0.17.jar';



%sum parameters that needs to be set for the mian heavy lifter function
%below

%minimum stations for RE detections
station_detect=3;
%if there is enough station just consider the first best 6 stations for cc
mean_threshold_number=6;
%if the cc is lower than this so there is a problem(e.g. noise)
max_cc_cut_off=0.7;
%min number for cluster length, if it is larger than that the code will
%break it down
min_num_visuall=1;
%Now if you want to break down the larg cluster you need to define a cutoff
%for breaking them for example 0.1
cutoff_break_cl=0.06;





%max number of stations we want to concider to seach for REs
st_max_num = 40;

%min number of stations to use it in the RE search process
min_station_num = 50;

%cross_correlation threshold for each individual stations,
%the higher the faster that the code would run
%
cc_tr=0.96;




%We read data from earthquake catalogs( in Hypoinverse format) and output 
%it in a Matlab structure that is more user friendly.HypoInverse earthquake
%catalogs are provided for Northern CA on a monthly basis, and the function
%below would loop over all files and create one structure. The files can 
%be downloaded from 
%(https://www.ncedc.org/ftp/pub/catalogs/ncsn/hypoinverse/phase2k/).

phase_dir = './phase2k/'; % the directory contain the hypoinverse phases in a same structure provided in the database

create_Mat_structure_from_phase_inf (phase_dir);
%note that the function does not return any paramters, as the main output
%structures are defined global. Next function would use those global
%structures to ouput sub_grids 



%The function below will gather seismicity information from 1984 to 2020 
%and will ouput sub_grids in the way that each sub_grid would contain 
%~2000 events.

%two hyper parameters needs to be set to define max and min for the range
%event numbers for each sub_grid
ceil_=1600;
floor_ = 700;

[phase_s] = sub_grid_divider(Main_poly,st_max_num,ceil_,floor_);
%%
%
%save([Main_dir,'/phase_s.mat','phase_s']);
%load([Main_dir,'/phase_s.mat']);
%%
%now for each sub_grid we create a folder and ...

FN = length(phase_s); %file number
%%

%loop throuth the sub_grids
parfor i=1:FN
    %create sub_directories
 
    %%
    sub_dir = [Main_dir,'/Grid_',num2str(i)];
    mkdir(sub_dir)
    sub_dir_req = [sub_dir,'/request_catalog'];
    mkdir(sub_dir_req);
    %%
    %loop over the stations and create input files for irisFetch.m
    for st_i=1:st_max_num
        %create input files for IrisFetch_helper_for_NCEDC
        Create_request_files_for_IrisFetch(phase_s(i).ss(1),phase_s(i).all_sta_40{st_i},sub_dir_req)
    end
    %%
    IrisFetch_helper_for_NCEDC(Iris_jar_dir,sub_dir,min_station_num);
    
    %%
    %this part perform the individual station clustering
    Individual_station_event_clustring(sub_dir,cc_tr, min_station_num);
    %%
    
    %final clustering
    [cl_inf,clus_f] = super_cluster_mixing(sub_dir, cc_tr, station_detect, mean_threshold_number,max_cc_cut_off,min_num_visuall,cutoff_break_cl);
    %%
    %final functions
    %function below create the catalog for all REs
    create_RE_catalog(cl_inf,sub_dir);
    %%
    %In order to create catagarzied REs modify and run below function
%      for i  = 1:length(clus_f)
%          [yn]=Catergaraizing_REs(clus_f,cl_inf,i);
%      end
    

end











































