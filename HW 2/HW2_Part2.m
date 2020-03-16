% Part 2

clear; close all; clc
[y,Fs] = audioread('music2.wav');
y=y';
tr_piano=length(y)/Fs;  % record time in seconds

% Piano Stuff
L = tr_piano; n = length(y);
t2=linspace(0,L,n+1); t=t2(1:n);
k=(1/L)*[0:ceil(n/2-1) ceil(-n/2):-1];
ks=fftshift(k);
yt = fft(y);

%p8 = audioplayer(y,Fs); playblocking(p8);

%% Plot the signal and its fft

figure(1)
subplot(2,1,1)
hold on
plot(t,y,'k','Linewidth',2)
set(gca,'Fontsize',16), xlabel('Time (t)'), ylabel('S(t)')

subplot(2,1,2)
plot(ks,abs(fftshift(yt))/max(abs(yt)),'r','Linewidth',2);
set(gca,'xlim',[-600 600],'Fontsize',16)
xlabel('frequency (Hz)'), ylabel('FFT(Sp)')
%% Find the main frequencies

firstLoc = k(abs(yt) == max(abs(yt((238<k)&(k<271)))));
firstNote = firstLoc(1)
secondLoc = k(abs(yt) == max(abs(yt((278<k)&(k<306)))));
secondNote = secondLoc(1)
thirdLoc = k(abs(yt) == max(abs(yt((306<k)&(k<342)))));
thirdNote = thirdLoc(1)

%% Spectrogram of unfiltered frequency signal
    a=60;
    sigma=1;
    tslide=0:0.1:L; % 4 SHOULD BE L, BUT IT'S 4 RN TO SAVE COMPUTATION TIME
    yht_spec = zeros(length(tslide),n);
    for j=1:length(tslide)    
        g=exp(-a*(t-tslide(j)).^2);
        Sg=g.*y;
        ygt=fft(Sg);  
        ygt_spec(j,:) = fftshift(abs(ygt)); % We don't want to scale it
    end
    
    figure(3)
    pcolor(tslide,ks,ygt_spec.') 
    shading interp 
    set(gca,'Ylim',[0 600],'Fontsize',16)
    xlabel('Time (sec)')
    ylabel('Frequency (Hz)')
    title('Music Score Piano (Spectrogram)')
    colormap(hot)
    
    print(gcf,'ScorePiano.png','-dpng')

