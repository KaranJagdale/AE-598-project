function vs = vsumstsk(s,a,lmd,p_s,V,n_s,cap)
    %Calculates the sum part of the V_infinity calculation for a particular
    %action
    %gamma = 0.7;
    vs = 0;

            for k = 0:cap(1)  
                for l = 0:cap(2)
                    for m = 0:1
                        for e1=0:1
                            for e2 = 0:1
                                %disp(i)
                                ns = [s(1),s(2),k,l,m,e1,e2]';                                
                                vs = vs + tranprobr(s,a,ns,lmd,p_s)*V(ns(1),ns(2),ns(3)+1,ns(4)+1,ns(5)+1,ns(6)+1,ns(7)+1);
                                %1 is added in the indices of V as the
                                %index 0 is not supported
                            end
                        end
                    end
                end
            end
        
end