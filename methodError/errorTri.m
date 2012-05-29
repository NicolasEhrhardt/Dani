function [e] = errorTri(image, points, methodError)
    %Authors : Lilley & Hippo
    %Input : 
    % image (matrix)
    % points - corner ( struct ( tuple, col, id ) ) 
    %Output :
    % err - error of triangle (double)

    %needed after to compute barycentric coordinates
    pointsTri = [points(:).p];
    tri = TriRep([1 2 3], pointsTri');
    
    %truncating points to rect        
    ma = max(pointsTri, [], 2);
    mi = min(pointsTri, [], 2);
    
    [X, Y] = meshgrid(mi(1):ma(1), mi(2):ma(2));
    allPointsRect = [reshape(X, numel(X), 1) reshape(Y, numel(Y), 1)];

    %triangle
    tri1 = pointsTri';
    
    %points in triangle
    idPointsTri1 = inpolygon(allPointsRect(:, 1), allPointsRect(:, 2), tri1(:, 1), tri1(:, 2));
    allPoints1 = allPointsRect(idPointsTri1 == 1, :);
    
    %computing barycentric coords - BE CAREFUL : coords can be negative
    bar1 = cartToBary(tri, ones(size(allPoints1, 1), 1), allPoints1);

    %appending anticipated error to the vector
    e = methodError(image, allPoints1, points, bar1);
end
