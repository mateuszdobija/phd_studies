function [node, cost] = MultiplyMatrixByMatrix(A, B, epsilon, r)
    disp('MultiplyMatrixByMatrix enter');
    A
    A.U_columns
    A.V_rows
    B
    B.U_columns
    B.V_rows
    
    cost = 0;
    
    if A.no_of_children == 0 && B.no_of_children == 0
        disp('MultiplyMatrixByMatrix enter1');
        %if A.rank == 0 || B.rank == 0
            %[numRows,~]=size(A);
            %[~,numCols]=size(B);
            %node.rowsWithZero = numRows;
            %node.columnsWithZero = numCols;

        if A.rank == 0 && B.rank == 0
            node=Node;
            node.rank=0;
            node.rowsWithZero = A.rowsWithZero;
            node.columnsWithZero = B.columnsWithZero;
            if checkCorrectnessOfTreeStructure(node)~=0
                error('error');
            end
        elseif A.rank == 0 && B.rank ~= 0
            node=Node;
            node.rank=0;
            node.rowsWithZero = A.rowsWithZero;
            [~,numCols]=size(B.V_rows);
            node.columnsWithZero=numCols;
            if checkCorrectnessOfTreeStructure(node)~=0
                error('error');
            end
        elseif A.rank ~= 0 && B.rank == 0
            node=Node;
            node.rank=0;
            [numRows,~]=size(A.U_columns);
            node.rowsWithZero = numRows;
            node.columnsWithZero = B.columnsWithZero;
            if checkCorrectnessOfTreeStructure(node)~=0
               error('error'); 
            end
        else
            [~,numCols]=size(A.U_columns);

            node=Node;
            node.rank=numCols;
            node.U_columns = A.U_columns;
            tmp = (A.V_rows * B.U_columns);
            [~,tmp_numCols]=size(tmp);
            [tmp_numRows,~]=size(B.V_rows);
            %COST
            node.V_rows = (tmp * B.V_rows);
            node = formatRankOfNode(node);
            A.U_columns
        end
        if checkCorrectnessOfTreeStructure(A)~=0
           error('error'); 
        end
        if checkCorrectnessOfTreeStructure(B)~=0
           error('error'); 
        end
        if checkCorrectnessOfTreeStructure(node)~=0
           error('error'); 
        end
    elseif A.no_of_children ~= 0 && B.no_of_children ~= 0
        disp('MultiplyMatrixByMatrix enter2');
        [multiply_result1, multiply_cost1] = MultiplyMatrixByMatrix(A.children(1), B.children(1), epsilon, r);
        [multiply_result2, multiply_cost2] = MultiplyMatrixByMatrix(A.children(2), B.children(3), epsilon, r);
        cost = cost + multiply_cost1 + multiply_cost2;
        subnode11 = Addition(multiply_result1, multiply_result2, epsilon, r);
        
        [multiply_result3, multiply_cost3] = MultiplyMatrixByMatrix(A.children(1), B.children(2), epsilon, r);
        [multiply_result4, multiply_cost4] = MultiplyMatrixByMatrix(A.children(2), B.children(4), epsilon, r);
        cost = cost + multiply_cost3 + multiply_cost4;
        subnode12 = Addition(multiply_result3, multiply_result4, epsilon, r);
        
        [multiply_result5, multiply_cost5] = MultiplyMatrixByMatrix(A.children(3), B.children(1), epsilon, r);
        [multiply_result6, multiply_cost6] = MultiplyMatrixByMatrix(A.children(4), B.children(3), epsilon, r);
        cost = cost + multiply_cost5 + multiply_cost6;
        subnode21 = Addition(multiply_result5, multiply_result6, epsilon, r);
        
        [multiply_result7, multiply_cost7] = MultiplyMatrixByMatrix(A.children(3), B.children(2), epsilon, r);
        [multiply_result8, multiply_cost8] = MultiplyMatrixByMatrix(A.children(4), B.children(4), epsilon, r);
        cost = cost + multiply_cost7 + multiply_cost8;
        subnode22 = Addition(multiply_result7, multiply_result8, epsilon, r);
    
        node=Node;
        append_child(node, subnode11);
        append_child(node, subnode12);
        append_child(node, subnode21);
        append_child(node, subnode22);
        
        if checkCorrectnessOfTreeStructure(node)~=0
            error('error');
        end
    elseif A.no_of_children == 0 && B.no_of_children ~= 0
        disp('MultiplyMatrixByMatrix enter3');
        if A.rank == 0
            node=Node;
            node.rank=0;
            node.rowsWithZero = A.rowsWithZero;
            node.columnsWithZero=getNumberOfColumnsOfNodeWhichHaveChildren(B);
           if checkCorrectnessOfTreeStructure(node)~=0
                error('error'); 
           end
        else
            if checkCorrectnessOfTreeStructure(A)~=0
                error('error');
            end
            [numRows,~]=size(A.U_columns);
            [~,numCols]=size(A.V_rows);

            if numRows == 1 || numCols == 1
                %node = Node;
                vector = A.U_columns * A.V_rows;
                [node, ~] = MultiplyVectorByMatrix(vector, B);
                node = compressMatrix(node, epsilon, r);
            else
                    U_prim = A.U_columns(1:floor(numRows/2),:);
                    U_bis = A.U_columns(floor(numRows/2+1):numRows,:);

                    V_prim =  A.V_rows(:,1:floor(numCols/2));
                    V_bis = A.V_rows(:,floor(numCols/2+1):numCols);

                    [~,numCols]=size(A.U_columns);

                    if(nnz(U_prim) == 0 || nnz(V_prim) == 0)
                        U_primV_prim = Node;
                        U_primV_prim.rank = 0;
                        [numRows,~]=size(U_prim);
                        [~,numCols]=size(V_prim);
                        U_primV_prim.rowsWithZero = numRows;
                        U_primV_prim.columnsWithZero = numCols;
                    else                
                        U_primV_prim = Node;
                        U_primV_prim.rank = numCols;
                        U_primV_prim.U_columns = U_prim;
                        U_primV_prim.V_rows = V_prim;
                    end 

                    if(nnz(U_prim) == 0 || nnz(V_bis) == 0)
                        U_primV_bis = Node;
                        U_primV_bis.rank = 0;
                        [numRows,~]=size(U_prim);
                        [~,numCols]=size(V_bis);
                        U_primV_bis.rowsWithZero = numRows;
                        U_primV_bis.columnsWithZero = numCols;
                    else
                        U_primV_bis = Node;
                        U_primV_bis.rank = numCols;
                        U_primV_bis.U_columns = U_prim;
                        U_primV_bis.V_rows = V_bis;
                    end

                    if(nnz(U_bis) == 0 || nnz(V_prim) == 0)
                        U_bisV_prim = Node;
                        U_bisV_prim.rank = 0;
                        [numRows,~]=size(U_bis);
                        [~,numCols]=size(V_prim);
                        U_bisV_prim.rowsWithZero = numRows;
                        U_bisV_prim.columnsWithZero = numCols;
                    else
                        U_bisV_prim = Node;
                        U_bisV_prim.rank = numCols;
                        U_bisV_prim.U_columns = U_bis;
                        U_bisV_prim.V_rows = V_prim;
                    end

                    if(nnz(U_bis) == 0 || nnz(V_bis) == 0)
                        U_bisV_bis = Node;
                        U_bisV_bis.rank = 0;
                        [numRows,~]=size(U_bis);
                        [~,numCols]=size(V_bis);
                        U_bisV_bis.rowsWithZero = numRows;
                        U_bisV_bis.columnsWithZero = numCols;
                    else
                        U_bisV_bis = Node;
                        U_bisV_bis.rank = numCols;
                        U_bisV_bis.U_columns = U_bis;
                        U_bisV_bis.V_rows = V_bis;
                    end
                    if checkCorrectnessOfTreeStructure(U_primV_prim)~=0
                        error('error');
                    end
                    if checkCorrectnessOfTreeStructure(U_primV_bis)~=0
                        error('error');
                    end
                    
                    if checkCorrectnessOfTreeStructure(B.children(1))~=0
                        error('error');
                    end
                    
                    if checkCorrectnessOfTreeStructure(B.children(2))~=0
                        error('error');
                    end
                    if checkCorrectnessOfTreeStructure(B.children(4))~=0
                        error('error');
                    end
                    epsilon
                    r
