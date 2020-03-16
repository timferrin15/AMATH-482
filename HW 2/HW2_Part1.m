%% Part 1
clear; close all; clc
load handel
S = y';
%figure(1)
%plot((1:length(S))/Fs,S);
%xlabel('Time [sec]');
%ylabel('Amplitude');
%title('Signal of Interest, v(n)');

%p8 = audioplayer(v,Fs);
%playblocking(p8);

L = length(S)/Fs; n = length(S); 
t2=linspace(0,L,n+1);t=t2(1:n);
k=(1/L)*[0:ceil(n/2-1) ceil(-n/2):-1];
ks=fftshift(k);
St = fft(S);

figure(1)
subplot(2,1,1)
plot(t,S,'k','Linewidth',2)
set(gca,'Fontsize',16), xlabel('Time (t)'), ylabel('S(t)')

subplot(2,1,2)
plot(ks,abs(fftshift(St))/max(abs(St)),'r','Linewidth',2);
set(gca,'Fontsize',16)
set(gca,'Fontsize',16)
xlabel('frequency (Hz)'), ylabel('FFT(S)')


%% Spectrograms for varying window sizes (Gaussian)
figure(7)

a_vec = [100 80 60 10];
for jj = 1:length(a_vec)    
    a = a_vec(jj); %a_vec(jj);    
    tslide=0:0.05:L;    
    Sgt_spec = zeros(length(tslide),n);    
    for j=1:length(tslide)        
        g=exp(-a*(t-tslide(j)).^2);         
        Sg=g.*S;         
        Sgt=fft(Sg);         
        Sgt_spec(j,:) = fftshift(abs(Sgt));     
    end
    
    subplot(2,2,jj)    
    pcolor(tslide,ks,Sgt_spec.'),     
    shading interp     
    title(['a = ',num2str(a)],'Fontsize',16)
    xlabel('Time (sec)')
    ylabel('Frequency (Hz)')
    set(gca,'Fontsize',16)     
    colormap(hot) 
    colorbar
end

sgtitle('Gaussian Gabor Transform Spectrograms for Different Widths')

%% Spectrograms for varying window sizes (Mexican Hat)

a_vec = [100 80 60 10];
for jj = 1:length(a_vec)    
    a = a_vec(jj); %a_vec(jj);    
    tslide=0:.01:L;    
    Sgt_spec = zeros(length(tslide),n);    
    for j=1:length(tslide)        
        g=(1-a*t.^2).*exp(-a*(.5*t.^2));
        Sg=g.*S;         
        Sgt=fft(Sg);         
        Sgt_spec(j,:) = fftshift(abs(Sgt));     
    end
    
    subplot(2,2,jj)    
    pcolor(tslide,ks,Sgt_spec.'),     
    shading interp     
    title(['a = ',num2str(a)],'Fontsize',16)
    xlabel('Time (sec)')
    ylabel('Frequency (Hz)')
    set(gca,'ylim',[-500 500],'Fontsize',16)     
    colormap(hot) 
    colorbar
end

sgtitle('Mexican Hat Gabor Transform Spectrograms for Different Widths')

%%

tslide=0:0.1:10;

for j=1:length(tslide)
    g=(1-a*t.^2).*exp(-a*(.5*t.^2));
    Sg=g.*S;
    Sgt=fft(Sg);
    
    subplot(3,1,1)
    plot(t,S,'k','Linewidth',2)
    hold on
    plot(t,g,'m','Linewidth',2)
    hold off
    set(gca, 'Fontsize', 16), xlabel('Time (t)'), ylabel('S(t)')
    
    subplot(3,1,2)
    plot(t,Sg,'k','Linewidth',2)
    set(gca,'Fontsize',16), xlabel('Time (t)'), ylabel('Sg(t)')    
        
    subplot(3,1,3)     
    plot(ks,abs(fftshift(Sgt))/max(abs(Sgt)),'r','Linewidth',2); 
    %axis([-50 50 0 1])    
    set(gca,'Fontsize',16)    
    xlabel('frequency (\omega)'), ylabel('FFT(Sg)')    
    drawnow    
    pause(0.1)
end





