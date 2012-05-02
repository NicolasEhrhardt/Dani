function [imResult] = decode(figure)
    %Algorithm start from here

    p = [figure(:).p];
    col = [figure(:).col];

    %loading delaunay triangulation
    tri = DelaunayTri(p');
    idTriPoint = tri.Triangulation;

    %plottin it
    triplot(tri);

    %---------------------------
    % Create new image matrix
    %---------------------------

    %search the image dimension :
    %first take the convex hull :
    hull = convexHull(tri);

    %get the image dimensions and creating new image
    %Max only computed in the hull : cleverer
    M = max(p(:, hull), [], 2);
    imResult = zeros(M(2), M(1));

    %loading all points of image
    [X, Y] = meshgrid(1:M(1), 1:M(2));
    allPoints = [reshape(X, M(1)*M(2),1)' ; reshape(Y, M(1)*M(2), 1)'];

    %---------------------------
    % Associating color to each point
    %---------------------------

    %getting id of triangle and barycentric coords of all points
    [idTri, bar] = pointLocation(tri, allPoints');

    for i=1:length(allPoints)
        imResult(i) = bar(i, 1)*col(idTriPoint(idTri(i),1)) + bar(i, 2)*col(idTriPoint(idTri(i),2)) + bar(i, 3)*col(idTriPoint(idTri(i),3));
    end

    imResult = round(imResult)';

    %---------------------------
    % Plotting image
    %---------------------------

    imagesc(imResult); axis image; colormap gray(256);
end
