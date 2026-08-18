%code for getting CM on K4
%cm1 = {{3,4,5,6},{1,4,5,6},{2,4,5,6},{2,3,5,6},{1,2,5,6},{0,4,5,6},{0,3,5,6},{0,1,5,6},{3,4,6,7},{1,3,6,7},{3,4,5,7},{2,3,5,7},{0,3,5,7},{2,4,6,7},{2,3,6,7},{1,2,6,7},{2,4,5,7},{0,2,5,7},{4,6,7,9},{3,6,7,9},{1,6,7,9},{4,5,7,9},{2,5,7,9},{0,5,7,9},{1,4,6,8},{1,3,6,8},{1,4,5,8},{1,2,5,8},{0,1,5,8},{1,3,7,8},{1,2,7,8},{1,7,8,9},{0,4,6,8},{0,3,6,8},{0,1,6,8},{0,4,5,8},{0,2,5,8},{0,3,7,8},{0,2,7,8},{0,7,8,9},{4,6,8,9},{3,6,8,9},{1,6,8,9},{4,5,8,9},{2,5,8,9},{0,5,8,9},{3,7,8,9},{2,7,8,9},{3,4,6,9},{1,4,6,9},{2,4,5,9},{0,4,5,9},{3,4,7,9},{2,4,7,9},{1,4,8,9},{0,4,8,9},{0,3,4,6},{0,1,3,6},{0,3,4,5},{0,2,3,5},{0,2,3,7},{0,3,7,9},{0,1,3,8},{0,3,8,9},{0,3,4,9},{1,2,4,6},{1,2,3,6},{1,2,4,5},{0,1,2,5},{1,2,3,7},{1,2,7,9},{0,1,2,8},{1,2,8,9},{1,2,4,9},{0,1,2,3}};

cm1 = {{3,4,5,6},{1,4,5,6},{2,4,5,6},{2,3,5,6},{1,2,5,6},{0,4,5,6},{0,3,5,6},{0,1,5,6},{3,4,6,7},{1,3,6,7},{3,4,5,7},{2,3,5,7},{0,3,5,7},{2,4,6,7},{2,3,6,7},{1,2,6,7},{2,4,5,7},{0,2,5,7},{4,6,7,9},{3,6,7,9},{1,6,7,9},{4,5,7,9},{2,5,7,9},{0,5,7,9},{1,4,6,8},{1,3,6,8},{1,4,5,8},{1,2,5,8},{0,1,5,8},{1,3,7,8},{1,2,7,8},{1,7,8,9},{0,4,6,8},{0,3,6,8},{0,1,6,8},{0,4,5,8},{0,2,5,8},{0,3,7,8},{0,2,7,8},{0,7,8,9},{4,6,8,9},{3,6,8,9},{1,6,8,9},{4,5,8,9},{2,5,8,9},{0,5,8,9},{3,7,8,9},{2,7,8,9},{3,4,6,9},{1,4,6,9},{2,4,5,9},{0,4,5,9},{3,4,7,9},{2,4,7,9},{1,4,8,9},{0,4,8,9},{0,3,4,6},{0,1,3,6},{0,3,4,5},{0,2,3,5},{0,2,3,7},{0,3,7,9},{0,1,3,8},{0,3,8,9},{0,3,4,9},{1,2,4,6},{1,2,3,6},{1,2,4,5},{0,1,2,5},{1,2,3,7},{1,2,7,9},{0,1,2,8},{1,2,8,9},{1,2,4,9},{0,1,2,3}};

maxCones = cellfun(@(x) cell2mat(x), cm1, 'UniformOutput', false); %change to matrices

maxCones = dictionary(maxCones, true(1, numel(maxCones))); %make each 4-ray cone a key in a dictionary


%find the five-ray cones

    B = 0:9;
    C = nchoosek(B,5); %generate all possible 5-ray cones
    
    fiveRayCones = {};
    k=1;
    
    for i = 1:size(C,1)
        M = C(i, :);
        foundAll = true;
    
        % Generate all 5 subsets of size 4, i.e. all the 4-ray cones
        for j = 1:5
            key = M;
            key(j) = [];              % remove one element
            key = {key}; % canonical form
    
            if ~isKey(maxCones, key)
                foundAll = false;
                break
            end
        end
    
        % If all five 4-ray cones are maximal cones
        if foundAll
            fiveRayCones{k} = M;
            k = k + 1;
        end
    end


%find the six-ray cones
    
C = nchoosek(B, 6); % All 6-element subsets
sixRayCones = {};
l = 1;

