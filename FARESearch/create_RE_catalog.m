%%
%Create RE calatlog into an ascci file

function create_RE_catalog(cl_inf,clus_id, sub_grid_dir)
%%
    re_cat = ['start time                lon       lat      depth  mag'];

    for i =1:length(cl_inf.lon)
        for j = 1:length(cl_inf.st_time{i})
            
            f1 = cl_inf.st_time{i}{j};
            f2 = num2str(cl_inf.lon{i}{j});
            f3 = num2str(cl_inf.lat{i}{j});
            f4 = num2str(cl_inf.depth{i}{j});
            f5 = num2str(cl_inf.mag{i}{j});
            f6 = num2str(clus_id{i}(j));
            re_cat=strcat([re_cat,'\n', f1,'  ',f2,'  ',f3,'  ',f4,'  ',f5,'  ',f6]);
            %re_cat
        end
        re_cat=strcat([re_cat,'\n']);
    end
    newfile=strcat(sub_grid_dir,'/','RE_catalog_with_IDs.txt');
    newid=fopen(newfile,'wt');
    fprintf(newid,re_cat);
    fclose(newid);
        
            
        
        
        
        
        
        
    



