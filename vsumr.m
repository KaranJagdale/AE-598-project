function vs = vsumr(s,a,lmd,p_s,V,n_s,cap)
    %Calculates the sum part of the V_infinity calculation for a particular
    %action
    gamma = 0.7;
    vs = 0;
    for i = 1:n_s
        for j = 1:n_s
            for k = 1:cap(1)
                for l = 1:cap(2)
                    for m = 0:1
                        for e1=0:1
                            for e2 = 0:1
                                %disp(i)
                                ns = [i,j,k,l,m,e1,e2]';
                                vs = vs + gamma*tranprobr(s,a,ns,lmd,p_s)*V(ns(1),ns(2),ns(3),ns(4),ns(5)+1,ns(6)+1,ns(7)+1);
                            end
                        end
                    end
                end
            end
        end
    end
end