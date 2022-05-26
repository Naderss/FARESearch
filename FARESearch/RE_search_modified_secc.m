function clus_id=RE_search_modified_secc(final_data,cc_tr,kk)

[data_len,len_s_ok]=size(final_data);
% len_s_ok=length(s_ok);
% 
% data_len=length(final_data(:,1));

dd=(1:len_s_ok).*data_len;

one_sec_len=round(data_len/10);

%zmat=zeros(data_len-1,1);

k=0;
for i=1:(len_s_ok-1)
    
    
    y=final_data(:,i);
    x=reshape(final_data(:,i:end),[],1); 
    %try
    cc=sec_c_one(x,y,kk);
    %catch
        
        %length(x)
        %length(y)
        %kk
        %xcv
    %end
        
    %cc=[zmat;cc;zmat];
    
    d2=arrayfun(@(X) max(cc(X-one_sec_len:X+one_sec_len)), dd(1:end-i-1),'UniformOutput', false);
    d3=find([d2{1:end}]>cc_tr);
    
    
    if ~isempty(d3)
        k=k+1;
        clus_id{k}=[i,d3+i];
        %clus_cc{k}=[d2{d3}];
    end

    
end

if k==0
    clus_id{1}=-1;
    return;
end
    

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