function  create_Mat_structure_from_phase_inf (phase_dir);

%A side fucntion to create a structure for gathering all catalog phase
%informations from 1984-2020


f_index = 1; 


for file_i=1984:2020   %loop over the years
    file_i
    for file_sub=1:12      % loop over the months
        clear text text2
        if file_sub<10      
            file=[phase_dir,num2str(file_i),'/',num2str(file_i),'.0',...
                num2str(file_sub),'.phase'];

        else
            %construct the directory of phase files
            file=[phase_dir,num2str(file_i),'/',num2str(file_i),'.',...
                num2str(file_sub),'.phase'];
        end
        
        %%
        % and lets tead the files using textscan
        id=fopen(file);
        text=textscan(id,'%s %*[^\n]','Delimiter','|');
        fclose(id);
        
        if f_index ==1
            global NC_phase_all
            NC_phase_all = text{1};
            f_index = 2;
        else
            NC_phase_all = [NC_phase_all; text{1}];
        end
        
    end
end
%%
%okay we gathered all the inf in one structure and lets save it, in order
%to avoid reading text files all over again.
%20m lines!
%save ('NC_phase_inf_1984_2020.mat','NC_phase_all');

%%
ff_u =1; %

%the idea is to store the indexes of all events in the phase catalog in a mat
%structure that we can use it to search for events later in O(1) time 
%complexity similar to a hash map
%found a pattern in the phase catalog based on the lenght of the lines
global NC_in
for j=1:length(NC_phase_all)
    
    x =  length(NC_phase_all{j});
    
    % if the lenght of the line is more than 150 charector, it mean it is a
    % header and it contain the event information
    if x > 150 

        NC_in.evID(ff_u)=str2num(NC_phase_all{j}(137:146));
        NC_in.lon(ff_u)=-1*(str2num(NC_phase_all{j}(24:26)) + (round(str2num(NC_phase_all{j}(28:31))*(100/60)))/10000);
        NC_in.lat(ff_u)=str2num(NC_phase_all{j}(17:18))+ (round(str2num(NC_phase_all{j}(20:23))*(100/60)))/10000;
        NC_in.start_ind(ff_u) = j;

        % so the next line would be an another event
        while length(NC_phase_all{j}) > 90
            j=j+1;
        end
        NC_in.end_ind(ff_u) = j;
        ff_u = ff_u+1; %lets go the next event
    end
    

end
%know we save the index information of the events to use it later.
%%
%save('NC_phase_inf_index_1984_2020.mat','NC_in');
%%

