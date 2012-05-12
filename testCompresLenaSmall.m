image = loadImage('lena_small.jpg');
mesh = createMesh(image);
disp('Mesh created');
[mesh err] = compress(mesh, 5000);

%{
dt = DelaunayTri([mesh(:).p]');
triplot(dt);
%}