for i = 1:size(C,1)
    S = C(i, :);
    
    perms = sixCycles(S); % permutations of the 6-element subset

    for k = 1:numel(perms)
        foundAll = true;

        T = perms{k};

        % Generate 6 subsets of size 4 that have two adjacent indices removed
        for j = 1:5
            key = T;
            key(j:j+1) = []; % remove two elements
            key = {sort(key)}; % canonical form
    
            if ~isKey(maxCones, key)
                foundAll = false;
                break
            end
        end
        
        if foundAll
            key = T;
            key(1) = [];
            key(end) = [];
            key = {sort(key)};
            if ~isKey(maxCones, key)
                foundAll = false;
            end
        end

        % If all six 4-sets are present
        if foundAll
            sixRayCones{l} = S;
            l = l + 1;
        end
    end
end


%remove duplicates
sixRayConesNew = cell(1,10);
for i=1:10
    sixRayConesNew{i} = sixRayCones{6*i};
end


%total list of cones
k4cones = [fiveRayCones, sixRayConesNew];

%rays of fan
rays = [-1 0 0 0 0 -1 0 1 0 1; 0 -1 0 0 0 0 -1 1 0 1; 0 0 -1 0 0 -1 0 0 1 1; 0 0 0 -1 0 0 -1 0 1 1; 0 0 0 0 -1 -1 -1 1 1 1];

for i=1:numel(k4cones)
    if size(k4cones{i},2) == 5
        S = k4cones{i};
        A = zeros(5,5);
        for j=1:5
            ind = S(j);
            A(:, j) = rays(:, ind+1);
        end
        formatSpec = 'C%d = coneFromVData matrix {{%d,%d,%d,%d,%d},{%d,%d,%d,%d,%d},{%d,%d,%d,%d,%d},{%d,%d,%d,%d,%d},{%d,%d,%d,%d,%d}}\n';
        fprintf(formatSpec, i, A(1,1), A(1,2), A(1,3), A(1,4), A(1,5),A(2,1), A(2,2), A(2,3), A(2,4), A(2,5), A(3,1), A(3,2), A(3,3), A(3,4), A(3,5), A(4,1), A(4,2), A(4,3), A(4,4), A(4,5), A(5,1), A(5,2), A(5,3), A(5,4), A(5,5))
    end

    if size(k4cones{i},2) == 6
        S = k4cones{i};
        A = zeros(5,6);
        for j=1:6
            ind = S(j);
            A(:, j) = rays(:, ind+1);
        end
        formatSpec = 'C%d = coneFromVData matrix {{%d,%d,%d,%d,%d, %d},{%d,%d,%d,%d,%d, %d},{%d,%d,%d,%d,%d, %d},{%d,%d,%d,%d,%d, %d},{%d,%d,%d,%d,%d, %d}}\n';
        fprintf(formatSpec, i, A(1,1), A(1,2), A(1,3), A(1,4), A(1,5), A(1,6), A(2,1), A(2,2), A(2,3), A(2,4), A(2,5), A(2,6),  A(3,1), A(3,2), A(3,3), A(3,4), A(3,5), A(3,6), A(4,1), A(4,2), A(4,3), A(4,4), A(4,5), A(4,6), A(5,1), A(5,2), A(5,3), A(5,4), A(5,5), A(5,6))
    end
end

%F = fan {C1, C2, C3, C4, C5, C6, C7, C8, C9, C10, C11, C12, C13, C14, C15, C16, C17, C18, C19, C20, C21, C22}


function cycles = sixCycles(p)
%generates all distinct 6-cycles on p, a 1x6 array [a b c d e f]
%modulo rotation and reversal

P = perms(p);          %all permutations
seen = containers.Map('KeyType','char','ValueType','logical');

cycles = {};
k = 1;

for i = 1:size(P,1)
    p = P(i,:);

    x = min(p);

    %fix representative: start with 1
    if p(1) ~= x
        continue
    end

    %rotate
    r = p;

    %reverse cycle
    rev = [p(1), fliplr(p(2:end))];

    %canonical representative: lexicographically smallest
    if lexLess(rev, r)
        r = rev;
    end

    key = num2str(r);

    if ~isKey(seen, key)
        seen(key) = true;
        cycles{k} = r;
        k = k + 1;
    end
end
end

function tf = lexLess(a,b)
%returns true if a < b lexicographically
    tf = false;
    for i = 1:length(a)
        if a(i) < b(i)
            tf = true;
            return
        elseif a(i) > b(i)
            return
        end
    end
end
