function [imResult] = decodeGeneric(points, tri)
    %Author : Lilley & Hippo
    %Input : compressed image struct
    %                         points :  ( struct( tuple, color (byte) ) )
    %                         tri : matrix n x 3
    %Output : image 2D matrix
    %Algorithm starts from here

    p = [points(:).p];
    col = [points(:).col];

    %---------------------------
    % Create new image matrix
    %---------------------------

    %search the image dimension :
    %first take the convex hull :
    M = max(p, [], 2);

    %get the image dimensions and creating new image
    %Max only computed in the hull : cleverer
    imResult = zeros(M(2), M(1));

    %loading all points of image
    [X, Y] = meshgrid(1:M(1), 1:M(2));
    allPoints = [reshape(X, M(1)*M(2),1) reshape(Y, M(1)*M(2), 1)];

    %---------------------------
    % Associating color to each point
    %---------------------------

    %getting id of triangle and barycentric coords of all points
    for idTri=1:size(tri, 1)
        t = tri(idTri, :);
        pTri = [points(t).p];
        triRep = TriRep([1 2 3], pTri');
        
        ma = max(pTri, [], 2);
        mi = min(pTri, [], 2);

        [X, Y] = meshgrid(mi(1):ma(1), mi(2):ma(2));
        allPointsRect = [reshape(X, numel(X), 1) reshape(Y, numel(Y), 1)];

        %triangle
        tri1 = pTri';

        %points in triangle
        idPointsTri = inpolygon(allPointsRect(:, 1), allPointsRect(:, 2), tri1(:, 1), tri1(:, 2));
        allPointsTri = allPointsRect(idPointsTri == 1, :);

        %computing barycentric coords - BE CAREFUL : coords can be negative
        bar = cartToBary(triRep, ones(size(allPointsTri, 1), 1), allPointsTri);
        
        for i=1:length(allPointsTri)
            imResult(allPointsTri(i, 1), allPointsTri(i, 2)) = bar(i, 1)*col(t(1)) + bar(i, 2)*col(t(2)) + bar(i, 3)*col(t(3));
        end
    end

    imResult = round(imResult);

    %---------------------------
    % Plotting image
    %---------------------------

    imagesc(imResult); axis image; colormap gray(256);
end
