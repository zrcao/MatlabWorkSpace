function yy=nyq_2zz(f_sym,f_smpl,alpha,m_sym,n_odd,q_ans)

% function yy=nyq_2xx(f_sym,f_smpl,alpha,m_sym,n_odd,q_ans);...
% m_smy = number of symbols in filter (number taps = m_sym*f_smpl)
% if m_sym is 0, routine selects m_sym for 80 db sidelobes
% n_odd=0 for even number of taps, n_odd=1 for odd number of taps
% q_ans=0 for 1/f sidlobes, q_ans=1 for equiripple sidelobes 
% try yy=nyq_2zz(1,8,0.25,12,1,0);...


wt=1.4;
wt=0.25;
wt=0.25;
%wt=1.0;
%wt=10;
wt=1;

OS=f_smpl/f_sym;

NN=1.6*3*f_smpl/(alpha*f_sym);
NN=ceil(NN/OS)*OS;
n_sym=NN/OS;

if m_sym<=0
    m_sym=n_sym;
end

% fprintf('Suggested Number of Symbols in Filter  = %3.0f',n_sym)
% fprintf(' \n')
% m_sym=input('Enter Your Choice of Number of Symbols =  ');

% fprintf('Even or Odd Number of Samples?')
% fprintf(' \n')
% n_odd=input('Enter Your Choice: 0 for Even, 1 for Odd =  ');
% 
% if isempty(n_odd)==1
%     n_odd=1;
% end

if n_odd==0;
    n_add=1;
elseif n_odd==1;
    n_add=0;
end

n_sym=2*ceil(m_sym/2);
n_sym=m_sym;

NN=m_sym*f_smpl/f_sym;
% q_ans=input(' equiripple sidelobes? (1=Y, 0=N) -> '); 

n_trans=OS*250;
zz=zeros(1,n_trans);
xx=(-0.5:1/n_trans:.5-1/n_trans)*f_smpl;

% figure(1)
% subplot(3,1,2)
% pp1=plot(xx,zz,'b','erasemode','xor');
% axis([0 f_sym -100 10]);
% 
% hold on
% plot([1 1]*0.5*f_sym, [-90 10],'r','linewidth',2)
% plot([1 1]*0.5*f_sym*(1-alpha), [-10 10],'r','linewidth',2)
% plot([1 1]*0.5*f_sym*(1+alpha), [-100 -40],'r','linewidth',2)
% pp1a=plot([1 1]*0.5*f_sym*(1-alpha), [-10 10],'r','linewidth',2,'erasemode','xor');
% pp1b=plot([1 1]*0.5*f_sym*(1-alpha), [-100 10],'r','linewidth',2,'erasemode','xor');
% 
% hold off
% txt=text(0.72,-30,['iteration ',num2str(0)]);
% grid
% title('Evolving Spectrum of Filter')
% 
% subplot(3,1,3)
% pp2=plot(xx,zz,'b','erasemode','xor');
% hold on
% plot([1 1]*0.5*f_sym*(1-alpha), [-0.1 0.1],'r','linewidth',2)
% pp3=plot([1 1]*0.5*f_sym*(1-alpha), [-0.1 0.1],'r','linewidth',2,'erasemode','xor');
% hold off
% grid
% title('Detail of Passband Spectrum of Filter')
% axis([0 0.5*f_sym -0.01 0.01]);

mm=1;
delta=0.0005;

% subplot(3,1,1)
f1=0.5*(1-alpha)*f_sym;
f2=0.5*f_sym;
f3=0.5*(1+alpha)*f_sym;
f4=0.5*f_smpl;

if q_ans==0
    hh=remez(NN-n_add,[0 f1 f2 f2 f3 f4]/f4,{'myfrf',[1 1 sqrt(2)/2 sqrt(2)/2 0 0]},[1 1 wt]);
else
    hh=remez(NN-n_add,[0 f1 f2 f2 f3 f4]/f4,[1 1 sqrt(2)/2 sqrt(2)/2 0 0],[1 1 wt]);
end    
  
