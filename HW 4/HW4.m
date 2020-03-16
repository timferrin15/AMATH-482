%% Part 1)
% Load audio files
clear all;clc
[yBob1,~] = audioread('Bob1.wav');
[yBob2,~] = audioread('Bob2.wav');
[yBob3,~] = audioread('Bob3.wav');
[yBilly1,~] = audioread('Billy1.wav');
[yBilly2,~] = audioread('Billy2.wav');
[yBilly3,~] = audioread('Billy3.wav');
[yMozart1,~] = audioread('Mozart1.wav');
[yMozart2,~] = audioread('Mozart2.wav');
[yMozart3,~] = audioread('Mozart3.wav');

%% Processing audio clips and their spectrograms

yBob = [yBob1; yBob2];
yBilly = [yBilly1; yBilly2];
yMozart = [yMozart1; yMozart2];

trainNum = 60;
BobData = process(yBob,trainNum);
BillyData = process(yBilly,trainNum);
MozartData = process(yMozart,trainNum);

testNum = 50;
TestBob = process(yBob3,testNum);
TestBilly = process(yBilly3,testNum);
TestMozart = process(yMozart3,testNum);

%% Sample Spectrograms of the music
figure(1)
subplot(1,3,1)
audio = reshape(yBob,length(yBob)/4,4);
audio = audio(:,1);
Fs = 44100;
Fsnew = Fs/4;
i = 20;
spectrogram(audio((i*Fsnew):((i+5)*Fsnew)-1),1500,1400,'yaxis')
set(gca,'Fontsize',12)
title('Bob Dylan Spectrogram')
print(gcf,'BobSpect.png','-dpng')
subplot(1,3,2)
audio = reshape(yBilly,length(yBilly)/4,4);
audio = audio(:,1);
Fs = 44100;
Fsnew = Fs/4;
i = 20;
spectrogram(audio((i*Fsnew):((i+5)*Fsnew)-1),1500,1400,'yaxis')
set(gca,'Fontsize',12)
title('Billy Joel Spectrogram')
print(gcf,'BillySpect.png','-dpng')
subplot(1,3,3)
audio = reshape(yMozart,length(yMozart)/4,4);
audio = audio(:,1);
Fs = 44100;
Fsnew = Fs/4;
i = 30;
spectrogram(audio((i*Fsnew):((i+5)*Fsnew)-1),1500,1400,'yaxis')
set(gca,'Fontsize',12)
title('Mozart Spectrogram')
print(gcf,'MozartSpect.png','-dpng')
%% LDA

feature = 160;

[U,~,~,w,~,~,~,thresh1,thresh2,order] = trainer(BobData,BillyData,MozartData,feature);

%% Testing new song clips

valuesBob = w'*U'*TestBob;
valuesBilly = w'*U'*TestBilly;
valuesMozart = w'*U'*TestMozart;

nameVec = ["Bob" "Billy" "Mozart"];
[nameVec(order);"1" "2" "3"]

idsBob = 1+sum([valuesBob>thresh1;valuesBob>thresh2]);
idsBilly = 1+sum([valuesBilly>thresh1;valuesBilly>thresh2]);
idsMozart = 1+sum([valuesMozart>thresh1;valuesMozart>thresh2]);

percentBob = (sum(idsBob == find(order==1)))/testNum
percentBilly = (sum(idsBilly == find(order==2)))/testNum
percentMozart = (sum(idsMozart == find(order==3)))/testNum


%%
testNum = 60;
valuesBob = w'*U'*BobData;
valuesBilly = w'*U'*BillyData;
valuesMozart = w'*U'*MozartData;

nameVec = ["Bob" "Billy" "Mozart"];
[nameVec(order);"1" "2" "3"]

idsBob = 1+sum([valuesBob>thresh1;valuesBob>thresh2]);
idsBilly = 1+sum([valuesBilly>thresh1;valuesBilly>thresh2]);
idsMozart = 1+sum([valuesMozart>thresh1;valuesMozart>thresh2]);

percentBob = (sum(idsBob == find(order==1)))/trainNum
percentBilly = (sum(idsBilly == find(order==2)))/trainNum
percentMozart = (sum(idsMozart == find(order==3)))/trainNum

