% Settings
%
% MultiplyMatrixByMatrixSettings
%
% Possible values: 0 or 1
%
%skipCompressionAfterAdditionOfMatrices=1;





%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% test 1 - dla masslowrank(0,32,5,0)
 epsilon=0.00001; 
 r=10;
% 
% %załaduj macierz wygenerowaną przez masslowrank(0,32,5,0) 
% 
A_compressed = compressMatrix(B, epsilon, r);
B_compressed = A_compressed;
C_compressed = A_compressed;
%B_compressed = compressMatrix(B, epsilon, r);
% C_compressed = compressMatrix(B, epsilon, r);
% 
AB_compressed = MultiplyMatrixByMatrix(A_compressed, B_compressed);
ABC_compressed = MultiplyMatrixByMatrix(AB_compressed, C_compressed);

AB=B*B;
ABC=AB*B;
AB_compressed_v2 = compressMatrix(AB, epsilon, r);
ABC_compressed_v2 = compressMatrix(ABC, epsilon, r);

generateBitmap(10000,AB_compressed)
generateBitmap(1000,AB_compressed_v2)

generateBitmap(1000,ABC_compressed)
generateBitmap(1000,ABC_compressed_v2)

%test 1 - koniec
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%result = MultiplyMatrixByMatrix(A_compressed, B_compressed);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% A = masslowrank(0,18,2,0);
% B = masslowrank(0,18,2,0);
% A_compressed = compressMatrix(A, epsilon, r);
% B_compressed = compressMatrix(B, epsilon, r)

% corner case 1  - liczba dzieci w A_compressed == 0 i B_compressed == 0, rząd obu == 0 - start
%  A = [0 0 0 ; 0 0 0 ];
%  B = [0 0; 0 0 ; 0 0 ];
% 
% A_compressed = compressMatrix(A, epsilon, r);
% B_compressed = compressMatrix(B, epsilon, r);
% 
% A_compressed = A_compressed.children(3);
% B_compressed = B_compressed.children(3);
% 
% result = MultiplyMatrixByMatrix(A_compressed, B_compressed);
% corner case 1 - end


% corner case 2  - liczba dzieci w A_compressed == 0 i B_compressed == 0, rząd obu != 0 - start
%  A = [1 1 1 ; 2 2 2 ];
%  B = [4 4; 4 4 ; 4 4 ];
% 
% A_compressed = compressMatrix(A, epsilon, r);
% B_compressed = compressMatrix(B, epsilon, r);
% 
% A_compressed = A_compressed.children(1);
% B_compressed = B_compressed.children(1);

%result = MultiplyMatrixByMatrix(A_compressed, B_compressed);
% corner case 2 - end






