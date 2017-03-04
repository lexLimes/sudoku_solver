function [new_counts, E_new] = objective_function(counts, value1, value2, position1, position2)

    new_counts = counts;

    for i = 1:2
        
        if i == 1
            position = position1;
            proposal = value2;
            value = value1;
        else
            position = position2;
            proposal = value1;
            value = value2;
        end
        
        row = position(1);
        column = position(2);

        box_x = floor((row-1)/3)+1;
        box_y = floor((column-1)/3)+1;
        box = box_x + 3*(box_y-1);

        new_counts(2,column,proposal) = new_counts(2,column,proposal) + 1;
        new_counts(2,column,value) = new_counts(2,column,value) - 1;

        new_counts(3,box,proposal) = new_counts(3,box,proposal) + 1;
        new_counts(3,box,value) = new_counts(3,box,value) - 1;
    
    end
    
    A = abs(new_counts-ones(3,9,9));
    E_new = sum(A(:));
   
   