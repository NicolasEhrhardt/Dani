function [mesh, ea] = compress(imageLoc, mesh, err)
    %Authors : Lilley & Hippo
    %Input : image (2D matrix) , number of points removed ( int )
    %Output : mesh (struct ( tuple, col, id ))
    
    image = loadImage(imageLoc);
    disp('Image loaded');
    
    %intializing mesh to the whole image
    if exist('mesh') ~= 1
        mesh = createMesh(image);
        disp('Mesh created');
    else
        disp('Mesh loaded');
    end

    n = input(['This mesh is ', int2str(numel(mesh)), ' nodes, how many do you want to remove ? ']);

    disp('Computing delaunay triangulation');
    tri = DelaunayTri([mesh(:).p]');
    disp('Done');

    N = length(mesh);

    %Algorithm starts from here
    
    %--------------------------
    % Initialisation
    %--------------------------

    disp('Initializing heap of error');
    
    if exist('err') ~= 1
        %Heap of anticipated error and error by tri:
        ea = zeros(N, 1);

        %We need length of image :
        w = size(image, 2);
        %loop on all vertexes
        for i=1:N
            ea(i) = anticipatedErrorInit(image, w, i);
        end
    else
        ea = err;
    end

    disp('Done');

    %--------------------------
    % Main loop
    %--------------------------
    disp('Algorithm started');
    percent = 0;
    
    %loop removing one point to one point
    for k=1:n
        %%{---------
        % Only for display
        npercent = floor(10*k/n);
        
        if npercent ~= percent
            percent = npercent;
            disp([int2str(percent), '0 %']);
        end
        %}---------

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
            disp('STOP');
            break;
        end 

        %update delaunay triangulation
        tri.X(imin, :) = [];
        mesh(imin) = []; 
 
        %pop y* from the heap
        ea(imin) = [];

        for i=1:length(pConnex),
            ea(pConnex(i)) = anticipatedError(image, mesh, tri, pConnex(i));
        end
    end
end
