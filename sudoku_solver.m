T0 = 1;
alpha = 1;
max_iter = 10^4;

load('games.mat')
 
x = squeeze(games(1,:,:));
fixed = x~=0;

% initialize board
for i = 1:9
    fixed_in_line = unique(x(i,:));
    fixed_in_line = fixed_in_line(2:end);
    free_in_line = setdiff(1:9,fixed_in_line);
    x(i,x(i,:)==0) = free_in_line(randperm(size(free_in_line,2)));
end

boards = zeros(max_iter+1,9,9);
boards(1,:,:) = x;
positions = zeros(max_iter,2,2);
energies = zeros(max_iter,1);

counts = zeros(3,9,9);  % Vielfachheiten in Zeilen, Spalten, Blöcken
edges = linspace(0.5,9.5,10);

for i = 1:9
    counts(1,i,:) = histcounts(x(i,:),edges);
    counts(2,i,:) = histcounts(x(:,i),edges);
    
    box_x = mod(i-1,3)+1;
    box_y = floor((i-1)/3)+1;
    
    x_box = x((box_x-1)*3+1:box_x*3,(box_y-1)*3+1:box_y*3);
    counts(3,i,:) = histcounts(x_box,edges);
end


E = Inf;
for t = 1:max_iter

    T = T0 * alpha^t;

    while true
        row = randi(9);
        column1 = randi(9);
        column2 = randi(9);

        position1 = [row column1];
        position2 = [row column2];

        if (~fixed(position1(1),position1(2))) && ...
           (~fixed(position2(1),position2(2))) && ...
           (position1(2)~=position2(2))
            break
        end
    end
    
    positions(t,1,:) = position1;
    positions(t,2,:) = position2;
    
    value1 = x(position1(1),position1(2));
    value2 = x(position2(1),position2(2));
    [new_counts, E_new] = objective_function(counts, value1, value2, position1, position2);

    p = min(1,exp(-(E_new-E)/T));
    if rand() < p
        x(position1(1),position1(2)) = value2;
        x(position2(1),position2(2)) = value1;
        counts = new_counts;
        E = E_new;
    end
    boards(t+1,:,:) = x;

    if E == 0
        break
    end
    
    energies(t) = E;
end


