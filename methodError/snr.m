function [e] = snr(im1, im2)
    e = sum(sum((im1-im2).^2)) / size(im1, 1) / size(im2, 2);
end
