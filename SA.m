clear 

load('Instance');
costMatrix = A;

tour_cost = 0;

tour = [randi([1 size(costMatrix,1)])];
for i=1:size(costMatrix,1)
    if i~=size(costMatrix,1)
        current = tour(end);

        current_row = costMatrix(current,:);
        current_row([tour]) = Inf;
        
        shortest = find(current_row==min(current_row));

        tour = [tour shortest(1)];
            
        tour_cost = tour_cost + costMatrix(tour(end),tour(end-1));
    else
        tour = [tour tour(1)];
        tour_cost = tour_cost + costMatrix(tour(end),tour(end-1));
    end
end

% Simulated Annealing start 

T = 50;
alpha = 0.99;
I = 500;

% NUMBER OF TIMES TEMPERATURE IS ALLOWED TO CHANGE
iter = 1;
iter_lim = 600;

% RECORDING THE BEST TOUR 
best_cost = tour_cost;
best_tour = tour;

% IMPROVEMENT STOPPING RULE 
last_imp = 0;
stop = 0;

% step is needed for creating a graph 
step = 1;

figure;
hold on 

while iter < iter_lim
    
    i=1;
   
    while i ~= I
%     PICK RANDOM EDGES TO SWAP
    [edge1,edge2] = chooserand(tour,costMatrix);
    
%     SWAP PICKED EDGES
    [newTour,tourCost] = twoEdgeExchange(costMatrix, tour, tour_cost, edge1, edge2);
    
    
%     RECORD THE BEST TOUR SO FAR
    if iter>200
        if tourCost < best_cost;
            best_cost = tourCost;
            best_tour = newTour;
            last_improvement = step; 
        end
    end

%     ASSIGN PROBABILITIES
    if tourCost <= tour_cost
        A = 1;      
    else 
        A = exp((tour_cost - tourCost)/T);
    end
    
    u = rand();
    
    if u <= A
        plot(step,tourCost,'r.'); drawnow;
        
        step = step + 1;
       
%         UPDATE CURRENT TOUR 
        tour_cost = tourCost;
        tour = newTour;
    end

    if iter>300
        if step - last_improvement > 50
            stop = 1;
            break
        end
    end
    
    i=i+1;
    
    
    end    
    
    if stop==1;
        break
    end
            
    T = alpha*T;
    
    iter = iter + 1
end

best_tour = tour
best_cost = tour_cost



function [e1,e2] = chooserand(tour,costMatrix)
    e1 = randperm(size(costMatrix,1),1);
    if e1 == 1
        not_allowed = [e1 e1+1 size(costMatrix,1)];
        
    elseif e1 == size(costMatrix,1)
        not_allowed = [e1 e1-1 1];
        
    else 
        not_allowed = [e1-1 e1 e1+1];
    end
    
    allowed = setdiff(1:size(costMatrix,1),not_allowed);
    
    e2 = randsample(allowed,1);
end
