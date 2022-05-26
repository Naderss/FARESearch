function [cl_inf]=find_struc_st_time(cl_id_tot,d,datadir)
%finding the structure if you have the ids
%tic

cl_len_to=length(cl_id_tot);
for jj=1:cl_len_to
    
    cl_id=cl_id_tot{jj};
    cl_len=length(cl_id);
    cl_st_times{cl_len}=[];
    cl_lon{cl_len}=[];
    cl_lat{cl_len}=[];
    cl_depth{cl_len}=[];
    cl_mag{cl_len}=[];
    
    ind_st=cellfun('isempty', cl_st_times);
    i=0;
    finish=0;
    while finish==0
        i=i+1;
        %DATA
        load([datadir,d(i).name]);
        eval(['st = struc_trimed_',d(i).name(1:end-4),';']);
        eval(['clear struc_trimed_',d(i).name(1:end-4)]);
        %RE CLUSTER
%         load([clusdir,d(i).name]);
%         eval(['cl = clust_',d(i).name(1:end-4),';']);
%         eval(['clear clust_',d(i).name(1:end-4)]);

%         if ((str2num(st(end).st_time(1:4))-str2num(st(1).st_time(1:4)))<15)||(length(st)<300)
%             continue;
%         end
        for j=find(ind_st==1);
            ind1=find([st.eventID]==cl_id(j));
            if (~isempty(ind1))
                cl_st_times{j}=st(ind1(1)).st_time;
                cl_lon{j}=st(ind1(1)).eq_lon;
                cl_lat{j}=st(ind1(1)).eq_lat;
                cl_depth{j}=st(ind1(1)).eq_depth;
                cl_mag{j}=st(ind1(1)).eq_mag;
            end
        end
        ind_st=cellfun('isempty', cl_st_times);
        if ~any(ind_st==1)
                finish=1;
        end
    end
    
    cl_st_times_t{jj}=cl_st_times;
    cl_lon_t{jj}=cl_lon;
    cl_lat_t{jj}=cl_lat;
    cl_depth_t{jj}=cl_depth;
    cl_mag_t{jj}=cl_mag;
    clear cl_st_times cl_lon cl_lat cl_depth cl_mag 
    
end
cl_inf.st_time=cl_st_times_t;
cl_inf.lon=cl_lon_t;
cl_inf.lat=cl_lat_t;
cl_inf.depth=cl_depth_t;
cl_inf.mag=cl_mag_t;
%toc
end


    
    
    
    
    