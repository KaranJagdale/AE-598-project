function vs = vsum(s,a,lmd,p_s,V,n_s,cap)
    %Calculates the sum part of the V_infinity calculation for a particular
    %action
    gamma = 0.7;
    vs = 0;
    for i = 1:n_s
        for j = 1:n_s
            for k = 1:cap(1)
                for l = 1:cap(2)
                    for m = 1:2
                        for e1=0:1
                            for e2 = 0:1
                                ns = [i,j,k,l,m,e1,e2]';
                                vs = vs + gamma*tranprob(s,a,ns,lmd,p_s)*V(ns(1),ns(2),ns(3),ns(4),ns(5));
                            end
                        end
                    end
                end
            end
        end
    end
end