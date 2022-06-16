env; %importing env params
vinf = zeros(n_s, n_s, cap(1)+1,cap(2)+1,2,2,2);
ni = 100;
    %A is the array of all the possible actions 
A = zeros(2,n_a*n_b);
A(2,1:5) = 1;
A(2,6:10) = 2;
for i = 1:n_a
    A(1,i) = i;
    A(1,i+5) = i;
end
tic;    
for iter = 1:ni
        for i = 1:n_s
            for j = 1:n_s
                for k = 0:cap(1)
                    for l = 0:cap(2)
                        for m = 0:1
                            for e1 = 0:1
                                for e2 = 0:1
                                    %v = zeros(1,n_a*n_b);
                                    s = [i,j,k,l,m,e1,e2]'; 
                                    Avac = [];
                                    for mod = 1:2
                                        %avac=[];
                                        e= mod + 5;
                                        sp = 5;
                                        if s(sp) == 0 
                                            if s(e) == 1
                                                avac = [1,2,4]; %stop, skip, split
                                            else
                                                avac = 5; %Only nextbs
                                            end
                                        else
                                            if s(e) == 1
                                                avac = [1,2]; %stop, skip
                                            else
                                                avac = [3,5];
                                            end
                                        end

                                        avac = [avac;mod*ones(1,size(avac,2))];
                                        Avac = [Avac avac];



                                    end
                                    v = zeros(1,size(Avac,2));
                                    for acts = 1:size(Avac, 2)
                                        act = Avac(1,acts);
                                        mod = Avac(2,acts);
                                        if act == 1 || act ==4
                                            vsum = vsumstsk(s,Avac(:,acts),lmd,p_s,vinf,n_s,cap); %change this
                                        elseif act ==2
                                            ns = s;
                                            ns(mod+5) = 0;
                                            if ns(5) == 0
                                                ns(6) = 0; ns(7) = 0;
                                            end
                                            vsum = vinf(ns(1),ns(2),ns(3)+1,ns(4)+1,ns(5)+1, ns(6)+1, ns(7)+1);
                                        elseif act == 3
                                            ns = s;
                                            if s(mod) == n_s
                                                smodp = 1;
                                            else
                                                smodp = s(mod) +1;
                                            end

                                            ns(1) = smodp;
                                            ns(2) = smodp;
                                            ns(5) = 0;
                                            ns(6) = 1; ns(7) = 1;
                                            vsum = vinf(ns(1),ns(2),ns(3)+1,ns(4)+1,ns(5)+1, ns(6)+1, ns(7)+1);
                                        
                                        else
                                            ns = s;
                                            if s(mod) == n_s
                                                smodp = 1;
                                            else
                                                smodp = s(mod) +1;
                                            end
                                            ns(mod) = smodp;
                                            ns(mod + 5)  = 1; 
                                            if ns(5) == 0
                                                ns(1) = smodp; ns(2) = smodp;
                                                ns(6) = 1; ns(7) = 1;
                                            end
                                            vsum = vinf(ns(1),ns(2),ns(3)+1,ns(4)+1,ns(5)+1, ns(6)+1, ns(7)+1);
                                        end
                                        v(acts) = reward(s,Avac(:,acts),lmd(s(mod)),p_s(s(mod)),w_st, w_b, alpha, beta, delta) + gamma*vsum;
                                    end

%                                         for a = 1:n_a*n_b
%                                             mod = A(2,a);
%                                             
%                                             v(a) = reward(s,A(:,a),lmd(s(mod)),p_s(s(mod)),w_st, w_b, alpha, beta, delta) + vsumr(s,A(:,a),lmd,p_s,vinf,n_s,cap);
%                                         end
                                    vinf(s(1),s(2),s(3)+1,s(4)+1,s(5)+1,s(6)+1,s(7)+1) = max(v);
                                end
                            end
                        end
                    end
                end
            end
        end
        disp(iter)
end
disp(toc/60)