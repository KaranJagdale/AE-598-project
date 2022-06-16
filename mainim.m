load("vinfcor.mat")
env;
%Assuming we have the optimal action as aopt
state0 = [1 1 0 0 0 1 1]; 
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
skcount = 0;
sjcount = 0;
spcount = 0;
stcount = 0;
nbcount = 0;
Aopt = [];
Time = 0;
time = 0;
cumurev = 0;
hor = 1000;
while true
    
    if count == hor
        break;
    end
    count = count + 1;
    t = [t count];
%     disp('t_nxt to choose module')
%     disp(t_nxt)
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
    time = time + t_nxt(im);
    Time = [Time time];
    %t_nxt(1) = t_nxt(2) is possible if the bus are joined or there is some
    %coincidence
    
    if count ~=1 
        if aopt ~=3
            ns(impl,im) = s(im); ns(impl,im+2) = s(im+2); ns(impl,im+5) = s(im+5); %magic assignment
        end
    end
    st1 = [st1 s(1)];
    st2 = [st2 s(2)];
    e = im + 5;
    epl = impl + 5;
    l = im + 2;
    lpl = impl + 2;
    sp = 5;
    t_nxt(im) = 0;
    %disp('t_nxt after reach')
    %disp(t_nxt)
    hw = headwayc(s, t_nxt,dis_stp,v_bus, count);
    %Here we will calculate the optimal action let it be aopt
%     disp('state')
%     disp(s)
%     fprintf('count- %f \n',count)
%     fprintf('s(e)- %f \n',s(e))
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

%Splitting at the first time instant and always stopping for the rest of
%the time-regular bus operation
% if s(e) == 1
%     if count ==1
%         aopt = 4;
%     else
%         aopt = 1;
%     end
% else
%     aopt = 5;
% end

%Uncomment below to apply zaid type policy
   H = sum(dis_stp)*3/v_bus/4;
    H = 200;
    %disp('hw')
    %disp(hw)
    if s(e) == 1
        if s(sp) == 0
            if hw(im) > H
                aopt = 4;
            else
                aopt = 1;
            end
        else
            if hw(im) > H
                aopt = 2;
            else
                aopt = 1;
            end
        end
    else
        aopt = 5;
    end

