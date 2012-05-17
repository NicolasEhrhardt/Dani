function [e] = errDani(image, allPoints, vertexData, barNew)
    %Authors : Lilley & Hippo
    %Input : 
    % image ( 2D-colour matrix )
    % allPoints ( list of 2D points in the triangle matching matrix coords )
    % vertexData ( struct of vertex of triangle )
    % barNew ( barycentric coords of allPoints in the triangle )
    %Output : 
    % error (double)
    colTri = [vertexData.col]';
    idx = sub2ind(size(image), allPoints(:, 1), allPoints(:, 2));
    if length(idx) > 0
        e = sum((  sum(barNew * colTri, 2) - image(idx)).^2);
    else
        e = 0;
    end
end
