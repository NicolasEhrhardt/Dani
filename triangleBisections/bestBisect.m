function [newP newTris err] = bestBisect(image, points, idVertices, methodError)
    %Authors : Lilley & Hippo
    %Input : 
    % points ( struct ( tuple, col, id ) ) 
    % idVertices - id of triangle corner in points ( int )
    %Output :
    % newP - new point (2x1 double vector)
    % newTris - new triangles (2x3 int vector)
    % err - error of new triangles (2x1 vector)

    %needed after to compute barycentric coordinates
    pointsTri = [points(idVertices).p];
    tri = TriRep([1 2 3], pointsTri');
    
    %truncating points to rect        
    ma = max(pointsTri, [], 2);
    mi = min(pointsTri, [], 2);
    
    [X, Y] = meshgrid(mi(1):ma(1), mi(2):ma(2));
    allPointsRect = [reshape(X, numel(X), 1) reshape(Y, numel(Y), 1)];

    %computing possible new points
    M = [0 1 1; 1 0 1; 1 1 0];
    middlePoints = floor(1/2 * pointsTri * M);

    mpoints = struct('p', {}, 'col', {});

    %anticipated error
    ea = [];

    for i=1:3
%        idTri1 = [mod(i,3) mod(i+2,3) 3+mod(i,3)]
%        idTri2 = [mod(i+1,3) mod(i+2,3) 3+mod(i,3)]

        %new triangles
        tri1 = [pointsTri(:, 1+mod(i,3)) pointsTri(:, i) middlePoints(:, i)]';
        tri2 = [pointsTri(:, 1+mod(i+1,3)) pointsTri(:, i) middlePoints(:, i)]';
        
        %points in triangle
        idPointsTri1 = inpolygon(allPointsRect(:, 1), allPointsRect(:, 2), tri1(:, 1), tri1(:, 2));
        idPointsTri2 = inpolygon(allPointsRect(:, 1), allPointsRect(:, 2), tri2(:, 1), tri2(:, 2));
        allPoints1 = allPointsRect(idPointsTri1 == 1, :);
        allPoints2 = allPointsRect(idPointsTri2 == 1, :);
        
        %computing barycentric coords - BE CAREFUL : coords can be negative
        bar1 = cartToBary(tri, ones(size(allPoints1, 1), 1), allPoints1);
        bar2 = cartToBary(tri, ones(size(allPoints2, 1), 1), allPoints2);

        spoints1 = points(idVertices);
        spoints1(1+mod(i,3)).p = middlePoints(:, i);
        spoints1(1+mod(i,3)).col = image(middlePoints(1, i), middlePoints(2, i));
        spoints2 = points(idVertices);
        spoints2(1+mod(i+1,3)).p = middlePoints(:, i);
        spoints2(1+mod(i+1,3)).col = image(middlePoints(1, i), middlePoints(2, i));

        %appending anticipated error to the vector
        ea = [ea; methodError(image, allPoints1, spoints1, bar1) methodError(image, allPoints2, spoints2, bar2)];
    end

    %best error is minimum error
    [e i] = min(sum(ea, 2));

    %outputs
    newP = struct('p', middlePoints(:, i), 'col', image(middlePoints(1,i), middlePoints(2,i)));
    newTris = [idVertices(i) idVertices(1+mod(i,3)) length(points)+1; idVertices(i) idVertices(1+mod(i+1,3)) length(points)+1];
    err = ea(i, :);
end
