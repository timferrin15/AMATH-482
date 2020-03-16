load('cam1_1.mat')
load('cam2_1.mat')
load('cam3_1.mat')
implay(vidFrames1_1)
implay(vidFrames2_1)
implay(vidFrames3_1)
% Can do this for the other cameras/scenarios, not included in order to
% keep code concise

checkPoints1 = [5 2;6 3;7 4;7 5;7 6;7 7;7 8;8 9;8 10;8 11;
                8 12;8 13; 8 14;8 15];
positions1 = getData(vidFrames1_1,checkPoints1,308,336,280,424,0.01,0.94,0);
checkPoints2 = [0 0;1 1;2 2;3 3;3 4;3 5;3 6;3 7;3 8;3 9;
                3 10;3 11;3 12;3 13;3 14;3 15;3 16;
                3 17;3 18;3 19;3 20;3 21;3 22;3 23;
                3 24;3 25;2 26;1 27;0 28];
positions2 = getData(vidFrames2_1,checkPoints2,220,278,180,364,0.01,.87,0);

checkPoints3 = [-1 -2;0 -1;0 0;0 1;0 2;0 3;0 4;0 5;-1 6;
                -2 7;-3 7;-4 7;-5 7;-6 7;-7 7;-8 7;-9 7;
                -10 7;-11 7;-12 7;-13 7;-14 8;-15 8;-16 8;
                -17 8;-18 8;-19 8];
positions3 = getData(vidFrames3_1,checkPoints3,324,470,298,350,0.01,.96,2);

positions2 = [positions2;11 265 246;12 265 246;29 265 277;39 265 358;109 265 274;
                172 265 242;177 265 202;178 265 198;179 265 196;180 265 196;   
                181 265 196;182 265 198;187 265 239;188 265 252;189 265 267;
                228 265 256;252 265 261;259 265 208;260 265 209;261 265 209];
[~,I]=sort(positions2(:,1));
positions2 = positions2(I,:);
for i=1:284
    if positions2(i,2) < 255
        positions2(i,2) = 265;
    end
end

%%
close all
cropBeg1 = 9;
cropped1 = positions1(cropBeg1+1:226,:);
cropBeg2 = cropBeg1+10;
cropEnd2 = 217 + cropBeg2;
cropped2 = positions2(cropBeg2+1:cropEnd2,:);
cropBeg3 = 9;
cropEnd3 = 217 + cropBeg3;
cropped3 = positions3(cropBeg3+1:cropEnd3,:);

figure(1)
hold on
plot(cropped1(:,1)-cropBeg1,cropped1(:,3),'ko')
plot(cropped2(:,1)-cropBeg2,cropped2(:,3),'bo')
plot(cropped3(:,1)-cropBeg3,cropped3(:,2),'ro')
xlabel('Frame Number')
ylabel('Pixel Value')
title('Scenario 1 Oscillation Data (Synced)','Fontsize',14)
legend('Camera 1 y-data','Camera 2 y-data','Camera 3 x-data')

print(gcf,'SyncedOsc.png','-dpng')

%% PCA
A = [cropped1(:,2:3) cropped2(:,2:3) cropped3(:,2:3)];
A = A-(sum(A,2)/217);
A = A.';
[U,S,V] = svd(A,'econ');
sVals = diag(S);
for i = 1:6
    sEnergy(i) = (sVals(i)^2)/sum(sVals.^2);
end
figure(2)
plot(1:6,(log(sEnergy)),'ks','MarkerSize',10,'MarkerEdgeColor','red','MarkerFaceColor',[1 .6 .6])
xlabel('Singular Value')
ylabel('Log of Energy Contribution')
title('Scenario 1 Singular Value Energies','Fontsize',14)

print(gcf,'Energies.png','-dpng')


