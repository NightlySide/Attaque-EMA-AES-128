function output = shiftrowinv(S)
    output = zeros(size(S));
    for row = 1:size(S)
       output(row, :) = circshift(S(row, :), -(row-1)); 
    end
end 