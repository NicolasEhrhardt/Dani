function [Image] = loadImage(name)
	
	raw = double(imread(name));
	
	[h w d] = size(raw);
	
	Image = zeros(h,w);
	
	for i=1:d
		Image = Image + raw(:,:,i);
	end
	
	Image = Image/d;
