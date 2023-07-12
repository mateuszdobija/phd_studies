function [result] = checkCorrectnessOfTreeStructure(v)
result=0;
    if v.no_of_children == 0
        a= v.rank ~=0;
        b= isempty(v.U_columns);
        c= isempty(v.V_rows);
        d = ~isempty(v.children);
        z = all(v.U_columns(:)==0);
        l = all(v.V_rows(:)==0);
        [Urows,Ucols]=size(v.U_columns);
        [Vrows,Vcols]=size(v.V_rows);
        p = Ucols~= Vrows;
        %p2 = Urows ~= Vcols;
        
        p2=0;
        if ((a) && (( b || c || z || l || (p) || p2 ) || (d)))  
            %error('Error. Zeroed U_columns or V_rows or not empty children in the element which no_of_children == 0')
            result = 1;
        end
        
        q = v.rowsWithZero == 0;
        w = v.columnsWithZero == 0;
        if (~a) && (q || w)
            result = 2; 
        end
        
%         [UnumRows,UnumCols]=size(v.U_columns);
%         [VnumRows,VnumCols]=size(v.V_rows);
%         if ~(UnumCols == VnumRows && UnumRows == VnumCols)
%             %error('Error. Zeroed U_columns or V_rows or not empty children in the element which no_of_children == 0')
%             result = 3;
%         end
    else
        a= ~isempty(v.rank);
        b= isempty(v.children);
        c = (~isempty(v.U_columns));
        d = (~isempty(v.V_rows));
        if  a || b || c || d
           %error('Error. Not set children or Not zeroed U_columns or not zeroed V_rows in the element which no_of_children ~= 0')
            result = 2;
        end
        
        result = max(result, checkCorrectnessOfTreeStructure(v.children(1)));
        result = max(result, checkCorrectnessOfTreeStructure(v.children(2)));
        result = max(result, checkCorrectnessOfTreeStructure(v.children(3)));
        result = max(result, checkCorrectnessOfTreeStructure(v.children(4)));
    end
    


end