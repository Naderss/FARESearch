%resample everythng to the 100 sample rate
function s_in=rate_unifier(s_in,s_ok,s_in_min_rate)

    dif_rate=s_ok([s_in(s_ok).samp_rate]~= 100);
    
    for i=1:length(dif_rate)
        if s_in(dif_rate(i)).samp_count < (10*s_in_min_rate)
            continue;
        end
        s_in(dif_rate(i)).data=resample(s_in(dif_rate(i)).data,...
            100,round(s_in(dif_rate(i)).samp_rate));
        s_in(dif_rate(i)).samp_count=length(s_in(dif_rate(i)).data);
        s_in(dif_rate(i)).samp_rate=100;
    end
    