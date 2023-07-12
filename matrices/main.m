%B=[1,2,3,0,0;4,5,0,0,0;6,7,8,0,0;0,3,0,0,0;0,3,0,0,0];
%B = zeros(39,39);
%B(:,:) = 1;
%B1=sparse(B);
%B1 = masslowrank(0,25,5,0);
B = masslowrank(0,4,2,0);
%%%%%%%%%%%%%B = masslowrank(1,13,3,0);
%%%%%%%%%%%%%B = masslowrank(2,12,2,2);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% RAZ URUCHOMIĆ, A
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% POTEM ZAKOMENTOWAĆ -
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% START
% B = masslowrank(0,32,5,0);
% 
% rank_of_matrix=sprank(B);
% [x,y]=eigs(B);
% [a,b]=size(y);
% number_of_eigenvalues = a;
% 
% [numRows,numCols]=size(B);
% z=rand(numRows,1);
% first_cost = nnz(B)*2;
% firstResult = B*z;
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% END

%epsilon=0.0006;
%r=10;

disp('Main start');


%[numRows,numCols]=size(B1)

%v = compressMatrix(B1, epsilon, r);
%generateBitmap(1000,v);
% v= Node;
% node=Node;
% node.rank=0;
% append_child(v, node);
% append_child(v, node);
% node=Node;
% node.rank=0;
% node.rank =1;
% node.no_of_children = 0;
% node.V_rows = 0.0015;
% node.U_columns = [0.9304;0.3665];
% append_child(v, node);
% node=Node;
% node.rank=0;
% node.rank =1;
% node.no_of_children = 0;
% node.V_rows = [-0.0015, -5.3295e-04];
% node.U_columns = [-0.33101;-0.9436];
% append_child(v, node);
% [resx, nested_costx] = MultiplyMatrixByVector(v, [1;1;1]);

%test1 - start
%c = linspace(1,1,4)
%c = c'
%firstResult= B*c;
%secondResult = MultiplyMatrixByVector(v, c);

%difference = secondResult - firstResult;
%logic_result = any(difference);

%test1 - end


%test 2 - start
%epsilon=0.00001;
epsilon=0.001; 
r=6;
B1=B; 
v = compressMatrix(B1, epsilon, r);
%[numRows,numCols]=size(B1);
%c = linspace(1,10,numRows);
%c = c';
%first_cost = nnz(B1)*2;
%firstResult = B1*c;
[secondResult, secondCost] = MultiplyMatrixByVector(v, z);
difference = secondResult - firstResult;
absdifference = abs(difference);
max_difference = max(absdifference);
min_difference = min(absdifference);
generateBitmap(640,v);

%firstResult= MultiplyMatrixByVectorOld(B1,c);


%logic_result = any(difference);

%test 2 - end

%test 2 - rozszerzenie macierzy - start
%[numRows,numCols]=size(B1)
%i=2;
%while i<= numRows
%    i=i*2;
%end

%B_new = zeros(i,i);
%tmp_vec = linspace(1,1,i);
%B_new = diag(tmp_vec);

%B_new(1:numRows, 1:numCols) = B1;
%B_new = sparse(B_new);
%v = compressMatrix(B_new, epsilon, r);


%c = linspace(1,100,i);
%c = c';
%firstResult= MultiplyMatrixByVectorOld(B_new,c);
%secondResult = MultiplyMatrixByVector(v, c);

%difference = secondResult - firstResult;
%logic_result = any(difference);

%test 2 - rozszerzenie macierzy - koniec
disp('Main end');
clear v; clear secondResult; clear secondCost; clear r;
clear min_difference; clear max_difference; clear epsilon;
clear difference; clear B1; clear absdifference;