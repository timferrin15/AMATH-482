function result = getData(video, checks, left, right, ceiling, floor, thresh1, thresh2, vhorb)

% checks is the halved y,x shape points with the NW corner as the origin
% left, right, and ceiling, floor are unhalved bound values
% vhorb ==0 means horizontal edge detection, ==1 means vertical, ==2 means both

[m,n,~,numFrames]=size(video);
positions = [];
lbound = left/2;
rbound = right/2;
ubound = ceiling/2;
bbound = floor/2;
for i=1:numFrames
    I1=rgb2gray(video(:,:,:,i));
    if vhorb == 0
        [~,cstar,~,~] = dwt2(im2double(I1),'haar');
    end
    if vhorb == 1
        [~,~,cstar,~] = dwt2(im2double(I1),'haar');
    end
    if vhorb == 2
        [~,cH,cV,~] = dwt2(im2double(I1),'haar');
        cstar = cH+cV;
    end
    points = [];
    for j=lbound:rbound % j is the halved x value
        for k=ubound:bbound % k is the halved y value
            checkPoints = [checks(:,1)+k checks(:,2)+j];
            compare = 0;
            numPoints = (size(checkPoints(:))/2);
            for p=1:numPoints
                if cstar(checkPoints(p,1),checkPoints(p,2)) > thresh1
                    compare = compare + 1;
                end
            end
            if compare > numPoints*thresh2
                points = [points; j k];
            end
        end
    end
    if sum(size(points))~=0
        minX = min(points(:,1));
        minY = points(find(points(:,1)==minX,1),2);
        positions = [positions; i 2*minX 2*minY];
    end
end

result = positions;
end