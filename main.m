load("vinf2.mat")
rng(1)
n_b = 2;
n_s = 4;
n_a = 4;
cap = [8 8];
lmd = randi(2,1,n_s); %arriving passengers are poisson distributed
p_s = rand(1,n_s)*0.6+0.2;
w_st = 10*60; w_b = 7*60; alpha = 2; beta = 5; delta = 5*60;
%vinf = Vinf(n_a, n_b, n_s, cap, lmd,p_s,w_st, w_b, alpha, beta, delta);

%dis_stp = 50*(rand(1,n_s) + 1); %Distance between stops distributed between 300 - 600 meters
dis_stp = [40 50 28 30];
v_bus = 20*5/18; % Speed of bus 20 Km/h
gamma = 0.7;
cap_bus =16;
unit_cap = cap_bus/2;
v_pas = 5.4*5/18; %Passenger speed in Km/h
t_bo = 5; %boarding time per passenger in seconds
t_al = 2; %Alighting time per passenger in seconds

%Assuming we have the optimal action as aopt
state0 = [1 3 0 0 0 1 1]; 
%initial state: the buses are joined and just reached at the stop 1
s = state0;
ns = zeros(2,size(s,2));
tispent = 20; %Using some dummy value for time spent at the initial stop
t_nxt = [tispent tispent]; 
passcap = [16 8]; %joined bus capacity and single unit capacity

count = 0;
t= 0;
st1 = s(1);
st2 = s(2);
while true
    
    if count == 20
        break;
    end
    count = count + 1;
    t = [t count];
    if t_nxt(1) < t_nxt(2)
        im = 1;
        impl = 2;
        t_nxt(2) = t_nxt(2) - t_nxt(1);

    else
        im = 2;
        impl = 1;
        t_nxt(1) = t_nxt(1) - t_nxt(2);
    end
    if count ~=1

        s = ns(im,:); %updating the state
    end
    %t_nxt(1) = t_nxt(2) is possible if the bus are joined or there is some
    %coincidence
    
    st1 = [st1 s(1)];
    st2 = [st2 s(2)];
    e = im + 5;
    epl = impl + 5;
    l = im + 2;
    lpl = impl + 2;
    sp = 5;
    hw = headwayc(s, t_nxt,dis_stp,v_bus, count);
    %Here we will calculate the optimal action let it be aopt
    disp('state')
    disp(s)
    fprintf('count- %f \n',count)
    fprintf('s(e)- %f \n',s(e))
