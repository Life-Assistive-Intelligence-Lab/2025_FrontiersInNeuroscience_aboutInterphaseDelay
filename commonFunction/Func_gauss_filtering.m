function [data,information] = Func_gauss_filtering(data,information,spatialFilterSize)
    data = zeros(size(data),class(data));
    F1 = diag(fliplr(pascal(spatialFilterSize)))/sum(diag(fliplr(pascal(spatialFilterSize)))); 
    F2 = repmat(F1,[1,spatialFilterSize]).*(repmat(F1,[1,spatialFilterSize]))';
    for ii=1:size(data,3)
        modifiedData=symmetricExpansion2(data(:,:,ii),spatialFilterSize);
        data(:,:,ii) = filter2(F2,modifiedData,'valid');
    end
end

function modifiedData = symmetricExpansion2(data,filterSize)
    expansionSize=filterSize/2-0.5; 
    ll = fliplr(data(1:end,1:expansionSize)); 
    rr = fliplr(data(1:end,end-expansionSize+1:end)); 
    uu = flipud(data(1:expansionSize,1:end)); 
    dd = flipud(data(end-expansionSize+1:end,1:end));
    lu = flipud(ll(1:expansionSize,1:end)); 
    ru = flipud(rr(1:expansionSize,1:end)); 
    ld = flipud(ll(end-expansionSize+1:end,1:end)); 
    rd = flipud(rr(end-expansionSize+1:end,1:end)); 
    modifiedData = [lu,uu,ru;ll,data,rr;ld,dd,rd];
    clear expansionSize lu uu ru ll Data rr ld dd rd
end