%structure of figure
figure = struct('p', {}, 'col', {});

r = 5;
%size of image : 2^r
figure(1).p = [0; 0];
figure(1).col = 0;

figure(2).p = [0; 2^r];
figure(2).col = 255;

figure(3).p = [2^r; 0];
figure(3).col = 255;

figure(4).p = [2^r; 2^r];
figure(4).col = 128;

figure(5).p = [2^(r-1); 2^(r-1)];
figure(5).col = 0;

figure(6).p = [2^(r-1);2^(r-2)];
figure(6).col = 255;

im = decode(figure)
