n_b = 2;
n_s = 4;
n_a = 4;
cap = [10 10];
lmd = randi(7,1,n_s); %arriving passengers are poisson distributed
p_s = rand(1,n_s)*0.6+0.2;
w_st = 10*60; w_b = 7*60; alpha = 2; beta = 5; delta = 5*60;

vinf = zeros(n_s, n_s, cap(1),cap(2),2);
ni = 1000;
    %A is the array of all the possible actions 
A = zeros(2,n_a*n_b);
A(2,1:4) = 1;
A(2,5:8) = 2;
for i = 1:4
    A(1,i) = i;
    A(1,i+4) = i;
end
    
for iter = 1:ni
        for i = 1:n_s
            for j = 1:n_s
                for k = 1:cap(1)
                    for l = 1:cap(2)
                        for m = 0:1
                             
                                v = zeros(1,n_a*n_b);
                                s = [i,j,k,l,m]';                            
                                for a = 1:n_a*n_b
                                    mod = A(2,a);
                                    v(a) = reward(s,A(:,a),lmd(s(mod)),p_s(s(mod)),w_st, w_b, alpha, beta, delta) + vsum(s,A(:,a),lmd,p_s,vinf,n_s,cap);
                                end
                                vinf(s(1),s(2),s(3),s(4),s(5)) = max(v);
                        end
                    end
                end
            end
        end
        disp(iter)
end