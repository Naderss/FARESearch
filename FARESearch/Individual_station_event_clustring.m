%northern california RE searching
%Nader Shakibay Senobari, summer 2016, UCR
%Modified Winter 2021 and Spring 20222 by NSS

function Individual_station_event_clustring(gr_dir,cc_tr,min_eqs)
    %The function links events if their CC is more than cc_tr and create a
    %MATLAB structure that contain information about cluster of events for
    %each station
    %Inputs:
    %gr_dir: directory path for each sub_grid 
    %cc_tr: the threshold for clsutering events based on cross-correlation 
    %min_eqs: min number of events to use the station for the RE search


    data_dir=[gr_dir,'/data'];
    data_dir_mod=[gr_dir,'/data_modified_',num2str(cc_tr*100)];
    clus_dir=[gr_dir,'/RE_clusters_',num2str(cc_tr*100)];
 
    if ~exist(data_dir_mod,'dir')
        mkdir(data_dir_mod);
    end
    
    if ~exist(clus_dir,'dir')
        mkdir(clus_dir);
    end

    file_names=dir([data_dir,'/*.mat']);
    
    %%
    for j=1:length(file_names)
        %%
        load([data_dir,'/',file_names(j).name]);
        eval(['sta_struc = struc_',file_names(j).name(1:end-4),';']); %ss ~ station structure that has all the information
        eval(['clear struc_',file_names(j).name(1:end-4)]);
        
        %/////////////////////////////////////////////////////
        %lets make the data clean first
        [s_in,final_data,s_ok,ok_or_not]=trim_data(sta_struc,min_eqs);
        
        disp([file_names(j).name(1:end-4),'--- number of eqs= ',num2str(length(s_ok))]);
        
        if ok_or_not==0
            %cluster events based on their similarity
            tic
            clus_tot_id=RE_search_modified_secc(final_data,cc_tr,2^12);
            toc
            
            if clus_tot_id{1}==-1
                disp('there is no similar pair');
                continue;
            end
            
            sta_data=s_in(s_ok);
            %save the cluster and also the trimed data
            eval(['struc_trimed_',file_names(j).name(1:end-4),'=sta_data;']);
            save([data_dir_mod,'/',file_names(j).name(1:end-4),'.mat'],['struc_trimed_',file_names(j).name(1:end-4)]);
            clear sta_data
            eval(['clear ','struc_trimed_',file_names(j).name(1:end-4)]);
        
            eval(['clust_',file_names(j).name(1:end-4),'= clus_tot_id;']);
            save([clus_dir,'/',file_names(j).name(1:end-4),'.mat'],['clust_',file_names(j).name(1:end-4)]);
            clear  clus_tot_id
            eval(['clear ','clust_',file_names(j).name(1:end-4)]);
            
        else
            disp('not enough events');
            continue
        end
       
        
        
    end
    
end


        