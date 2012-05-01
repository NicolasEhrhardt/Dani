function [mesh] = Compress(Image,n)
	
	mesh = struct('p',{},'col',{});
	
	[h w] = size(Image);
	
	dx = floor(sqrt(h*w/n));
	dy = dx;
	
	for i=1:dx:h
		for j=1:dy:w
			k = length(mesh)+1;
			mesh(k).p = [i;j];
			mesh(k).col = Image(i,j);
		end
	end