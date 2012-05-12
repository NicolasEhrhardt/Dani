function [e] = anticipatedError(image, mesh, tri, p)
    %Authors : Lilley & Hippo
    %Input : mesh (struct ( tuple, col, id )), mesh (struct ( tuple, col, id )), tri (DelaunayTri), point id (int)
    %Output : error (double)

    %for corner points
    if mesh(p).c == 1
        e = +Inf;
    else
        %identifiying its neighbors
        triConnex = vertexAttachments(tri, p);
        triConnex = triConnex{1};
        
        pConnex = unique(tri.Triangulation(triConnex, :));
        [v, ind] = ismember(p, pConnex);
        pConnex(ind) = [];
        
        %building triangulation without p   
        triNew = DelaunayTri(tri.X(pConnex, :));
        idTri = pConnex(triNew.Triangulation);
        
        %truncating points to rect        
        ma = max(triNew.X, [], 1);
        mi = min(triNew.X, [], 1);
        
        [X, Y] = meshgrid(mi(1):ma(1), mi(2):ma(2));
        allPointsRect = [reshape(X, numel(X), 1) reshape(Y, numel(Y), 1)];

        [id, bar] = pointLocation(triNew, allPointsRect);

        e = 0;

        for i=1:size(idTri, 1)
            allPoints = allPointsRect(id == i, :);
            idx = sub2ind(size(image), allPoints(:, 1), allPoints(:, 2));
	        barNew = bar(id == i, :);
            %computing error for each triangle if there is a point inside
            if length(idx) > 0
                e = e + sum((  sum(barNew * [mesh(idTri(i, :)).col]', 2) - image(idx)).^2);
            end
        end
    end
end