%     if s(sp) == 0 
%        if s(e) == 1
%            avac = [1,2,4]; %stop, skip, split
%        else
%           avac = 5; %Only nextbs
%        end
%     else
%        if s(e) == 1
%           avac = [1,2]; %stop, skip
%        else
%           avac = [3,5];
%        end
%     end
%     v = zeros(1,size(avac,2));
%     idx = 0;
%     for acts = avac
%         idx = idx + 1;
%         if acts == 1 || acts == 4
%             vsum = vsumstsk(s,[acts;im],lmd,p_s,vinf,n_s,cap);
%         elseif acts == 2
%             ts = s;
%             ts(im+5) = 0;
%             if ts(5) == 0
%                ts(6) = 0; ts(7) = 0;
%             end
%             vsum = vinf(ts(1),ts(2),ts(3)+1,ts(4)+1,ts(5)+1, ts(6)+1, ts(7)+1);
%         elseif acts == 3
%             ts = s;
%             if s(im) == n_s
%                simp = 1;
%             else
%                simp = s(im) +1;
%             end
% 
%             ts(1) = simp;
%             ts(2) = simp;
%             ts(5) = 0;
%             ts(6) = 1; ts(7) = 1;
%             vsum = vinf(ts(1),ts(2),ts(3)+1,ts(4)+1,ts(5)+1, ts(6)+1, ts(7)+1);
%         else
%             ts = s;
%             if s(im) == n_s
%                simp = 1;
%             else
%                simp = s(im) +1;
%             end
%             ts(im) = simp;
%             ts(im + 5)  = 1; 
%             if ts(5) == 0
%                ts(1) = simp; ts(2) = simp;
%                ts(6) = 1; ts(7) = 1;
%             end
%             vsum = vinf(ts(1),ts(2),ts(3)+1,ts(4)+1,ts(5)+1, ts(6)+1, ts(7)+1);
%         end
%         v(idx) = reward(s,[acts;im],lmd(s(im)),p_s(s(im)),w_st, w_b, alpha, beta, delta) + gamma*vsum;
%         
%                           
% 
%     end
%     [vmax,ind] = max(v);
%     aopt = avac(ind);
%     if s(sp) == 0 
%        if s(e) == 1
%            avac = [1,2,4]; %stop, skip, split
%        else
%           avac = 5; %Only nextbs
%        end
%     else
%        if s(e) == 1
%           avac = [1,2]; %stop, skip
%        else
%           avac = [3,5];
%        end
%     end
%     r = zeros(1,size(avac,2));
% 
%     for i=1:size(r,2)
%         r(i) = reward(s,[avac(i);im],lmd(s(im)),p_s(s(im)),w_st, w_b, alpha, beta, delta);
%         [maxr, ind] = max(r);
%         aopt = avac(ind);
%     end
    Aopt = [Aopt aopt];
    %fprintf('aopt- %f \n',aopt)
    if s(im) == n_s
        nstop = 1;
    else
        nstop = s(im) + 1;
    end
    rw = reward(s,[aopt;im],lmd(s(im)),p_s(s(im)),w_st, w_b, alpha, beta, delta);
    cumurev = cumurev + rw;
    if aopt == 1 %stop
        
        stcount = stcount + 1;
        if s(sp) == 0
            ns(im,:) = s;
            pd = binornd(s(3)+s(4),p_s(s(im)));
            ns(im, l) = ns(im,l) - pd;
           % disp(ns(im,l))
            if ns(im,l) < 0    
                
                ns(im,lpl) = ns(im, lpl) + ns(im, l);
                ns(im,l) = 0;
            end
            %disp(ns(im,lpl))
            pb = poissrnd(lmd(s(im))*hw(im));
            pb = min(cap_bus - (ns(im,l)+ns(im,lpl)), pb);
            ns(im,l) = ns(im,l) + pb;
            %disp(ns(im,l))
            if ns(im,l) > unit_cap
                
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
        skcount = skcount + 1;
        ns(im,:) = s;
        ns(im,e) = 0;
        tspent = 0;       
        t_nxt(im) = tspent;
        if s(sp) == 0
            ns(im,epl) = 0;
            t_nxt(impl) = tspent;
        end
    
    elseif aopt == 3 %Join
        sjcount = sjcount + 1;
        ns(im,:) = s;
        ns(im,sp) = 0;        
        %t_nxt = [dis_stp(s(im))/v_bus dis_stp(s(im))/v_bus];
        ns(im,im) = nstop;
        ns(im,impl) = ns(im,im);
        s(e) = 1;
        s(impl + 5) = 1;
        tspent = hw(impl);
        t_nxt(im) = tspent + dis_stp(s(im))/v_bus;
        ns(impl,:) = ns(im,:);
    elseif aopt == 4 %Split, in split we always skip the imule 1 and stop the mudule 2
        spcount = spcount +1;
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
        nbcount = nbcount +1;
        ns(im,:) = s;
        ns(im,im) = nstop;
        if s(sp) == 0
            ns(im,6) = 1;
            ns(im,7) = 1;
            ns(im,impl) = nstop;
            t_nxt = [dis_stp(s(im))/v_bus dis_stp(s(im))/v_bus];
        else
            %disp('hello')
            ns(im,e) = 1;
            t_nxt(im) = dis_stp(s(im))/v_bus;
        end
    end
    if s(sp) == 0
        ns(impl,:) = ns(im, :);
    end
    
    %disp(ns)
end
disp(cumurev/hor)
counts = [stcount, skcount,spcount,sjcount,nbcount];
disp(counts)
figure(1)
plot(Time(150:180), st1(150:180))
hold on 
plot(Time(150:180),st2(150:180))
legend('module 1', 'module 2')
xlabel('time (seconds)')
ylabel('Bus stop')
box off
yticks([1 2 3 4])
axis()
figure(3)
plot(Aopt, t(2:end))




