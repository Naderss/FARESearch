%%
function [sub_grid_phases] = sub_grid_divider(XY_cor,st_max_num,ceil_,floor_);

%NC_in and NC_phase_all are defined globaly in the create_Mat_structure_from_phase_inf 


%
%a function that find events inside the XY_polygon, devide it into sub_grids and
%produce phase information for retreiving data for each sub_grid:
%input: 
%NC_phase_all: Phase information from all events in NC 
%NC_in:  The index for each event from in NC_phase_all 
%Note that these two vaiables produced globally in 
%create_Mat_structure_phase_inf.m function

%XY_cor: cordinates for the taregeted polygon
%st_max_num: the max number of stations that are concidering to search for
%REs
%Output: 
%ss: phase information only for events inside the polygon
%all_sta_40: station names with the most repeated time in the ss 
%

%x and y cordinates from the polygon
x_poly=XY_cor(:,1);
y_poly=XY_cor(:,2);
% lets cut catalog inf into small pieces
%%
[in_all,on_all] = inpolygon(NC_in.lon,NC_in.lat,x_poly,y_poly);
st_ind_all = NC_in.start_ind(in_all);
end_ind_all = NC_in.end_ind(in_all);
ss{1}{1}='x';


for i= 1:length(st_ind_all)
        ind1_text = st_ind_all(i);
        ind2_text = end_ind_all(i);
        for ll=ind1_text:ind2_text
            ss{1}{length(ss{1})+1}=NC_phase_all{ll};
        end
       
end
%
ss{1}(1)=[];

%keep NC_in_inp for 

%now we just keep events inside the big polygon

NC_phase_all_inp = ss;
clear ss 
NC_in_inp.evID = NC_in.evID(in_all);
NC_in_inp.lon = NC_in.lon(in_all);
NC_in_inp.lat = NC_in.lat(in_all);
NC_in_inp.start_ind = NC_in.start_ind(in_all);
NC_in_inp.end_ind = NC_in.end_ind(in_all);


%now lets slice it
xv = x_poly;
yv = y_poly;

%number of events
ev_num = length(NC_in_inp.evID);

num_sl = 0; %number of slices

%The part below need to be improved in order to account for the overlapes 
%bentween the bundries.The reason is becuase the EQs location are not 
%accurate and there might be some RE family member located in a neightbering grid.
%this can be updated later as the cases could be rare!

ev_num_t_T = 0;

while ev_num - ev_num_t_T>10
    %%
    num_sl = num_sl +1;
    
    %now the test is to find k such as the length(NC_in_inp.evID(in)) fall
    %between 2000 to 2500
    
    
    T =1; %the variable that indicates when to move to the next slice 
    k =2; %We cut the area by 1/k to see how many events are inside slice
    
    
    while T ==1   
        %%
        
        x_m1 = (xv(2)-xv(1))/k+xv(1);
        x_m2 = (xv(3)-xv(4))/k+xv(4);
        y_m1  = ((yv(2)-yv(1))/(xv(2)-xv(1)))*(x_m1-xv(1))+yv(1);
        y_m2 = ((yv(3)-yv(4))/(xv(3)-xv(4)))*(x_m2-xv(4))+yv(4);
        xv_m = [xv(1) x_m1 x_m2 xv(4) xv(5)];
        yv_m = [yv(1) y_m1 y_m2 yv(4) yv(5)];
        
        %between the bundries can be solve here by specifiyin an ovelaping
        %bundires here later
        [in,on] = inpolygon(NC_in_inp.lon,NC_in_inp.lat,xv_m,yv_m);
        ev_num_tm = length(NC_in_inp.evID(in));
        
        if k==1
            break
        end
        
        %another corner case beside the between the bundries:
        %when the number of events would be so dense that 3/4 k and 3/2
        %produce loops. 
        %it can be solved by changing 3/4 and 3/2 numbers if such a case
        %occurs
        %ceil_ max number of events in each section before spliting
        %floor_ min number of events before increasing the area
        if ev_num_tm < floor_ 
            k = k*(3/4);%reduce k somehow
        elseif ev_num_tm > ceil_
            k = k*(3/2);%increase k somehow
        else
            T=0;
        end
       
        %if k is smaller than 1, make it 1 and loop it the last time.
        if k<1
            k = 1;
        end
        
        %%
    end
    ev_num_t_T = ev_num_t_T + ev_num_tm;
    
    
    
    %introduce overlap between sub_grid boundries could be added
    %here
    %p1 and p4 need to be updated to acount for the buffer
    xv(1) = xv_m(2);
    xv(4) = xv_m(3);
    xv(5) = xv_m(2);
    yv(1) = yv_m(2);
    yv(4) = yv_m(3);
    yv(5) = yv_m(2);
    
    
        
    
%now we gather id information for all of the events inside the polygon
ev_ID = NC_in_inp.evID(in);
st_ind = NC_in_inp.start_ind(in);
end_ind = NC_in_inp.end_ind(in);

%some initiolizations
%

clear ss sta_cell all_sta sta
ss{1}{1}='x';
sta_cell{1}='X';
all_sta{1}='x';

%Lets loop over events and gather phase information for them

for i = 1: length(ev_ID)
    %we have the index inf in NC_in_inp for each event
    ind1_text = st_ind(i);
    ind2_text = end_ind(i);
    
    clear sta_cell
    sta_cell{1}='x';
    %loops below is gathering infs from stations
    %later we use these inf to find stations with most repeated times
    for sta_in = ind1_text+1:ind2_text-1
        sta_text = NC_phase_all{sta_in};
        len_l=length(sta_text);
        if len_l>4
            sta_cell{length(sta_cell)+1}=strtrim(sta_text(1:5));
        else
            sta_cell{length(sta_cell)+1}=strtrim(sta_text(1:len_l));
        end
    end
    %here we gather inf for fetching events in the next functions 
    for ll=ind1_text:ind2_text
        ss{1}{length(ss{1})+1}=NC_phase_all{ll};
    end
    sta_cell{1}=[];
    all_sta=[all_sta,sta_cell{2:end-1}];
end

ss{1}(1)=[];

%lets find the most ?? frequent stations
[ff1,~,ff2]=unique(all_sta);
freq=hist(ff2,unique(ff2));      
[s_1,s_2]=sort(freq,'descend');  
all_sta_40=ff1(s_2(1:st_max_num));


%sub_grid_phases is the super structure that contain information for all sub_grids
%ignore the last grid if the number of events are less than 100
if ev_num_tm >100
    sub_grid_phases(num_sl).ss = ss;
    sub_grid_phases(num_sl).all_sta_40 = all_sta_40;
    grid_polygones(num_sl).lats = xv_m;
    grid_polygones(num_sl).lons = yv_m;
end
%
%now we plot the results to see if results make sense
figure
plot(x_poly,y_poly);
hold on;
plot(xv_m,yv_m,'k');
hold on;
plot(NC_in_inp.lon(in),NC_in_inp.lat(in),'r*')
%pause
%close 
end
clear NC_in NC_phase_all


%

    
  