%                     [multiply_result4, multiply_cost4] = 
%                     cost = cost + multiply_cost3 + multiply_cost4;
                    
                    [multiply_result1, multiply_cost1] = MultiplyMatrixByMatrix(U_primV_prim, B.children(1), epsilon, r);
                    [multiply_result2, multiply_cost2] = MultiplyMatrixByMatrix(U_primV_bis, B.children(3), epsilon, r);
                    cost = cost + multiply_cost1 + multiply_cost2;
                    subnode11 = Addition(multiply_result1, multiply_result2, epsilon, r);
                    
                    [multiply_result3, multiply_cost3] = MultiplyMatrixByMatrix(U_primV_prim, B.children(2), epsilon, r);
                    [multiply_result4, multiply_cost4] = MultiplyMatrixByMatrix(U_primV_bis, B.children(4), epsilon, r);
                    cost = cost + multiply_cost3 + multiply_cost4;
                    
                    if checkCorrectnessOfTreeStructure(multiply_result3)~=0
                        error('error');
                    end
                    if checkCorrectnessOfTreeStructure(multiply_result4)~=0
                        error('error');
                    end
                    
                    subnode12 = Addition(multiply_result3, multiply_result4, epsilon, r);
                    
                    [multiply_result5, multiply_cost5] = MultiplyMatrixByMatrix(U_bisV_prim, B.children(1), epsilon, r);
                    [multiply_result6, multiply_cost6] = MultiplyMatrixByMatrix(U_bisV_bis, B.children(3), epsilon, r);
                    cost = cost + multiply_cost5 + multiply_cost6;
                    subnode21 = Addition(multiply_result5, multiply_result6, epsilon, r);
                    
                    [multiply_result7, multiply_cost7] = MultiplyMatrixByMatrix(U_bisV_prim, B.children(2), epsilon, r);
                    [multiply_result8, multiply_cost8] = MultiplyMatrixByMatrix(U_bisV_bis, B.children(4), epsilon, r);
                    cost = cost + multiply_cost7 + multiply_cost8;
                    subnode22 = Addition(multiply_result7, multiply_result8, epsilon, r);

                    node=Node;
                    append_child(node, subnode11);
                    append_child(node, subnode12);
                    append_child(node, subnode21);
                    append_child(node, subnode22);
            end
                if checkCorrectnessOfTreeStructure(node)~=0
                   error('error'); 
                end
        end
    elseif A.no_of_children ~= 0 && B.no_of_children == 0
        disp('MultiplyMatrixByMatrix enter4');
        if B.rank == 0
            disp('MultiplyMatrixByMatrix enter4_1');
            node=Node;
            node.rank=0;
            node.rowsWithZero = getNumberOfRowsOfNodeWhichHaveChildren(A); 
            node.columnsWithZero=B.columnsWithZero;
        else
            disp('MultiplyMatrixByMatrix enter4_2');
            [numRows,~]=size(B.U_columns);
            [~,numCols]=size(B.V_rows);
            
            if numRows == 1 || numCols == 1
                %node = Node;
                vector = B.U_columns * B.V_rows;
                %COST
                [node, ~] = MultiplyMatrixByVector(A, vector);
                node = compressMatrix(node, epsilon, r);
            else
                U_prim = B.U_columns(1:floor(numRows/2),:);
                U_bis = B.U_columns(floor(numRows/2+1):numRows,:);

                V_prim =  B.V_rows(:,1:floor(numCols/2));
                V_bis = B.V_rows(:,floor(numCols/2+1):numCols);

                [~,numCols]=size(B.U_columns);

                if(nnz(U_prim) == 0 || nnz(V_prim) == 0)
                    disp('MultiplyMatrixByMatrix enter4_2_1');
                    U_primV_prim = Node;
                    U_primV_prim.rank = 0;
                    [numRows,~]=size(U_prim);
                    [~,numCols]=size(V_prim);
                    U_primV_prim.rowsWithZero = numRows;
                    U_primV_prim.columnsWithZero = numCols;
                else
                    disp('MultiplyMatrixByMatrix enter4_2_2');
                    U_primV_prim = Node;
                    U_primV_prim.rank = numCols;
                    U_primV_prim.U_columns = U_prim;
                    U_primV_prim.V_rows = V_prim;
                end

                if(nnz(U_prim) == 0 || nnz(V_bis) == 0)
                    disp('MultiplyMatrixByMatrix enter4_2_3');
                    U_primV_bis = Node;
                    U_primV_bis.rank = 0;
                    [numRows,~]=size(U_prim);
                    [~,numCols]=size(V_bis);
                    U_primV_bis.rowsWithZero = numRows;
                    U_primV_bis.columnsWithZero = numCols;
                else
                    disp('MultiplyMatrixByMatrix enter4_2_4');
                    U_primV_bis = Node;
                    U_primV_bis.rank = numCols;
                    U_primV_bis.U_columns = U_prim;
                    U_primV_bis.V_rows = V_bis;
                end

                if(nnz(U_bis) == 0 || nnz(V_prim) == 0)
                    disp('MultiplyMatrixByMatrix enter4_2_5');
                    U_bisV_prim = Node;
                    U_bisV_prim.rank = 0;
                    [numRows,~]=size(U_bis);
                    [~,numCols]=size(V_prim);
                    U_bisV_prim.rowsWithZero = numRows;
                    U_bisV_prim.columnsWithZero = numCols;
                else
                    disp('MultiplyMatrixByMatrix enter4_2_6');
                    U_bisV_prim = Node;
                    U_bisV_prim.rank = numCols;
                    U_bisV_prim.U_columns = U_bis;
                    U_bisV_prim.V_rows = V_prim;
                end

                if(nnz(U_bis) == 0 || nnz(V_bis) == 0)
                    disp('MultiplyMatrixByMatrix enter4_2_7');
                    U_bisV_bis = Node;
                    U_bisV_bis.rank = 0;
                    [numRows,~]=size(U_bis);
                    [~,numCols]=size(V_bis);
                    U_bisV_bis.rowsWithZero = numRows;
                    U_bisV_bis.columnsWithZero = numCols;
                else
                    disp('MultiplyMatrixByMatrix enter4_2_8');
                    U_bisV_bis = Node;
                    U_bisV_bis.rank = numCols;
                    U_bisV_bis.U_columns = U_bis;
                    U_bisV_bis.V_rows = V_bis;
                end

                disp('MultiplyMatrixByMatrix enter4_3');
                if checkCorrectnessOfTreeStructure(A.children(1))~=0
                    error('error');
                end
                if checkCorrectnessOfTreeStructure(U_primV_prim)~=0
                    error('error');
                end
                A.children(1)
                U_primV_prim
                epsilon
                r
                %                     [multiply_result4, multiply_cost4] =
                %                     cost = cost + multiply_cost3 + multiply_cost4;
                [multiply_result1, multiply_cost1] = MultiplyMatrixByMatrix(A.children(1), U_primV_prim, epsilon, r);
                [multiply_result2, multiply_cost2] = MultiplyMatrixByMatrix(A.children(2), U_bisV_prim,  epsilon, r);

                if checkCorrectnessOfTreeStructure(multiply_result1)~=0
                    error('error');
                end

                if checkCorrectnessOfTreeStructure(multiply_result2)~=0
                    error('error');
                end
                disp('MultiplyMatrixByMatrix enter4_4');
                subnode11 = Addition(multiply_result1, multiply_result2, epsilon, r);

                [multiply_result3, multiply_cost3] = MultiplyMatrixByMatrix(A.children(1), U_primV_bis, epsilon, r);

                if checkCorrectnessOfTreeStructure(multiply_result3)~=0
                    error('error');
                end

                [multiply_result4, multiply_cost4] = MultiplyMatrixByMatrix(A.children(2), U_bisV_bis, epsilon, r);

                if checkCorrectnessOfTreeStructure(multiply_result4)~=0
                    error('error');
                end
                subnode12 = Addition(multiply_result3, multiply_result4, epsilon, r);

                [multiply_result5, multiply_cost5] = MultiplyMatrixByMatrix(A.children(3), U_primV_prim, epsilon, r);

                if checkCorrectnessOfTreeStructure(multiply_result5)~=0
                    error('error');
                end
                if checkCorrectnessOfTreeStructure(A.children(4))~=0
                    error('error');
                end
                [multiply_result6, multiply_cost6]= MultiplyMatrixByMatrix(A.children(4), U_bisV_prim, epsilon, r);

                if checkCorrectnessOfTreeStructure(multiply_result6)~=0
                    error('error');
                end

                subnode21 = Addition(multiply_result5, multiply_result6, epsilon, r);

                [multiply_result7, multiply_cost7] = MultiplyMatrixByMatrix(A.children(3), U_primV_bis, epsilon, r);

                if checkCorrectnessOfTreeStructure(multiply_result7)~=0
                    error('error');
                end

                [multiply_result8, multiply_cost8] = MultiplyMatrixByMatrix(A.children(4), U_bisV_bis, epsilon, r);

                if checkCorrectnessOfTreeStructure(multiply_result8)~=0
                    error('error');
                end

                subnode22 = Addition(multiply_result7, multiply_result8, epsilon, r);

                node=Node;
                append_child(node, subnode11);
                append_child(node, subnode12);
                append_child(node, subnode21);
                append_child(node, subnode22);
            end
            if checkCorrectnessOfTreeStructure(node)~=0
               error('error'); 
            end
        end
    else
        warning('MultiplyMatrixByMatrix(A, B): Unhandled case. Investigation is needed.')
    end
