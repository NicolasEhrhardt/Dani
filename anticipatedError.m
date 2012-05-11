function [e] = anticipatedError(meshInit, mesh, tri, p)
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
        triNew = delaunay(tri.X(pConnex, :));
        triNew = reshape([mesh(pConnex(triNew)).id], size(triNew));

        e = 0;

        for i=1:size(triNew, 1)
            e = e + errorTri(meshInit, triNew(i, :));
        end
    end
end
