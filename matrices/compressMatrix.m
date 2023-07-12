 function [v] = compressMatrix(A, epsilon, r)
    disp('compressMatrix enter');    
    [numRows,numCols]=size(A);
    
    %if numRows == numCols
    %    n=numRows;
    %else
    %    warning('This is not square matrix')
        %return
    %end
    %
    %Make empty node
    v = Node;
    
    %Extract sub-matrices from A
    %A11=A(1:floor(n/2),1:floor(n/2));
    %A12=A(1:floor(n/2),floor(n/2+1):n); 
    %A21=A(floor(n/2+1):n,1:floor(n/2));
    %A22=A(floor(n/2+1):n,floor(n/2+1):n);
    
    [numRows,numCols]=size(A);
    
    if numRows ==0 || numCols == 0
        error("error");
    end
    if numRows == 1 || numCols == 1
        minimum=min(numRows, numCols);
       [U,D,V]=svds(A,minimum);
        eigenvalues = diag(D);
        rank = sum(abs(eigenvalues) > epsilon);   
        
        if rank > 0
            v.rank=rank;
            v.eigenvalues = eigenvalues(1:rank);
            v.U_columns = U(:,1:rank);
            V_transposed = V';
            v.V_rows = V_transposed(1:rank,:);   %V transponowane
            for i=1:rank
                v.V_rows(i,:) = v.V_rows(i,:) * v.eigenvalues(i);
            end
        else
            v.rank=0;
            v.rowsWithZero = numRows;
            v.columnsWithZero = numCols;
        end
    else
        A11=A(1:floor(numRows/2),1:floor(numCols/2));
        A12=A(1:floor(numRows/2),floor(numCols/2+1):numCols); 
        A21=A(floor(numRows/2+1):numRows,1:floor(numCols/2));
        A22=A(floor(numRows/2+1):numRows,floor(numCols/2+1):numCols);

        node = handleSubmatrix(A11, epsilon, r);
        append_child(v, node);

        node = handleSubmatrix(A12, epsilon, r);
        append_child(v, node);

        node = handleSubmatrix(A21, epsilon, r);
        append_child(v, node);

        node = handleSubmatrix(A22, epsilon, r);
        append_child(v, node);
        disp('compressMatrix leave');  
    end
    if checkCorrectnessOfTreeStructure(v)~=0
       error('error'); 
    end
end


function [node] = handleSubmatrix(A, epsilon, r)
    disp('handleSubmatrix enter');    
    if nnz(A) == 0                          %nnz - number of non-zero elements in a matrix
        node=Node;
        node.rank=0;
        [numRows,numCols]=size(A);
        node.rowsWithZero = numRows;
        node.columnsWithZero = numCols;
    else
        [numRows,numCols]=size(A);
        minimum=min(numRows, numCols);
        [U,D,V]=svds(A,minimum);
        eigenvalues = diag(D);
        rank = sum(abs(eigenvalues) > epsilon);

        [numRows,numCols]=size(A);

        if rank == 0
            node=Node;
            node.rank=0;
            node.rowsWithZero = numRows;
            node.columnsWithZero = numCols;
        elseif ((rank <= r) && (rank < (numRows/2))) || (rank == 1)
            node=Node;
            node.rank=rank;
            node.eigenvalues = eigenvalues(1:rank);
            %node.V_columns = V(:, 1:rank);
            %node.U_rows = U(1:rank, :);
            node.U_columns = U(:,1:rank);
            V_transposed = V';
            node.V_rows = V_transposed(1:rank,:);   %V transponowane

            for i=1:rank
                node.V_rows(i,:) = node.V_rows(i,:) * node.eigenvalues(i);
            end
        else
            node = compressMatrix(A, epsilon, r);
        end

    end
    disp('handleSubmatrix leave');   
end