function [points, tri, e] = compressBissections(imageLoc, methodError, mesh, err)
    %Authors : Lilley & Hippo
    %Input : image (2D matrix), error methodError (function) , mesh (struct ( tuple, col, id )), err (array of same length of mesh)
    %Output : mesh (struct ( tuple, col, id ))
    %Description : gives the mesh associated to the AT* compression of the image imageLoc, it is possible to recompress a mesh, better if having its error
    
    image = loadImage(imageLoc);
    disp('Image loaded');
   
    disp('Initializing triangulation');

    [h w] = size(image);

    if exist('mesh') ~= 1
        points = struct('p', {}, 'col', {});
        mesh = struct('points', {}, 'tri', {});

        points(1).p = [1; 1];
        points(1).col = image(1, 1);
        points(2).p = [1; w];
        points(2).col = image(1, w);
        points(3).p = [h; 1];
        points(3).col = image(h, 1);
        points(4).p = [h; w];
        points(4).col = image(h, w);
    
        tri = [1 2 4; 1 3 4];

        mesh(1).points = points;
        mesh.tri = tri;
    end

    N = size(tri, 1);

    disp('Done');

    %Algorithm starts from here
    
    %--------------------------
    % Initialization
    %--------------------------

    disp('Initializing heap of error');
    
    %error associated to triangles not given
    if exist('err') ~= 1
        %Heap of anticipated error and error by tri:
        e = zeros(N, 1);

        %loop on all triangle 
        %if it is a first compression
        for i=1:N
            e(i) = errorTri(image, points(tri(i,:)), methodError);
        end
    else
        e = err;
    end

    disp('Done');

    %--------------------------
    % Main loop
    %--------------------------

    nit = input('Number of points wanted ? ') - 4;

    disp('Algorithm started');
    percent = 0;
    
    %loop removing one point to one point
    for k=1:nit
        %%{---------
        % Only for display
        npercent = floor(10*k/nit);
        
        if npercent ~= percent
            percent = npercent;
            disp([int2str(percent), '0 %']);
        end
        %}---------
        
        %finding the triangle to bissect
        [emax imax] = max(e);
        
        %identifiying its vertices
        idVertices = tri(imax, :); 

        %removing values associated to removed triangle
        tri(imax, :) = [];
        e(imax) = [];
        
        %Core of the algorithm
        [newP newTris errTris] = bestBisect(image, points, idVertices, methodError);

        %updating heaps
        points(end + 1) = newP;
        tri = [tri; newTris];
        e = [e errTris];
        %input('Again ?')
    end
end