fhh=20*log10(abs(fft(hh,n_trans))+0.000001);
% plot(xx,fftshift(fhh));
% hold on
% plot([1 1]*0.5*f_sym*(1-alpha), [-10 10],'r','linewidth',2)
% plot([1 1]*0.5*f_sym*(1+alpha), [-100 -40],'r','linewidth',2)
% plot([1 1]*0.5*f_sym, [-80 10],'r','linewidth',2)
% hold off
% text(0.72,-30,['iteration ',num2str(1)]);
% grid
% axis([0 f_sym -100 10]);
% title('Passband Spectrum of harris-Moerder Filter: Initial Condition')

% measure isi
rr1=conv(hh,hh);
rr1=rr1/max(rr1);

q1=find(rr1==1);
r1=length(rr1(OS:OS:length(rr1)));

if n_odd==0
rms1=sqrt(rr1(OS:OS:length(rr1))*rr1(OS:OS:length(rr1))'-1);
else
rms1=sqrt(rr1(OS+1:OS:length(rr1))*rr1(OS+1:OS:length(rr1))'-1);
end

f1_d=f1;
f3_d=f3;
rms_ref=rms1;

while abs(delta)>0.0000001; 
%hh=remez(NN-1,[0 beta*f1 f2 f3]/f3,[1 1 0 0],[1 wt]);

f1_d=f1_d+delta;
f3_d=f3_d+delta;
if q_ans==0
    hh=remez(NN-n_add,[0 f1_d f2 f2 f3_d f4]/f4,{'myfrf',[1 1 sqrt(2)/2 sqrt(2)/2 0 0]},[1 1 wt]);
else
    hh=remez(NN-n_add,[0 f1_d f2 f2 f3_d f4]/f4,[1 1 sqrt(2)/2 sqrt(2)/2 0 0],[1 1 wt]);
end   

    rr1=conv(hh,hh);
    rr1=rr1/max(rr1);
    
if n_odd==0
  rms1=sqrt(rr1(OS:OS:length(rr1))*rr1(OS:OS:length(rr1))'-1); 
else
rms1=sqrt(rr1(OS+1:OS:length(rr1))*rr1(OS+1:OS:length(rr1))'-1);
end

[mm f1_d rms1];
if rms_ref>=rms1;
    rms_ref=rms1;
else
    delta=-delta/2;
end

% fhh=20*log10(abs(fft(hh,n_trans))+0.000001);
% set(pp1,'xdata',xx,'ydata',fftshift(fhh));
% set(pp1a,'xdata',[1 1]*f1_d,'ydata',[-10 10]);
% set(pp1b,'xdata',[1 1]*f3_d,'ydata',[-100 -40]);
% set(pp2,'xdata',xx,'ydata',fftshift(fhh));
% set(pp3,'xdata',[1 1]*f1_d,'ydata',[-0.1 0.1]);
% 
% set(txt,'string',['iteration ',num2str(mm)]) 
% pause(0.1)

mm=mm+1;
if mm==500
    delta=0;
end

end
yy=hh;
% 
% pause
% hh2a=rcosine(f_sym,2*f_smpl,'sqrt',alpha,floor(n_sym/2));
% if n_odd==0;
% hh2=hh2a(2:2:length(hh2a));
% else
% hh2=hh2a(1:2:length(hh2a));
% end    
% fhh2=abs(fft(hh2,n_trans));
% pk1=max(fhh2(1:floor(0.4*(1-alpha)*n_trans*f_sym/f_smpl)));
% pk2=min(fhh2(1:floor(0.4*(1-alpha)*n_trans*f_sym/f_smpl)));
% scl=0.5*(pk1+pk2);
% hh2=hh2/scl;
% fhh2=fftshift(20*log10(abs(fft(hh2,n_trans)+0.00001)));
% 
% figure(2)
% subplot(3,1,1)
% plot(xx,fftshift(fhh))
% grid
% % title('full spectrum of converged filter')
% hold on
% plot(xx,fhh2,'r')
% hold off
% axis([0 0.5*f_smpl -100 10])
% 
% title('Comparison of Converged and Standard rcosine Design' )
% 
% subplot(3,1,2)
% plot(xx,fftshift(fhh))
% grid
% hold on
% plot(xx,fhh2,'r')
% hold off
% axis([0 1 -100 10])
% title('Passband Comparison')
% 
% subplot(3,1,3)
% plot(xx,fftshift(fhh))
% grid
% hold on
% plot(xx,fhh2,'r')
% hold off
% axis([0 1 -.05 .05])
% title('Zoom to Passband')
% pause
% 
% figure(3)
% subplot(3,1,1)
% rr1=conv(hh,hh);
% rr1=rr1/max(rr1);
% 
% rr2=conv(hh2,hh2);
% rr2=rr2/max(rr2);
% 
% rr3=conv(hh,hh2);
% rr3=rr3/max(rr3);
% 
% q1=find(rr1==1);
% q2=find(rr2==1);
% q3=find(rr3==1);
% if n_odd==0
% tt1=max(abs(rr1(OS:OS:q1-1)));
% tt2=max(abs(rr2(OS:OS:q2-1)));
% tt3=max(abs(rr3(OS:OS:q3-1)));
% else
% tt1=max(abs(rr1(OS+1:OS:q1-1)));
% tt2=max(abs(rr2(OS+1:OS:q2-1)));
% tt3=max(abs(rr3(OS+1:OS:q3-1)));
% end
% tt=max([tt1 tt2 tt3]);
% r1=length(rr1(OS:OS:length(rr1)));
% r2=length(rr2(OS:OS:length(rr2)));
% r3=length(rr3(OS:OS:length(rr3)));
% 
% subplot(3,1,1)
% if n_odd==0
% stem(1:r1,rr1(OS:OS:length(rr1)))
% else
% stem(1:r1,rr1(OS+1:OS:length(rr1)))
% end    
% grid
% title('Auto Correlation, harris-Moerder Filter')
% axis([0 r1+1 -0.1 1.1])
% 
% subplot(3,1,2)
% if n_odd==0
% stem(1:r2,rr2(OS:OS:length(rr2)))
% else
% stem(1:r2,rr2(OS+1:OS:length(rr2)))
% end
% grid
% title('Auto Correlation rcosine Filter')
% axis([0 r2+1 -0.1 1.1])
% 
% subplot(3,1,3)
% if n_odd==0
% stem(1:r3,rr3(OS:OS:length(rr3)))
% else
% stem(1:r3,rr3(OS+1:OS:length(rr3)))
% end
% grid
% title('Cross Correlation rcosine and harris-Moerder Filter')
% axis([0 r2+1 -0.1 1.1])
% 
% pause
% subplot(3,1,1)
% axis([0 r1+1 -1.5*tt 1.5*tt])
% if n_odd==0
% pk1=sum(abs(rr1(OS:OS:length(rr1))))-1;
% rms1=rr1(OS:OS:length(rr1))*rr1(OS:OS:length(rr1))'-1;
% else
% pk1=sum(abs(rr1(OS+1:OS:length(rr1))))-1;
% rms1=rr1(OS+1:OS:length(rr1))*rr1(OS+1:OS:length(rr1))'-1;
% end
% rms1=sqrt(rms1);
% 
% txt=text(0.7*r1,1.2*tt,['MAX ISI = ',num2str(pk1)]);
% txt=text(0.7*r1,0.9*tt,['RMS ISI = ',num2str(rms1)]);
% 
% title('Detail: Auto Correlation of harris-Moerder Filter')
% 
% subplot(3,1,2)
% if n_odd==0
% pk2=sum(abs(rr2(OS:OS:length(rr2))))-1;
% rms2=rr2(OS:OS:length(rr2))*rr2(OS:OS:length(rr2))'-1;
% else
% pk2=sum(abs(rr2(OS+1:OS:length(rr2))))-1;
% rms2=rr2(OS+1:OS:length(rr2))*rr2(OS+1:OS:length(rr2))'-1;
% end
% rms2=sqrt(rms2);
% 
% txt=text(0.7*r2,1.2*tt,['MAX ISI = ',num2str(pk2)]);
% txt=text(0.7*r1,0.9*tt,['RMS ISI = ',num2str(rms2)]);
% axis([0 r2+1 -1.5*tt 1.5*tt])
% title('Detail: Auto Correlation of rcosine Filter')
% 
% subplot(3,1,3)
% if n_odd==0
% pk3=sum(abs(rr3(OS:OS:length(rr2))))-1;
% rms3=rr3(OS:OS:length(rr3))*rr3(OS:OS:length(rr3))'-1;
% else
% pk3=sum(abs(rr3(OS+1:OS:length(rr2))))-1;
% rms3=rr3(OS+1:OS:length(rr3))*rr3(OS+1:OS:length(rr3))'-1;    
% end
% rms3=sqrt(rms3);
% 
% txt=text(0.7*r2,1.2*tt,['MAX ISI = ',num2str(pk3)]);
% txt=text(0.7*r1,0.9*tt,['RMS ISI = ',num2str(rms3)]);
% axis([0 r3+1 -1.5*tt 1.5*tt])
% title('Detail: Cross Correlation of harris-Moerder and rcosine Filter')
% pause
% 
% 
% 
% figure(4)
% subplot(3,1,1)
% plot((-0.5:1/n_trans:.5-1/n_trans)*f_smpl,fftshift(abs(fft(hh,n_trans))))
% hold on
% plot((-0.5:1/n_trans:.5-1/n_trans)*f_smpl,fftshift(abs(fft(hh2,n_trans))),'r')
% hold off
% grid
% axis([0 1 0 1.1])
% title('Spectrum; harris-Moerder Filter and rcosine Filter')
% 
% subplot(3,1,2)
% plot((-0.5:1/n_trans:.5-1/n_trans)*f_smpl,fftshift(abs(fft(rr1/sum(rr1),n_trans))))
% hold on
% plot((-0.5:1/n_trans:.5-1/n_trans)*f_smpl,fftshift(abs(fft(rr2/sum(rr2),n_trans))),'r')
% hold off
% grid
% axis([0 1 0 1.1])
% title('Spectrum; Squared Spectra')
% 
% subplot(3,1,3)
% der_1=conv([-1 0 1]*125,abs(fft(rr1/sum(rr1),n_trans)));
% der_2=conv([-1 0 1]*125,abs(fft(rr2/sum(rr2),n_trans)));
% 
% 
% plot((-0.5:1/n_trans:.5-1/n_trans)*f_smpl,fftshift(der_1(2:n_trans+1)))
% hold on
% plot((-0.5:1/n_trans:.5-1/n_trans)*f_smpl,fftshift(der_2(2:n_trans+1)),'r')
% hold off
% pk=max(der_1(2:n_trans));
% axis([0 1 0 1.1*pk])
% title('Spectral Derivative')
% grid
% % 
% % pause
% % figure(5)
% % subplot(2,1,1)
% % plot((-0.5:1/n_trans:.5-1/n_trans)*f_smpl,fftshift(abs(fft(hh,n_trans))))
% % hold on
% % plot((-0.5:1/n_trans:.5-1/n_trans)*f_smpl,fftshift(abs(fft(hh2,n_trans))),'r')
% % hold off
% % grid
% % axis([0 1 0 1.1])
% % title('Spectrum; harris-Moerder Filter and rcosine Filter')
% % 
% % subplot(2,1,2)
% % der_1a=conv([-1 0 1]*125,abs(fft(hh/sum(hh),n_trans)));
% % der_2a=conv([-1 0 1]*125,abs(fft(hh2/sum(hh2),n_trans)));
% % der_1a(1:2)=[0 0];
% % der_1a(n_trans+1:n_trans+2)=[0 0];
% % 
% % der_2a(1:2)=[0 0];
% % der_2a(n_trans+1:n_trans+2)=[0 0];
% % 
% % plot((-0.5:1/n_trans:.5-1/n_trans)*f_smpl,fftshift(der_1a(2:n_trans+1)))
% % hold on
% % plot((-0.5:1/n_trans:.5-1/n_trans)*f_smpl,fftshift(der_2a(2:n_trans+1)),'r')
% % hold off
% % pk=max(der_1a(2:n_trans));
% % axis([0 1 0 1.1*pk])
% % title('Spectral Derivative: Band Edge Filter')
% % grid
% % 
% % figure(6)
% % subplot(3,1,1)
% % plot(fftshift(real(ifft(fftshift(der_1a(1:1+n_trans/4))))))
% % grid
% % title('Even Symmetric Component of Impulse Response: fred filter')
% % 
% % subplot(3,1,2)
% % plot(fftshift(imag(ifft(fftshift(der_1a(1:1+n_trans/4))))))
% % grid
% % title('Odd Symmetric Component of Impulse Response: fred filter')
% % 
% % subplot(3,1,3)
% % plot(fftshift(real(ifft(fftshift(der_1a(1:1+n_trans/4))))+imag(ifft(fftshift(der_1a(1:1+n_trans/4))))))
% % grid
% % title('Total Impulse Response: fred filter')
% % 
% % figure(7)
% % subplot(3,1,1)
% % plot(fftshift(real(ifft(fftshift(der_2a(1:1+n_trans/4))))))
% % grid
% % title('Even Symmetric Component of Impulse Response: Cos Taper filter')
% % 
% % subplot(3,1,2)
% % plot(fftshift(imag(ifft(fftshift(der_2a(1:1+n_trans/4))))))
% % grid
% % title('Odd Symmetric Component of Impulse Response: Cos Taper filter')
% % 
% % subplot(3,1,3)
% % plot(fftshift(real(ifft(fftshift(der_2a(1:1+n_trans/4))))+imag(ifft(fftshift(der_2a(1:1+n_trans/4))))))
% % grid
% % title('Total Impulse Response: Cos Taper filter')
% % 
% % figure(8)
% % subplot(2,1,1)
% % plot((-0.5:1/n_trans:0.5-1/n_trans)*f_smpl,fftshift(abs(der_1a(2:n_trans+1)))/max(der_1a),'r')
% % hold on
% % plot((-0.5:1/n_trans:0.5-1/n_trans)*f_smpl,fftshift(abs(fft(hh/sum(hh),n_trans))))
% % hold off
% % grid
% % axis([-0.5*f_smpl 0.5*f_smpl 0 1.1])
% % title('Matched Filter and Band Edge Filter (fred filter)')
% % 
% % subplot(2,1,2)
% % plot((-0.5:1/n_trans:0.5-1/n_trans)*f_smpl,fftshift(abs(der_2a(2:n_trans+1)))/max(der_2a),'r')
% % hold on
% % plot((-0.5:1/n_trans:0.5-1/n_trans)*f_smpl,fftshift(abs(fft(hh2/sum(hh2),n_trans))))
% % hold off
% % grid
% % axis([-0.5*f_smpl 0.5*f_smpl 0 1.1])
% % title('Matched Filter and Band Edge Filter (Cos Taper filter)')
% % 
% % % figure(4)
% % % subplot(2,1,1)
% % % rr3=conv(hh,hh2);
% % % rr3=rr3/max(rr3);
% % % r3=length(rr3(8:8:length(rr3)));
% % % q3=find(rr3==1);
% % % tt3=max(abs(rr3(8:8:q3-8)));
% % % stem(1:r3,rr3(8:8:length(rr3)))
% % % grid
% % % title('cross correlation, freds filter and rcosine')
% % % axis([0 r3+1 -0.1 1.1])
% % % subplot(2,1,2)
% % % stem(1:r3,rr3(8:8:length(rr3)))
% % % grid
% % % title('detail of cross correlation ')
% % % axis([0 r3+1 -1.5*tt3 1.5*tt3])
% % % pk3=sum(abs(rr3(8:8:length(rr3))))-1;
% % % txt=text(0.7*r3,1.2*tt3,['peak ISI = ',num2str(pk3)]);
% % 
% % % pk1
% % % pk2
% % % pk3
% % 
% % % 
% % % figure(6)
% % % subplot(3,1,1)
% % % v=find(rr1>0.9);
% % % rr1(v)=0;
% % % hist(rr1(OS:OS:length(rr1)),20)
% % % subplot(3,1,2)
% % % v=find(rr2>0.9);
% % % rr2(v)=0;
% % % hist(rr2(OS:OS:length(rr2)),20)
% % % subplot(3,1,3)
% % % v=find(rr3>0.9);
% % % rr3(v)=0;
% % % hist(rr3(OS:OS:length(rr3)),20)
% % 
% % 
% % % > vv=get(gca,'grid')
% % % vv = :
% % % > set(gca,'gridlinestyle','--')