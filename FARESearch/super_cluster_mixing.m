%Producing final clusters!
function [cl_inf,clus_f,clus_id]= super_cluster_mixing(gr_dir,cc_tr,station_detect, mean_threshold_number,max_cc_cut_off,min_num_visuall,cutoff_break_cl)
%lets define the grid directory


    tic;
    %if there is too much stations and it takes time to get all of them!
    condition_restriction=0;
    %if yes so determine the restrictions!
    if condition_restriction==1
        eq_min=500;
        min_years=15;
    end
    
    disp(gr_dir);
    datadir=[gr_dir,'/data_modified_',num2str(cc_tr*100),'/'];
    clusdir=[gr_dir,'/RE_clusters_',num2str(cc_tr*100),'/'];
    d=dir([datadir,'*.mat']);
    final_dir=[gr_dir,'/Final_clusters_',num2str(cc_tr*100),'/'];
    if ~exist(final_dir,'dir')
        mkdir(final_dir);
    else
        rmdir(final_dir);
        mkdir(final_dir);
    end

%lets gather all the clusters for each grid by their id informations
k=0;
for i=1:length(d)
    %DATA
    load([datadir,d(i).name]);
    eval(['st = struc_trimed_',d(i).name(1:end-4),';']);
    eval(['clear struc_trimed_',d(i).name(1:end-4)]);
    %RE CLUSTER
    load([clusdir,d(i).name]);
    eval(['cl = clust_',d(i).name(1:end-4),';']);
    eval(['clear clust_',d(i).name(1:end-4)]);

      if condition_restriction==1
         if ((str2num(st(end).st_time(1:4))-str2num(st(1).st_time(1:4)))<min_years)||(length(st)<eq_min)
            continue;
         end
      end
      for j=1:length(cl)
          idcl=[st(cl{j}).eventID];
          idcl=unique(idcl);
          if length(idcl)==1
              continue;
          else
              k=k+1;
              clid{k}=idcl;
          end
      end
          
end

%now make them uniqe
clus_id=clid;

n=1;
while n<length(clus_id)
    i=n+1;
    while i<=length(clus_id)
        c=intersect(clus_id{n},clus_id{i});
        if ~isempty(c)
            clus_id{n}=union(clus_id{n},clus_id{i});
            clus_id(i)=[];
            i=n;
        end
        i=i+1;
    end
    n=n+1;
end


%clear i n k j dd 

%//////////////////////////////////////////////////////
%lets see what is the the lenght of the biggest cluster
test=cellfun(@length, clus_id);
max(test)

%problem that I knew from the first day: big clusters: why I didn't do
%it:perfectionism:
%I could use the CC from previous section, but lag time from
%neighboring waveform slightly affect CCs. So the better way is to pad
%zeros between waveforms in the previous section.
%or use higher CC and smaller area for now?



%/////////////////////////////////////////////////////



%making a matrix for each cluster for gathering cc informations
 for dd=1:length(clus_id)
     clus_mat{dd}{length(clus_id{dd}),length(clus_id{dd})}=[];
 end

 %each matrix has the cc information for each stations
for i=1:length(d)
    %DATA
    load([datadir,d(i).name]);
    eval(['st = struc_trimed_',d(i).name(1:end-4),';']);
    eval(['clear struc_trimed_',d(i).name(1:end-4)]);
    
    if condition_restriction==1
       if ((str2num(st(end).st_time(1:4))-str2num(st(1).st_time(1:4)))<min_years)||(length(st)<eq_min)
           continue;
       end
    end
    
    for k=1:length(clus_id)

        lcl=length(clus_id{k});
        for j=1:(lcl-1)
            for jj=(j+1):(lcl)
                ind1=find([st.eventID]==clus_id{k}(j));
                ind2=find([st.eventID]==clus_id{k}(jj));
                if (~isempty(ind1))&&((~isempty(ind2)))
                    s_in_rate=st(ind1(1)).samp_rate;
                    st_point=5*s_in_rate;
                    end_point=15*s_in_rate-1;
                    try
                    [cros_c,log]=xcorr((st(ind1(1)).data(st_point:end_point))./(st(ind1(1)).sens),...
                        (st(ind2(1)).data(st_point:end_point))./(st(ind2(1)).sens),...
                        s_in_rate,'coeff');
                    catch
                        maxc= 0
                    end
                    
                    %%
                    maxc=max(max(cros_c));
                    if maxc>max_cc_cut_off
                        clus_mat{k}{j,jj}=[clus_mat{k}{j,jj},maxc];
                    end
                end
            end
        end
        
    end
end

%now it is time to make a clu_f that has the average cc information
%we consider only the best mean_threshold_number of stations 
for k=1:length(clus_id)
        lcl=length(clus_id{k});
        for j=1:(lcl-1)
            for jj=(j+1):(lcl)
                len_d=length(clus_mat{k}{j,jj});
                if len_d>=station_detect
                    st_num_det=min(len_d,mean_threshold_number);
                    sort_clus=sort(clus_mat{k}{j,jj},'descend');
                    mean_clus=1-mean(sort_clus(1:st_num_det));
                    clus_f{k}(j,jj)=mean_clus;
                    clus_f{k}(jj,j)=mean_clus;
                else
                    clus_f{k}(j,jj)=1-max_cc_cut_off;
                    clus_f{k}(jj,j)=1-max_cc_cut_off;
                end

            end
        end
end

%now it time to break the larger cluster to the smaller one 
% and append them to the end of the the cluster for visuallization 

[nn]=cellfun(@length,clus_f);

big_clus_ind=find(nn>min_num_visuall);
%debiging section
clus_f_or=clus_f;
clus_id_or=clus_id;

%breaking the large clusters to small ones and append them to the end of
%clus_f and clus_id
if ~isempty(nn)
    [clus_f,clus_id]=breaking_to_sm_cl(clus_f,clus_id,big_clus_ind,cutoff_break_cl);
end





%now clear the large ones!
clus_f(big_clus_ind)=[];
clus_id(big_clus_ind)=[];

%now it is time to find the inf for each id like:mag, st time and location
[cl_inf]=find_struc_st_time(clus_id,d,datadir);

%now it is time save 3 main structures for each grid: clus_id, clus_f and
%cl_inf
%first make a directory for each cluster and cc threshold
t_time=toc;
t_time=t_time/3600

save([final_dir,'cl_inf.mat'],'cl_inf');
save([final_dir,'clus_f.mat'],'clus_f');
save([final_dir,'clus_id.mat'],'clus_id');
save([final_dir,'clus_mat.mat'],'clus_mat');
save([final_dir,'t_time.mat'],'t_time');

%clear cl_inf clus_f clus_id clus_mat t_time clid cl big_clus ind nn

end

    


