% download dataset from https://www.kaggle.com/bryanpark/sudoku

fileID = fopen('sudoku.csv');
data = textscan(fileID,'%s %s','Delimiter',',');
fclose(fileID);

quizzes = data(1);
N_G = 1000;
games = zeros(N_G,9,9);
for g = 1:N_G
    x = quizzes{1}{2+g};
    x = x - '0';
    x = reshape(x,[9 9]);
    games(g,:,:) = x;
end

save('games.mat', 'games')