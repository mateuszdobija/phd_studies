function testMultiplyMatrixByMatrix2()
epsilon=0.0001 
r=10
[A]=mmread('matrix-8x8');
B=A;
%B = A(92:130,92:130)
%B = rand(5,5);

% B1 = eye(64);
% B1(1:39,1:39) = B;
% B=B1;
v = compressMatrix(B, epsilon, r);
%generateBitmap(1000,v);

if checkCorrectnessOfTreeStructure(v)~=0
    error('error');
end
                
C = InverseMatrix(v, epsilon, r);

end