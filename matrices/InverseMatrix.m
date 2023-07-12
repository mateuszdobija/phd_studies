function [B] = InverseMatrix(A, epsilon, r)
% Input parameters:
%   - A
%   Matrix to inverse. Matrix in compressed format.
%
%   Description:
%
%   Function inverse the matrix passed as a parameter A.
%   Since matrix is in compressed format, A should be a type Node, and
%   should be a root of compressed matrix.
%   Because Node is as called handle class(see: https://www.mathworks.com/help/matlab/matlab_oop/handle-objects.html
%   and
%   https://www.mathworks.com/help/matlab/matlab_oop/how-to-define-handle-compatible-classes-1.html),
%   this function works in place, i.e. we do not need to return A and assign it to a variable, as all
%   modifications are done at A directly, and A in this modified form is
%   available from the caller level after performing this function.
%
% if ~isa(A, Node)
%        error('Error. \nA must be a Node (root of compressed matrix), not a %s.',class(A))
% end

% if A.no_of_children~=4
%        error('Error. \nA should have 4 children (4 compressed submatrices).')
% end

    if A.no_of_children == 0
        if A.rank~=0
            if checkCorrectnessOfTreeStructure(A)~=0
                error('error'); 
            end
            rebuild_matrix = A.U_columns * A.V_rows;
            %[numRows,numCols]=size(rebuild_matrix);
            %X = sprintf('U_columns:numRows = %d,V_rows:numCols = %d.', numRows, numCols);
            %disp(X);
            disp("Rebuild matrix: U_columns");
            A.U_columns
            disp("Rebuild matrix: V_rows");
            A.V_rows
            disp("Rebuild matrix");
            rebuild_matrix;
            rebuild_matrix_inversed = inv(rebuild_matrix);
            rebuild_matrix_inversed_compressed = compressMatrix(rebuild_matrix_inversed, epsilon, r);
            B = rebuild_matrix_inversed_compressed;
            if checkCorrectnessOfTreeStructure(B)~=0
                error('error'); 
            end
        else
            error('Error. Zeroed matrix. Unhnandled case')
        end
    else
        if checkCorrectnessOfTreeStructure(A.children(1))~=0
           error('error'); 
        end
        
        disp("test: 59");
        A.children(1)
        A.children(1).U_columns
        A.children(1).V_rows
        A11_inv = InverseMatrix(A.children(1), epsilon, r);
        
        if checkCorrectnessOfTreeStructure(A11_inv)~=0
           error('error'); 
        end
        
        if checkCorrectnessOfTreeStructure(A.children(3))~=0
           error('error'); 
        end
        
        S22 = MultiplyMatrixByMatrix(A.children(3), A11_inv, epsilon, r);
        if checkCorrectnessOfTreeStructure(S22)~=0
           error('error'); 
        end
        if checkCorrectnessOfTreeStructure(A.children(2))~=0
           error('error'); 
        end
        S22 = MultiplyMatrixByMatrix(S22, A.children(2), epsilon, r);
        if checkCorrectnessOfTreeStructure(S22)~=0
           error('error'); 
        end
        S22_negated = NegateMatrix(S22);
        if checkCorrectnessOfTreeStructure(S22_negated)~=0
           error('error'); 
        end
        disp("Rebuild matrix: Before addition");
        A.children(4).U_columns
        A.children(4).V_rows
        S22_negated
        S22 = Addition(A.children(4), S22_negated, epsilon, r);
        if checkCorrectnessOfTreeStructure(S22)~=0
           error('error'); 
        end
        disp("test: 96");
        S22.U_columns
        S22.V_rows
        
        S22_inversed = InverseMatrix(S22, epsilon, r);
        
        if checkCorrectnessOfTreeStructure(S22_inversed)~=0
           error('error'); 
        end
        
        B11 = MultiplyMatrixByMatrix(A.children(2), S22_inversed, epsilon, r);
        if checkCorrectnessOfTreeStructure(B11)~=0
           error('error'); 
        end
        if checkCorrectnessOfTreeStructure(A.children(3))~=0
           error('error'); 
        end
        B11 = MultiplyMatrixByMatrix(B11, A.children(3), epsilon, r);
        if checkCorrectnessOfTreeStructure(B11)~=0
           disp('error'); 
        end
        B11 = MultiplyMatrixByMatrix(B11, A11_inv, epsilon, r);
        if checkCorrectnessOfTreeStructure(B11)~=0
           disp('error'); 
        end
        disp("test: 125 A11_inv");
        A11_inv.U_columns
        A11_inv.V_rows
        
        disp("test: 125 B11");
        B11.U_columns
        B11.V_rows
        
        B11 = MultiplyMatrixByMatrix(A11_inv, B11, epsilon, r);
        if checkCorrectnessOfTreeStructure(B11)~=0
           error('error'); 
        end
        B11 = Addition(A11_inv, B11, epsilon, r);
        
        if checkCorrectnessOfTreeStructure(B11)~=0
           error('error'); 
        end
        
        B12 = NegateMatrix(A11_inv);
        B12 = MultiplyMatrixByMatrix(B12, A.children(2), epsilon, r);
        B12 = MultiplyMatrixByMatrix(B12, S22_inversed, epsilon, r);
        
        if checkCorrectnessOfTreeStructure(B12)~=0
           error('error'); 
        end
        
        B21 = NegateMatrix(S22_inversed);
        B21 = MultiplyMatrixByMatrix(B21, A.children(3), epsilon, r);
        B21 = MultiplyMatrixByMatrix(B21, A11_inv, epsilon, r);
                
        if checkCorrectnessOfTreeStructure(B21)~=0
           error('error'); 
        end
        B22 = S22_inversed;
        
        if checkCorrectnessOfTreeStructure(B22)~=0
           error('error'); 
        end
        
        B = Node;
        append_child(B, B11);
        append_child(B, B12);
        append_child(B, B21);
        append_child(B, B22);
    end
    
end

function [node] = NegateMatrix(A)
    if A.no_of_children == 0
        if A.rank~=0
            node=Node;
            node.rank=A.rank;     
            node.U_columns = A.U_columns;
            node.V_rows = A.V_rows * (-1); %U_columns and eigenvalues should not be changed . only V_rows values should be negated when we negate the matrix A (when A is in compressed format).
        else
            node=Node;
            node.rank=0;
            node.rowsWithZero = A.rowsWithZero;
            node.columnsWithZero = A.columnsWithZero;
        end
    else
        A11_negated = NegateMatrix(A.children(1));
        A12_negated = NegateMatrix(A.children(2));
        A21_negated = NegateMatrix(A.children(3));
        A22_negated = NegateMatrix(A.children(4));
        
        node=Node;
        append_child(node, A11_negated);
        append_child(node, A12_negated);
        append_child(node, A21_negated);
        append_child(node, A22_negated);
    end
end