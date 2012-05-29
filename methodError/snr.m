function [e] = snr(im1, im2)
    e = sum(sum((im1-im2).^2));
end
