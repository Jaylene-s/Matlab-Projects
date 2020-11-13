%part 1 
tic; override={'TT',10};mdNVE000; toc; clear('override');
%Elapsed time is 1.248784 seconds.

%part 2 
tic; override={'TT',20};mdNVE000; toc; clear('override');
%Elapsed time is 1.149984 seconds.

%part 3 
override={'phi_set',.7,'KE0',1,'TT', 20}; mdNVE000;
t=(1:Nt)*dt;                         % make a time variable from dt to TT
plot(t,[Ek Ep Ek+Ep],'linewidth',3);  % concatenate variable to add to plot
set(gca,'fontsize',20);              % make font bigger
xlabel('Time');                       % axis labels
ylabel('Energy');

%part 4
 %new 
figure(1);
[nn,bb]=hist(vxs(:),-.5:.25:.5);plot(bb,nn); %bin size anything lower is not enough noise and anything higher is too much noise
figure(2);
[nn,bb]=hist(vys(:),-.5:.25:.5);plot(bb,nn);
s=std (hist(vxs(:),-.5:.25:.5)) %6.6599e+04 for vys=6.5712e+04
m = mean(hist(vxs(:),-.5:.25:.5)) %32000 same mean

%To normalize:
ff=nn/sum(nn);
pp=ff/binsize
%pp = 0    0.0312    0.9341    0.0347         0

%This is the one to compare to the limiting normal distribution 

exp(-bb.^2/2/s/s)/sqrt(2*pi*s*s)

%ans =

 %  1.0e-05 *

  %  0.5990    0.5990    0.5990    0.5990    0.5990
  
 % plot the limiting distribution along with the data.
figure(1);
[nn,bb]=hist(vxs(:),-.5:.25:.5);plot(bb,pp); %bin size anything lower is not enough noise and anything higher is too much noise
figure(2);
[nn,bb]=hist(vys(:),-.5:.25:.5);plot(bb,pp);

%part 5
phi_set
%phi_set = 0.7000
    %Investigate what happens when you change phi_set with everything else the same. This is equivalent to changing the V in the NVE simulation. Show how the average Ek changes with density for 3 or 4 densities.
%change line 35 to =3 and 4 see what happens.


%last part #6
if(~exist('MDLabIdata.mat','file'))  % only run first time
  Nv=40;                  % number of points between .1 and .9 ~10 min
  phlist=(1:Nv)/Nv*.8+.1; % list of 40 numbers between .1 and .9
  Pc=zeros(1,Nv);         % store average Pc for each run
  Ks=zeros(1,Nv);         % " Ek for each run
  Es=zeros(1,Nv);         % " total for each run (check for conservation)
  for nv=1:Nv;            % loop
    override={'phi_set',phlist(nv),'Gb',8/5/sqrt(3)};    % set overrides
    mdNVE000;                                            % run simulation
    % find average value over last half of sim
    Pc(nv)=-mean(Ps(end/2:end,1,1)+Ps(end/2:end,2,2))/2; % average collisional
    Ks(nv)=mean(Ek(end/2:end));                          % kinetic
    Es(nv)=mean(Ek(end/2:end)+Ep(end/2:end));            % total for check
    % visual feedback
    figure(2);
    plot(phlist(1:nv),Lx*Ly*Pc(1:nv)./Ks(1:nv));
    drawnow;
    figure(1);
  end
  save('MDLabIdata.mat');     % save for later
else
  load('MDLabIdata.mat');     % load second time around
end

% nice plot:
plot(phlist,Lx*Ly*Pc./Ks,'o-','linewidth',2);
axis([.1 .9 0 20])
set(gca,'fontsize',20);
xlabel('$$\phi$$','interpreter','latex');
ylabel('$$\mathcal{X}(\phi)$$','interpreter','latex');


