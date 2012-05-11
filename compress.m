function [mesh, ea] = compress(mesh, n)
    %Authors : Lilley & Hippo
    %Input : image (2D matrix) , number of points removed ( int )
    %Output : mesh (struct ( tuple, col, id ))

    %intializing mesh to the whole image
    meshInit = mesh;
    disp('Computing delaunay triangulation');
    tri = DelaunayTri([mesh(:).p]');
    N = length(mesh);
    %Algorithm starts from here
    
    %--------------------------
    % Initialisation
    %--------------------------

    disp('Initializing heap of error');
    %Heap of anticipated error and error by tri:
    ea = zeros(N, 1);
    %loop on all vertexes
    for i=1:N
        ea(i) = anticipatedError(meshInit, mesh, tri, i);
    end

    %--------------------------
    % Main loop
    %--------------------------
    
    %loop removing one point to one point
    for k=1:n
        disp(k);

        %finding the point to remove
        [emin imin] = min(ea);
        
        %identifiying its neighbors
        triConnex = vertexAttachments(tri, imin);
        triConnex = triConnex{1};
        pConnex = unique(tri.Triangulation(triConnex, :));
        [v, ind] = ismember(imin, pConnex);
        pConnex(ind) = [];
        pConnex(ind:end) = pConnex(ind:end) - 1;
        

        if mesh(imin).c == 1
            disp('STOPPPPPPPPP');
        end 

        %update delaunay triangulation
        tri.X(imin, :) = [];
        mesh(imin) = []; 
 
        %pop y* from the heap
        ea(imin) = [];

        for i=1:length(pConnex),
            ea(pConnex(i)) = anticipatedError(meshInit, mesh, tri, pConnex(i));
        end
    end
end
