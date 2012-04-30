%structure of figure
figure = struct('p', {}, 'col', {})

r = 5
%size of image : 2^r
figure(1).p = [-2^(r-1); 2^(r-1)]
figure(1).col = 0

figure(2).p = [2^(r-1); 2^(r-1)]
figure(2).col = 255

figure(3).p = [2^(r-1); -2^(r-1)]
figure(3).col = 0

figure(4).p = [-2^(r-1); -2^(r-1)]
figure(4).col = 255


p = [figure(:).p]

tri = DelaunayTri(p')
triplot(tri)
