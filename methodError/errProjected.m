function [e] = errProjected(image, allPoints, vertexData, barNew)
    %Authors : Lilley & Hippo
    %Input : 
    % image ( 2D-colour matrix )
    % allPoints ( list of 2D points in the triangle matching matrix coords )
    % vertexData ( struct of vertex of triangle )
    % barNew ( barycentric coords of allPoints in the triangle )
    %Output : 
    % error (double)
    
    origin = [vertexData(1).p' vertexData(1).col];
    v1 = [vertexData(2).p' vertexData(2).col] - origin;
    v2 = [vertexData(3).p' vertexData(3).col] - origin;
    
    idx = sub2ind(size(image), allPoints(:, 1), allPoints(:, 2));
    
    % translating to good origin
    allPoints = [allPoints image(idx)] - repmat(origin, size(allPoints, 1), 1);
    % normal of triangle
    normal = cross(v1 , v2);
    normal = normal / norm(normal);

    e = sum((allPoints * normal').^2);
end
