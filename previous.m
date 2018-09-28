function [sys,x0,str,ts] = previous(t,x,u,flag)
switch flag,
  case 0,
    [sys,x0,str,ts]=mdlInitializeSizes;
  case 1,
    sys=[];
  case 2,
    sys=[];
  case 3,
    sys=mdlOutputs(t,x,u);
  case 4,
    sys=[];
  case 9,
    sys=[];
   otherwise
    error(['Unhandled flag = ',num2str(flag)]);
end
% mdlInitializeSizes
function [sys,x0,str,ts]=mdlInitializeSizes

sizes = simsizes;

sizes.NumContStates  = 0;
sizes.NumDiscStates  = 0;
sizes.NumOutputs     = 3;
sizes.NumInputs      = 18;
sizes.DirFeedthrough = 1;
sizes.NumSampleTimes = 1;   % at least one sample time is needed

sys = simsizes(sizes);
x0  = [];
str = [];
ts  = [0.00001 0];     % 采样时间0.002s,500 Hz

% mdlOutputs

function sys=mdlOutputs(t,x,u)
persistent a_prev  b_prev c_prev d_prev e_prev f_prev g_prev h_prev i_prev 
persistent j_prev k_prev l_prev 
global Udc Uc_A Uc_B Uc_C Io_A Io_B Io_C
global Io_A_1 Io_B_1 Io_C_1 Uo_A Uo_B Uo_C
global Ts Rs Ls


    
a_prev=u(1); b_prev=u(2);c_prev=u(3);d_prev=u(4);e_prev=u(5);f_prev=u(6);
g_prev=u(7);h_prev=u(8);i_prev=u(9);j_prev=u(10);k_prev=u(11);l_prev=u(12);
Io_A=u(13); Io_B=u(14); Io_C=u(15);Uc_A=u(16); Uc_B=u(17); Uc_C=u(18);
if isempty(a_prev)
a_prev=1; b_prev=1;c_prev=0;d_prev=0;e_prev=0;f_prev=0;
g_prev=1;h_prev=1;i_prev=1;j_prev=0;k_prev=0;l_prev=0;
end



Ts=0.00001; Rs=5; Ls=0.006;

Udc=(a_prev-d_prev)*Uc_A+(b_prev-e_prev)*Uc_B+(c_prev-f_prev)*Uc_C;
Uo_A=Udc*(1/3)*(2*g_prev-1*h_prev-1*i_prev); Uo_B=Udc*(1/3)*(2*g_prev-1*h_prev-1*i_prev); Uo_C=Udc*(1/3)*(2*g_prev-1*h_prev-1*i_prev);
 Io_A_1=Ts/(Rs*Ts+Ls)*(Ls/Ts*Io_A+Uo_A);
 Io_B_1=Ts/(Rs*Ts+Ls)*(Ls/Ts*Io_B+Uo_B);
 Io_C_1=Ts/(Rs*Ts+Ls)*(Ls/Ts*Io_C+Uo_C);
 
 sys(1)=Io_A_1; sys(2)=Io_B_1; sys(2)=Io_C_1;

