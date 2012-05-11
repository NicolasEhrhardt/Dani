function [mesh] = compressGreedy(image, n)
    %Author : Lilley
    %Input : image (2D matrix) , number of points removed ( int )
    %Output : mesh (struct ( tuple, col ))

    %intializing mesh to the whole image
	meshInit = struct('p',{},'col',{});
    
    %storing positions and colors
    [h w] = size(image);
    [X, Y] = meshgrid(1:h, 1:w);
    N = h*w;
    allPoints = [reshape(X, 1, N) ; reshape(Y, 1, N)];
    
    %Is there a better way ?
    for i=1:N,
        meshInit(i).p = allPoints(:,i);
        meshInit(i).col = image(i);
    end
    
    mesh = meshInit;
    triInit = DelaunayTri(mesh(:).p');
    tri = triInit;
    
    %Algorithm starts from here
    
    %--------------------------
    % Initialisation
    %--------------------------

    [idTri, bar] = pointLocation(tri, allPoints);
    
    %Heap of anticipated error and error by tri:
    e = zeros(N, 1);
    eTri = zeros(length(tri.Triangulation), 1),
    
    %loop on all vertexes
    for i=1:N,
        %finding all triangles attached to each vertex :
        triConnex = vertexAttachment(tri, i);
        
        %loop on all connex triangle
        %generating anticipated error
        for j=1:size(triConnex),
            %storing error for each simplex
            if(eTri(triConnex(j)) == 0)
                eTri(triConnex(j)) = err(meshInit, mesh.p(tri.Triangulation(triConnex(j), :)));
            end 
            
            %storing anticipated error for each vertex
            e(i) = e(i) + eTri(triConnex(j))
        end
    
    end

    %--------------------------
    % Main loop
    %--------------------------
    
    %loop removing one point to one point
    for k=1:n,
        %finding the point to remove
        [emax imax] = max(e);

        %identifiying its neighbors
        triConnex = vertexAttachment(tri, imax);
        pConnex = unique(tri.Triangulation(triRemoved, :));
       
        dis = sum((tri.X(connex, :) - tri.X(imax)).^2, 2);
        [dmax pMerged] = min(dis);

        %Now we know that imax and pMerged will merge
        triRemoved = simplexAttachment(tri, [idmax pMerged])
         
        %removing point from tri AND recomputation of delaunayTri
        tri.X(imax,:) = []
        %removing error from heap
        e(imax) = []

        triRecomputed = triConnex;
        [v, ind] = ismember(triRemoved, triConnex);
        triRecomputed(ind) = [];

        for i=length(triRemoved),
            triRecomputed(find(triRecomputed > triRemoved(i)) = triRecomputed(find(triRecomputed > triRemoved(i)) - 1;
        end

        %removing index for triangles removed
        eTri(triRemoved) = []
          
        %recompute eTri
        for j=1:size(triRecomputed),
            %storing error for each simplex
            eTri(triRecomputed(j)) = err(meshInit, mesh.p(tri.Triangulation(triRecomputed(j), :)));
        end

        %recompute e
        for i=1:size(pConnex)
            %storing anticipated error for each vertex
            e(pConnex(i)) = 0
            tConnex = simplexAttachment(tri, pConnex(i)); 
            for i=1:size(tConnex),
                e(pConnex(i)) = e(oConnex(i)) + eTri(tConnex(j))
            end
        end
    end
end
