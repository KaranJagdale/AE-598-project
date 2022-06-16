rng(1)
n_b = 2;
n_s = 4;
n_a = 4;
cap = [8 8];
lmd = randi(2,1,n_s); %arriving passengers are poisson distributed 10 passengers in 2 mins
lmd = lmd/24;
p_s = rand(1,n_s)*0.6+0.2;
 alpha = 2; beta = 5; 
%vinf = Vinf(n_a, n_b, n_s, cap, lmd,p_s,w_st, w_b, alpha, beta, delta);
v_bus = 20*5/18; % Speed of bus 20 Km/h
gamma = 0.8;
cap_bus =16;
unit_cap = cap_bus/2;
v_pas = 5.4*5/18; %Passenger speed in m/s
%dis_stp = 50*(rand(1,n_s) + 1); %Distance between stops distributed between 300 - 600 meters
dis_stp = [1000 900 580 800];
w_st = mean(dis_stp)/v_pas;
w_b = sum(dis_stp)/2/v_bus;
delta = w_b;

t_bo = 5; %boarding time per passenger in seconds
t_al = 2; %Alighting time per passenger in seconds
