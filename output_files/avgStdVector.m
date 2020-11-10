function [avg,standdev] = avgStdVector(A)

    [rows,cols]=size(A);

    avg = zeros(1,cols);
    standdev = zeros(1,cols);
    
    for i = 1:cols
        avg(i) = mean(A(:,i));
        standdev(i) = std(A(:,i));
    end


end