function data = process(audio,numFrames)
    Fs = 44100;
    Fsnew = Fs/4;
    audio = reshape(audio,length(audio)/4,4);
    audio = audio(:,1);
    
    fiver = audio(Fsnew:(6*Fsnew-1));
    Sp = spectrogram(fiver,1500,1400,'yaxis');
    [m,n] = size(Sp);

    data = zeros(m*n,numFrames);
    for frame = 1:numFrames
        i = randi(floor(length(audio)/Fsnew)-5);
        fiver = audio((i*Fsnew):((i+5)*Fsnew)-1);
        Sp = spectrogram(fiver,1500,1400,'yaxis');
        [m,n] = size(Sp);
        data(:,frame) = reshape(abs(Sp),m*n,1);
    end
end

function [U,S,V,w,proj1,proj2,proj3,thresh1,thresh2,order] = trainer(data1,data2,data3,feature)
    n1 = size(data1,2);
    n2 = size(data2,2);
    n3 = size(data3,2);
    
    [U,S,V] = svd([data1 data2 data3],'econ');
    
    clips = S*V'; % projection onto principal components
    U = U(:,1:feature);
    data1s = clips(1:feature,1:n1);
    data2s = clips(1:feature,n1+1:n1+n2);
    data3s = clips(1:feature,n1+n2+1:n1+n2+n3);
    
    figure(2)
    plot(1:length(diag(S)),(diag(S))/sum(diag(S).^2),'bo')
    set(gca,'Fontsize',12)
    xlabel('Singular Value Number')
    ylabel('Singular Value Energy')
    title('Singular Value Energy Dropoff')
    print(gcf,'SVDEnergies.png','-dpng')
    
    m1 = mean(data1s,2);
    m2 = mean(data2s,2);
    m3 = mean(data3s,2);
    m = mean([m1 m2 m3]);
    
    Sw = 0; % within class variances
    for k = 1:n1
        Sw = Sw + (data1s(:,k)-m1)*(data1s(:,k)-m1)';
    end
    for k = 1:n2
        Sw = Sw + (data2s(:,k)-m2)*(data2s(:,k)-m2)';
    end
    for k = 1:n3
        Sw = Sw + (data3s(:,k)-m3)*(data3s(:,k)-m3)';
    end
    
    Sb = (m1-m)*(m1-m)'+(m2-m)*(m2-m)'+(m3-m)*(m3-m)';
    % between class variances
    
    [V2,D] = eig(Sb,Sw);
    [~,ind] = max(abs(diag(D)));
    w = V2(:,ind); w = w/norm(w,2);
    
    proj1 = w'*data1s; proj2 = w'*data2s; proj3 = w'*data3s;
    
    mProj1 = mean(proj1); mProj2 = mean(proj2); mProj3 = mean(proj3);
    stdProj1 = std(proj1); stdProj2 = std(proj2); stdProj3 = std(proj3);
    
    meanVec = [mProj1 mProj2 mProj3];
    stdVec = [stdProj1 stdProj2 stdProj3];
    [~,order] = sort(meanVec);
    a1 = (meanVec(order(2))-meanVec(order(1)))/(stdVec(order(1))+stdVec(order(2)));
    a2 = (meanVec(order(3))-meanVec(order(2)))/(stdVec(order(2))+stdVec(order(3)));
    thresh1 = meanVec(order(1))+a1*stdVec(order(1));
    thresh2 = meanVec(order(2))+a2*stdVec(order(2));
    
    %sortVec = [sort(proj1);sort(proj2);sort(proj3)];
    %low = sortVec(order(1),:);
    %mid = sortVec(order(2),:);
    %high = sortVec(order(3),:);
    %t1 = length(low);
    %t2 = 1;
    %while low(t1)>mid(t2)
        %t1 = t1-1;
        %t2 = t2+1;
    %end
    %thresh1 = (low(t1)+low(t2))/2;
    %t1 = length(mid);
    %t2 = 1;
    %while mid(t1)>high(t2)
        %t1 = t1-1;
        %t2 = t2+1;
    %end
    %thresh2 = (mid(t1)+high(t2))/2;
end