%result = 0;
        disp('MultiplyMatrixByMatrix leave');
        
    if checkCorrectnessOfTreeStructure(node)~=0
       error('error');
    end
end



function [numRows] = getNumberOfRowsOfNodeWhichHaveChildren(node)
    disp('getNumberOfRowsOfNodeWhichHaveChildren enter');
    numRows = 0;

    submatrix11 = node.children(1);
    submatrix21 = node.children(3);

    if submatrix11.no_of_children ~= 0
        numRows = numRows + getNumberOfRowsOfNodeWhichHaveChildren(submatrix11);
    else
        if submatrix11.rank == 0
            numRows = numRows + submatrix11.rowsWithZero;
        else
            [localNumRows,~]=size(submatrix11.U_columns);
            numRows = numRows + localNumRows;
        end
    end

    if submatrix21.no_of_children ~= 0
        numRows = numRows + getNumberOfRowsOfNodeWhichHaveChildren(submatrix21);
    else
        if submatrix21.rank == 0
            numRows = numRows + submatrix21.rowsWithZero;
        else
            [localNumRows,~]=size(submatrix21.U_columns);
            numRows = numRows + localNumRows;
        end
    end
    
    if checkCorrectnessOfTreeStructure(node)~=0
        error('error');
    end
    disp('getNumberOfRowsOfNodeWhichHaveChildren leave');
end

function [numCols] = getNumberOfColumnsOfNodeWhichHaveChildren(node)
    disp('getNumberOfColumnsOfNodeWhichHaveChildren enter');
    numCols = 0;

    submatrix11 = node.children(1);
    submatrix12 = node.children(2);

    if submatrix11.no_of_children ~= 0
        numCols = numCols + getNumberOfColumnsOfNodeWhichHaveChildren(submatrix11);
    else
        if submatrix11.rank == 0
            numCols = numCols + submatrix11.columnsWithZero;
        else
            [~,localNumCols]=size(submatrix11.V_rows);
            numCols = numCols + localNumCols;
        end
    end

    if submatrix12.no_of_children ~= 0
        numCols = numCols + getNumberOfColumnsOfNodeWhichHaveChildren(submatrix12);
    else
        if submatrix12.rank == 0
            numCols = numCols + submatrix12.columnsWithZero;
        else
            [~,localNumCols]=size(submatrix12.V_rows);
            numCols = numCols + localNumCols;
        end
    end
    disp('getNumberOfColumnsOfNodeWhichHaveChildren leave');
end