%clean data before applying cross_crorrelation
%

function [s_in,final_data,s_ok,ok_or_not]=trim_data(s_in,sta_min_number)
 %%
    ok_or_not=0; % 0=we will use this station for RE search and 1=not
    
    %lets find out which on is okay 
    s_ok=find([s_in.problem]==0); %indexes that has no problem
    
    if length(s_ok) < sta_min_number
        ok_or_not=1;
        final_data=0;
        return;
    end
    
    s_in_min_rate=min([s_in(s_ok).samp_rate])
    s_in_max_rate=max([s_in(s_ok).samp_rate])
    dif_rate_l=length(s_ok([s_in(s_ok).samp_rate]~= 100));
    if dif_rate_l > 0
        %lets check if eather one is 123 it means there is a data structure that
        %didn't have sample rate so it means there is somthing wrong
        %if (s_in_max_rate==123)||(s_in_min_rate==123)
            %rate_prob=find([s_in(s_ok).samp_rate]==123);
            s_ok([s_in(s_ok).samp_rate]==123)=[];
            
            if length(s_ok) < sta_min_number
                ok_or_not=1;
                final_data=0;
                return;
            end
            %lets check if it the problem is solved
            s_in_min_rate=min([s_in(s_ok).samp_rate]);
            s_in_max_rate=max([s_in(s_ok).samp_rate]);
            dif_rate_l=length(s_ok([s_in(s_ok).samp_rate]~= 100));
            
            if dif_rate_l > 0
                %lets resample everything to the min-sample-rate
                s_in=rate_unifier(s_in,s_ok,s_in_min_rate);
            end

    end
    s_in_min_rate=min([s_in(s_ok).samp_rate]);
    
    %lets find and delete all those stations that has less than 10 second
    %data
    s_ok([s_in(s_ok).samp_count]<(10*s_in_min_rate))=[];
    
    %now lets fill the gaps for those that the gap is smaller than 10sec
    gap_prob=s_ok([s_in(s_ok).samp_count] < 20*s_in_min_rate-10);
    
    if ~isempty(gap_prob)
        for i=1:length(gap_prob)
            st_gap_time=etime(datevec(s_in(gap_prob(i)).fetch_st_time),...
                datevec(s_in(gap_prob(i)).st_time));
            
            end_gap_time=etime(datevec(s_in(gap_prob(i)).end_time),...
                datevec(s_in(gap_prob(i)).fetch_end_time));
            
            if (abs(st_gap_time)>(1.5/s_in_min_rate))
                if (st_gap_time < 0)
                    end_gap_time=end_gap_time+st_gap_time;
                else
                    st_gap_time_num=round(st_gap_time*s_in_min_rate);
                    s_in(gap_prob(i)).data=[zeros(st_gap_time_num,1);s_in(gap_prob(i)).data];
                    s_in(gap_prob(i)).samp_count=s_in(gap_prob(i)).samp_count+st_gap_time_num;
                end
            end
            if (abs(end_gap_time)>(1.5/s_in_min_rate))
                if end_gap_time > 0
                    end_gap_time_num=round(end_gap_time*s_in_min_rate);
                    s_in(gap_prob(i)).data=[s_in(gap_prob(i)).data;zeros(end_gap_time_num,1)];
                    s_in(gap_prob(i)).samp_count=s_in(gap_prob(i)).samp_count+end_gap_time_num;
                else
                    if (abs(end_gap_time)>(10/s_in_min_rate))
                        s_ok(s_ok==gap_prob(i))=[];
                    end
                end
            end
        end
    end
    %I hope there won't be any more problem
    
    
    %now lets make a matrix with only 10 secend data length for all events 
   % s_in_min_rate=min([s_in(s_ok).samp_rate]);
    st_point=5*s_in_min_rate;
    end_point=15*s_in_min_rate-1;
    
    %%
    data_cells=arrayfun(@(x) x.data(st_point:end_point), s_in(s_ok),'UniformOutput', false);  
    final_data=[data_cells{:}];
       
                            
            
            
            
        