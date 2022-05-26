function IrisFetch_helper_for_NCEDC(Iris_jar_dir,grid_dir,min_eqs)


%Fetching data from Northern California Earhtquake Datat Center 
%Running this code requires to have irisFetch.m in your MATLAB Path
%irisFetch.m can be downloaded here:
%https://github.com/iris-edu/irisFetch-matlab/releases

%input files:
%Iris_jar_dir: the path dir to the IRIS_WS jar file can be find below:
            %http://ds.iris.edu/ds/nodes/dmc/software/downloads/iris-ws/
%grid_dir: Sub_grid directory that contain request files
%min_eqs: minimum number of events per station to consider requesting data 

%Add IRIS_WS to the javaaddpath
javaaddpath(Iris_jar_dir);
    
    grid_dir_com=[grid_dir,'/request_catalog'];
    data_dir=[grid_dir,'/data'];
    log_dir=[grid_dir,'/logs'];
    
    if ~exist(data_dir,'dir')
        mkdir(data_dir);
    end
    if ~exist(log_dir,'dir')
        mkdir(log_dir);
    end
    
    file_names=dir([grid_dir_com,'/*.txt']);
    
    %j indicates each station
    
    for j=1:length(file_names)
        
        fileID=fopen([grid_dir_com,'/',file_names(j).name]);
        t_lines=textscan(fileID,'%s %s %s %s %s %s %s %f %f %f %f %f');
        fclose(fileID);
        
    
        %lets check if there is more than min_eqs are detected by this
        %staion 
        if length(t_lines{1}) < min_eqs
            continue;
        end
        
        %lets make a stucture for each station 
        [sta_str]=request_text2structure(t_lines);
        
        %perfect, lets download the data now 
        T=evalc('[sta_str]=IrisFetch_runner_NCEDC(sta_str);');
               
        %saving data as MATLAB structures
        eval(['struc_',file_names(j).name(1:end-4),'=sta_str;']);
        save([data_dir,'/',file_names(j).name(1:end-4),'.mat'],['struc_',file_names(j).name(1:end-4)]);
        clear sta_str
        eval(['clear ','struc_',file_names(j).name(1:end-4)]);
        
        eval(['struc_log_',file_names(j).name(1:end-4),'=T;']);
        save([log_dir,'/',file_names(j).name(1:end-4),'.mat'],['struc_log_',file_names(j).name(1:end-4)]);
        clear  T
        eval(['clear ','struc_log_',file_names(j).name(1:end-4)]);
    end
end

        
   

    
        


    
    
    
    