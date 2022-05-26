function [cc]=sec_c_one(x_t,y,k)

%%
%x_t is the data, y is the query
    %compute y stats -- O(n)
    sumy2 = sqrt(sum(y.^2));
     m = length(y);
    
    x=buffer(x_t,k,m-1);    %make a matrix from x_t with m-1 overlaps
    
    %n = length(x(:,1));
    %y = (y-mean(y))./std(y,1);                      %Normalize the query. If you do not want to normalize just comment this line.
   % m = length(y);
    y = y(end:-1:1);                                %Reverse the query
    y(m+1:k) = 0;                                 %Append zeros
    
    
    
    %The main trick of getting dot products in O(n log n) time. The algorithm is described in [a].
    X = fft(x);                                     %Change to Frequency domain
    Y = fft(y);                                     %Change to Frequency domain
    Z = X.*Y;                                       %Do the dot product
    z = ifft(Z);                                    %Come back to Time domain

    sumx2_t=sqrt(movsum(x.^2,[m-1,0]));
    
    
cc=z(m:k,:)./(sumx2_t(m:k,:)*sumy2); %correlation coefficients
cc=cc(m:length(x_t));
%dist=sqrt(((2*m).*(1-cc(m:length(x_t))'))); %calculate the dist from correlation coefficients

