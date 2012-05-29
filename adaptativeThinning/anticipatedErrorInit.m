function [e] = anticipatedErrorInit(image, w, p)
    %Authors : Lilley & Hippo
    %Input : image (struct ( tuple,, id )), width of ivge (int), point id (int)
    %Output : error (double)

    %for corner points
    mo = mod(p, w);       
    if mo == 1
        if p == 1
            v = [+Inf 0];
        elseif p == numel(image) - w + 1	
            v = [+Inf 0];
        else
            v = [image(p+1), image(p+w), image(p-w)];
        end
    elseif mo == 0
        if p == w
            v = [+Inf 0];
        elseif p == numel(image)	
            v = [+Inf 0];
        else
            v = [image(p-1), image(p+w), image(p-w)];
        end
    elseif p < w
        v = [image(p-1), image(p+1), image(p+w)];
    elseif p > numel(image) - w
        v = [image(p-1), image(p+1), image(p-w)];
    else
        v = [image(p-1), image(p+1), image(p+w), image(p-w)];
    end
    e = abs((max(v) - min(v))/2 - image(p));
end
