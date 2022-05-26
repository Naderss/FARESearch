function [clus_f,clus_id]=breaking_to_sm_cl(clus_f,clus_id,big_clus_ind,cutoff_break_cl)
%%
for ii=1:length(big_clus_ind)
    nn=big_clus_ind(ii);
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
        continue;
    end
    
    for i=1:length(DD)
        clus_f_sub{i}=clus_f{nn}(DD{i},DD{i});
        clus_id_sub{i}=clus_id{nn}(DD{i});
    end

    %clus_f{nn}=[];
    clus_f=[clus_f,clus_f_sub];
    clus_id=[clus_id,clus_id_sub];
    clear clus_f_sub clus_id_sub DD
end

    