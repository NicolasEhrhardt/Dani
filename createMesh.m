function [mesh] = createMesh(Image,n)
	if exist('n') ~= 1
		n = numel(Image);
	end

	mesh = struct('p',{},'col', {}, 'id', {});
	
	[h w] = size(Image);
	
	dx = floor(sqrt(h*w/n));
	dy = dx;
	
	for i=1:dx:h
		for j=1:dy:w
			k = length(mesh)+1;
			mesh(k).p = [i;j];
			mesh(k).col = Image(i,j);
			mesh(k).id = k;
            if (i == 1 | i == h) & (j == 1 | j == w) 
                mesh(k).c = 1
            else
                mesh(k).c = 0
            end
		end
	end
end