%Uncomment to generate random aopt
%     if s(e) == 1
%         while true
%             aopt = randi(4);
%             if aopt ~= 3
%                 break;
%             end
%         end
%     else
%         while true
%             aopt = randi(3) + 2;
%             if aopt ~= 4
%                 break;
%             end
%         end
%     end

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
    v = zeros(1,size(avac,2));
    idx = 0;
    for acts = avac
        idx = idx + 1;
        if acts == 1 || acts == 4
            vsum = vsumstsk(s,[acts;im],lmd,p_s,vinf,n_s,cap);
        elseif acts == 2
            ts = s;
            ts(im+5) = 0;
            if ts(5) == 0
               ts(6) = 0; ts(7) = 0;
            end
            vsum = vinf(ts(1),ts(2),ts(3)+1,ts(4)+1,ts(5)+1, ts(6)+1, ts(7)+1);
        elseif acts == 3
            ts = s;
            if s(im) == n_s
               simp = 1;
            else
               simp = s(im) +1;
            end

            ts(1) = simp;
            ts(2) = simp;
            ts(5) = 0;
            ts(6) = 1; ts(7) = 1;
            vsum = vinf(ts(1),ts(2),ts(3)+1,ts(4)+1,ts(5)+1, ts(6)+1, ts(7)+1);
        else
            ts = s;
            if s(im) == n_s
               simp = 1;
            else
               simp = s(im) +1;
            end
            ts(im) = simp;
            ts(im + 5)  = 1; 
            if ts(5) == 0
               ts(1) = simp; ts(2) = simp;
               ts(6) = 1; ts(7) = 1;
            end
            vsum = vinf(ts(1),ts(2),ts(3)+1,ts(4)+1,ts(5)+1, ts(6)+1, ts(7)+1);
        end
        v(idx) = reward(s,[acts;im],lmd(s(im)),p_s(s(im)),w_st, w_b, alpha, beta, delta) + gamma*vsum;
        
                          

    end
    [vmax,ind] = max(v);
    aopt = avac(ind);


    fprintf('aopt- %f \n',aopt)
    if s(im) == n_s
        nstop = 1;
    else
        nstop = s(im) + 1;
    end
    
    if aopt == 1 %stop
        if s(sp) == 0
            ns(im,:) = s;
            pd = binornd(s(3)+s(4),p_s(s(im)));
            ns(im, l) = ns(im,l) - pd;
            disp(ns(im,l))
            if ns(im,l) < 0    
                
                ns(im,lpl) = ns(im, lpl) + ns(im, l);
                ns(im,l) = 0;
            end
            disp(ns(im,lpl))
            pb = poissrnd(lmd(s(im))*hw(im));
            pb = min(cap_bus - (ns(im,l)+ns(im,lpl)), pb);
            ns(im,l) = ns(im,l) + pb;
            %disp(ns(im,l))
            if ns(im,l) > unit_cap
                if count == 3
                    disp('issue')
                end
                ns(im,lpl) = ns(im,lpl) + ns(im,l) - unit_cap;
                ns(im,l) = unit_cap;
            end
            ns(im,6) = 0;ns(im,7) = 0; 
            tspent = pd*t_al + pb*t_bo;
            t_nxt = [tspent tspent];          
        else  %If bus are splitted
            ns(im,:) = s; %ns is the next state
            ns(im,e) = 0;
            pd = binornd(s(l),p_s(s(im)));
            ns(im,l) = ns(im,l) - pd;
            pb1 = poissrnd(lmd(s(im))*hw(im));
            pb = min(unit_cap - s(l), pb1);
            ns(im,l) = ns(im,l) + pb;
            tspent = pd*t_al + pb*t_bo;
            t_nxt(im) = tspent;
        end
    elseif aopt == 2 %skip
        ns(im,:) = s;
        ns(im,e) = 0;
        tspent = 0;       
        t_nxt(im) = tspent;
        if s(sp) == 0
            ns(im,epl) = 0;
            t_nxt(impl) = tspent;
        end
    
    elseif aopt == 3 %Join
        ns(im,:) = s;
        ns(im,sp) = 0;        
        t_nxt = [dis_stp(s(im))/v_bus dis_stp(s(im))/v_bus];
        ns(im,im) = nstop;
        ns(im,impl) = ns(im,im);
        s(e) = 1;
        s(impl + 5) = 1;
        tspent = hw(impl);
        t_nxt(im) = tspent + dis_stp(s(im))/v_bus;
    elseif aopt == 4 %Split, in split we always skip the imule 1 and stop the mudule 2
        ns(im,:) = s;
        pback = min(floor(p_s(s(im))*s(3)), unit_cap- s(4));
        ns(im,4) = s(4) + pback;
        ns(im,3) = s(3) - pback;
        pd = binornd(s(4),p_s(s(im)));
        ns(im,4) = ns(im,4) - pd;
        pb = poissrnd(lmd(s(im))*hw(im)); 
        pb = min(unit_cap - ns(im,4), pb);
        ns(im,4) = ns(im,4) + pb;
        tspent = pd*t_al + pb*t_bo;
        ns(im,6) = 0; ns(im,7) = 0;
        ns(im,sp) = 1;
        t_nxt = [0 tspent];
        ns(impl,:) = ns(im,:);
    else %aopt == 5
        ns(im,:) = s;
        ns(im,im) = nstop;
        if s(sp) == 0
            ns(im,6) = 1;
            ns(im,7) = 1;
            ns(im,impl) = nstop;
            t_nxt = [dis_stp(s(im))/v_bus dis_stp(s(im))/v_bus];
        else
            disp('hello')
            ns(im,e) = 1;
            t_nxt(im) = dis_stp(s(im))/v_bus;
        end
    end
    if s(sp) == 0
        ns(impl,:) = ns(im, :);
    end
    disp('t_nxt')
    disp(t_nxt)
    disp(ns)
end
figure(1)
plot(st1, t)
hold on 
plot(st2,t)




