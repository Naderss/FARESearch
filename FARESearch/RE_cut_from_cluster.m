%there is bug in this function, fix it


function [clus_f_sub,clus_id_sub,cl_inf_sub]=RE_cut_from_cluster(clus_f,clus_id,cl_inf,cutoff_break_cl,nn)
% 

    Z=squareform(clus_f{nn});
    ZZ=linkage(Z);
    T = cluster(ZZ,'cutoff',cutoff_break_cl,'criterion','distance');

    clear clus_f_sub clus_id_sub cl_inf_sub DD
    maxt=max(T);
    n=0;
    for i=1:maxt
        if length(find(T==i))>1
            n=n+1;
            DD{n}=find(T==i);
        end
    end
 
    if ~exist('DD','var')
        clus_f_sub{1}=[];
        clus_id_sub{1}=[];
        cl_inf_sub.st_time{1}=[];
        cl_inf_sub.lon{1}=[];
        cl_inf_sub.lat{1}=[];
        cl_inf_sub.depth{1}=[];
        cl_inf_sub.mag{1}=[];
         return;
    end
    
    for i=1:length(DD)
        clus_f_sub{i}=clus_f{nn}(DD{i},DD{i});
        clus_id_sub{i}=clus_id{nn}(DD{i});
        cl_inf_sub.st_time{i}=cl_inf.st_time{nn}(DD{i});
        cl_inf_sub.lon{i}=cl_inf.lon{nn}(DD{i});
        cl_inf_sub.lat{i}=cl_inf.lat{nn}(DD{i});
        cl_inf_sub.depth{i}=cl_inf.depth{nn}(DD{i});
        cl_inf_sub.mag{i}=cl_inf.mag{nn}(DD{i});
    end

    %clus_f{nn}=[];
%     clus_f=[clus_f,clus_f_sub];
%     clus_id=[clus_id,clus_id_sub];
%     clear clus_f_sub clus_id_sub DD

