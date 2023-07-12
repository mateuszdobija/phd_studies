function [node] = Addition(A, B, epsilon, r)
    skipCompressionAfterAdditionOfMatrices=0;
    disp('Addition enter');
    
    [A_numRows_U_columns,A_numCols_U_columns]=size(A.U_columns);
    [A_numRows_V_rows,A_numCols_V_rows]=size(A.V_rows);
    
    [B_numRows_U_columns,B_numCols_U_columns]=size(B.U_columns);
    [B_numRows_V_rows,B_numCols_V_rows]=size(B.V_rows);
    
    if A.no_of_children == 0 && B.no_of_children == 0
        if A.rank == 0 && B.rank == 0      % czy musimy sprawdzac ile ktory node mial kolumn/wierszy, czy po prostu zwracamy dowolny?
            node=Node;
            node.rank=0;

            if (A.rowsWithZero >= B.rowsWithZero)
                node.rowsWithZero = A.rowsWithZero;
            else
                node.rowsWithZero = B.rowsWithZero;
            end

            if (A.columnsWithZero >= B.columnsWithZero)
                node.columnsWithZero = A.columnsWithZero;
            else
                node.columnsWithZero = B.columnsWithZero;
            end
            
                    if checkCorrectnessOfTreeStructure(node)~=0
            error('error'); 
        end
        elseif A.rank == 0 && B.rank ~= 0
            node = B;
            
                    if checkCorrectnessOfTreeStructure(node)~=0
            error('error'); 
        end
        elseif A.rank ~= 0 && B.rank == 0
            node = A;
            
                    if checkCorrectnessOfTreeStructure(node)~=0
            error('error'); 
        end
        elseif A.rank == 1 && B.rank == 1 && A_numRows_U_columns == 1 && A_numCols_V_rows == 1 && B_numRows_U_columns == 1 && B_numCols_V_rows == 1
            node=Node;
            node.rank=1; 
            
            A_rebuild = A.U_columns * A.V_rows;
            B_rebuild = B.U_columns * B.V_rows;
            
            V_rows = A_rebuild + B_rebuild;
            
            node.U_columns = [1];
            node.V_rows = [V_rows];
            
            node = formatRankOfNode(node);
            
            if checkCorrectnessOfTreeStructure(node)~=0
                error('error');
            end
        else
            [~,numCols1]=size(A.U_columns);
            [~,numCols2]=size(B.U_columns);
            
            node=Node;
            node.rank=numCols1 + numCols2; 
            node.U_columns = [A.U_columns B.U_columns];
            node.V_rows = [A.V_rows; B.V_rows];
            node = formatRankOfNode(node);%21062023
            if checkCorrectnessOfTreeStructure(node)~=0
                error('error');
            end

            matrix = node.U_columns * node.V_rows;
            if skipCompressionAfterAdditionOfMatrices == 0
                display('matrix');
                epsilon
                r
                matrix
                node = compressMatrix(matrix, epsilon, r);
            end
        end
        
        if checkCorrectnessOfTreeStructure(node)~=0
            error('error'); 
        end
    elseif A.no_of_children ~= 0 && B.no_of_children ~= 0
        A.children(1)
        B.children(1)
        epsilon
        r
            subnode11 = Addition(A.children(1), B.children(1), epsilon, r);
            subnode12 = Addition(A.children(2), B.children(2), epsilon, r);
            subnode21 = Addition(A.children(3), B.children(3), epsilon, r);
            subnode22 = Addition(A.children(4), B.children(4), epsilon, r);

            node=Node;
            append_child(node, subnode11);
            append_child(node, subnode12);
            append_child(node, subnode21);
            append_child(node, subnode22);
            
        if checkCorrectnessOfTreeStructure(node)~=0
           error('error'); 
        end
    elseif A.no_of_children == 0 && B.no_of_children ~= 0
        if A.rank == 0
            %node=Node;
            %node.rank=0;
            %node.rowsWithZero = A.rowsWithZero;
            %node.columnsWithZero=getNumberOfColumnsOfNodeWhichHaveChildren(B);
            node=B;
        else
            [numRows,~]=size(A.U_columns);
            U_prim = A.U_columns(1:floor(numRows/2),:);
            U_bis = A.U_columns(floor(numRows/2+1):numRows,:);
    
            [~,numCols]=size(A.V_rows);
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
            
            if checkCorrectnessOfTreeStructure(B.children(1))~=0
                error('error');
            end
            subnode11 = Addition(U_primV_prim, B.children(1),epsilon, r);
            subnode12 = Addition(U_primV_bis, B.children(2),epsilon, r);
            subnode21 = Addition(U_bisV_prim, B.children(3),epsilon, r);
            subnode22 = Addition(U_bisV_bis, B.children(4),epsilon, r);
            
            node=Node;
            append_child(node, subnode11);
            append_child(node, subnode12);
            append_child(node, subnode21);
            append_child(node, subnode22);
            if checkCorrectnessOfTreeStructure(node)~=0
                error('error');
            end
        end
    elseif A.no_of_children ~= 0 && B.no_of_children == 0
        if B.rank == 0
%             node=Node;
%             node.rank=0;
%             node.rowsWithZero = getNumberOfRowsOfNodeWhichHaveChildren(A); 
%             node.columnsWithZero=B.columnsWithZero;
              node=A;
        else
            [numRows,~]=size(B.U_columns);
            U_prim = B.U_columns(1:floor(numRows/2),:);
            U_bis = B.U_columns(floor(numRows/2+1):numRows,:);

            [~,numCols]=size(B.V_rows);
            V_prim =  B.V_rows(:,1:floor(numCols/2));
            V_bis = B.V_rows(:,floor(numCols/2+1):numCols);

            [~,numCols]=size(B.U_columns);

            
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
            
            subnode11 = Addition(A.children(1), U_primV_prim);
            subnode12 = Addition(A.children(2), U_primV_bis);
            subnode21 = Addition(A.children(3), U_bisV_prim);
            subnode22 = Addition(A.children(4), U_bisV_bis);

            node=Node;
            append_child(node, subnode11);
            append_child(node, subnode12);
            append_child(node, subnode21);
            append_child(node, subnode22);
        end
        if checkCorrectnessOfTreeStructure(node)~=0
            error('error');
        end
    else
        warning('Addition(A, B): Unhandled case. Investigation is needed.')
    end
    disp('Addition leave');
    
    if isempty(A.rank)
       tmp_rank_A=0;
    else
        tmp_rank_A=A.rank;
        if isempty(B.rank)
            tmp_rank_B=0;
        else
            tmp_rank_B=B.rank;
                if isempty(node.rank)
                    tmp_rank_node=0;
                else
                   tmp_rank_node=node.rank;
                   
                    if tmp_rank_node < max(tmp_rank_A, tmp_rank_B)
                        disp('ERROR ERROR');
                    end
                end
        end
    end
    
    if checkCorrectnessOfTreeStructure(node)~=0
        error('error');
    end
    if node.no_of_children == 0
        node = formatRankOfNode(node);%21062023
    end
end