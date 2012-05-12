[mesh err] = compress('lenaMedium', 20000);

%%{
dt = DelaunayTri([mesh(:).p]');
triplot(dt);
%}
