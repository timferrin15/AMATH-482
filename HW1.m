% Setup
clear; close all; clc;
load Testdata
L=15; % spatial domain
n=64; % Fourier modes
x2=linspace(-L,L,n+1);
x=x2(1:n); y=x; z=x;
k=(2*pi/(2*L))*[0:(n/2-1) -n/2:-1];

[X,Y,Z]=meshgrid(x,y,z);
[Kx,Ky,Kz]=meshgrid(k,k,k);

% Averaging the transformed data
ave = zeros(n,n,n);
for j=1:20
    un(:,:,:)=reshape(Undata(j,:),n,n,n);
    unt = fftn(un);
    ave = ave + unt;
end
ave = ave/20;
maxInd = abs(ave) == max(abs(ave(:)));
% Central Frequencies in each spatial dimention:
kx0 = Kx(maxInd)
ky0 = Ky(maxInd)
kz0 = Kz(maxInd)

tau = 1;
% Filter for the x, y, and z directions
Filter = exp(-tau*((Kx-kx0).^2+(Ky-ky0).^2+(Kz-kz0).^2));

isoValue = .4;
path = zeros(20,3);
locInd = 0;
for j=1:20
    un(:,:,:)=reshape(Undata(j,:),n,n,n);
    unt = fftn(un);
    unft = Filter.*unt; % Applying filter
    unf = ifftn(unft);
    locInd = abs(unf) == max(abs(unf(:)));
    path(j,:) = [X(locInd) Y(locInd) Z(locInd)];
    %close all, 
    %isosurface(X,Y,Z,abs(unf)/max(abs(unf(:))),isoValue)
    %axis([-20 20 -20 20 -20 20]), grid on, drawnow
    %pause(1)
end

path(20,:)

%% Figure 1
figure(1)
firstNoise = reshape(abs(Undata(1,:)),n,n,n);
isosurface(X,Y,Z,firstNoise,isoValue)
xlabel('X coordinate'), ylabel('Y coordinate'), zlabel('Z coordinate')
title('Noisy Unfiltered Ultrasound Data','Fontsize',14)

print(gcf,'Unfiltered_Data.png','-dpng')

%% Figure 2
figure(2)
clc
isosurface(X,Y,Z,abs(unf)/max(abs(unf(:))),isoValue)
axis([-20 20 -20 20 -20 20]), grid on, drawnow
xlabel('X coordinate'), ylabel('Y coordinate'), zlabel('Z coordinate')
title('Filtered Ultrasound Data','Fontsize',14)

print(gcf,'Filtered_Data.png','-dpng')

%% Figure 3
figure(3)
set(gcf, 'Position',  [100, 100, 1000, 400])
subplot(1,2,1)
plot3(path(:,1),path(:,2),path(:,3),'-o','Linewidth',2)
axis([-12 12 -6 6 -12 12])
yticks(-5:2.5:5)
xlabel('X coordinate'), ylabel('Y coordinate'), zlabel('Z coordinate')
title('Angled Overhead View of Marble Path','Fontsize',14)

subplot(1,2,2)
plot(path(:,1),path(:,3),'-o','Linewidth',2)
axis([-12 12 -12 12])
xticks(-10:5:10)
xlabel('X coordinate'), ylabel('Z coordinate')
title('Side View of Marble Path','Fontsize',14)

print(gcf,'Marble_Path.png','-dpng')


